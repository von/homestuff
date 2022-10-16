-- Init file for HammerSpoon - http://www.hammerspoon.org/
------------------------------------------------------------
-- List of errors (as strings) encountered during setup. These
-- will be displayed prominently at end of init.lua
local errors = {}
------------------------------------------------------------
-- Configure console

hs.console.darkMode(true)
hs.console.consoleFont({ name = "Courier New", size = 16 })
-- Alpha == transparency. 0 = fully transparent, 1 = fully opaque
hs.console.alpha(0.985)

local colors = hs.drawing.color.definedCollections
hs.console.outputBackgroundColor(colors.hammerspoon.black)
hs.console.inputBackgroundColor(colors.hammerspoon.black)
hs.console.consoleCommandColor(colors.hammerspoon.white)
hs.console.consoleResultColor(colors.x11.lightgreen)
hs.console.consolePrintColor(colors.x11.lightgrey)

------------------------------------------------------------
-- Default log level
-- Options are: 'nothing', 'error', 'warning', 'info', 'debug', or 'verbose'
hs.logger.defaultLogLevel = "warning"

local log = hs.logger.new("init", "info")
log.i("Hammerspoon configuration loading...")

-- lower logging level for noisy Hammerspoon modules
-- Kudos: https://github.com/megalithic/dotfiles/tree/master/hammerspoon
hs.hotkey.setLogLevel("warning")
hs.window.filter.setLogLevel(1)

------------------------------------------------------------
-- My personal Zoom rooms
workDefaultZoomId = "4027221152"
personalDefaultZoomId = "2888787860"

------------------------------------------------------------
-- Configuration options based on hostname

local hostname = hs.host.localizedName()
if hostname == "Vons-WL" then
  defaultChromePersona="IU"
  defaultZoomMeetingId = workDefaultZoomId
  WorkLaptop = true
else
  WorkLaptop = false
end

if hostname == "Vons-PL" then
  defaultChromePersona="Personal"
  defaultZoomMeetingId = personalDefaultZoomId
  PersonalLaptop = true
else
  PersonalLaptop = false
end

------------------------------------------------------------
-- Install Spoons
-- This should have been intalled into ~/.hammerspoon/Spoons/ by
-- ~/homestuff/os/Darwin/init/92-hammerspoon-bootstrap.sh

hs.loadSpoon("SpoonInstall")
-- Have andUse() update and install packages synchronously
spoon.SpoonInstall.use_syncinstall = true

local install = spoon.SpoonInstall

install:andUse("EjectMenu", {
    config = {
      -- This seems to eject only when the lid is re-opened, which isn't useful
      eject_on_lid_close = false,
      show_in_menubar = true,
      notify = true,
      never_eject = {
        "/Volumes/GoogleDrive"
      },
    },
    start = true
  })
install:andUse("MouseCircle")
install:andUse("PasswordGenerator")
install:andUse("Seal")
-- It's tempting to restore the default http/https handler when Hammerspoon
-- quits, but OSX asks each time we change the handler, which gets annoying
-- quickly.
install:andUse("URLDispatcher", {start = true})
install:andUse("WiFiTransitions")
install:andUse("WinWin")

------------------------------------------------------------
-- Set up package.path
-- This is what require searches and also where spoons are looked for

-- Include my lib/ directory
-- hs.configdir is typically ~/.hammerspoon/
package.path = package.path .. ";" ..  hs.configdir .. "/lib/?.lua"

-- Include MySpoons, my personal spoons
package.path = package.path .. ";" ..  hs.configdir .. "/MySpoons/?.spoon/init.lua"

------------------------------------------------------------
-- Read extensions from ~/.hammerspoon/ext/*.lua
-- Then configuration from ~/.hammerspoon/config/*.lua
-- Then local configuration from ~/.hammerspoon-local/*.lua
-- Also *.json files from those paths and load into MyConfig dictionary

local extPath = hs.configdir .. "/ext/"
local configPath = hs.configdir .. "/config/"
local localConfigPath = os.getenv("HOME") .. "/.hammerspoon-local/"

-- Global configuration containing contents of *.json files
-- This is a two-level dictionary: topic->key->value
MyConfig = {}

function mergeConfigs(main, new)
  for topic,tv in pairs(new) do
    if not main[topic] then
      main[topic] = {}
    end
    if type(tv) == "table" then
      for k,v in pairs(tv) do
        main[topic][k] = v
      end
    else
      log.ef("Configuration is not a table: %s.%s", topic, tv)
    end
  end
end

function loadConfigs(path)
  -- As of 0.9.81 hs.fs.dir throws an error if path does not exist, so check first
  local attr, err = hs.fs.attributes(path)
  if not attr then
    -- Only a warning as we may have optional paths
    log.wf("Configuration path %s: %s", path, err)
    return false
  end
  for file in hs.fs.dir(path) do
    local fullpath = path .. file
    if file == "." or file == ".." then
      -- Ignore
    elseif file:sub(-4) == ".lua" then
      log.f("Reading configuration file %s", fullpath)
      -- xpcall() kudos https://stackoverflow.com/a/45788987/197789
      local result, errormsg = xpcall(dofile, debug.traceback, fullpath)
      if not result then
        log.ef("Error parsing %s: %s", fullpath, errormsg)
        hs.alert.show("Error parsing " .. fullpath)
        table.insert(errors, "Error parsing " .. fullpath)
      end
    elseif file:sub(-5) == ".json" then
      log.f("Reading configuration file %s", fullpath)
      local c = hs.json.read(fullpath)
      if c then
        mergeConfigs(MyConfig, c)
      else
        log.ef("Error reading %s", fullpath)
        table.insert(errors, "Error reading " .. fullpath)
      end
    else
      -- Recurse into subdirectories
      local attr = hs.fs.attributes(fullpath)
      if attr.mode == "directory" then
        log.f("Recursing into directory %s", fullpath)
        loadConfigs(fullpath .. "/")
      end
    end
  end
  return true
end

-- Load local configuration first so it takes precedent
loadConfigs(localConfigPath)
loadConfigs(extPath)
loadConfigs(configPath)

------------------------------------------------------------
-- Turn on debuging for requested modules
local d = require("ModuleDebug")
d:debug(true)
d:start()

------------------------------------------------------------
-- Install handler for hammerspoon://chromePersona?name=<name>
local chrome = require("chrome")
chrome.installHandler()
------------------------------------------------------------
-- Apply Context based on Screen configuration
local Contexts = hs.loadSpoon("Contexts")
Contexts:applyMapping()

------------------------------------------------------------
-- Load other modules
local focusOnMinimize = require("focusTweaks")

------------------------------------------------------------
-- hs.shutdownCallback

hs.shutdownCallback = function()
  log.i("Hammerspoon shutting down.")
  hs.alert("Hammerspoon shutting down.")
end

------------------------------------------------------------
-- Done.
hs.alert.show("HammerSpoon configuration loaded.")
log.i("Hammerspoon configuration loaded.")

if #errors > 0 then
  hs.alert.show("Encountered " .. #errors .. " errors during setup.")
  for i,err in ipairs(errors) do
    log.ef("Error %d: %s", i, err)
  end
end
------------------------------------------------------------
