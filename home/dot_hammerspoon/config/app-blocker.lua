-- Kill certain apps when they start

local log = hs.logger.new('app-blocker', 'info')

local appsToBlock = {
  "Music" -- Apple Music, which gets started by attachment of headphones
}

-- Use a coroutine to prevent preemption (the callback getting invoked
-- while the callback is being invoked)
local watcherCoroutine = coroutine.create(
  function(appName, eventType, appObj)
    while true do -- Loop for yield()
      if eventType == hs.application.watcher.launching then
        if hs.fnutils.contains(appsToBlock, appName) then
          log.f("Blocking application %s", appName)
          appObj:kill()
        end
      end
      -- And wait for next event
      appName, eventType, appObj = coroutine.yield()
    end -- while
  end -- function()
  )

-- We call the coroutine this way instead of using coroutine.wrap()
-- to make the callback function because that will result in errors if
-- it is called while already being invoked, while this approach serializes
-- calls.
local function watcherCallback(appName, event, app)
  log.df("watcherCallback(%s, %d)", appName, event)
  status, err = coroutine.resume(watcherCoroutine, appName, event, app)
  if status then
    log.df("watcherCallback(%s, %d) done", appName, event)
  else
    log.ef("watcherCallback(%s, %d) error: %s", appName, event, err)
  end
end

appBlockerWatcher = hs.application.watcher.new(watcherCallback)
appBlockerWatcher:start()
