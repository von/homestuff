-- FileChooser
-- Interface to a chooser with files from a given directory, calling a callback
-- function.

-- The table representing the class, which will double as the metatable for the instances
local FileChooser = {}
-- Failed table lookups on the instances should fallback to the class table, to get methods
FileChooser.__index = FileChooser

-- Calls to FileChooser() return FileChooser.new()
setmetatable(FileChooser, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

-- Set up logger
local log = hs.logger.new("FileChooser")
FileChooser.log = log

-- syntax equivalent to "FileChooser.new = function..."
function FileChooser.new(path)
  log.d("new() called")
  local self = setmetatable({}, FileChooser)
  self.path = path
  return self
end

-- Launch chooser and call callback with choice
--   callback() should take one argument, the full path to the chosen file
--   Optional errorcallback() should take one argument, an error message.
--    If not provided, hs.alert() is used instead.
function FileChooser.go(self, callback, errorcallback)
  local path = self.path
  if not errorcallback then
    errorcallback = hs.alert
  end
  local iter, data = hs.fs.dir(path)
  if iter == nil then
    errorcallback("Path " .. path .. " does not exist.")
    return
  end
  local choices = {}
  for file in hs.fs.dir(path) do
    -- If filename starts with "." ignore it
    -- This catches "." ".." as well
    if file:sub(1,1) == "." then -- noop
    else
      local choice = {
        ["text"] = file,
        ["path"] = path .. "/" .. file
      }
      table.insert(choices, choice)
    end
  end

  if #choices == 0 then
    errorcallback("No files found in " .. path)
    return
  end

  -- Call callback with path
  local callbackWrapper = function(info)
    if not info then
      log.d("User canceled selection")
      return false
    end
    if not callback(info["path"]) then
      return false
    end
  end

  table.sort(choices, function(a,b) return a.text:lower() < b.text:lower() end)
  chooser = hs.chooser.new(callbackWrapper)
  chooser:choices(choices)
  chooser:show()
end

-- If module, return class definition
return FileChooser
