-- Make sure commandline client (${HOMEBREW_PREFIX}/bin/hs) is installed
-- and IPC module is running.
require("hs.ipc")

local logger = hs.logger.new("ipc", "info")

-- Set in ../init.lua
local path = homebrew_prefix

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
