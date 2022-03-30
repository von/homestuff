-- DownloadChooser module
local DownloadChooser = {}

-- Path to Download director
DownloadChooser.path = os.getenv("HOME") .. "/Downloads/"

-- Set up logger
DownloadChooser.log = hs.logger.new("DownloadChooser", "info")

function DownloadChooser:debug(enable)
  if enable then
    self.log.setLogLevel('debug')
    self.log.d("Debugging enabled")
  else
    self.log.d("Disabling debugging")
    self.log.setLogLevel('info')
  end
end

local function callback(choice)
  if not choice then
    return -- User dismissed
  end
  hs.open(choice.path)
end

function DownloadChooser:show()
  local iter, dirObj = hs.fs.dir(self.path)
  if not iter then
    self.log.ef("Error reading %s: %s", self, path, dirObj)
    return false
  end
  local files = {}
  for file in iter, dirObj do
    -- This catches "." and ".." as well as dotfiles
    if file:sub(1,1) == "." then
      -- No-op
    else
      table.insert(files, file)
    end
  end
  -- Sort by modification time
  local function byModificationTime(a,b)
    return hs.fs.attributes(self.path .. a, "modification") > hs.fs.attributes(self.path .. b, "modification")
  end
  table.sort(files, byModificationTime)
  local c = hs.chooser.new(callback)
  local choices = hs.fnutils.map(files,
    function(f) return { text = f, path = self.path .. f } end)
  c:choices(choices)
  c:show()
  return true
end

return DownloadChooser
