-- Wrapper around chrome-cli command
-- https://github.com/prasmussen/chrome-cli

-- ChromeCLI module
local module = {}

-- Set up logger for module
local log = hs.logger.new("ChromeCLI", "info")
module.log = log

local myConfig = MyConfig["ChromeCLI"] or {}
local path = myConfig["path"] or "/usr/local"
module.executable = myConfig["executable"] or "/usr/local/bin/chrome-cli"

module.debug = function(enable)
  if enable then
    log.setLogLevel('debug')
    log.d("Debugging enabled")
  else
    log.d("Disabling debugging")
    log.setLogLevel('info')
  end
end

-- Output Processors {{{ --

-- parseIdLines(): Given an array of lines of the form "[id] TItle"
-- return a table of id->title pairs, or nil on error
local function parseIdLines(lines)
  log.df("Processing %d lines of output", #lines)
  local t = {}
  for i = 1,#lines do
    local line = lines[i]
    local id,title = line:match("%[(%d+)%] (.*)")
    if not id then
      log.e("Failed to parse id line: " .. line)
    end
    t[tonumber(id)] = title
  end
  -- Tempted to log # of windows here, but would have to iterate them to count them
  return t
end

-- parseDoubleIdLines(): Given an array of lines of the form "[windowId:tabId] TItle"
-- return a table of tabId->{title->title, windowId->windowId} pairs, or nil on error
local function parseDoubleIdLines(lines)
  log.df("Processing %d lines of output", #lines)
  local t = {}
  for i = 1,#lines do
    local line = lines[i]
    local windowId,tabId,title = line:match("%[(%d+):(%d+)%] (.*)")
    if not tabId then
      log.e("Failed to parse id line: " .. line)
    end
    t[tonumber(tabId)] = { title=title, windowId=tonumber(windowId) }
  end
  -- Tempted to log # of windows here, but would have to iterate them to count them
  return t
end


-- parseAttrLines(): Given an array of lines of the form "attribute: value"
-- return a table of attribute->value pairs, or nil on error
local function parseAttrLines(lines)
  log.df("Processing %d lines of output", #lines)
  local t = {}
  for i = 1,#lines do
    local line = lines[i]
    local attr,value = line:match("(.+): (.*)")
    if not attr then
      log.e("Failed to parse line: " .. line)
    end
    -- TODO: convert value to number?
    t[attr] = value
  end
  -- Tempted to log # of windows here, but would have to iterate them to count them
  return t
end

-- }}} Output Processors --

-- start() {{{ --

-- Start chrome-cli task
--
-- callbackFn should be the callback which accepts a table of results from the
--    outputProcessor function
-- outputProcessor should accept an array of lines of output from chrome-cli and return
--    a table of prarsed results.
-- args should be the arguments to chrome-cli
--
-- Returns hs.task object on success, nil on failure
local function start(callbackFn, outputProcessor, args)

  local function callback(exitCode, stdOut, stdErr)
    if exitCode > 0 then
      log.e(string.format("%s returned %d: %s", module.executable, exitCode, stdErr))
      return nil
    end
    if callbackFn and outputProcessor then
      -- Kudos: https://stackoverflow.com/a/32847589/197789
      local lines = {}
      for line in stdOut:gmatch("[^\r\n]+") do
          table.insert(lines, line)
      end
      local t = outputProcessor(lines)
      callbackFn(t)
    end
  end

  log.df("Executing %s %s", module.executable, table.concat(args, " "))
  local task = hs.task.new(module.executable, callback, args)
  if not task then
    log.e("Failed to create task for " .. module.executable)
    return nil
  end
  if not task:start() then
    log.e("Failed to start task for " .. module.executable)
    return nil
  end
  return task
end

-- }}} start() --

-- activate() {{{ --

-- Activate specified tab
-- Returns hs.task object
local function activate(tabId)
  local args = { "activate", "-t", tostring(tabId) }
  return start(nil, nil, args)
end

module.activate = activate

-- }}} activate() --

-- info() {{{ --

-- Get info about tab given by id, or active tab if not given
-- Returns hs.task object
local function info(tabId, callback)
  local args = { "info" }
  if tabId then
    table.insert(args, "-t")
    table.insert(args, tostring(tabId))
  end
  return start(callback, parseAttrLines, args)
end

module.info = info

-- }}} info() --

-- listWindows() {{{ --

-- Return table with list of windows indexed by id
local function listWindows(callback)
  log.d("Listing windows")
  local args = {"list", "windows"}
  return start(callback, parseIdLines, args)
end

module.listWindows = listWindows

-- }}} listWindows() --

-- listTabs() {{{ --

-- Return table with list of tabs indexed by id
-- Values of table are { title->tile, windowId->windowId }
local function listTabs(callback)
  log.d("Listing tabs")
  local args = { "list", "tabs" }
  return start(callback, parseDoubleIdLines, args)
end

module.listTabs = listTabs

-- }}} listTabs() --

-- listTabsForWindow() {{{ --

-- Return table with list of tabs for given window indexed by id
-- Values are tab titles
local function listTabsForWindow(callback, windowId)
  log.df("Listing tabs for windowId %d", windowId)
  local args = { "list", "tabs", "-w", tostring(windowId) }
  return start(callback, parseIdLines, args)
end

module.listTabsForWindow = listTabsForWindow

-- }}} listTabsForWindow() --

-- open() {{{ --

-- Open a URL
-- callback is a function which should accept a single argument of a table
--   with the new tab attributes.
-- url is the url to open
-- opts is a table which can have the following values:
-- newWindow, windowId, tabId, incognito- mutually exclusive
-- Returns hs.task object on success, nil on failure
local function open(callback, url, opts)
  local args = { "open", url }
  if opts then
    if opts.newWindow then
      table.insert(args, "-n")
    elseif opts.windowId then
      table.insert(args, "-w")
      table.insert(args, tostring(opts.windowId))
    elseif opts.tabId then
      table.insert(args, "-t")
      table.insert(args, tostring(opts.tabId))
    elseif opts.incognito then
      table.insert(args, "-i")
    end
  end
  return start(callback, parseAttrLines, args)
end

module.open = open

-- }}} open() --

return module
-- vim:foldmethod=marker:
