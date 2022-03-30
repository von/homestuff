-- CommandChooser.lua
--
-- Provide a menu to scripts in ~/.CommandChooser and run selected script

-- CommandChooser CommandChooser
local CommandChooser = {}
-- Failed table lookups on the instances should fallback to the class table, to get methods
CommandChooser.__index = CommandChooser

-- Calls to CommandChooser() return CommandChooser.new()
setmetatable(CommandChooser, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

local filechooser = require("FileChooser")

-- Set up logger for CommandChooser
local log = hs.logger.new("CommandChooser", "info")
CommandChooser.log = log

-- Create a new CommandChooser object
--   path is the path to scripts, defaults to ${HOME}/.CommandChooser if not given
function CommandChooser.new(path)
  log.d("new() called")
  local self = setmetatable({}, CommandChooser)
  if path then
    self.path = path
  else
    self.path = os.getenv("HOME") .. "/.CommandChooser"
  end
  return self
end

function CommandChooser.debug(enable)
  if enable then
    log.setLogLevel('debug')
    log.d("Debugging enabled")
  else
    log.d("Disabling debugging")
    log.setLogLevel('info')
  end
end

-- taskCallback {{{ --
local function taskCallback(exitCode, stdOut, stdErr)
  if exitCode == 0 then
    log.d("Task completed")
  else
    log.ef("Task completed with error(%d): %s", exitCode, stdErr)
    hs.alert(stdErr)
  end
end
-- }}} taskCallback --

-- executeFile {{{ --
local function executeFile(path)
  log.d("Running " .. path)
  local task = hs.task.new(path, taskCallback)
  if not task:start() then
    log.e("Failed to start task: " .. path)
    hs.alert("Failed to run " .. path)
  end
end
-- }}} executeFile --

-- go() {{{ --
function CommandChooser.go(self)
  local chooser = filechooser(self.path)
  chooser:go(executeFile)
end

-- }}} CommandChooser --

return CommandChooser
-- vim:foldmethod=marker:
