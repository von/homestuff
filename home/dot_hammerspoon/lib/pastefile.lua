-- pastefile.lua
-- Bring up a menu with files, allow user to select one, and put
-- its contents into the pastebuffer.
-- A pastefile is a text file with an optional first line that specifies the
-- UTI for the contents of the file (most be one of the supportedUTIs below).
-- If no leading line with a UTI exists, plain text is assumed.

local module = {}

local filechooser = require("FileChooser")

local log = hs.logger.new('pastefile', 'info')
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

local defaultUTI = "public.utf8-plain-text"

-- Following is the order of preference for extraction from the pastebuffer
-- in pasteFileWrite.
local supportedUTIs = {
  "public.rtf",
  "public.html",
  defaultUTI
}

-- pasteFileRead {{{ --
-- Read system pastebuffer from file
-- Acceptable callback for pasteFileChooser()
-- Returns true on success, false otherwise
local function pasteFileRead(path)
  -- Default if no UTI is found in file
  local uti = defaultUTI
  local data = {}

  local lines = io.lines(path)
  if not lines then
    hs.alert("Failed to open " .. path)
    return false
  end
  local firstline = lines()
  if not firstline then
    hs.alert("Empty file " .. path)
    return false
  end
  if hs.fnutils.contains(supportedUTIs, firstline) then
    uti = firstline
  else
    -- Not recognized, assume plain text and first line is data
    -- This should put an unrecognized UTI into the pastebuffer where
    -- it can be debugged.
    table.insert(data, firstline)
  end
  for line in lines do
    table.insert(data, line)
  end
  -- Note this will not put a carriage return at end of file
  if not hs.pasteboard.writeDataForUTI(uti, table.concat(data, "\n"), false) then
    hs.alert("Failed to load pastebuffer")
    return false
  end
  hs.alert("Paste buffer loaded from " .. path)
  return true
end

module["pasteFileRead"] = pasteFileRead
-- }}} pasteFileRead --

-- pasteFileWrite {{{ --
-- Write system pastebuffer to file
-- Acceptable callback for pasteFileChooser()
-- Returns true on success, false otherwise
local function pasteFileWrite(path)
  local uti = nil
  local data = nil
  for i,u in ipairs(supportedUTIs) do
    data = hs.pasteboard.readDataForUTI(u)
    if data then
      uti = u
      break
    end
  end
  if not data then
    hs.alert("No suitable data found in Paste Buffer to save")
    return false
  end
  local f = io.open(path, "w")
  if not f then
    hs.alert("Failed to open " .. path)
    return
  end
  f:write(uti .. "\n")
  f:write(data)
  f:close()
  hs.alert("Wrote pastebuffer to " .. path)
  return true
end

module["pasteFileWrite"] = pasteFileWrite
-- }}} pasteFileWrite --

-- pastebufferWriteDialog {{{ --
-- Prompt user for filename and write system pastebuffer to filename at path
local function pastebufferWriteDialog(path)
  local defaultFilename = ""
  local button, filename = hs.dialog.textPrompt("Write Paste Buffer",
    "Enter filename:", defaultFilename,
    "OK", "Cancel")
  if button == "Cancel" then
    hs.alert("Canceled")
    return false
  end
  local fullpath = path .. "/" .. filename
  if not pasteFileWrite(fullpath) then
    return false
  end
  hs.alert("Paste buffer written to " .. filename)
end

module["pastebufferWriteDialog"] = pastebufferWriteDialog
-- }}} pastebufferWriteDialog --

-- pastebufferOverwriteChooser {{{ --
-- Provide chooser with all files at path and overwrite selected file with
-- system pastebuffer.
local function pastebufferOverwriteChooser(path)
  local chooser = filechooser(path)
  chooser:go(pasteFileWrite)
end

module["pastebufferOverwriteChooser"] = pastebufferOverwriteChooser
-- }}} pastebufferOverwriteChooser

-- pasteFileLoadChooser {{{ --

-- Display chooser of files at path and load selected file into pastebuffer
local function pasteFileLoadChooser(path)
  local chooser = filechooser(path)
  chooser:go(pasteFileRead)
end

module["pasteFileLoadChooser"] = pasteFileLoadChooser
-- }}} pasteFileLoadChooser --

return module
-- vim:foldmethod=marker:
