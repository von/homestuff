-- Caffeinate watcher configuration

local screensaver = hs.loadSpoon("ScreenSaver")

local logger = hs.logger.new("caffeinate")

local eventNames = {
  [hs.caffeinate.watcher.screensaverDidStart] = "Screensaver started",
  [hs.caffeinate.watcher.screensaverDidStop] = "Screensaver stopped",
  [hs.caffeinate.watcher.screensaverWillStop] = "Screensaver will stop",
  [hs.caffeinate.watcher.screensDidLock] = "Screen locked",
  [hs.caffeinate.watcher.screensDidSleep] = "Screen slept",
  [hs.caffeinate.watcher.screensDidUnlock] = "Screen unlocked",
  [hs.caffeinate.watcher.screensDidWake] = "Screen woke",
  [hs.caffeinate.watcher.sessionDidBecomeActive] = "Session actived",
  [hs.caffeinate.watcher.sessionDidResignActive] = "Session deactivated",
  [hs.caffeinate.watcher.systemDidWake] = "System woke",
  [hs.caffeinate.watcher.systemWillPowerOff] = "System will power off",
  [hs.caffeinate.watcher.systemWillSleep] = "System will sleep"
}

local watcherFunction = function(event)
  logger.f("watcher() called. Event = %s", eventNames[event])

  if event == hs.caffeinate.watcher.systemWillSleep then
    if screensaver:getTimeout() > 0 then
      logger.d("Screensaver already enabled.")
    else
      -- Enable screensaver before sleep
      -- I often disable it for a presentation and forget to re-enable it.
      logger.w("Enabling screensaver before sleep")
      screensaver:enable()
    end
    return
  end -- systemWillSleep

end

-- I believe caffeinateWatcher needs to be a global to avoid it being garbage
-- collected.
caffeinateWatcher = hs.caffeinate.watcher.new(watcherFunction)
caffeinateWatcher:start()
logger.i("hs.caffeinate.watcher started")
