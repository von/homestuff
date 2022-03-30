-- Configuration for URLDispatcher spoon
-- Kudos: https://github.com/zzamboni/dot-hammerspoon

local Zoom = require("Zoom")
local myConfig = MyConfig["URLDispatcher"] or {}

if myConfig['debugLevel'] then
  spoon.URLDispatcher.logger.setLogLevel(myConfig['debugLevel'])
end

local noApp = nil  -- for readability

spoon.URLDispatcher.url_patterns = {
  -- j == join, s == start
  -- Don't rediret Zoom webinar URLs ('w') as Zoom.handleURL() doesn't handle them.
  { "https://.*.zoom.us/[js]/", noApp, Zoom.handleURL },
  { "https://.*.zoomgov.com/[js]/", noApp, Zoom.handleURL },
  { "msteams:", "com.microsoft.teams" }
}

if myConfig["useURLOpener"] then
  -- Don't use url.urlevent.Open() for function as they will result in an
  -- infinite loop calling URLDispatcher
  local URLOpener = require("URLOpener")
  URLOpener.setDefaultPersona(defaultChromePersona)
  table.insert(spoon.URLDispatcher.url_patterns, { ".*", noApp, URLOpener.open })
else
  --Use chrome.openURL()
  local chrome = require("chrome")
  local function opener(url)
    local args={url=url, persona=defaultChromePersona}
    chrome.openURL(args)
  end
  table.insert(spoon.URLDispatcher.url_patterns, { ".*", noApp, opener })
end

if myConfig["defaultHandler"] then
  spoon.URLDispatcher.default_handler = myConfig["defaultHandler"]
end

spoon.URLDispatcher.url_redir_decoders = {}

if myConfig["redirectTeams"] then
  -- Send MS Teams URLs directly to the app
  -- Kudos: https://github.com/zzamboni/dot-hammerspoon/blob/master/init.org
  table.insert(spoon.URLDispatcher.url_redir_decoders,
    { "MS Teams URLs", "(https://teams.microsoft.com.*)", "msteams:%1", true })
end
