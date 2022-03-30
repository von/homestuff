-- Make sure commandline client (/usr/local/bin/hs) is installed
-- and IPC module is running.
require("hs.ipc")

local logger = hs.logger.new("ipc", "info")

local myConfig = MyConfig["ipc"] or {}
-- XXX /usr/local seems to be hard-corded into the client
-- See https://github.com/Hammerspoon/hammerspoon/issues/3088
-- On Macs with Apple chips, with homebrew in /opt/homebrew, /usr/local
-- make not be writable.
local path = myConfig["path"] or "/usr/local"

-- Second parameter to cliStatus() and cliInstall() is silent
if hs.ipc.cliStatus(path, false) then
  logger.d("HammerSpoon CLI already installed at " .. path)
else
  logger.i("Installing HammerSpoon CLI in " .. path)
  hs.alert.show("Installing HammerSpoon CLI tool")
  local result = hs.ipc.cliInstall(path, true)
  if result then
    logger.i("CLI install successful.")
  else
    logger.e("CLI install failed.")
    hs.alert.show("CLI install failed.")
  end
end

hs.ipc.cliColors({
    -- Logged stuff
    initial = "\27[35m", -- Magenta
    -- Prompt and typed input
    input = "\27[33m", -- Yellow
    -- Output from run commands
    output = "\27[26m" -- Cyan
  })
