-- RescueWindows module
-- Move any windows that are off-screen onto the main screen
-- Kudos: https://footle.org/2018/01/23/rescuing-windows-with-hammerspoon/
local RescueWindows = {}

-- Set up logger
RescueWindows.log = hs.logger.new("RescueWindows", "info")

RescueWindows.debug = function(enable)
  if enable then
    RescueWindows.log.setLogLevel('debug')
    RescueWindows.log.d("Debugging enabled")
  else
    RescueWindows.log.d("Disabling debugging")
    RescueWindows.log.setLogLevel('info')
  end
end

function RescueWindows:rescue()
  local screen = hs.screen.mainScreen()
  local screenFrame = screen:fullFrame()
  local wins = hs.window.visibleWindows()
  hs.fnutils.each(wins, function(win)
    local frame = win:frame()
    if not frame:inside(screenFrame) then
      win:moveToScreen(screen, true, true)
    end
  end)
end

return RescueWindows
