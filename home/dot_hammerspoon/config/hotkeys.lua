-- hotkeys.lua
--
------------------------------------------------------------
-- Load required modules {{{ --
local appkeys = require("appkeys")
local applauncher = require("applauncher")
local gmail = hs.loadSpoon("Email").GMail()
local chrome = require("chrome")
local cchooser = require("CommandChooser")
-- Don't use loadSpoon() here to preserve state from ../config/contexts.lua
local Contexts = require("Contexts")
local DownloadChooser = require("DownloadChooser")
local EjectMenu = hs.loadSpoon("EjectMenu")
local execfunction = require("execfunction")
local LastWindow = require("LastWindow")
local launchDefaultApps = require("launchDefaultApps")
local Modal = hs.loadSpoon("ModalExt")
local modifiers = Modal.modifiers
local mounter = require("mounter")
local MouseCircle = spoon.MouseCircle
local outlook = hs.loadSpoon("Email").Outlook()
local pastefile = require("pastefile")
local PBExt = hs.loadSpoon("PasteBoardExt")
local PasswordGenerator = hs.loadSpoon("PasswordGenerator")
local PasteRegister = hs.loadSpoon("PasteRegister")
local PasteStack = hs.loadSpoon("PasteStack")
local RescueWindows = require("RescueWindows")
local seal = hs.loadSpoon("Seal")
local screensaver = hs.loadSpoon("ScreenSaver")
local Teams = require("Teams")
local Tiler = hs.loadSpoon("Tiler")
local URLOpener = require("URLOpener")
local util = require("util")
local winlauncher = require("winlauncher")
local WindowPool = require("WindowPool")
local WinWin = spoon.WinWin
local WW = require("WatcherWatcher")
local Zoom = require("Zoom")

-- }}} Load required modules --
------------------------------------------------------------
local config = MyConfig['hotkeys'] or {}
------------------------------------------------------------
-- Set default email interface
local defaultEmail = gmail
defaultEmail:useHTMLforCompose(false)  -- Use 'true' for New Outlook
------------------------------------------------------------
-- Configure Modal Spoon
Modal.defaults.cheatsheetDelay = 2
------------------------------------------------------------
-- Mod-A: Modal hotkey for Opening Applications {{{ --

local openAppModalKeys = {
  B = {
    func = applauncher.new("Google Chrome"),
    desc = "Google Chrome"
  },
  E = {
    func = applauncher.new("Evernote"),
    desc = "Evernote"
  },
  F = {
    func = applauncher.new("Finder"),
    desc = "Finder"
  },
  H = {
    func = function()
      local w = hs.console.hswindow()
      if w then
        w:focus()
      else
        -- Open and bring to front
        hs.openConsole(true)
      end
    end,
    desc = "Hammerspoon console"
  },
  I = {
    -- "iTerm" and not "iTerm2"
    func = applauncher.new("iTerm"),
    desc = "iTerm2"
  },
  L = {
    func = function() launchDefaultApps.launch() end,
    desc = "Launch default applications"
  },
  V = {
    func = applauncher.new("VOX"),
    desc = "VOX"
  },
  Z = {
    func = applauncher.new("zoom.us"),
    desc = "Zoom"
  },
}

if config["MSOutlook"] then
  openAppModalKeys["C"] = {
    func = function() outlook:focusOnCalendar() end,
    desc = "Calendar"
  }
end

if config["Discord"] then
  openAppModalKeys["D"] = {
    func = applauncher.new("Discord"),
    desc = "Discord"
  }
end

if config["AppleMail"] then
  -- TODO: Find way to focus on Mail window (name changes with mailbox)
  openAppModalKeys["M"] = {
    func = applauncher.new("Mail"),
    desc = "Apple Mail"
  }
end

if config["Slack"] then
  openAppModalKeys["S"] = {
    func = applauncher.new("Slack"),
    desc = "Chat (Slack)"
  }
end

if config["MSTeams"] then
  openAppModalKeys["T"] = {
    func = applauncher.new("Microsoft Teams"),
    desc = "Microsoft Teams"
  }
end

local openAppMode = Modal:new(modifiers.opt, 'A', "Open application", openAppModalKeys)

-- }}} Mod-A: Modal hotkey for Opening Applications --
------------------------------------------------------------
-- Mod-B: Modal hotkey for Browser control {{{ --

local browserModalKeys = {
  A = {
    func = chrome.wrapped.activateTab("My Tasks",
      { url = "https://app.asana.com/",
        persona = defaultChromePersona, newWindow = true }),
    desc = "Open Asana"
  },
  D = {
    func = chrome.wrapped.selectPersona("Dev"),
    desc = "Chrome Dev Persona"
  },
  G = {
    func = chrome.wrapped.activateTab("My Drive",
      { url = "https://drive.google.com/drive/",
        persona = defaultChromePersona, newWindow = true }),
    desc = "Open Google Drive"
  },
  M = {
    func = chrome.wrapped.activateTab("Google Play Music",
        { url = "https://play.google.com/music/",
          persona = "Personal",
          newWindow = true
        }),
    desc = "Google Play Music"
  },
  N = {
    func = chrome.wrapped.openURL(
      { url = "",
        persona = defaultChromePersona,
        newWindow = true
      }),
    desc = "New Chrmoe Window"
  },
  O = {
    func = function() PBExt:openURL() end,
    desc = "Open URL contained in Paste Buffer"
  },
  P = {
    func = chrome.wrapped.selectPersona("Personal"),
    desc = "Chrome Personal Persona"
  },
  R = {
    func = function() URLOpener.setWindow(nil) end,
    desc = "Reset browser window opening URLs"
  },
  S = {
    func = chrome.wrapped.selectPersona("Social"),
    desc = "Chrome Social Persona"
  },
  T = {
    func = chrome.wrapped.activateTab("TripIt",
        { url = "https://www.tripit.com/trips", persona = "Personal", newWindow=true }),
    desc = "Open TripIt"
  },
  V = {
    func = chrome.wrapped.selectPersona("vonwelch.com"),
    desc = "Chrome vonwelch.com Persona"
  },
  W = {
    func = chrome.wrapped.selectPersona("IU"),
    desc = "Chrome Work Persona"
  },
  Z = {
    func = chrome.wrapped.openURL{
      url = defaultZoomMeetingId,
      persona = defaultChromePersona,
      newWindow = true
    },
    desc = "Open Peronal Zoom Meeting"
  }
}

local function mailFromChromeTab()
  if not defaultEmail:compose({
      subject = chrome.getActiveTabTitle(),
      content = chrome.getActiveTabURL()
    }) then
    hs.alert("Failed to create email from Chrome tab")
  end
end
browserModalKeys["E"] = {
  func = mailFromChromeTab,
  desc = "Create Mail from frontmost tab"
}

if config["MSOutlook"] then
  browserModalKeys["C"] = {
    func = chrome.wrapped.activateTab("Welch, Von - Outlook",
      {
        url = "https://www.exchange.iu.edu/owa/#path=/calendar",
        persona = "IU",
        newWindow = true
      }),
    desc = "Open Exchange Calendar"
  }
end

local broswerMode = Modal:new(modifiers.opt, 'B', "Browser control", browserModalKeys)

-- }}} Mod-B: Modal hotkey for Browser control --
------------------------------------------------------------
-- Mod-C: Clean Paste Buffer {{{ --
hs.hotkey.bind(modifiers.opt, 'C', "Clean Paste Buffer", function() PBExt:clean() end)
-- }}} Mod-C: Clean Paste Buffer --
------------------------------------------------------------
-- Mod-D: Modal hotkey for Managing Display {{{ --

local displayModalKeys = {
  D = {
    func = function() screensaver:disable() end,
    desc = "Disable Screensaver"
  },
  E = {
    func = function() screensaver:enable() end,
    desc = "Enable Screensaver"
  },
  G = {
    func = function() hs.alert(string.format("Timeout: %d", screensaver:getTimeout())) end,
    desc = "Get Screensaver Timeout"
  },
  P = {
    func = function() hs.screen.primaryScreen():next():setPrimary() end,
    desc = "Rotate Primary screen"
  },
  R = {
    func = function() RescueWindows:rescue() end,
    desc = "Rescue Windows"
  },
  S = {
    func = function() screensaver:suspend() end,
    desc = "Suspend Screensaver for One Hour"
  },
}

local displayMode = Modal:new(modifiers.opt, 'D', "Display Mode", displayModalKeys)

-- }}} Mod-D: Modal hotkey for Managing Display --
------------------------------------------------------------
-- Mod-E: Modal hotkey for Email {{{ --

local emailTemplatePath = os.getenv("HOME") .. "/.email-templates"

local emailModalKeys = {
  T = {
    func = function() defaultEmail:composeFromChooser(emailTemplatePath) end,
    desc = "New email from template"
  },
  U = {
    func = util.getmailurl,
    desc = "Copy Mail message URL to clipboard"
  },
}

local emailMode = Modal:new(modifiers.opt, 'E', "Email Mode", emailModalKeys)

-- }}} Mod-E: Modal hotkey for Email --
------------------------------------------------------------
-- Mod-H: Show Help {{{ --

-- Using an empty table still binds escape to exit.
local helpModalKeys = {
}

local helpMode = Modal:new(modifiers.opt, 'H', "Show Help", helpModalKeys,
  { cheatsheetDelay = 0 })

-- }}} Mod-H: Show Help --
------------------------------------------------------------
-- Mod-M: Modal hotkey for Mounting {{{ --

if config["PersonalMounts"] then
  local mountModalKeys = {
    M = {
      func = mounter.new("afp://von@EmmaCrate.local/music"),
      desc = "Mount music"
    },
    V = {
      func = mounter.new("afp://von@EmmaCrate.local/video"),
      desc = "Mount video"
    }
  }

  local mountMode = Modal:new(modifiers.opt, 'M', "Mount Mode", mountModalKeys)
end

-- }}} Mod-M: Modal hotkey for Mounting --
------------------------------------------------------------
-- Mod-P: Modal hotkey for Paste Buffer {{{ --

local pastesPath = os.getenv("HOME") .. "/.pastes"

local pastebufferModalKeys = {
  B = {
    func = chrome.wrapped.urlToPastebuffer(),
    desc = "Copy Paste Buffer from Chrome"
  },
  C = {
    func = function() util.pbwordcount() end,
    desc = "Count words in Paste Buffer",
    mods = {
      {
        mod = optionShift,
        func = function() util.pbcharcount() end,
        desc = "Count characters in Paste Buffer"
      }
    }
  },
  D = {
    func = PasteRegister.queryAndClearRegister,
    desc = "Delete register"
  },
  E = {
    func = function() PBExt:edit() end,
    desc = "Edit Paste Buffer"
  },
  F = {
    func = function() pastefile.pasteFileLoadChooser(pastesPath) end,
    desc = "Load Paste Buffer from file"
  },
  G = {
    func = function() PasswordGenerator:copyPassword() end,
    desc = "Generate password and place in clipboard"
  },
  L = {
    func = PasteRegister.queryAndLoadPasteBuffer,
    desc = "Load Paste Buffer from register"
  },
  O = {
    func = function() PBExt:openURL() end,
    desc = "Open URL contained in Paste Buffer"
  },
  P = {
    func = PasteRegister.queryAndPasteRegister,
    desc = "Paste register"
  },
  S = {
    func = PasteRegister.queryAndSavePasteBuffer,
    desc = "Save Paste Buffer to register"
  },
  -- Kudos: http://www.hammerspoon.org/go/#pasteblock
  V = {
    func = function() PBExt:keyStrokes() end,
    desc = "Paste with keystrokes (defeat paste blocking)"
  },
  W = {
    func = function() pastefile.pastebufferWriteDialog(pastesPath) end,
    desc = "Save Paste Buffer to file",
    mods = {
      {
        mod = optionShift,
        func = function() pastefile.pastebufferOverwriteChooser(pastesPath) end,
        desc = "Save Paste Buffer to existing file",
      }
    }
  },
  X = {
    func = function() PasteStack:pop() end,
    desc = "Pop paste buffer off of stack"
  },
  Z = {
    func = function() PasteStack:push() end,
    desc = "Push paste buffer onto stack"
  }
}

local pastebufferMode = Modal:new(modifiers.opt, 'P', "Paste Buffer Mode", pastebufferModalKeys)

-- }}} Mod-P: Modal hotkey for Paste Buffer --
------------------------------------------------------------
-- Mod-U: Modal hotkey for Utilities {{{ --

local utilModalKeys = {
  A = {
    -- In case one gets left somehow
    func = hs.alert.closeAll,
    desc = "Close all alerts"
  },
  C = {
    func = util.urlclean,
    desc = "Clean URL in clipboard"
  },
  D = {
    func = function() DownloadChooser:show() end,
    desc = "Show download chooser"
  },
  E = {
    func = function() EjectMenu:ejectVolumes() end,
    desc = "Eject Mounted Drives"
  },
  H = {
    func = hs.toggleConsole,
    desc = "Toggle Hammerspoon Console"
  },
  L = {
    func = hs.caffeinate.lockScreen,
    desc = "Lock Screen"
  },
  M = {
    func = function() WW:mute() end,
    desc = "Mute WatcherWatcher flashers"
  },
  N = {
    func = util.checknetwork,
    desc = "Check Network"
  },
  P = {
    func = util.windowcapturepb,
    desc = "Window or Area Capture to pasteboard"
  },
  S = {
    func = util.screencapture,
    desc = "Screen Capture"
  },
  W = {
    func = util.windowcapture,
    desc = "Window or Area Capture"
  },
}

local utilMode = Modal:new(modifiers.opt, 'U', "Utilities", utilModalKeys)

-- }}} Mod-U: Modal hotkey for Utilities --
----------------------------------------------------------------------
-- Mod-X is used by iTerm
-- Mod-Z is used by iTerm
----------------------------------------------------------------------
-- Mod-Tab: Previous browser tab {{{ --

hs.hotkey.bind(modifiers.opt, "Tab", "Previous Chrome Tab", chrome.wrapped.previousTab())

-- }}} Mod-Tab: Browser window switcher --
----------------------------------------------------------------------
-- CapsLock/f19 keybindings {{{ --
-- Karabiner-Elements remaps CapsLock to F19 when pressed and released
-- Kudos: http://evantravers.com/articles/2020/06/08/hammerspoon-a-better-better-hyper-key/

local hyperModalKeys = {
  TAB = {
    func = function() WindowPool:toggleFocusedWindow() end,
    desc = "Toggle focused window from pool"
  },
  space = {
    func = function() seal:show() end,
    desc = "Open Seal"
  },
  A = {
    func = function() Contexts:chooser() end,
    desc = "Contexts chooser"
  },
  C = {
    func = function() cchooser():go() end,
    desc = "Command chooser"
  },
  D = {
    func = function() hs.alert(os.date("%A %B %d %Y")) end,
    desc = "Show date"
  },
  P = {
    func = function() PasteRegister:chooser() end,
    desc = "PasteRegister chooser"
  },
  R = {
    func = function() Contexts:reapply() end,
    desc = "Reapply current Context"
  },
  Z = {
    func = Zoom.wrapped.focusOrJoin(defaultZoomMeetingId),
    desc = "Launch or focus Zoom"
  }
}

local hyperMode = Modal:new(modifiers.none, 'f19', "Hyper Mode", hyperModalKeys)

-- }}} CapsLock/f19 keybindings --
----------------------------------------------------------------------
-- Caps lock/hyper {{{ --
-- Karabiner-Elements remaps CapsLock to Control-Alt-Shift-Command (aka "hyper"
-- or modifiers.all) when held and another key is pressed.

-- Window manipulation
hs.hotkey.bind(modifiers.all, "N", "Move window to next screen",
    function() WinWin:moveToScreen("next") end)
hs.hotkey.bind(modifiers.all, "U", "Undo last window resize",
    function() WinWin:undo() end)
hs.hotkey.bind(modifiers.all, "V", "Tile windows side-by-side",
    function() Tiler:chooser() end)
hs.hotkey.bind(modifiers.all, "LEFT", "Move window to left half of screen",
    function() WinWin:moveAndResize("halfleft") end)
hs.hotkey.bind(modifiers.all, "RIGHT", "Move window to right half of screen",
    function() WinWin:moveAndResize("halfright") end)
hs.hotkey.bind(modifiers.all, "UP", "Expand window",
    function() WinWin:moveAndResize("expand") end)
hs.hotkey.bind(modifiers.all, "DOWN", "Shrink window",
    function() WinWin:moveAndResize("shrink") end)
hs.hotkey.bind(modifiers.all, "RETURN", "Maximize window",
    function() WinWin:moveAndResize("maximize") end)
hs.hotkey.bind(modifiers.all, "SPACE", "Toggle window focus",
    function() LastWindow:toggle() end)
hs.hotkey.bind(modifiers.all, "TAB", "Rotate window",
    function() WindowPool.switcher:next() end)

-- }}} Caps lock/hyper keys --
----------------------------------------------------------------------
-- Function Keys {{{ --
-- Control my Music
-- Avoids Mac wanting to launch iTunes
hs.hotkey.bind(modifiers.none, "f7", "Previous Track", nil, function() hs.vox.previous() end)
hs.hotkey.bind(modifiers.opt, "f7", "Rewind", nil, function() hs.vox.backward() end)
hs.hotkey.bind(modifiers.none, "f8", "Play/Pause", nil, function() hs.vox.playpause() end)
hs.hotkey.bind(modifiers.opt, "f8", "Pause", nil, function() hs.vox.pause() end)
hs.hotkey.bind(modifiers.none, "f9", "Next Track", nil, function() hs.vox.next() end)
hs.hotkey.bind(modifiers.opt, "f9", "Fast Forward", nil, function() hs.vox.forward() end)

-- F15 is mute on my USB keyboard
hs.hotkey.bind(modifiers.none, "f15", "Mute", nil,
  function() hs.audiodevice.defaultOutputDevice():setMuted(true) end)

-- Karabeaner-Elements maps fn to F20
hs.hotkey.bind(modifiers.none, "f20", "Open Seal", nil, function() seal:show() end)

-- }}} Function Keys --
----------------------------------------------------------------------
-- appkeys {{{ --
-- Configuration application-specific hotkeys

appkeys.register("zoom.us",
  {
    hs.hotkey.new(modifiers.none, "UP", function() Zoom.unmute() end),
    hs.hotkey.new(modifiers.none, "Down", function() Zoom.mute() end),
    hs.hotkey.new(modifiers.shift, "UP", function() Zoom.startVideo() end),
    hs.hotkey.new(modifiers.shift, "Down", function() Zoom.stopVideo() end)
  })

if config["HIARCSMinimize"] then
  -- Remap Meta-M for HIARCS to minimize
  appkeys.register("HIARCS Chess Explorer",
    {
      hs.hotkey.new(modifiers.cmd, "m",
      function()
        local w = hs.window.frontmostWindow()
        if w then w:minimize() end
      end)
    })
end

if config["emailMoveMode"] then

  local emailMoveKeys = {
    P = {
      func = function() defaultEmail:moveToFolder("Pending") end,
      desc = "File to Pending"
    },
    R = {
      func = function() defaultEmail:moveToFolder("ToRead") end,
      desc = "File to ToRead"
    },
    T = {
      func = function() defaultEmail:moveToFolder("ToDo") end,
      desc = "File to ToDo"
    },
    W = {
      func = function() defaultEmail:moveToFolder("ToWatch") end,
      desc = "File to ToWatch"
    }
  }
  local emailMoveMode = Modal:newWithoutHotkey(emailMoveKeys)

  appkeys.register("Mail",
    {
      hs.hotkey.new(modifiers.ctrl, "s", function() emailMoveMode:enter() end),
    })
  appkeys.register("Microsoft Outlook",
    {
      hs.hotkey.new(modifiers.ctrl, "a", function() outlook:moveToArchive() end),
      hs.hotkey.new(modifiers.ctrl, "c", function() outlook:clearFlag() end),
      hs.hotkey.new(modifiers.ctrl, "d", function() outlook:delete() end),
      hs.hotkey.new(modifiers.ctrl, "f", function() outlook:flag() end),
      hs.hotkey.new(modifiers.ctrl, "r", function() outlook:reply() end),
      hs.hotkey.new(modifiers.ctrlShift, "r", function() outlook:replyAll() end),
      hs.hotkey.new(modifiers.ctrl, "s", function() emailMoveMode:enter() end),
      hs.hotkey.new(modifiers.ctrl, "t", function() outlook:forward() end)
    })
end

if config["MSTeams"] then
  appkeys.register("Microsoft Teams",
    {
      -- I don't know a good way of telling a Teams Meeting window from non-Meeting window.
      hs.hotkey.new(modifiers.ctrl, "UP", function() Teams.toggleMute() end),
      hs.hotkey.new(modifiers.ctrl, "Down", function() Teams.toggleMute() end),
      -- Shift Up/Down is used to select regions of text
      hs.hotkey.new(modifiers.ctrlShift, "UP", function() Teams.toggleVideo() end),
      hs.hotkey.new(modifiers.ctrlShift, "Down", function() Teams.toggleVideo() end)
    })
end

appkeys.init()

-- }}} appkeys --
----------------------------------------------------------------------
-- Keypad {{{ --
-- Let me manage my windows using the keypad when I have a full keyboard

local keypad_bindings = {}

table.insert(keypad_bindings,
  hs.hotkey.bind(modifiers.none, "pad0", "Window to next screen",
    function() WinWin:moveToScreen("next") end))
table.insert(keypad_bindings,
  hs.hotkey.bind(modifiers.none, "pad1", "Window to lower left quadrant",
    function() WinWin:moveAndResize("cornerSW") end))
table.insert(keypad_bindings,
  hs.hotkey.bind(modifiers.none, "pad2", "Window to lower half",
    function() WinWin:moveAndResize("halfdown") end))
table.insert(keypad_bindings,
  hs.hotkey.bind(modifiers.none, "pad3", "Window to lower right quadrant",
    function() WinWin:moveAndResize("cornerSE") end))
table.insert(keypad_bindings,
  hs.hotkey.bind(modifiers.none, "pad4", "Window to left half",
    function() WinWin:moveAndResize("halfleft") end))
table.insert(keypad_bindings,
  hs.hotkey.bind(modifiers.none, "pad5", "Maximize window",
    function() WinWin:moveAndResize("maximize") end))
table.insert(keypad_bindings,
  hs.hotkey.bind(modifiers.none, "pad6", "Window to right half",
    function() WinWin:moveAndResize("halfright") end))
table.insert(keypad_bindings,
  hs.hotkey.bind(modifiers.none, "pad7", "Window to upper left quadrant",
    function() WinWin:moveAndResize("cornerNW") end))
table.insert(keypad_bindings,
  hs.hotkey.bind(modifiers.none, "pad8", "Window to upper half",
    function() WinWin:moveAndResize("halfup") end))
table.insert(keypad_bindings,
  hs.hotkey.bind(modifiers.none, "pad9", "Window to upper right quadrant",
    function() WinWin:moveAndResize("cornerNE") end))
table.insert(keypad_bindings,
  hs.hotkey.bind(modifiers.none, "pad-", "Shrink window",
    function() WinWin:moveAndResize("shrink") end))
table.insert(keypad_bindings,
  hs.hotkey.bind(modifiers.none, "pad+", "Expand window",
    function() WinWin:moveAndResize("expand") end))
table.insert(keypad_bindings,
  hs.hotkey.bind(modifiers.none, "pad/", "Undo last window move",
    function() WinWin:undo() end))
table.insert(keypad_bindings,
  hs.hotkey.bind(modifiers.none, "pad.", "TBD",
    function() WinWin:undo() end))
table.insert(keypad_bindings,
  hs.hotkey.bind(modifiers.none, "pad*", "Minimize window",
    function() WinWin:moveAndResize("minimize") end))
table.insert(keypad_bindings,
  hs.hotkey.bind(modifiers.none, "padenter", "Window to Next Screen",
    function() WinWin:moveToScreen("next") end))

-- TODO: Would be nice to make this a toggle
local keypad_enable = function() hs.fnutils.each(keypad_bindings, function(b) b:enable() end) end
local keypad_disable = function() hs.fnutils.each(keypad_bindings, function(b) b:disable() end) end

-- Lock key on upper left of my Code keyboard
hs.hotkey.bind(modifiers.none, "padclear", "Keypad bindings enabled", keypad_enable)
hs.hotkey.bind(modifiers.shift, "padclear", "Keypad bindings disabled", keypad_disable)

-- }}} Keypad --
----------------------------------------------------------------------
-- vim:foldmethod=marker
