-- Get 'message:' url for selected message in Apple Mail
-- It works by extracting the "Message-ID" from the email. If multiple
-- such headers are found, it puts them all, CR-separated into the paste buffer.
-- Emails from me don't seem to have this header.
-- Kudos: https://daringfireball.net/2007/12/message_urls_leopard_mail
tell application "Mail"
  set _sel to get selection
  set _links to {}
  repeat with _msg in _sel
      set _messageURL to "message://%3c" & _msg's message id & "%3e"
      set end of _links to _messageURL
  end repeat
  set AppleScript's text item delimiters to return
  set the clipboard to (_links as string)
end tell
