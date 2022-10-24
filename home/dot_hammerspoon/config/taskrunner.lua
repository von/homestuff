-- Set PATH for TaskRunner
-- ../lib/TaskRunner.lua
local TaskRunner = require("TaskRunner")
-- homebrew_prefix set in ../init.lua
local path = "/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:" .. homebrew_prefix .. "/bin:" .. os.getenv("HOME") .. "/bin"
TaskRunner.setPath(path)
