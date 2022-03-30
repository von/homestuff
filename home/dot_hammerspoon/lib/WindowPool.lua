-- WindowPool.lua
-- Allow creation of a pool of windows that we can rotate among, similar to
-- Command-Tab. Also similar to hs.window.switcher, but allows specifying
-- specific windows and not just applications.

local WindowPool = {}

WindowPool.log = hs.logger.new('WindowPool', 'info')

function WindowPool:debug(enable)
  if enable then
    self.log.setLogLevel('debug')
    self.log.d("Debugging enabled")
  else
    self.log.d("Disabling debugging")
    self.log.setLogLevel('info')
  end
end

WindowPool.windowpool = {}
WindowPool.windowpoolindex = 1

--- WindowPool:inPool()
--- Method
--- Return true if given window is in the window pool.
---
--- Parameters:
--- * hw.window instance
---
--- Returns:
--- * true if window is in pool, false otherwise
function WindowPool:inPool(win)
  return hs.fnutils.contains(self.windowpool, win)
end

--- WindowPool:rotate()
--- Method
--- Rotate to next window in the pool.
--- If that window already has focus, does nothing.
--- If the window pool is empty, displays an alert saying so.
---
--- Parameters:
--- * None
---
--- Returns:
--- * Nothing
function WindowPool:rotate()
  if #self.windowpool == 0 then
    hs.alert.show("Window pool empty")
    return
  end
  if self.windowpoolindex > #self.windowpool then
    self.windowpoolindex = 1
  end
  self.windowpool[self.windowpoolindex]:focus()
  self.windowpoolindex = self.windowpoolindex + 1
end

--- WindowPool:addFocusedWindow()
--- Method
--- Add the currently focused window to the pool.
--- If it is already in the window pool is empty, displays an alert saying so.
---
--- Parameters:
--- * None
---
--- Returns:
--- * Nothing
function WindowPool:addFocusedWindow()
  local currentWindow = hs.window.focusedWindow()
  if not self:contains(currentWindow) then
    table.insert(self.windowpool, currentWindow)
    hs.alert.show("Added to rotation")
  else
    hs.alert.show("Already in rotation")
  end
end

--- WindowPool:removeFocusedWindow()
--- Method
--- Remove the currently focused window to the pool.
--- If it is not in the window pool is empty, displays an alert saying so.
---
--- Parameters:
--- * None
---
--- Returns:
--- * Nothing
function WindowPool:removeFocusedWindow()
  local currentWindow = hs.window.focusedWindow()
  local index = hs.fnutils.indexOf(self.windowpool, currentWindow)
  if index == nil then
    hs.alert.show("Not in rotation")
  else
    table.remove(self.windowpool, index)
    hs.alert.show("Removed from rotation")
  end
end

--- WindowPool:toggleFocusedWindow()
--- Method
--- Add or remove the currently focused window from the pool, depending
--- on whether or not it is already in the pool.
--- Displays an alert with whatever the change is.
---
--- Parameters:
--- * None
---
--- Returns:
--- * Nothing
function WindowPool:toggleFocusedWindow()
  local currentWindow = hs.window.focusedWindow()
  local index = hs.fnutils.indexOf(self.windowpool, currentWindow)
  if index == nil then
    table.insert(self.windowpool, currentWindow)
    hs.alert.show("Added to rotation")
  else
    table.remove(self.windowpool, index)
    hs.alert.show("Removed from rotation")
  end
end

--- WindowPool:clear()
--- Method
--- Empty the window pool.
---
--- Parameters:
--- * None
---
--- Returns:
--- * Nothing
function WindowPool:clear()
  self.windowpool = {}
  self.windowpoolindex = 1
end

--- WindowPool.filter
--- Variable
--- A hs.window.filter which acts on windows in the pool.
WindowPool.filter = hs.window.filter.new(function(w) return WindowPool:inPool(w) end)

--- WindowPool.switcher
--- Variable
--- A hs.window.switcher instance that acts on windows in the pool.
WindowPool.switcher = hs.window.switcher.new(WindowPool.filter)
WindowPool.switcher.ui.showTitles = true
WindowPool.switcher.ui.textSize = 10  -- default is 16
WindowPool.switcher.ui.showThumbnails = false
WindowPool.switcher.ui.showSelectedThumbnail = false

return WindowPool
