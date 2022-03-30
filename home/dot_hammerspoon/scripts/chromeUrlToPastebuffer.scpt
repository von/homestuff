#!/usr/bin/osascript
tell application "Google Chrome"
  set the clipboard to (URL of active tab of first window as text)
end tell
