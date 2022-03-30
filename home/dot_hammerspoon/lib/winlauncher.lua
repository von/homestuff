-- winlauncher.lua
-- Return a function to launch/focus a window.
-- Meant for use in hotkey bindings.

local module = {}

local log = hs.logger.new('winlauncher', 'info')
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

module.new = function(winname)
  return function()
    win = hs.window.find(winname)
    if win then
      win:unminimize()
      win:focus()
    else
      hs.alert("Cannot find window: " .. winname)
    end
  end
end

return module
