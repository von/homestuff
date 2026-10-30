-- TimeMachineEjector
--
-- Monitor Time Machine and eject after a backup is seen running and completed.
-- Idea is I connect to my USB drive, a backup is done, and then I don't have
-- to manaully eject the USB drive.
--
-- Uses 'tmutil status' to monitor Time Machine status.
--
-- Kudos:
-- https://github.com/nielsmouthaan/ejectify-macos/issues/19
-- https://stackoverflow.com/a/74521281/197789
local TimeMachineEjector = {}

-- Set up logger for module
TimeMachineEjector.log = hs.logger.new("TimeMachineEjector", "info")

function TimeMachineEjector:debug(enable)
  if enable then
    self.log.setLogLevel('debug')
    self.log.d("Debugging enabled")
  else
    self.log.d("Disabling debugging")
    self.log.setLogLevel('info')
  end
end

-- Handle an error and stop ourselves from running further since
-- something is broken.
function TimeMachineEjector:handleError(...)
  self.log.ef(...)
  self:stop()
end

-- Full paths to binaries
TimeMachineEjector.tmutilPath = "/usr/bin/tmutil"

-- How often we check on Time Machine, in seconds
-- If a backup completes in less time than this, we may miss it.
TimeMachineEjector.frequency = 30

-- State. Should be key to TimeMachineEjector.stateFunctions
TimeMachineEjector.state = "notRunning"

-- State functions
-- Functions should take as arguments:
--  * TimeMachineEjector instance (i.e. self)
--  * output from 'tmutil status' as table
-- They return nothing.

function TimeMachineEjector:notRunningStateFunction(tmutilOuput)
  local running = tmutilOuput["Running"]
  local mountPoint = tmutilOuput["DestinationMountPoint"]
  -- Running will be 1 for a while before DestinationMountPoint is set, so
  -- look for both to be set before transitioning state
  if running == "1" and mountPoint then
    self.mountPoint = mountPoint
    self.log.f("Changing state to running. Mount point: %s", self.mountPoint)
    self.state = "running"
  end
end

function TimeMachineEjector:runningStateFunction(tmutilOuput)
  local running = tmutilOuput["Running"]
  if running == "0" then
    self.log.f("Changing state to not running. Ejecting: %s", self.mountPoint)
    self.state = "notRunning"
    local success, errorMsg = hs.fs.volume.eject(self.mountPoint)
    if success then
      self.log.df("Successfully ejected %s", self.mountPoint)
    else
      self.log.ef("Failed to eject %s: %s", self.mountPoint, errorMsg)
    end
  end
end

-- Map state to function
TimeMachineEjector.stateFunctions = {
  notRunning = TimeMachineEjector.notRunningStateFunction,
  running = TimeMachineEjector.runningStateFunction
}

-- timerCallback() invoked tmutil asynchronously, which invokes this callback
-- It parses 'tmutil status' output dispatches state-specific function
-- with that output as a table.
--
-- Example tmutil status output for running and not running.
--
-- Backup session status:
-- {
--     BackupPhase = ThinningPostBackup;
--     ClientID = "com.apple.backupd";
--     DateOfStateChange = "2026-10-28 00:22:05 +0000";
--     DestinationID = "C7B1D086-CE6C-48A2-B26F-D25577A0D477";
--     DestinationMountPoint = "/Volumes/Two TB USB Drive";
--     Percent = "-1";
--     Running = 1;
--     attemptOptions = 1;
-- }
--
-- Backup session status:
-- {
--     ClientID = "com.apple.backupd";
--     Percent = "-1";
--     Running = 0;
-- }
function TimeMachineEjector:tmutilCallback(exitCode, stdOut, stdErr)
  if exitCode ~= 0 then
    self:handleError("tmutil exited with status %d: %s", exitCode, stdErr)
    return
  end

  -- Parse tmutil output, which is a plist with a one-line header, which we discard
  -- string.match() does the header discard
  -- Second argument indicates if first argument is binary
  local tmutilOuput = hs.plist.readString(string.match(stdOut, "\n(.*)"), false)
  if not tmutilOuput then
    self:handleError("Failed to parse output from tmutil")
    return
  end

  local stateFunction = self.stateFunctions[self.state]
  if not stateFunction then
    self:handleError("Unrecogized state: %s", self.state)
    return
  end

  stateFunction(self, tmutilOuput)
end

-- This callback is called by timer regularly
-- It invokes 'tmutil status' with a callback to tmutilCallback()
function TimeMachineEjector:timerCallback()
  self.log.df("timerCallback() called. State = %s", self.state)
  hs.task.new(
    self.tmutilPath,
    hs.fnutils.partial(self.tmutilCallback, self),
    { "status" }
    ):start()
end

-- Start monitoring
function TimeMachineEjector:start()
  self.log.f("Starting. Frequency = %s", self.frequency)
  self.timer = hs.timer.doEvery( self.frequency, function() self:timerCallback() end)
  return self
end

-- Stop monitoring
function TimeMachineEjector:stop()
  self.log.i("Stopping.")
  self.timer:stop()
  return self
end

return TimeMachineEjector
