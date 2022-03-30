-- Functionality for Microsoft Teams

local module = {}

local teamsId = "com.microsoft.teams"

-- Wrapped functions for binding
module.wrapped = {}

local log = hs.logger.new('teams', 'info')
module.log = log

-- debug() {{{ --
module.debug = function(enable)
  if enable then
    log.setLogLevel('debug')
    log.d("Debugging enabled")
  else
    log.d("Disabling debugging")
    log.setLogLevel('info')
  end
end
-- }}}  debug() --

-- toggleMute() {{{ --
-- Toggle mute.
local function toggleMute(when)
  log.d("Toggling Mute")
  local teams = hs.application.find(teamsId)
  if not teams then
    log.e("Could not find Teams application")
    return
  end
  hs.eventtap.event.newKeyEvent({"cmd", "shift"}, "m", true):post(teams)
end

module.toggleMute = toggleMute

-- }}} toggleMute() --

-- toggleVideo() {{{ --
local function toggleVideo()
  log.d("Toggling Mute")
  local teams = hs.application.find(teamsId)
  if not teams then
    log.e("Could not find Teams application")
    return
  end
  hs.eventtap.event.newKeyEvent({"cmd", "shift"}, "o", true):post(teams)
end

module.toggleVideo = toggleVideo

-- }}} toggleVideo() --

return module
-- vim:foldmethod=marker:
