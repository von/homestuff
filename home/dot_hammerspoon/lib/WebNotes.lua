-- WebNotes module
--
-- Opens a text file in MacVim with a name based on the hostname of the
-- url in the focused Chrome tab. Intended for me to take persistent notes
-- for websites.

local WebNotes = {}

local chrome = require("chrome")

-- Set up logger for module
WebNotes.log = hs.logger.new("WebNotes", "info")

function WebNotes:debug(enable)
  if enable then
    self.log.setLogLevel('debug')
    self.log.d("Debugging enabled")
  else
    self.log.d("Disabling debugging")
    self.log.setLogLevel('info')
  end
end

-- Where to save notes
WebNotes.notesPath = os.getenv("HOME") .. "/.webnotes"

-- Path to MacVim
-- XXX TODO: Don't hardcode paths
WebNotes.path = {
  macvim = "/Applications/MacVim.app/Contents/bin/mvim",
  git = "/opt/homebrew/bin/git"
}

-- Open file in MacVim for hostname in URL for focused Chrome tab
-- Arguments: None
-- Returns: Nothing
function WebNotes:open()
  local url = chrome.getActiveTabURL()
  local urlparts = hs.http.urlParts(url)
  self.log.i("Opening notes for " .. urlparts.host)
  local filename = urlparts.host
  local filepath = self.notesPath .. "/" .. filename
  self.log.d("WebNotes path: " .. filepath)

  -- TODO: Handle if notesPath doesn't exist.

  -- See if we are managing notesPath with git
  -- TODO: Use git rev-parse --is-inside-work-tree
  --       per https://stackoverflow.com/a/16925062/197789
  local callbackFn = nil
  if hs.fs.attributes(self.notesPath .. "/.git/", "mode") == "directory" then
    -- Yes, add note once we are done editing it
    self.log.d("WebNotes detected git management")
    callbackFn = hs.fnutils.partial(self._gitAdd, self, filename)
  end

  -- Open MacVim with note file, will create if doesn't exist.
  -- Not sure I really need --nofork here
  local t = hs.task.new(self.path.macvim, callbackFn, { "--nofork", filepath })
  t:setWorkingDirectory(self.notesPath)
  if not t:start() then
    log.e("Failed to launch " .. self.path.macvim)
  end
end

-- Add any changes to given file and then call _gitCommit().
-- If the gile hasn't been altered, this will do nothing and return zero.
-- Arguments:
--  -Filename
--  -Exit code from editor
--  -Standard out from editor
--  -Standard error from editor
-- Returns: Nothing
function WebNotes:_gitAdd(filename, exitCode, stdOut, stdErr)
  if exitCode ~= 0 then
    self.log.ef("Editor returned non-zero: %s\nStdout: %s\nStderr: %s",
      exitCode, stdOut, stdErr)
    return
  end
  self.log.d("Committing to git: " .. filename)
  local callbackFn = hs.fnutils.partial(self._gitCommit, self, filename)
  local t = hs.task.new(self.path.git, callbackFn, { "add", filename })
  t:setWorkingDirectory(self.notesPath)
  if not t:start() then
    log.e("Failed to launch " .. self.path.git)
  end
end

-- Commit any added changes to given file.
-- If the file hasn't been altered, this will return 1 and print an error.
-- Arguments:
--  -Filename
--  -Exit code from 'git add'
--  -Standard out from 'git add'
--  -Standard error from 'git add'
-- Returns: Nothing
function WebNotes:_gitCommit(filename, exitCode, stdOut, stdErr)
  if exitCode ~= 0 then
    self.log.ef("git add returned non-zero: %s\nStdout: %s\nStderr: %s",
      exitCode, stdOut, stdErr)
    return
  end
  self.log.d("Comitting to git: " .. filename)
  local callbackFn = hs.fnutils.partial(self._gitCommitCB, self, filename)
  local t = hs.task.new(self.path.git, callbackFn,
    { "commit", "-m", "Update to " .. filename, filename })
  t:setWorkingDirectory(self.notesPath)
  if not t:start() then
    log.e("Failed to launch " .. self.path.git)
  end
end

-- Callback for _gitCommit() - just log any errors.
-- Arguments:
--  -Filename
--  -Exit code from 'git add'
--  -Standard out from 'git add'
--  -Standard error from 'git add'
-- Returns: Nothing
function WebNotes:_gitCommitCB(filepath, exitCode, stdOut, stdErr)
  if exitCode ~= 0 then
    self.log.ef("git commit returned non-zero: %s\nStdout: %s\nStderr: %s",
      exitCode, stdOut, stdErr)
  end
end

return WebNotes
