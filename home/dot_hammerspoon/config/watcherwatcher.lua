-- WatcherWatcher configuration
local ww = hs.loadSpoon("WatcherWatcher")
ww:debug(true)
-- Currently broken, see https://github.com/Hammerspoon/hammerspoon/issues/3057
ww.monitorMics = false
ww:start()
