-- PresentationMode module
-- Puts my system into a mode where it doesn't go to sleep, or lock the
-- screen, etc. while I'm making a presentation or similar.
local pm = {}

pm.screensaver = hs.loadSpoon("ScreenSaver")

pm.enabled = false
-- Our state prior to being enabled
pm.priorState = {}

-- Set up logger for module
pm.log = hs.logger.new("PresentationMode", "info")

function pm:debug(enable)
  if enable then
    self.log.setLogLevel('debug')
    self.log.d("Debugging enabled")
  else
    self.log.d("Disabling debugging")
    self.log.setLogLevel('info')
  end
end

--- PresentationMode:enable()
--- Function
--- Enable presentation mode, disabling any sleeping of the system
--- or screensacer until disabled.
---
--- Parameters:
--- * None
---
--- Returns:
--- * true on success, false on error.
function pm:enable()
  self.log.i("Enabling")

  if self.enabled then
    self.log.i("Already enabled.")
    return false
  end

  self.priorState.screensaverTimeout = pm.screensaver:getTimeout()
  self.screensaver:disable()

  hs.caffeinate.set("displayIdle", true)

  self.enabled = true

  return true
end

--- PresentationMode:disable()
--- Function
--- Disable presentation mode, restoring prior state.
---
--- Parameters:
--- * None
---
--- Returns:
--- * true on success, false on error.
function pm:disable()
  self.log.i("Disabling")

  if not self.enabled then
    self.log.i("Not enabled.")
    return false
  end

  self.screensaver:setTimeout(self.priorState.screensaverTimeout)

  hs.caffeinate.set("displayIdle", false)

  self.enabled = false

  return true
end

--- PresentationMode:toggle()
--- Function
--- Toggle presentation mode.
---
--- Parameters:
--- * None
---
--- Returns:
--- * true on success, false on error.
function pm:toggling()
  self.log.i("Toggling")

  if self.enabled then
    return self:disable()
  else
    return self:enable()
  end
  -- Should not get here.
end

return pm
