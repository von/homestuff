-- TaskRunner
-- Wrapper around hs.task to provide notifications and retries

local TaskRunner = {}
-- Failed table lookups on the instances should fallback to the class table, to get methods
TaskRunner.__index = TaskRunner

TaskRunner.log = hs.logger.new("TaskRunner", "info")

function TaskRunner.debug(enable)
  if enable then
    log.setLogLevel('debug')
    log.d("Debugging enabled")
  else
    log.d("Disabling debugging")
    log.setLogLevel('info')
  end
end

-- Calls to TaskRunner() return TaskRunner.new()
setmetatable(TaskRunner, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

TaskRunner.path = nil

function TaskRunner.setPath(path)
  TaskRunner.path = path
end

function TaskRunner.new(taskFunc)
  local self = setmetatable({}, TaskRunner)
  self.taskFunc = taskFunc
  self.gateFunc = function() return true end
  self.cleanupFunc = nil
  self.message = {
    start = "",
    gateFailed = "",
    success = "",
    failure = "",
    retry = "",
  }
  self.option = {
    retry = true,
    retry_delay = 5,  -- in seconds
    retry_count = 10,  -- max number of retries
  }
  self.notification = nil
  return self
end

function TaskRunner.setMessages(self, messages)
  for k,v in pairs(messages) do
    if self.message[k] then
      self.message[k] = v
    else
      self.log.ef("Unknown message parameter: %s", k)
    end
  end
end

function TaskRunner.setOptions(self, options)
  for k,v in pairs(options) do
    if self.option[k] ~= nil then
      self.option[k] = v
    else
      self.log.ef("Unknown option: %s", k)
    end
  end
end

function TaskRunner.setGateFunction(self, f)
  self.gateFunc = f
end

function TaskRunner.setCleanupFunction(self, f)
  self.cleanupFunc = f
end

-- Run gateFunc, returning true if we should proceed with running task
function TaskRunner.checkGate(self)
  local status = self.gateFunc()
end

-- Create and start task
-- Returns true on success, false otherwise
function TaskRunner.run(self)
  local status = self.gateFunc()
  if status ~= true then
    self.log.i("Gate failed.")
    if self.message.gateFailed ~= "" then
      self:showMessage(self.message.gateFailed, stdOut, stdErr, false)
    end
    return true
  end
  local task = self.taskFunc(function(...) self:callback(...) end)
  if not task then
    hs.alert("Failed to create task")
    self.log.e("Failed to create task: " .. hs.inspect(self.taskFunc))
    return false
  end
  if TaskRunner.path then
    local env = task:environment() or {}
    env["PATH"]  = TaskRunner.path
    if not task:setEnvironment(env) then
      self.log.e("Failed to set task PATH")
    end
  end
  if not task:start() then
    hs.alert("Failed to start task")
    self.log.e("Failed to start task: " .. hs.inspect(self.taskFunc))
    return false
  end
  if self.message.start ~= "" then
    self:showMessage(self.message.start, stdOut, stdErr)
  end
  return true
end

-- Should be called by task when completed
function TaskRunner.callback(self, exitCode, stdOut, stdErr)
  if exitCode == 0 then
    self:success(exitCode, stdOut, stdErr, false)
  else
    self:failure(exitCode, stdOut, stdErr)
    if self.option.retry then
      if self.option.retry_count > 0 then
        self.option.retry_count = self.option.retry_count - 1
        self.log.df("Retry count now %d", self.option.retry_count)
        self:retry(exitCode, stdOut, stdErr)
      else
        self.log.i("Retry limit reached")
      end
    end
  end
  if self.cleanupFunc ~= nil then
    self.log.d("Calling cleanup function")
    self:cleanupFunc(exitCode, stdOut, stdErr)
  end
end

-- Called on success by callback()
function TaskRunner.success(self, exitCode, stdOut, stdErr)
  self.log.i("Success.")
  if self.message.success ~= "" then
    self:showMessage(self.message.success, stdOut, stdErr)
  end
end

-- Called on failure by callback() if retry is false
function TaskRunner.failure(self, exitCode, stdOut, stdErr)
  self.log.f("Failure. Stdout: %s Stderr: %s", stdOut, stdErr)
  if self.message.failure ~= "" then
    self:showMessage(self.message.failure, stdOut, stdErr)
  end
end

-- Called on failure by callback() when retry is true
function TaskRunner.retry(self, exitCode, stdOut, stdErr)
  self.log.i("Retrying in " .. self.option.retry_delay .. " seconds.")
  self:showMessage(self.message.retry, stdOut, stdErr)
  local timer = hs.timer.doAfter(self.option.retry_delay, function() self:run() end)
end

-- Display formatted message as notification
-- Arguments:
--   msg: String to disaply
--     %stdout% is replaced by stdOut
--     %stderr% is replaced by stdErr
--  stdOut: string with stdout
--  stdErr: string with stderr
--  autoWithdraw: option boolean
function TaskRunner.showMessage(self, msg, stdOut, stdErr, ...)
  local args = {...}
  local subtitle = ""
  local informativeText = ""
  local autoWithdraw = true
  if stdOut then
    local modMsg, subs = string.gsub(msg, "%%stdout%%", stdOut)
    msg = modMsg
  end
  if stdErr then
    local modMsg, subs = string.gsub(msg, "%%stderr%%", stdErr)
    msg = modMsg
  end
  if #args > 0 then
    autoWithdraw = args[1]
  end
  if self.notification then
    self.notification:withdraw()
  end
  local callbackfn = nil
  local attributes = {
    autoWithdraw = autoWithdraw,
    title = msg,
    subtitle = subtitle,
    informativeText = informativeText
  }
  self.notification = hs.notify.new(callbackfn, attributes)
  self.notification:send()
  return msg
end

return TaskRunner
