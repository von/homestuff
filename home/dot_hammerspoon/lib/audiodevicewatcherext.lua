-- Audiodevicewatcherext
--
-- Wrapper around hs.audiodevice.watcher that allows chaining of multiple callbacks.
-- See https://github.com/Hammerspoon/hammerspoon/issues/3865
local module = {}

local module.callbacks = ()

module.log = hs.logger.new("audiodevicewatcherext", "info")

if hs.audiodevice.watcher.isRunning() then
  module.log.e("hs.audiodevice.watcher already running. Refusing to start.")
  return nil
end

module.callback = function(self, dIn, dOut, sOut, devnum)
  hs.fnutils.each(self.callbacks, function(c)
      staus, err = pcall(c, dIn, dOut, sOut, devnum)
      if not status then
        self.log.ef("callback returned error: %s", err)
      end
    end
    )
end

module.addCallback = function(self, callback)
  -- TODO: Check for callback already being in the list
  table.insert(self.callbacks, callback)
end

-- Initialize the module
module.log.d("Starting hs.audiodevice.watcher")
hs.audiodevice.watcher.setCallback(hs.fnutils.partial(module.callback, module)
hs.audiodevice.watcher.start()

return module
