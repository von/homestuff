-- Mouse Bindings configuration
local mb = hs.loadSpoon("MouseBind")
local modifiers = require("modifiers")

local MouseCircle = hs.loadSpoon("MouseCircle")
local function showCircleCallback(event)
  MouseCircle:show()
  return true -- delete event
end
mb:createBinding(modifiers.alt, "leftMouseDown", nil, showCircleCallback)
