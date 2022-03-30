-- Set PATH for TaskRunner
-- ../lib/TaskRunner.lua
local TaskRunner = require("TaskRunner")
local path = "/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:" .. os.getenv("HOME") .. "/bin"
TaskRunner.setPath(path)
