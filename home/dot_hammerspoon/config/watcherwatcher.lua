-- WatcherWatcher configuration
local ww = hs.loadSpoon("WatcherWatcher")
ww:debug(true)

local flasher = ww.Flasher:new()
flasher:debug(true)
local startCallback, stopCallback = flasher:callbacks()
ww.callbacks.cameraInUse = startCallback
ww.callbacks.cameraNotInUse = stopCallback

local menubar = ww.Menubar
menubar:debug(true)
menubar.monitorCameras = false
startCallback, stopCallback = menubar:callbacks()
ww.callbacks.micInUse = startCallback
ww.callbacks.micNotInUse = stopCallback

ww:start()
