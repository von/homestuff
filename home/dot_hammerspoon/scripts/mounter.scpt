-- Mount a given volume
-- Usage: <volume path>
on run argv
  tell application "Finder"
    try
      mount volume item 1 of argv
    end try
  end tell
end run
