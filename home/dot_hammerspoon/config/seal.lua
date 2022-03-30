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

  -- Personal Zoom meetings {{{ --
  actions["Beacon Board Meeting Zoom"] = {
    fn = function() Zoom.join("88993254191", "aTd0UU9YL2NUVDFQOU85RGF2MGcvUT09") end,
    icon = zoomIcon
  }
  actions["Beacon Exec Meeting Zoom"] = {
    fn = function() Zoom.join("88957185163?", "ekt6M0VLRURxQVFjWXVXUVdVYjBCZz09") end,
    icon = zoomIcon
  }
  actions["Beacon Finance Committee Meeting Zoom"] = {
    fn = function() Zoom.join("85978998810", "UUlVcnNINWsvdWR5V2xRZkM4UzRTdz09") end,
    icon = zoomIcon
  }
  actions["BPP Exec Meeting Zoom"] = {
    fn = function() Zoom.join("89254627627", "SVhDOWIyTEp0KzBrQU1TUDFxYnpvZz09") end,
    icon = zoomIcon
  }
  actions["Personal Zoom"] = {
    fn = function() Zoom.join(personalDefaultZoomId) end,
    icon = zoomIcon
  }
  actions["Weekly Family Zoom (mine)"] = {
    fn = function() Zoom.join("84270787200", "QUFDQTdHejhWRHlLWGlIMzdOOWpUZz09") end,
    icon = zoomIcon
  }
  actions["Weekly Family Zoom (Lester's)"] = {
    fn = function() Zoom.join("85671874388", "MTRGbEs1N3p1R2E2dUsyNWlIWFJDdz09") end,
    icon = zoomIcon
  }
  -- }}} Personal Zoom meetings --

  -- Work Zoom meetings {{{ --
  actions["Work Personal Zoom"] = {
    fn = function() Zoom.join(workDefaultZoomId) end,
    icon = zoomIcon
  }
  actions["CACR Privacy and Security Lunch"] = {
    fn = function() Zoom.join("6609552631", "N3dZZ0E5T2tVK3ozMG1tazdaNGV1dz09") end,
    icon = zoomIcon
  }
  actions["CACR CISO Meeting Zoom"] = {
    fn = function()
      Zoom.join("98455226514", "NUppNFR3cUp5WFdqdktHYTY1ZFYvZz09")
      openURL("https://docs.google.com/document/d/1nhK7OwlkAKqor5nUWL7GA8gQfZFSfkuPC2WPgnZt6Yg/edit")
    end,
    icon = zoomIcon
  }
  actions["CACR Leadership Meeting"] = {
    fn = function() Zoom.join("84758633480", "WGdndGJ3Z2MxZkRoSnZrSmNyMmlmZz09") end,
    icon = zoomIcon
  }
  actions["CACR Staff Meeting Zoom"] = {
    fn = function() Zoom.join("89449724241", "azVtZUVnRGlPS1NVSHdtd082V2Q1Zz09") end,
    icon = zoomIcon
  }
  actions["CCRI Planning Meeting Zoom"] = {
    fn = function() Zoom.join("97929679109", "VnZlZHNrbTd3L3hBdTdFclJQb2RzZz09") end,
    icon = zoomIcon
  }
  actions["Cybercorps SFS PI Meeting Zoom"] = {
    fn = function() Zoom.join("97218721178", "RVgzdkkxRWFScW9hS0liMnkxSUZJZz09") end,
    icon = zoomIcon
  }
  actions["OVPIT IMT Exec Meeting"] = {
    fn = function() Zoom.handleURL("https://iu.zoom.us/j/816790239") end,
    icon = zoomIcon
  }
  actions["InCommon SC Zoom"] = {
    fn = function() Zoom.handleURL("https://internet2.zoom.us/j/96609121734?pwd=UFEyNWtYaVE5bTJhQjI3UlZ3Sml2dz09") end,
    icon = zoomIcon
  }
  actions["InfoSec Social Hour"] = {
    fn = function() Zoom.join("96080015053", "bDJKWEN1allyS0hMZTh3K0VCUUNlQT09") end,
    icon = zoomIcon
  }
  actions["ITCO meeting Zoom"] = {
    fn = function() Zoom.join("99165840204", "dnNadXV1OFBmb3daMHJQNmYrK3NjZz09") end,
    icon = zoomIcon
  }
  actions["IU Infosec and Legal"] = {
    fn = function()
      Zoom.join("88602078168", "bkRUSlhIUWhaTWlmRE5JdmdhOVkvdz09")
      openURL("https://docs.google.com/document/d/1GI4plWLGeP9OnmkdywrzJ45OYA-mH3Vzm_98deU6WU8/edit")
    end,
    icon = zoomIcon
  }
  actions["Kelli Zoom"] = {
    fn = function() Zoom.join("2903825817") end,
    icon = zoomIcon
  }
  actions["Kelli Coffee/Tea/Facetime"] = {
    fn = function() Zoom.join("2903825817", "WEhjK09VMFdQRDZOc2V3a3RiblE1Zz09") end,
    icon = zoomIcon
  }
  actions["Kim Milford Personal Zoom"] = {
    fn = function() Zoom.join("3172784815", "aTRtUWI0Z2RUd0RyQkVyMGpYUXRJUT09") end,
    icon = zoomIcon
  }
  actions["Matt Link Zoom"] = {
    fn = function() Zoom.join("8128556339") end,
    icon = zoomIcon
  }
  actions["Navy CISO Zoom"] = {
    fn = function() Zoom.join("798622013", "bng3dXNLeUptdE8vQVAxNTQ5SzRsQT09") end,
    icon = zoomIcon
  }
  actions["OmniSOC CISO Zoom"] = {
    fn = function() Zoom.join("8858171184") end,
    icon = zoomIcon
  }
  actions["OmniSOC Elastic Zoom"] = {
    fn = function() Zoom.handleURL("https://elastic.zoom.us/j/99956489677?pwd=eWtndGh4Wmkyb0FaR0N6T2RSeVFmZz09") end,
    icon = zoomIcon
  }
  actions["OmniSOC Monthly Management Zoom"] = {
    fn = function() Zoom.join("88224719083", "aE5CYm81VmI5akd2SlJZZDMvTU9CZz09") end,
    icon = zoomIcon
  }
  actions["OmniSOC Quarterly Zoom"] = {
    fn = function() Zoom.join(personalDefaultZoomId) end,
    icon = zoomIcon
  }
  actions["OmniSOC Turn Up Zoom"] = {
    fn = function() Zoom.join("810250107", "RWd5b2cyTWpwTXlJbjVtSitUWVlTQT09") end,
    icon = zoomIcon
  }
  actions["ResearchSOC/GAGE Zoom"] = {
    fn = function() Zoom.handleURL("https://iu.zoom.us/j/95359294382?pwd=MVhCcGxDSlZjYWM4Q2ZPaGUvTUsxQT09") end,
    icon = zoomIcon
  }
  actions["ResearchSOC Program Admin Zoom"] = {
    fn = function()
      Zoom.handleURL("https://iu.zoom.us/j/2903825817?pwd=WEhjK09VMFdQRDZOc2V3a3RiblE1Zz09")
      openURL("https://docs.google.com/document/d/1zNaHglSyxBcn2T7FPCVw5sOlreT91MQmoLKgLPHAJ50/edit#")
    end,
    icon = zoomIcon
  }
  actions["Rob Beverly Zoom"] = {
    fn = function() Zoom.handleURL("https://nsf.zoomgov.com/my/rbeverly?pwd=TkVjcW95UUhreGxUWlJ6MTNac201UT09") end,
    icon = zoomIcon
  }
  actions["Scott Shackelford Zoom"] = {
    fn = function() Zoom.join("7329364268", "VWFodXRjb0E3S2gwTmNGMW1SMnVydz09") end,
    icon = zoomIcon
  }
  actions["Trusted CI AHC Zoom"] = {
    fn = function() Zoom.join("996731730", "cmtxMVRWelRyS1cxeDBEcysxSEYvQT09") end,
    icon = zoomIcon
  }
  actions["Trusted CI CACR Zoom"] = {
    fn = function() Zoom.join("996731730", "cmtxMVRWelRyS1cxeDBEcysxSEYvQT09") end,
    icon = zoomIcon
  }
  actions["Trusted CI FAB Zoom"] = {
    fn = function() Zoom.join("621175486", "cWdOdm8vMXBrR1o4OHVqYXptK1ZTZz09") end,
    icon = zoomIcon
  }
  actions["Trusted CI Fellows VI Zoom"] = {
    fn = function() Zoom.join("578877003") end,
    icon = zoomIcon
  }
  actions["Trusted CI Framework Zoom"] = {
    fn = function() Zoom.join("99964535327", "SzJNc1pNZGZzT1NQRDFxZDcybUYvdz09") end,
    icon = zoomIcon
  }
  actions["Trusted CI Program Admin Zoom"] = {
    fn = function() Zoom.join("99866382425", "c00yU2RCNUUydWc1U09uV1JkRUZ4UT09") end,
    icon = zoomIcon
  }
  actions["Trusted CI PI/Leads Zoom"] = {
    fn = function() Zoom.join("520860454") end,
    icon = zoomIcon
  }
  -- }}} Work Zoom meetings --
end -- Zoom installed
-- }}} Zoom meetings --

-- MS Teams meetings {{{ --
if hs.application.infoForBundleID("com.microsoft.teams") then
  local teamsIcon = hs.image.imageFromAppBundle("com.microsoft.teams")
  actions["OVPIT Cabinet Meeting"] = {
    fn = function() hs.urlevent.openURL("msteams:https://teams.microsoft.com/l/meetup-join/19%3ameeting_ZDQwZmI1ZTctOGE3NS00ZTlhLWJhZGYtYzYyNjQ0YTc2OTFj%40thread.v2/0?context=%7b%22Tid%22%3a%221113be34-aed1-4d00-ab4b-cdd02510be91%22%2c%22Oid%22%3a%225666f7d3-8712-4f7b-a241-399722316329%22%7d") end,
    icon = teamsIcon
  }
  actions["Restart Teams Meeting"] = {
    fn = function() hs.urlevent.openURL("https://teams.microsoft.com/l/meetup-join/19%3aa51d3d46c73a422b98721002eb59446e%40thread.tacv2/1600113555628?context=%7b%22Tid%22%3a%221113be34-aed1-4d00-ab4b-cdd02510be91%22%2c%22Oid%22%3a%225666f7d3-8712-4f7b-a241-399722316329%22%7d") end,
    icon = teamsIcon
  }
end -- Teams installed
-- }}} MS Teams meetings --

-- Add actions for my contexts
actions = Contexts:sealUserActions(actions)

spoon.Seal.plugins.useractions.actions = actions

-- vim: foldmethod=marker: --
