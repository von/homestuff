-- Configuration for Seal spoon
-- http://www.hammerspoon.org/Spoons/Seal.html

if not spoon.Seal then
  return
end

-- Including "apps" here causes some slow down and I don't really use it.
spoon.Seal:loadPlugins({"useractions"})

local Contexts = require("Contexts")
local gdocs = require("GDocs")
local URLOpener = require("URLOpener")
URLOpener.setDefaultPersona(defaultChromePersona)
local function openURL(url) URLOpener.open(url) end
local WindowPool = require("WindowPool")
local Zoom = require("Zoom")

local iconPath = hs.configdir .. "/icons/"

local actions = spoon.Seal.plugins.useractions.actions or {}

actions["New Google Doc"] = {
  fn = gdocs.newDoc,
  icon = hs.image.imageFromPath(iconPath .. "google_document_x16.png")
}
actions["New Google Sheet"] = {
  fn = gdocs.newSheet,
  icon = hs.image.imageFromPath(iconPath .. "google_sheet_x16.png")
}
actions["New Google Slides"] = {
  fn = gdocs.newSlides,
  icon = hs.image.imageFromPath(iconPath .. "google_slides_x16.png")
}
actions["Google Maps"] = {
  url = "http://maps.google.com/",
  icon = "favicon"
}
actions["Wunderground Bloomington"] = {
  url = "https://www.wunderground.com/weather/us/in/bloomington/39.16,-86.50",
  icon = "favicon"
}
actions["Microsoft Office Website"] = {
  url = "https://www.office.com/",
  icon = "favicon"
}

-- WindowPool actions
actions["Clear Window Rotation"] = {
  fn = function() WindowPool:clear() end
}
actions["Add Window to Rotation"] = {
  fn = function() WindowPool:addFocusedWindow() end
}
actions["Remove Window from Rotation"] = {
  fn = function() WindowPool:removeFocusedWindow() end
}

-- Zoom meetings {{{ --
if hs.application.infoForBundleID("us.zoom.xos") then
  local zoomIcon = hs.image.imageFromAppBundle("us.zoom.xos")
  -- Make personal and work zoom configuration available on both laptops so I can
  -- join any meeting from either laptop.

  actions["Personal Zoom"] = {
    fn = function() Zoom.join(defaultZoomMeetingId) end,
    icon = zoomIcon
  }

  local config = MyConfig["ZoomMeetings"] or {}
  for name,params in pairs(config) do
    actions[name] = {
      fn = function() Zoom.join(params["id"], params["password"]) end,
      icon = zoomIcon
    }
  end

end -- Zoom installed
-- }}} Zoom meetings --

-- MS Teams meetings {{{ --
if hs.application.infoForBundleID("com.microsoft.teams") then
  local teamsIcon = hs.image.imageFromAppBundle("com.microsoft.teams")
  -- Nothing currently
end -- Teams installed
-- }}} MS Teams meetings --

-- Add actions for my contexts
actions = Contexts:sealUserActions(actions)

spoon.Seal.plugins.useractions.actions = actions

-- vim: foldmethod=marker: --
