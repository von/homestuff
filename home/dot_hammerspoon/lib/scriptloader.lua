-- Load scripts from files in ~/.hammerspoon/scripts/

local module = {}

local scriptPath = hs.configdir .. "/scripts/"

local log = hs.logger.new('scriptloader', 'info')
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


local fullPath = function(scriptname)
  return scriptPath .. scriptname
end
module.fullPath = fullPath

module.load = function(scriptname)
  local path = fullPath(scriptname)
  local f = io.open(path, "r")
  if not f then
    hs.alert("Failed to open " .. path)
    log.e("Failed to open " .. path)
    return
  end
  local txt = f:read("*all")
  f:close()
  return txt
end

return module
