-- Handle QU codes in various ways
-- Wrapper around qrtool: https://github.com/sorairolake/qrtool
--   Install with 'brew install qrtool'

-- QRCode module
local QRCode = {}

-- qrtool binary name/path
-- XXX Hardcoded path
QRCode.cmd = "/opt/homebrew/bin/qrtool"

-- Set up logger for module
QRCode.log = hs.logger.new("Module", "info")

function QRCode:debug(enable)
  if enable then
    self.log.setLogLevel('debug')
    self.log.d("Debugging enabled")
  else
    self.log.d("Disabling debugging")
    self.log.setLogLevel('info')
  end
end

-- Return a unique, temporary filename
-- Caller is responsible for removing file when done
local function tmpfile(suffix)
end

-- Given a string, encode it and write it out to png file given by path
-- Returns true on success, false otherwise
function QRCode:encode(str, path)
  local cmd = self.cmd .. " encode -o " .. path .. " \"" .. str .. "\""
  local output, status, type, rc = hs.execute(cmd)
  if not status then
    hs.alert("QR encoding failed.")
    if type == "exit" then
      self.log.ef("Failed to run command (rc = %d): %s", rc, cmd)
    else
      self.log.ef("Command killed by signal (%d): %s", rc, cmd)
    end
    return false
  end
  return true
end


-- Given a string, encode it and place the image in the pastebuffer
-- Returns true on success, false otherwise
function QRCode:encodeToPasteboard(str)
  local path = os.tmpname()
  if not self:encode(str, path) then
    return false
  end
  local img = hs.image.imageFromPath(path)
  os.remove(path)
  if not img then
    hs.alert("Failed to load image from temporary file")
    self.log.e("Failed to load image from " .. path)
    return false
  end
  if not hs.pasteboard.writeObjects(img) then
    hs.alert("Failed to update pasteboard")
    self.log.e("Failed to update pasteboard")
    return false
  end
  return true
end


-- Encode the string in the pastebuffer, placing the resulting image into
-- the pastebuffer.
-- Returns true on success, false otherwise
function QRCode:encodePasteboard()
  local str = hs.pasteboard.getContents()
  if not str then
    hs.alert("Pasteboard empty")
    self.log.i("Pasteboard empty")
    return false
  end
  return self:encodeToPasteboard(str)
end


-- Given a path to a image file, decode QR code it contains and return the data
-- Returns nil on error
function QRCode:decode(path)
  local cmd = self.cmd .. " decode " .. path
  local output, status, type, rc = hs.execute(cmd)
  if not status then
    hs.alert("QR decoding failed.")
    if type == "exit" then
      self.log.ef("Failed to run command (rc = %d): %s", rc, cmd)
    else
      self.log.ef("Command killed by signal (%d): %s", rc, cmd)
    end
    return nil
  end
  return output
end


-- Decode image from pasteboard
-- Returns string on success, nil on erro
function QRCode:decodeFromPasteboard()
  local img = hs.pasteboard.readImage()
  if not img then
    hs.alert("No image in pastebuffer")
    self.log.i("No image in pastebuffer")
    return false
  end
  local path = os.tmpname()
  if not img:saveToFile(path) then
    hs.alert("Failed to write image to temporary file")
    self.log.ef("Failed to write image to temporary file %s", path)
    return false
  end
  local str = self:decode(path)
  os.remove(path)
  return str -- may be nil
end


-- Decode the image in the pastebuffer, placing the resulting string into the pastebuffer
-- Returns true on success, false otherwise
function QRCode:decodePasteboard()
  local str = self:decodeFromPasteboard()
  if not str then
    return false
  end
  if not hs.pasteboard.setContents(str) then
    hs.alert("Failed to set pasteboard")
    self.e("Failed to set pasteboard")
    return false
  end
  return true
end

return QRCode
