-- Turn debugging on for modules and Spoons as specified in MyConfig
--
-- 1) Use module:debug(true) method if that method exists.
-- 2) Use module.logger.setLogLevel("debug") if module.logger exists.

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
          -- Try to call module:debug(true) if it has a debug() method
          local m = require(module)
          if m.debug then
            Module.log.df("Calling %s:debug(true)", module)
            m:debug(true)
            return
          end 
          -- Try setting level on module.logger
          if m.logger then
            Module.log.df("Setting loglevel on %s.logger to debug", module)
            -- Yes "." not ":" - it's a static function
            m.logger.setLogLevel("debug")
            return
          end
          Module.log.ef("Could not turn on debugging on %s", module)
        end
        local result, errormsg = pcall(f)
        if not result then
          Module.log.df("Error enabling debugging for %s: %s",
            module, errormsg)
        end
      end
    end
  end
end

return Module
