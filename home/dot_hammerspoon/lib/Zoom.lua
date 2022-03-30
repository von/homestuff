-- Zoom.lua
-- Routines to group Zoom application


local Zoom = {}

Zoom.bundleID = "us.zoom.xos"

-- Wrapped functions for binding
Zoom.wrapped = {}

Zoom.log = hs.logger.new("Zoom", "info")
local log = Zoom.log

function Zoom.debug(enable)
  if enable then
    log.setLogLevel('debug')
    log.d("Debugging enabled")
  else
    log.d("Disabling debugging")
    log.setLogLevel('info')
  end
end

-- Open a Zoom meeting directly using the zoommtg:// protocol
-- meetingId should be an integer with the meeting id
-- pwd is an optional string with the password
-- https://medium.com/zoom-developer-blog/zoom-url-schemes-748b95fd9205
function Zoom.join(meetingId, pwd)
  local url = "zoommtg://zoom.us/join?action=join&confno=" .. meetingId
  if pwd then
    log.i("Opening Zoom id " .. meetingId .. " using password")
    url = url .. string.format("&pwd=%s", pwd)
  else
    log.i("Opening Zoom id " .. meetingId)
  end
  log.d("Url for Zoom meeting: " .. url)
  result = hs.urlevent.openURL(url)
  if not result then
    log.e("Failed to open Zoom URL: " .. url)
  end
  return result
end

Zoom.wrapped.join = function(meetingId)
  return function()
    if not Zoom.join(meetingId) then
      hs.alert("Failed to open Zoom meeting")
    end
  end
end

-- If we are already in a Zoom meeting, focus the App.
-- Otherwise, join the given meeting.
function Zoom.focusOrJoin(meetingId)
  local zoom = hs.application.get(Zoom.bundleID)
  if zoom then
    local zoomMeetingWindow = zoom:findWindow("Zoom Meeting") or zoom:findWindow("Zoom Webinar")
    if zoomMeetingWindow then
      log.i("Focusing on existing Zoom meeting")
      zoomMeetingWindow:focus()
      return true
    end
  end
  log.i("No Zoom meeting found")
  return Zoom.join(meetingId)
end

Zoom.wrapped.focusOrJoin = function(meetingId)
  return function()
    if not Zoom.focusOrJoin(meetingId) then
      hs.alert("Failed to open/focus Zoom meeting")
    end
  end
end

-- Join by Zoom URL
-- Translates into a 'zoommtg:' url to avoid going through browser
function Zoom.handleURL(url)
  local id = string.match(url, ".*/[js]/(%d+)")
  if not id then
    log.e("Failed to parse Zoom URL: " .. url)
    return false
  end
  local newURL = string.format("zoommtg://zoom.us/join?action=join&confno=%s", id)
  -- Now handle password, if present.
  local pwd = string.match(url, "?pwd=(%S+)")
  if pwd then
    newURL = newURL .. string.format("&pwd=%s", pwd)
  end
  result = hs.urlevent.openURL(newURL)
  if not result then
    log.e("Failed to open Zoom URL: " .. url)
  end
  return result
end

Zoom.wrapped.handleURL = function(url)
  return function()
    if not Zoom.handleURL(url) then
      hs.alert("Failed to handle Zoom url")
    end
  end
end

-- Mute a running Zoom window
function Zoom.mute()
  local zoom = hs.application.find(Zoom.bundleID)
  if not zoom then
    log.e("Could not find Zoom application")
    return
  end
  if not zoom:selectMenuItem({"Meeting", "Mute Audio"}) then
    log.d("Failed to mute Zoom meeting")
  end
end

-- Unmute a running Zoom window
function Zoom.unmute()
  local zoom = hs.application.find(Zoom.bundleID)
  if not zoom then
    log.e("Could not find Zoom application")
    return
  end
  if not zoom:selectMenuItem({"Meeting", "Unmute Audio"}) then
    log.d("Failed to unmute Zoom meeting")
  end
end

-- Start video in a running Zoom window
function Zoom.startVideo()
  local zoom = hs.application.find(Zoom.bundleID)
  if not zoom then
    log.e("Could not find Zoom application")
    return
  end
  if not zoom:selectMenuItem({"Meeting", "Start Video"}) then
    log.d("Failed to start Zoom video")
  end
end

-- Stop video in a running Zoom window
function Zoom.stopVideo()
  local zoom = hs.application.find(Zoom.bundleID)
  if not zoom then
    log.e("Could not find Zoom application")
    return
  end
  if not zoom:selectMenuItem({"Meeting", "Stop Video"}) then
    log.d("Failed to stop Zoom video")
  end
end

return Zoom
