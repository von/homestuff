-- chrome.lua
-- Support for manipulating Google Chrome

local module = {}

-- Wrapped functions for binding
module.wrapped = {}

local loader = require('scriptloader')
local taskext = require("taskext")

local chromeCLI = require("ChromeCLI")

local chromeId = "com.google.Chrome"

local log = hs.logger.new('chrome', 'info')
module.log = log

module.debug = function(enable)
  if enable then
    log.setLogLevel('debug')
    log.d("Debugging enabled")
  else
    log.d("Disabling debugging")
    log.setLogLevel('info')
  end
end

-- selectPersona() {{{ --
-- Activate (open if needed) a chrome window for a certain persona.
-- Returns true on success, false otherwise (e.g. if the persona
-- was not found in Chrome's People menu).
-- If optional parameter minimizeOtherWindows is true, then minimize
-- all other Chrome windows.
local function selectPersona(persona, minimizeOtherWindows)
  local chrome = hs.application.find("Google Chrome")
  if not chrome then
    log.e("Could not find Chrome application")
    return false
  end
  -- Activate application. This is needed if we have multiple screens
  -- otherwise this doesn't work reliably.
  if not chrome:activate() then
    log.e("Could not activate Chrome application")
    -- Go ahead and try...
  end
  log.df("Selecting persona %s", persona)
  if minimizeOtherWindows then
    hs.fnutils.map(chrome:visibleWindows(), function(w) w:minimize() end)
  end
  local menuChoice = { "Profiles", persona }  -- Changed from "People" at some point
  if not chrome:selectMenuItem(menuChoice) then
    -- Chrome may do a form such as "<Google login> (<persona>)"
    -- Use a regex to find it
    -- Need to escape backslashes in lua: https://stackoverflow.com/a/53738023/197789
    local regex = ".*\\(" .. persona .. "\\)"
    if not chrome:selectMenuItem(regex, true) then
      return false
    end
  end
  return true
end

module.selectPersona = selectPersona

module.wrapped.selectPersona = function(persona)
  return function()
    if not selectPersona(persona) then
      hs.alert("Failed to select Chrome persona " .. persona)
    end
  end
end

-- }}} selectPersona() --

-- openURL() {{{
-- Open given URL with the given persona
-- Argument can be a string with url or table with the following fields:
--    url - if empty string, a new tab will be opened
--    persona (optional) Chrome persona to use.
--    newWindow (optional) Open in new window
local function openURL(arg)
  if not arg then
    module.log.e("open() called with arg == nil")
    return false
  end
  local url = nil
  local persona = nil
  local newWindow = nil
  if type(arg) == "string" then
    url = arg
  else
    url = arg.url
    persona = arg.persona
    newWindow = arg.newWindow
  end
  if not url then
    module.log.e("open() called with url == nil")
    return false
  end
  if url == "" then
    -- A empty string results in "about:blank", so use newtab instead
    url = "chrome://newtab"
  end
  module.log.i("opening URL " .. url)
  if persona then
    module.log.d("Opening with persona: " .. persona)
    if not selectPersona(persona) then
      hs.alert("Failed to select Chrome persona " .. persona)
      return false
    end
  end
  if newWindow then
    module.log.d("Opening in new window...")
    local task = chromeCLI.open(nil, url, { newWindow=true })
    if not task then
        hs.alert("Failed to open URL")
        module.log.d("Failed to open URL: task creation failed.")
        return false
    end
  else -- newWindow == nil
    module.log.d("Opening...")
    if not hs.urlevent.openURLWithBundle(url, chromeId) then
      hs.alert("Failed to open URL: " .. url)
      return false
    end
  end
  return true
end

module.openURL = openURL

module.wrapped.openURL = function(arg)
  return function()
    return openURL(arg)
  end
end

-- }}} URLopener()

-- installHandler {{{ --
-- Install handler for hammerspoon://chromePersona?name=<name>

local function chromePersonaHandler(eventName, params)
  if not selectPersona(params.name) then
    hs.alert("Failed to select Chrome persona " .. persona)
  end
end

local function installHandler()
  hs.urlevent.bind("chromePersona", chromePersonaHandler)
end

module.installHandler = installHandler

-- }}} installHandler --

-- activateTab() {{{ --
-- XXX This could be rewritten using the chrome-cli program and I suspect
--     would be more efficient. Looks like it could also be written
--     purely in AppleScript per:
--     http://hints.macworld.com/article.php?story=20110622061755509

local findTab = loader.fullPath("chromeFindTab.js")

local activateTabCache = {}

-- Focus on tab with given name
-- Uses ../scripts/chromeFindTab.js
-- searchString is the tab title to search for
-- openURLArg is used if the tab is not found and is the argument to openURL
function activateTab(searchString, openURLArg)

  local callback = function(exitCode, stdOut, stdErr)
    if exitCode == 0 then
      hs.alert("Success")
      local winId = tonumber(stdErr)
      log.df("Caching WindowId %s:%d", searchString, winId)
      activateTabCache[searchString] = winId
    elseif exitCode == 2 then
      -- Clear any cache that may exist
      activateTabCache[searchString] = nil
      log.df("Tab %s not found - opening", searchString)
      hs.alert("Opening " .. searchString)
      openURL(openURLArg)
    else
      log.w("Script failure")
      hs.alert("Failed to select Chrome tab")
      module.log.e(stdErr)
    end
  end

  hs.alert("Selecting " .. searchString)
  log.f("Selecting tab %s", searchString)
  local args = {searchString}
  local cachedWindowId = activateTabCache[searchString]
  if cachedWindowId then
    log.df("Adding cachedWindowId (%s) to args", cachedWindowId)
    table.insert(args, tostring(cachedWindowId))
  end
  local t = taskext.newFromOSAPath(findTab, callback, args)
  t:start()
end

module.activateTab = activateTab

module.wrapped.activateTab = function(searchString, openURLArg)
  return function()
    return activateTab(searchString, openURLArg)
  end
end
-- }}} activateTab

-- getActiveTabURL() {{{ --
-- Kudos: https://gist.github.com/dongyuwei/a1c9d67e4af6bbbd999c
function getActiveTabURL()
  local script = [[
    using terms from application "Google Chrome"
      tell application "Google Chrome" to set currentTabUrl to URL of active tab of front window
    end using terms from
    return currentTabUrl
  ]]
  local success, url, output = hs.osascript.applescript(script)
  if not success then
    log.e("Failed to get Chrome active tab URL")
    return nil
  end
  return url
end

module.getActiveTabURL = getActiveTabURL
-- }}} getActiveTabURL() --

-- getActiveTabTitle() {{{ --
-- Kudos: https://gist.github.com/dongyuwei/a1c9d67e4af6bbbd999c
function getActiveTabTitle()
  local script = [[
    using terms from application "Google Chrome"
      tell application "Google Chrome" to set currentTabTitle to title of active tab of front window
    end using terms from
    return currentTabTitle
  ]]
  local success, title, output = hs.osascript.applescript(script)
  if not success then
    log.e("Failed to get Chrome active tab title")
    return nil
  end
  return title
end

module.getActiveTabTitle = getActiveTabTitle
-- }}} getActiveTabTitle() --

-- urlToPastebuffer() {{{ --

local urlToPastebufferScript = loader.fullPath("chromeUrlToPasteBuffer.scpt")

function urlToPastebuffer()
  local callback = function(exitCode, stdOut, stdErr)
    if exitCode ~= 0 then
      hs.alert("Failed to copy URL to pastebuffer")
      log.ef("Failed to copy URL to pastebuffer: " .. stdErr)
    end
  end
  local t = taskext.newFromOSAPath(urlToPastebufferScript, callback, {})
  t:start()
end

module.urlToPastebuffer = urlToPastebuffer

module.wrapped.urlToPastebuffer = function()
  return function()
    return urlToPastebuffer()
  end
end

-- }}} urlToPastebuffer() --

-- previousTab {{{ --
-- Activates active tab last time this function was called.
-- First time called, does nothing.

local previousTabId = nil

-- Current running task, serves as a guard for reentrance
local previousTabTask = nil

function previousTabCallback(table)
  previousTabTask = nil
  if previousTabId then
    log.df("Activating Previous Tab: %d", previousTabId)
    chromeCLI.activate(previousTabId)
  else
    hs.alert("Previous Tab Set")
  end
  previousTabId = table.Id
  log.df("previousTabId set: %d ", previousTabId)
end

function previousTab()
  if previousTabTask then
    log.i("previosTab: re-entered and ignoring")
    return
  end
  previousTabTask = chromeCLI.info(nil, previousTabCallback)
end

module.previousTab = previousTab

module.wrapped.previousTab = function()
  return function()
    return previousTab()
  end
end

-- }}} previousTab --

return module
-- vim:foldmethod=marker:
