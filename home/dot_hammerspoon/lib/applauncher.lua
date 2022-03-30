-- applauncher.lua
-- Return a function to launch/focus an application. Meant for use in hotkey.
-- Unminimizes window for application if none are visible.
-- bindings.

local module = {}

local log = hs.logger.new("applauncher", "info")

module.debug = function(enable)
  if enable then
    log.setLogLevel('debug')
    log.d("Debugging enabled")
  else
    log.d("Disabling debugging")
    log.setLogLevel('info')
  end
end


module.new = function(appname)
  return function()
    if not hs.application.launchOrFocus(appname) then
      hs.alert("Could not launch Application " .. appname)
      log.ef("Could not launch %s", appname)
      return false
    end
    app = hs.appfinder.appFromName(appname)
    if not app then
      hs.alert("Could not find Application " .. appname)
      log.ef("Could not find %s", appname)
      return false
    end
    if #app:visibleWindows() == 0 then
      -- Do our best to find the window and unminimize it
      win = app:focusedWindow() or app:mainWindow() or app:allWindows()[1]
      if win and win:isMinimized() then
        win:unminimize()
      end
    end
  end
end

return module
