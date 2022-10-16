-- util.lua
-- Miscellaneous utilities

local module = {}

local loader = require("scriptloader")
local log = hs.logger.new("util", "info")
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

-- Capture screen and open in Preview
module.screencapture = function()
  hs.alert.show("Capturing screen...")
  -- -P == opens capture in Preview
  -- -x == no sounds
  -- hs.execute("screencapture -P ${TMPDIR}/hs-screencapture-$$.png")
  local task = hs.task.new("/usr/sbin/screencapture", nil,
    { "-P", "-x",
      os.getenv("TMPDIR") .. "/hs-screencapture-" .. tostring(os.time()) .. ".png"
    })
  task:start()
end

-- Interactively capture selected window or screen area and open in Preview
module.windowcapture = function()
  hs.alert.show("Capturing window or area...")
  -- -i == Interactive
  -- -P == opens capture in Preview
  -- -W == Start in window slection mode
  -- -x == No sounds
  -- hs.execute("screencapture -i -W -P ${TMPDIR}/hs-screencapture-$$.png")
  local task = hs.task.new("/usr/sbin/screencapture", nil,
    { "-i", "-W", "-P", "-x",
      os.getenv("TMPDIR") .. "/hs-windowcapture-" .. tostring(os.time()) .. ".png"
    })
  task:start()
end

-- Interactively capture selected window or screen area in pasteboard
module.windowcapturepb = function()
  hs.alert.show("Capturing window or area to pastboard...")
  -- -i == Interactive
  -- -c == Captures to pastboard
  -- -W == Start in window slection mode
  -- -x == No sounds
  -- hs.execute("screencapture -i -W -c ${TMPDIR}/hs-screencapture-$$.png")
  local task = hs.task.new("/usr/sbin/screencapture", nil,
    { "-i", "-W", "-c", "-x",
      os.getenv("TMPDIR") .. "/hs-windowcapture-" .. tostring(os.time()) .. ".png"
    })
  task:start()
end

-- Clean up URL in clipboard
module.urlclean = function()
  hs.alert.show("Cleaning URL in clipboard...")
  hs.execute(os.getenv("HOME") .. "/bin/urlclean")
end

-- Count characters in pastebuffer, displaying in alert
module.pbcharcount = function()
  local pb = hs.pasteboard.readString()
  if not pb then
    hs.alert.show("Clipboard empty")
    return
  end
  _,words = pb:gsub("%S+","")
  chars = pb:len()
  hs.alert.show("Char count: " .. chars)
end

-- Count words in pastebuffer, displaying in alert
module.pbwordcount = function()
  local pb = hs.pasteboard.readString()
  if not pb then
    hs.alert.show("Clipboard empty")
    return
  end
  -- Kudos: http://stackoverflow.com/a/29136751
  _,words = pb:gsub("%S+","")
  hs.alert.show("Word count: " .. words)
end

-- Check network
module.checknetwork = function()
  local callback = function(exitCode, stdout, stderr)
    if exitCode == 0 then
      hs.alert.show("Network good")
    else
      hs.alert.show("Network check failed: " .. stdout:gsub("^%s*(.-)%s*$", "%1").. stderr:gsub("^%s*(.-)%s*$", "%1"))
    end
  end -- callback()
  hs.alert.show("Checking network...")
  local task = hs.task.new(os.getenv("HOME") .. "/bin/check-network", callback)
  task:start()
end


-- Get 'message:' url for selected message in Apple Mail
-- Emails from me don't seem to have this header.
-- Uses ../scripts/mailGetUrl.scpt
local mailGetURLScript = loader.load("mailGetURL.scpt")
module.getmailurl = function()
  local result, output, desc = hs.osascript.applescript(mailGetURLScript)
  if result then
    hs.alert("Mail message URL copied to clipboard")
  else
    hs.alert("Could not get Mail message url")
    hs.printf("Could not get Mail message url: " .. desc.OSAScriptErrorMessageKey)
  end
end

-- Rotate the log level of loaded modules.
local logLevels = { 'nothing', 'error', 'warning', 'info', 'debug', 'verbose' }
local currentLogLevel = 2 -- 'warning' by default

module.rotateLogLevel = function()
  currentLogLevel = (currentLogLevel + 1) % #logLevels
  local name = logLevels[currentLogLevel + 1]
  hs.alert("Setting logger level to " .. name)
  log.f("Setting logger level to %s", name)
  -- hs.logger.setModulesLogLevel() doesn't seem to work as expected here
  hs.logger.setGlobalLogLevel(currentLogLevel)
end

return module
