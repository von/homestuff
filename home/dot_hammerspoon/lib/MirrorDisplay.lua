-- MirrorDisplay module
-- XXX How do I detect if mirroring is going on and hence write a toggle()
--     method? Doesn't see possible:
--     https://github.com/Hammerspoon/hammerspoon/issues/168
local md = {}

-- Set up logger for module
md.log = hs.logger.new("MirrorDisplay", "info")

function md:debug(enable)
  if enable then
    self.log.setLogLevel('debug')
    self.log.d("Debugging enabled")
  else
    self.log.d("Disabling debugging")
    self.log.setLogLevel('info')
  end
end

--- MirrorDisplay:enable()
--- Function
--- Mirror current display onto first other display found.
---
--- Parameters:
--- * None
---
--- Returns:
--- * true on success, false on error
function md:enable()
  self.log.d("enable()")
  local mainScreen = hs.screen.mainScreen()
  local allScreens = hs.screen.allScreens()
  local otherSreen = nil
  -- Find the other screen to set up mirroring.
  for i, screen in ipairs(allScreens) do
    if screen:id() ~= mainScreen:id() then
      otherScreen = screen
      break
    end
  end
  if otherScreen == nil then
    self.log.i("No other screen found to mirror.")
    hs.alert("No other screen found to mirror.")
    return false
  end
  self.log.f("Mirroring %s to %s", mainScreen:name(), otherScreen:name())
  return otherScreen:mirrorOf(mainScreen)
end

--- MirrorDisplay:disable()
--- Function
--- Turn off mirroring on all screens.
---
--- Parameters:
--- * None
---
--- Returns:
--- * true on success, false on error
function md:disable()
  self.log.d("disable()")
  local allScreens = hs.screen.allScreens()
  local errors = 0
  hs.fnutils.each(allScreens,
    function(s) if not s:mirrorStop() then errors = errors +1 end end)
  return errors == 0
end

--- MirrorDisplay:toggle()
--- Function
--- Toggle mirroring.
--- Currently makes the assumption that if we have one screen, it is mirroed,
--- and if we have two screens, there is no mirroring. This is because I
--- don't see a way to detect mirroring.
--- See https://github.com/Hammerspoon/hammerspoon/issues/168#issuecomment-2298922458
---
--- Parameters:
--- * None
---
--- Returns:
--- * true on success, false on error
function md:toggle()
  local allScreens = hs.screen.allScreens()
  self.log.df("#allScreens = %d", #allScreens)
  if #allScreens == 1 then
    return self:disable()
  else
    return self:enable()
  end
  -- Should not get here 
end

return md
