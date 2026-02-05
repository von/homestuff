-- Configuration for Contexts module

Contexts = hs.loadSpoon("Contexts")
Contexts:start()

local logger = hs.logger.new("contexts")

-- Constants {{{ --

-- "LG UltraFine" is monitor in IC
-- "LG HDR 4K" is monitor in CIB Matt gave me
-- "Samsung" is TV on cart
-- "Sony" is TV in den
-- "DELL S2440L" is Dell monitor in home office
local externalDisplay = "screen:LG UltraFine,SONY TV,SAMSUNG,LG HDR 4K,DELL S2440L"
local builtInLCD = "screen:Built-in Retina Display,Built-in Display"

-- }}} Constants --

-- Supporting functions {{{ --

-- Mute VOX when Zoom Meeting is focused on {{{ --
local function muteVox(win)
  -- Don't start Vox if not already running
  local vox = hs.application.find("com.coppertino.Vox")
  -- Don't use hs.vox.isRunning() here because it is broken
  -- See https://github.com/Hammerspoon/hammerspoon/issues/2906
  if not vox then
    logger.d("Vox not found")
    return
  end
  if vox:isRunning() then
    hs.vox.pause()
  else
    logger.d("Vox not running")
  end
end
-- }}} Mute VOX when Zoom Meeting is focused on

-- Run 'displayplacer' with given arguments {{{
-- https://github.com/jakehilborn/displayplacer
-- Installed via Homebrew
local function displayplacer(...)
  local args = hs.fnutils.map({...}, function(s) return "\"" .. s .. "\"" end)
  -- homebrew_prefix from ../init.lua
  table.insert(args, 1, homebrew_prefix .. "bin/displayplacer")
  local cmd = table.concat(args, " ")
  logger.df("displayplacer command: %s", cmd)
  local output, status, type, rc = hs.execute(cmd)
  if not status then
    logger.ef("Failed to execute displayplacer (%s): type = %s rc =%d", cmd, type, rc)
    logger.ef("Output: %s", output)
  else
    if rc ~= 0 then
      logger.ef("displayplacer returned %d: type = %s Output: %s", rc, type, output)
    end
  end
end
-- }}} Run 'displayplacer' with given arguments

-- }}} Supporting functions --

-- baseContext {{{ --
-- Base context shared between Personal and Work laptops
local baseContext = Contexts.new({
    title = "Base Context",
    -- List both Work and Personal audio devices
    -- MH-1000XM3 == Sony Headphones
    -- USB2.0 Device == work speaker
    -- OWC Thunderbolt 3 Audio Device == audio out on work dock
    -- USB PnP Audio Device == UCB-C hub, I should ignore this.
    defaultInputDevice = {
      "Jabra Elite 75t", "Von's Pixel Buds",
      "WH-1000XM3", "Samson Meteor Mic", "Motorola EQ5",
      "LG UltraFine Display Audio", "Macbook Air Microphone",
      "USB PnP Audio Device"
    },
    defaultOutputDevice = {
      -- Earbuds/headphones
      "Jabra Elite 75t", "Von's Pixel Buds", "WH-1000XM3",
      -- Soundbars
      "USB2.0 Device", "USB PnP Audio Device", "Dell AC511 USB SoundBar",
      "Motorola EQ5",
      -- Monitors
      "LG UltraFine Display Audio", "SONY TV", "SAMSUNG",
      -- And finally, the laptop speakers
      "MacBook Air Speakers",
      -- USB-C Hub
      "USB PnP Audio Device"
    },
    apps = {
      {
        name = "Signal",
        apply = { "minimize" }
      },
      {
        name = "VOX",
        apply = { builtInLCD, "left50" }
      },
      {
        -- Minimize the Zoom controls window
        name = "zoom.us",
        windowNames = "^Zoom$",
        apply = { "minimize" }
      },
      {
        -- Make sure Calendar pop ups are on the screen
        name = "Calendar",
        windowNames ="^$",
        apply = { "inBounds" },
        create = { "inBounds" }
      }
    },
  })

-- }}} baseContext --

-- {{{ InternalOnlyContext
-- For when I've only got by built-in display
local internalOnlyConfig = {
  title = "Internal Only Context",
  inherits = baseContext,
  apps = {
    {
      name = "iTerm2",
      apply = { "maximize" }
    },
    {
      name = "zoom.us",
      windowNames = "^Zoom Meeting$",
      apply = { "maximize" },
      create = { muteVox }
    },
    {
      name = "Discord",
      apply = { "maximize" }
    },
    {
      name = "Mail",
      apply = { "maximize" }
    },
    {
      name = "Microsoft Outlook",
      windowNames =  "^Calendar$",
      apply = { "maximize" },
      create = { "maximize" }
    },
    {
      name = "Microsoft Outlook",
      windowNames = "^%d+ Reminders?$",
      -- Near, but not in, upper right corner of screen
      apply = { "-400,100 360*130" },
      create = { "-400,100 360*130" }
    },
    {
      name = "Slack",
      apply = { "maximize" }
    },
    {
      -- All Teams windows end with "| Microsoft Teams" and there is no clean
      -- way to tell meetings from other Teams windows as meetings can be freely
      -- renamed. Plus every notificaiton has the same name, so hard to do anything.
      name = "Microsoft Teams",
    }
  }
}
local internalOnlyContext = Contexts.new(internalOnlyConfig)
-- }}} InternalOnlyContext

-- {{{ internalPrimaryContext
-- For one or two displays, with internal display being primary if it is present.
local internalPrimaryConfig = {
  title = "Internal Primary Context",
  inherits = baseContext,
  apps = {
    {
      name = "iTerm2",
      apply = { builtInLCD, "maximize" }
    },
    {
      name = "zoom.us",
      windowNames = "^Zoom Meeting$",
      apply = { builtInLCD },
      create = { muteVox, externalDisplay }
    },
    {
      name = "Discord",
      apply = { externalDisplay, "left50" }
    },
    {
      name = "Mail",
      apply = { externalDisplay, "left50" }
    },
    {
      name = "Microsoft Outlook",
      windowNames =  "^Calendar$",
      apply = { externalDisplay, "right50" },
      create = { externalDisplay, "right50" }
    },
    {
      name = "Microsoft Outlook",
      windowNames = "^%d+ Reminders?$",
      -- Near, but not in, upper right corner of screen
      apply = { builtInLCD, "-400,100 360*130" },
      create = { builtInLCD, "-400,100 360*130" }
    },
    {
      name = "Slack",
      apply = { externalDisplay, "right50" }
    },
    {
      -- All Teams windows end with "| Microsoft Teams" and there is no clean
      -- way to tell meetings from other Teams windows as meetings can be freely
      -- renamed.
      name = "Microsoft Teams",
      -- Every notification mutes Vox
      -- create = { muteVox }
    }
  }
}
local internalPrimaryContext = Contexts.new(internalPrimaryConfig)
-- }}} InternalPrimaryContext

-- {{{ smallExternalContext
-- For use with an small external display
local smallExternalConfig = {
  title = "Small External Context",
  inherits = baseContext,
  enterFunction = function() displayplacer(
      "id:3A77959F-10AD-9A27-0857-D6964E3302DB res:1920x1080 hz:60 color_depth:8 scaling:off origin:(0,0) degree:0",
      "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1440x900 hz:60 color_depth:8 scaling:on origin:(1920,180) degree:0"
    ) end,
  apps = {
    {
      name = "iTerm2",
      apply = { builtInLCD, "maximize" }
    },
    {
      name = "zoom.us",
      windowNames = "^Zoom Meeting$",
      apply = { externalDisplay, "maximize" },
      create = { muteVox, externalDisplay, "maximize" }
    },
    {
      name = "Google Chrome",
      apply = { externalDisplay, "maximize" }
    },
    {
      name = "Discord",
      apply = { externalDisplay, "maximize" }
    },
    {
      name = "Mail",
      apply = { externalDisplay, "maximize" }
    },
    {
      name = "Microsoft Outlook",
      windowNames =  "^Calendar$",
      apply = { externalDisplay, "maximize" },
      create = { externalDisplay, "maximize" }
    },
    {
      name = "Microsoft Outlook",
      windowNames = "^%d+ Reminders?$",
      -- Near, but not in, upper right corner of screen
      apply = { externalDisplay, "-400,100 360*130" },
      create = { externalDisplay, "-400,100 360*130" }
    },
    {
      name = "Slack",
      apply = { externalDisplay, "maximize" }
    },
    {
      -- All Teams windows end with "| Microsoft Teams" and there is no clean
      -- way to tell meetings from other Teams windows as meetings can be freely
      -- renamed.
      name = "Microsoft Teams",
      -- Every notification mutes Vox
      -- create = { muteVox }
    }
  }
}
local smallExternalContext = Contexts.new(smallExternalConfig)
-- }}} smallExternalContext

-- {{{ LargeExternalContext
-- For two displays, with external display being primary
local largeExternalConfig = {
  title = "Large External Context",
  inherits = baseContext,
  apps = {
    {
      name = "zoom.us",
      windowNames = "^Zoom Meeting$",
      apply = { externalDisplay },
      create = { muteVox, externalDisplay }
    },
    {
      name = "Discord",
      apply = { externalDisplay, "left50" }
    },
    {
      name = "Mail",
      apply = { externalDisplay, "left50" }
    },
    {
      name = "Microsoft Outlook",
      windowNames =  "^Calendar$",
      apply = { builtInLCD, "maximize" },
      create = { builtInLCD, "maximize" }
    },
    {
      name = "Microsoft Outlook",
      windowNames = "^%d+ Reminders?$",
      -- Near, but not in, upper right corner of screen
      apply = { externalDisplay, "-400,100 360*130" },
      create = { externalDisplay, "-400,100 360*130" }
    },
    {
      name = "Slack",
      apply = { externalDisplay, "right50" }
    },
    {
      -- All Teams windows end with "| Microsoft Teams" and there is no clean
      -- way to tell meetings from other Teams windows as meetings can be freely
      -- renamed.
      name = "Microsoft Teams",
      -- Every notification mutes Vox
      -- create = { muteVox }
    }
  }
}
local largeExternalContext = Contexts.new(largeExternalConfig)
-- }}} largeExternalContext

-- mappings {{{ --
local mappings = {
  { {"Built-in Retina Display" }, internalOnlyContext },
  -- Home office
  { {"Built-in Retina Display","DELL S2440L" }, smallExternalContext },
  -- IC
  { {"Built-in Retina Display","LG UltraFine" }, largeExternalContext },
  -- CIB
  { {"Built-in Retina Display","DELL P3222QE" },  internalPrimaryContext },
  -- Various TVs
  { {"Built-in Retina Display","SONY TV" },  internalPrimaryContext },
  { {"Built-in Retina Display","SAMSUNG" },  internalPrimaryContext },
}
Contexts:setContextMappings(mappings)
-- }}} mappings --

-- vim: foldmethod=marker: --
