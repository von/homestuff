-- URLOpener
-- Handling opening a URL in Chrome, in either a new window or the last window ar
-- URL was opened in, if it was still around.
-- This class is basically a state machine for a series of async calls to
-- chrome-cli.

local URLOpener = {}
-- Failed table lookups on the instances should fallback to the class table, to get methods
URLOpener.__index = URLOpener

local chrome = require("chrome")
local ChromeCLI = require("ChromeCLI")

-- Set up logger
local log = hs.logger.new("URLOpener")
URLOpener.log = log

function URLOpener.debug(enable)
  if enable then
    URLOpener.log.setLogLevel('debug')
    URLOpener.log.d("Debugging enabled")
  else
    URLOpener.log.d("Disabling debugging")
    URLOpener.log.setLogLevel('info')
  end
end

-- Id of last window URL was opened in
URLOpener.lastWindowId = nil

-- Default Chrome persona to use
URLOpener.persona = nil

-- Set the default Chrome persona to use for opened URLs
function URLOpener.setDefaultPersona(persona)
  URLOpener.log.df("Setting default persona to %s", persona)
  URLOpener.persona = persona
  return self
end

-- Set the Chrome window to use for opening URLs
-- windowId is the window Id as returned by chrome-cli
-- If windowId is nil, the next call to open() will open in a new window
function URLOpener.setWindow(windowId)
  if windowId then
    URLOpener.log.df("Setting windowId to %d", windowId)
    URLOpener.lastWindowId = windowId
  else
    URLOpener.log.d("Clearing windowId")
    URLOpener.lastWindowId = nil
  end
end

-- If we previously opened a URL and the window in which we opened the URL
-- (as identified by ChromeCLI) is still around, then open the URL in that
-- window. Otherwise open in a new window.
-- This call is asynchronous.
-- Returns false on errors, true otherwise
function URLOpener.open(url)
  -- self is not returned, just used to hold state between tasks
  local self = setmetatable({}, URLOpener)
  if url == "" then
    -- A empty string results in "about:blank", so use newtab instead
    url = "chrome://newtab"
  end
  self.log.i("opening URL " .. url)
  self.url = url
  if URLOpener.lastWindowId then
    return self:checkLastWindow()
  else
    return self:openInNewWindow()
  end
end

-- Open self.url in new window
-- This call is asynchronous.
-- Returns false on errors, true otherwise
function URLOpener.openInNewWindow(self)
  if self.persona then
    self.log.d("Opening in new window with persona: " .. self.persona)
    if not chrome.selectPersona(self.persona) then
      hs.alert("Failed to select Chrome persona " .. self.persona)
      return false
    end
  end
  local task = ChromeCLI.open(
    function(...) self:openInNewWindowCallback(...) end,
    self.url, { newWindow=true })
  if not task then
      hs.alert("Failed to open URL")
      self.log.d("Failed to open URL: task creation failed.")
      return false
  end
  return true
end

-- Callback for openInNewWindow()
-- Invoke ChromeCLI.listWindows() with listWindowsCallback()
function URLOpener.openInNewWindowCallback(self, attr)
  self.log.d("openInNewWindowCallback()")
  if not ChromeCLI.listWindows(function(...) self:listWindowsCallback(...) end) then
    self.log.e("Failed to invoke listWindows()")
    return
  end
end

-- Callback for listWindows()
-- Record last window (highest id) in URLOpener.lastWindowId
-- Note the assumption here of highest id being last, this is both a
-- implementation assumptiion and open to race conditions.
function URLOpener.listWindowsCallback(self, windows)
  self.log.d("listWindowsCallback()")
  if not windows then
    self.log.d("listWindowsCallback(): windows == nil")
    return
  end
  local max=0
  for id,title in pairs(windows) do
    if id > max then
      max = id
    end
  end
  self.log.df("setting lastWindowId=%d", max)
  URLOpener.lastWindowId = max
end

function URLOpener.checkLastWindow(self)
  self.log.df("Checking to see if window %d still around", URLOpener.lastWindowId)
  if not ChromeCLI.listTabsForWindow(
      function(...) self:checkLastWindowCallback(...) end,
      URLOpener.lastWindowId) then
    self.log.ef("Failed to invoke listTabsForWindow(%d)", URLOpener.lastWindowId)
    return
  end
end

function URLOpener.checkLastWindowCallback(self, tabs)
  self.log.d("checkLastWindowCallback()")
  local tabsFound=false
  for _ in pairs(tabs) do
    tabsFound=true
    break
  end
  if tabsFound then
    self.log.df("Window %d still around, opening URL in it.", URLOpener.lastWindowId)
    ChromeCLI.open(nil, self.url, { windowId=URLOpener.lastWindowId })
  else
    self.log.d("Last window not found. Opening in new window.")
    self:openInNewWindow()
  end
end

-- If module, return class definition
return URLOpener
