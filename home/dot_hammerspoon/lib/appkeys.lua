-- AppKeys module
-- Activate/decative hotkeys whenever given applications become active/inactive
-- (gain/lose keyboard focus).
local module = {}

-- Set up logger for module
local log = hs.logger.new("AppKeys", "info")
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

-- Current application
module.activeApp = nil

-- Module contents here
-- e.g. module.foo = function() hs.alert("Hello world") end

-- Table indexed by application name, with each entry being a list of
-- hs.hotkey objects
local appKeys = {}

-- hs.application.watcher instance
local appWatcher = nil

-- For more easy to understand debugging
local eventName = {
  [hs.application.watcher.activated]="Activated",
  [hs.application.watcher.deactivated]="Deactivated",
  [hs.application.watcher.hidden]="Hidden",
  [hs.application.watcher.launched]="Launched",
  [hs.application.watcher.launching]="Launching",
  [hs.application.watcher.terminated]="Terminated",
  [hs.application.watcher.unhidden]="Unhidden"
}

-- Enable a hotkey, handling errors
-- XXX: hs.hotkey.idx isn't documented part of API
local function enable(hk)
  log.df("Enabling hotkey: %s", hk.idx)
  if hk:enable() == nil then
    log.ef("Failed to enable hotkey: %s", hk.idx)
  end
end

-- Disable a hotkey, handling errors
-- XXX: hs.hotkey.idx isn't documented part of API
local function disable(hk)
  log.df("Disabling hotkey: %s", hk.idx)
  -- No error to catch
  hk:disable()
end

-- Callback for hs.application.watcher instance
-- A couple things this has to handle:
--  1) Callbacks may occur out of order, that is changing from App A to App B
--     I often see the callback with Activation for App B followed by the callback
--     with Deactivation for App A.
--  2) A callback may be interrupted by a callback. So for the case above, the
--     Deactivation callback for App A may interrupt the Activation callback
--     for App B.
-- Hence we use a coroutine here since it is non-pre-emptive and check to make
-- sure a Deactivation is for the current application.
local appWatcherCoroutine = coroutine.create(
    function(appName, event, app)
      while true do
        if event == hs.application.watcher.deactivated or
          event == hs.application.watcher.terminated then
          -- Make sure we're deactivating the current application
          if module.activeApp and module.activeApp == appName then
            module.activeApp = nil
            local hotkeys = appKeys[appName]
            if hotkeys then
              hs.fnutils.each(hotkeys, disable)
            end
          end
        elseif event == hs.application.watcher.activated then
          if module.activeApp then
            -- Disable the current application
            local hotkeys = appKeys[module.activeApp]
            if hotkeys then
              hs.fnutils.each(hotkeys, disable)
            end
          end
          module.activeApp = appName
          local hotkeys = appKeys[appName]
          if hotkeys then
            hs.fnutils.each(hotkeys, enable)
          end
        end
        -- And wait for next event
        appName, event, app = coroutine.yield()
      end -- while true
    end
    )

-- We call the coroutine this way instead of using coroutine.wrap()
-- to make the callback function because that will result in errors if
-- it is called while already being invoked, while this approach serializes
-- calls.
local function appWatcherCallback(appName, event, app)
  log.df("appWatcherFunc(%s, %s)", appName, eventName[event])
  status, err = coroutine.resume(appWatcherCoroutine, appName, event, app)
  if status then
    log.df("appWatcherFunc(%s, %s) done", appName, eventName[event])
  else
    log.ef("appWatcherFunc(%s, %s) error: %s", appName, eventName[event], err)
  end
end

-- Callback if a chooser is about to appear so we can disable
-- appKeys in case they interfere
local function chooserGlobalCallback(chooser, event)
  log.df("chooserGlobalCallback() got event \"%s\"", event)

  if event == "willOpen" then
    module.suspend()
  elseif event == "didClose" then
    module.resume()
  end

  -- Chain prior callback
  if module.priorGlobalCallback then
    module.priorGlobalCallback(chooser, event)
  end

end

-- Initialize this module
-- This starts out hs.application.watcher instance
module.init = function()
  log.i("Initializing")
  if appWatcher then
    appWatcher:stop()
  end
  module.activeApp = nil
  appWatcher = hs.application.watcher.new(appWatcherCallback)
  appWatcher:start()
  module.priorGlobalCallback = hs.chooser.globalCallback
  hs.chooser.globalCallback = chooserGlobalCallback
end

-- Shutdown this module
module.stop = function()
  log.i("Stopping")
  if appWatcher then
    appWatcher:stop()
  end
  hs.chooser.globalCallback = module.priorGlobalCallback
  module.disable()
end

-- Register hotkeys for an application
--   appName should be the name of the application, e.g. Mail
--   hotkeys should be a table of hs.hotkey objects
module.register = function(appName, hotkeys)
  appKeys[appName] = hotkeys
end

-- Disable current hotkeys, if any
module.disable = function()
  if module.currentAppName then
    hotkeys = appKeys[module.currentAppName]
    if hotkeys then
      log.df("Disabling hotkeys for %s", module.currentAppName)
      hs.fnutils.each(hotkeys, disable)
    end
    module.currentAppName = nil
  end
end

-- Suspend current hotkeys, if any
module.suspend = function()
  if module.currentAppName then
    hotkeys = appKeys[module.currentAppName]
    if hotkeys then
      log.df("Suspending hotkeys for %s", module.currentAppName)
      hs.fnutils.each(hotkeys, disable)
    end
  end
end

-- Resume suspended hotkeys, if any
module.resume = function()
  if module.activeApp then
    hotkeys = appKeys[module.activeApp]
    if hotkeys then
      log.df("Resuming hotkeys for %s", module.activeApp)
      hs.fnutils.each(hotkeys, enable)
    end
  end
end

return module
