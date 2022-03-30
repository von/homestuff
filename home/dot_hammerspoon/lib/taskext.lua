-- taskext (extensions to hs.task)
-- I can't seem to extend instances with methods
--
local module = {}

local log = hs.logger.new("taskext", "info")
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

-- Create a task based on OSAScript in a string
-- script_string is the script as string
-- callbackFn is the callback as per hs.task.new()
-- [arguments] is an optional table of arguments to pass, as per hs.task.new()
module.newFromOSAString = function(script_string, callbackFn, ...)
  local varargs = {...}
  local args = {}
  -- Make sure first argument is a "-" so we read script from stdin
  if (#varargs > 0) then
    args = varargs[1]
  end
  table.insert(args, 1, "-")
  log.f("New osascript task from string: %s", hs.inspect(args))
  local t = hs.task.new("/usr/bin/osascript", callbackFn, args)
  t:setInput(script_string)
  return t
end

-- Create a task based on OSAScript path
-- path is the path to the script
-- callbackFn is the callback as per hs.task.new()
-- [arguments] is an optional table of arguments to pass, as per hs.task.new()
module.newFromOSAPath = function(path, callbackFn, ...)
  local varargs = {...}
  local args = {}
  if (#varargs > 0) then
    args = varargs[1]
  end
  -- Make sure first argument is script name
  table.insert(args, 1, path)
  log.f("New osascript task: %s", hs.inspect(args))
  local t = hs.task.new("/usr/bin/osascript", callbackFn, args)
  return t
end
return module
