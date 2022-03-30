-- Turn debugging on for modules and Spoons as specified in MyConfig
--
-- Modules must have a debug() method that is called with true to turn on debugging.

local Module = {}

-- Set up logger for module
Module.log = hs.logger.new("ModuleDebug", "info")

function Module:debug(enable)
  if enable then
    self.log.setLogLevel('debug')
    self.log.d("Debugging enabled")
  else
    self.log.d("Disabling debugging")
    self.log.setLogLevel('info')
  end
end

-- Should be a table of <module name>,<value>
Module.modules = MyConfig["debug.modules"] or {}

function Module:start()
  if Module.modules then
    for module,v in pairs(Module.modules) do
      if v then
        Module.log.df("Turning on debugging for %s", module)
        local f = function()
          local m = require(module)
          m:debug(true)
        end
        local result, errormsg = pcall(f)
        if not result then
          Module.log.ef("Error turning on debugging for %s: %s", module, errormsg)
        end
      end
    end
  end
end

return Module
