-- focusTweaks.lua
--
-- When we minimize a window, focus on the frontmost window.
-- Otherwise, if the minimzed window was the last unminimized window
-- of an application, we'll end up with no focused window, which
-- I find counterintuitive.
--
-- When we focus on a window, unminimize it if it is minimized.

local Module = {}

-- Set up logger for module
Module.log = hs.logger.new("focusTweaks", "info")

function Module:debug(enable)
  if enable then
    self.log.setLogLevel('debug')
    self.log.d("Debugging enabled")
  else
    self.log.d("Disabling debugging")
    self.log.setLogLevel('info')
  end
end

local function minimizeCallback(window, appName, event)
  local w = hs.window.frontmostWindow()
  if w then
    Module.log.df("Minimize detected, focusing on %s", w:title())
    w:focus()
  else
    Module.log.d("Minimize detected, but no frontmostWindow found")
  end
end

local function focusCallback(window, appName, event)
  if window then
    if window:isMinimized() then
      Module.log.df("Unminimizing %s", window:title())
      window:unminimize()
    end
  else
    -- XXX I'm not sure why/when this happens but it does
    Module.log.df("focusCallback() with no window")
  end
end

-- Filter that encompasses every window
Module.wf = hs.window.filter.new(true)
Module.wf:subscribe({hs.window.filter.windowMinimized}, minimizeCallback)
Module.wf:subscribe({hs.window.filter.windowFocused}, focusCallback)

return Module
