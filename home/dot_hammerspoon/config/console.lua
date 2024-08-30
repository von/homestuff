-- Configuration for the Hammerspoon console and functions meant for use in the console
-- Kudos to @megalithic:
-- https://github.com/megalithic/dotfiles/blob/master/hammerspoon/hammerspoon.symlink/console.lua

-- Shortcuts common functions for easy use
inspect = hs.inspect
i = hs.inspect
r  = hs.reload
c = hs.console.clearConsole
a = hs.alert
p = print
u = hs.checkForUpdates
help = hs.help
docs = hs.hsdocs
settings = hs.openPreferences

dumpApps = function(hint)
  local apps = hint == nil and hs.application.runningApplications() or { hs.application.find(hint) }

  hs.fnutils.each(apps, function(app)
    print(hs.inspect({
      name             = app:name(),
      title            = app:title(),
      path             = app:path(),
      bundleID         = app:bundleID(),
      pid              = app:pid(),
    }))
  end)
end

dumpWindow = function(win)
  print(hs.inspect({
        id               = win:id(),
        title            = win:title(),
        app              = win:application():name(),
        bundleID         = win:application():bundleID(),
        role             = win:role(),
        subrole          = win:subrole(),
        frame            = win:frame(),
        isFullScreen     = win:isFullScreen(),
        -- buttonZoom       = axuiWindowElement(win):attributeValue('AXZoomButton'),
        -- buttonFullScreen = axuiWindowElement(win):attributeValue('AXFullScreenButton'),
        -- isResizable      = axuiWindowElement(win):isAttributeSettable('AXSize')
    }))
end

dumpWindows = function(app)
  local windows
  if not app then
    windows = hs.window.allWindows()
  elseif type(app) == "string" then
    windows = hs.application.find(app):allWindows()
  else -- Assume hs.application instance
    windows = app:allWindows()
  end

  hs.fnutils.each(windows, dumpWindow)
end

listWindows = dumpWindows

dumpUsbDevices = function()
  hs.fnutils.each(hs.usb.attachedDevices(), function(usb)
    print(hs.inspect({
      productID           = usb.productID,
      productName         = usb.productName,
      vendorID            = usb.vendorID,
      vendorName          = usb.vendorName
    }))
  end)
end

-- Internal function for use by other dump*AudioDevice() functions
local dumpAudioDevice = function(d)
  print(hs.inspect({
    name = d:name(),
    uid = d:uid(),
    -- Following doesn't have meaning for input devices?
    muted = d:muted(),
    volume = d:volume(),
    inUse = d:inUse(),
    isInput = d:isInputDevice(),
    isOutput = d:isOutputDevice(),
    watcherIsRunning = d:watcherIsRunning(),
    device = d
  }))
end

dumpCurrentInputAudioDevice = function()
  d = hs.audiodevice.defaultInputDevice()
  dumpAudioDevice(d)
end

dumpAllInputAudioDevices = function()
  hs.fnutils.each(hs.audiodevice.allInputDevices(), dumpAudioDevice)
end

dumpCurrentOutputAudioDevice = function()
  d = hs.audiodevice.defaultOutputDevice()
  dumpAudioDevice(d)
end

dumpAllOutputAudioDevices = function()
  hs.fnutils.each(hs.audiodevice.allOutputDevices(), dumpAudioDevice)
end

dumpCameras = function()
  hs.fnutils.each(hs.camera.allCameras(),
    function(c)
      print(hs.inspect({
            name = c:name(),
            uid = c:uid(),
            -- Following always seems to return false, see:
            -- https://github.com/Hammerspoon/hammerspoon/issues/3046
            inUse = c:isInUse(),
            connectionId = c:connectionID()
          }))
    end)
end

dumpScreen = function(s)
  print(hs.inspect({
        name = s:name() or "nil", -- Airplay screens have no name
        id = s:id(),
        position = s:position(),
        frame = s:frame(),
        fullFrame = s:fullFrame(),
        uuid = s:getUUID(),
        position = s:position()
    }))
end

dumpScreens = function()
  hs.fnutils.each(hs.screen.allScreens(), dumpScreen)
end

dumpHotkeys = function()
  hs.fnutils.each(hs.hotkey.getHotkeys(),
    function(h) print(hs.inspect(h)) end)
end

timestamp = function(date)
  date = date or hs.timer.secondsSinceEpoch()
  return os.date("%F %T" .. ((tostring(date):match("(%.%d+)$")) or ""), math.floor(date))
end

debugKeystrokes = function(duration)
  local duration=duration or 10
  local function callback(event)
    local code = event:getKeyCode()
    hs.printf("%s (%d)", hs.keycodes.map[code], code)
    return false -- propagate event
  end
  local tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, callback)
  hs.timer.doAfter(duration, function() tap:stop() hs.printf("Debugging done") end)
  tap:start()
  hs.printf("Debugging keystrokes for %d seconds", duration)
end

dumpCaffienateSessionProperties = function()
  hs.printf(hs.inspect(hs.caffeinate.sessionProperties()))
end

dumpCaffienateAssertions = function()
  hs.printf(hs.inspect(hs.caffeinate.currentAssertions()))
end

dumpCaffienateSleepPreventionSettings = function()
  keys = { "displayIdle", "systemIdle", "system" }
  for i,type in ipairs(keys) do
    hs.printf("%s: %s", type, hs.caffeinate.get(type))
  end
end

dumpSpaces = function()
  -- table of screenUUIDs as keys and table of spaceIDs as value
  local spaces = hs.spaces.allSpaces()
  hs.printf("%s", spaces)
end

-- For more easy to understand debugging
local applicationEventName = {
  [hs.application.watcher.activated]="Activated",
  [hs.application.watcher.deactivated]="Deactivated",
  [hs.application.watcher.hidden]="Hidden",
  [hs.application.watcher.launched]="Launched",
  [hs.application.watcher.launching]="Launching",
  [hs.application.watcher.terminated]="Terminated",
  [hs.application.watcher.unhidden]="Unhidden"
}

debugAppCallbacks = function(duration)
  local duration=duration or 10
  local callback = function(appName, event, app)
    hs.printf("Callback: %s %s", appName, applicationEventName[event])
  end
  local appWatcher = hs.application.watcher.new(callback)
  hs.timer.doAfter(duration, function() appWatcher:stop() hs.printf("Debugging done") end)
  appWatcher:start()
  hs.printf("Debugging application events for %d seconds", duration)
end

debugWindowCallbacks = function(duration)
  local duration=duration or 10
  local callback = function(window, appName, eventName)
    hs.printf("Window created: Application: \"%s\" Title: \"%s\" Event: %s", appName, window:title(), eventName)
  end
  local filter = hs.window.filter.new(true) -- filter that allows every window
  filter:subscribe(hs.window.filter.windowCreated, callback)
  hs.timer.doAfter(duration, function() filter:unsubscribeAll() hs.printf("Debugging done") end)
  hs.printf("Debugging window creation events for %d seconds", duration)
end
