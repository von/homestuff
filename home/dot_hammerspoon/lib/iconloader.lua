-- Load icons from files in ~/.hammerspoon/icons/

local module = {}

local scriptPath = hs.configdir .. "/icons/"

local log = hs.logger.new('iconloader', 'info')
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


local fullPath = function(iconname)
  return scriptPath .. iconname
end
module.fullPath = fullPath

-- Return hs.image from given relative filename
module.load = function(iconname)
  local path = fullPath(iconname)
  local image = hs.image.imageFromPath(path)
  if not image then
    hs.alert("Failed to load image " .. path)
    log.e("Failed to load image " .. path)
    return
  end
  return image
end

return module
