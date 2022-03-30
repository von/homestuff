-- Layout for hs.layout

local builtinScreen = "Color LCD"

-- If a large screen exists, return it, otherwise return nil
local largeScreenNames = { "LG UltraFine" }

local layout = {
  -- App name, window name, screen, unit-rect(win), frame-rect(win), full-frame-rect(win)
  {"Mail", nil, preferLargeDisplay, hs.layout.maximized, nil, nil},
  -- To do: Figure out how to handle different Personas
  {"Google Chrome", nil, nil, hs.layout.maximized, nil, nil},
  {"Slack", nil, builtinScreen, hs.layout.maximized, nil, nil},
  {"Discord", nil, builtinScreen, hs.layout.maximized, nil, nil},
  {"iTerm2", nil, preferLargeDisplay, hs.layout.maximized, nil, nil}
}

function preferLargeDisplay()
  local screenNames = hs.fnutils.map(
    hs.screen.allScreens(),
    function(s) return s:name() end)
  for i, screenName in ipairs(largeScreenNames) do
    if hs.fnutils.contains(screenNames, screenName) then
      return screenName
    end
  end
  -- No large screen found, return default
  return nil
end

function doLayout()
  hs.layout.apply(layout)
end
