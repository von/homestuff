-- LastWindow.lua
-- Let me jump between two windows.

-- LastWindow module
local LastWindow = {}

-- Set up logger for module
LastWindow.log = hs.logger.new("LastWindow", "info")

function LastWindow:debug(enable)
  if enable then
    self.log.setLogLevel('debug')
    self.log.d("Debugging enabled")
  else
    self.log.d("Disabling debugging")
    self.log.setLogLevel('info')
  end
end

-- Module contents here
local previousWindow = nil

function LastWindow:toggle()
  self.log.d("toggle() called")
  local currentWindow = hs.window.focusedWindow()
  if previousWindow then
    if previousWindow == currentWindow then
      self.log.d("Previous window == current window. Doing nothing.")
    else
      -- XXX Check to make sure window still exists?
      self.log.df("Focusing on %s", previousWindow:title())
      previousWindow:focus()
      previousWindow = currentWindow
    end
  else
    self.log.df("No previous window. Setting: %s", currentWindow:title())
    hs.alert("Window for toggle set")
    previousWindow = currentWindow
  end
end

return LastWindow
