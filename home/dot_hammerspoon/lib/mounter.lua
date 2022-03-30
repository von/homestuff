-- mounter.lua
-- Return a function to mount a volume.
-- Meant for use in hotkey bindings.

local module = {}

local loader = require("scriptloader")
local taskext = require("taskext")
local taskrunner = require("TaskRunner")

local path = loader.fullPath("mounter.scpt")

local log = hs.logger.new('mounter', 'info')
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

module.new = function(volname)
  return function()
    local taskFunction = function(callback)
      return taskext.newFromOSAPath(path, callback, {volname})
    end

    local runner = taskrunner(taskFunction)
    runner:setMessages({
        start = "Mounting " .. volname,
        success = "Mounted " .. volname,
        failure = "Could not mount " .. volname,
      })
    runner:run()
  end
end

return module
