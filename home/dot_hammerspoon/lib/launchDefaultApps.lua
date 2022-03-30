-- Launch my default applications
local module = {}

-- Set up logger for module
local log = hs.logger.new("LaunchDefaultApps", "info")
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

-- Launch app if not already open
-- 'name' should be argument as to hs.application.find()
local function launchIfNotOpen(name)
  local foundApp = hs.application.find(name)
  if foundApp then
    log.d("Found app already running: " .. name)
  else
    log.i("Launching " .. name)
    hs.application.open(name)
    -- Since the above is not waiting for app to launch, will return nil
  end
end

local function launch()
  module.log.i("Launching default applications")
  launchIfNotOpen("com.googlecode.iterm2")
  launchIfNotOpen("com.google.Chrome")
  -- TODO: Open Chrome personas
  if PersonalLaptop then
    -- TODO
  elseif WorkLaptop then
    launchIfNotOpen("com.apple.mail")
    launchIfNotOpen("com.tinyspeck.slackmacgap")
    launchIfNotOpen("com.hnc.Discord")
  end
end

module.launch = launch

return module
