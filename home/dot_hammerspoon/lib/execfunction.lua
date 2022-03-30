-- execfunction.lua
-- Return a function to execute a command.
-- Meant for use in hotkey bindings.

local module = {}

local log = hs.logger.new('execfunction', 'info')
module.log = log

module.debug = function(enable)
  if enable then
    log.setLogLevel('debug')
    log.d("Debugging enabled")
  else
    log.d("Disabling debugging")
    log.setLogLevel('info')
  end
end

-- execfunction{args}
-- Execute a command, handling errors.
--
-- args.cmd="command to execute"
-- args.msg="Message to display"
-- args.doneMsg="Message to display when complete"
--     Only on success. %s is replaced with output of command
-- Returns output from command
local function execfunction(args)
  return function()
    if args.msg then
      hs.alert(args.msg)
    end
    output, status, exit_mode, rc = hs.execute(args.cmd)
    if status then
      -- Success
      if args.doneMsg then
        -- Output doneMsg, substituting output for %s, trimming whitespace
        hs.alert(string.format(args.doneMsg, output:match( "^%s*(.-)%s*$" )))
      end
    else
      hs.alert("Command failed")
      -- Detailed diagnostics to console
      hs.printf("Failed to execute: " .. args.cmd)
      hs.printf("output: " .. output)
      hs.printf("Return code: " .. rc)
    end
    return output
  end
end

module.new = execfunction

-- taskfunction{args}
-- Execute a task in the background.
--
-- args.path="Path to executable"
-- args.arguments=Optional table of arguments
-- args.msg="Message to display"
-- args.doneMsg="Message to display when complete"

local function taskfunction(args)
  -- Return false to disable subsequent calls
  local function streamCallback(task, stdOut, strErr) return false ; end

  -- Handle task finishing
  local function callback(exitCode, stdOut, stdErr)
    if exitCode == 0 then
      hs.alert(args.doneMsg)
    else
      hs.alert("Task returned non-zero")
      -- Diagnostics to console
      hs.printf("Task returned non-zero: " .. args.path)
      hs.printf("Status: " .. tostring(exitCode))
      hs.printf("StdOut: " .. stdOut)
      hs.printf("StdErr: " .. stdErr)
    end
  end

  return function()
    if args.msg then
      hs.alert(args.msg)
    end
    task = hs.task.new(args.path, callback, streamCallback, args.arguments)
    if not task then
      hs.alert("Failed to create task " .. args.path)
      return
    end
    if not task:start() then
      hs.alert("Failed to start task")
      return
    end
  end
end

module.task = taskfunction

return module
