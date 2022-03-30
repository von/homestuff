-- Modifiers.lua
-- Note that "Option" key is "alt"
--
modifiers = {
  none =            {},
  ctrl =            {'ctrl'},
  cmd =             {'cmd'},
  alt =             {'alt'},
  opt =             {'alt'},
  altShift =        {'alt', 'shift'},
  optShift =        {'alt', 'shift'},
  cmdAlt =          {'cmd', 'alt'},
  cmdOpt =          {'cmd', 'alt'},
  cmdShift =        {'cmd', 'shift'},
  ctrlShift =       {'ctrl', 'shift'},
  cmdCtrl =         {'cmd', 'ctrl'},
  ctrlAlt =         {'ctrl', 'alt'},
  ctrlOpt =         {'ctrl', 'alt'},
  cmdCtrlShift =    {'cmd', 'ctrl', 'shift'},
  cmdAltShift =     {'cmd', 'alt', 'ctrl'},
  cmdOptShift =     {'cmd', 'alt', 'ctrl'},
  all =             {'cmd', 'alt', 'ctrl', 'shift' }
}

return modifiers
