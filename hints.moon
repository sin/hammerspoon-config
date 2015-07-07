hints = require "mjolnir.th.hints.internal"
window = require "mjolnir.window"
modal_hotkey = require "mjolnir._asm.modal_hotkey"

hints.CHARS = {"Z", "X", "C", "V", "B", "A", "S", "D", "F", "G",
               "Q", "W", "E", "R", "T"}
hints.MINIMIZED = false

list = {}
index = 0
modal = nil

hints.adjustHintPosition = (pos) ->
  for i, hint in pairs list
    h = hint.pos
    if ((h.x - pos.x) ^ 2 + (h.y - pos.y) ^ 2) < 40 ^ 2
      newpos = {x: pos.x, y: pos.y + 80}
      return hints.adjustHintPosition(newpos)
  return {x: pos.x, y: pos.y}

hints.createHint = (win) ->
  app = win\application!
  if app == nil return
  if index == 0 modal\enter!

  index = index + 1
  char = hints.CHARS[index]
  frame = win\frame!
  screen = win\screen!
  appid = app\bundleid!
  pos = {
    x: frame.x + (frame.w / 2)
    y: frame.y + (frame.h / 2)
  }
  pos = hints.adjustHintPosition(pos)
  hint = hints.__new(pos.x, pos.y, char, appid, screen)

  list[char] = {
    win: win
    pos: pos
    hint: hint
  }

hints.displayHints = ->
  hints.closeAllHints!
  for i, win in ipairs window.allwindows! 
    if win\isstandard! or (win\isminimized! and hints.MINIMIZED)
      hints.createHint(win)

hints.closeAllHints = ->
  for i, hint in pairs list 
    hint.hint\__close!
  modal\exit!
  list = {}
  index = 0

hints.createHandler = (char) ->
  return ->
    if list[char]
      win = list[char].win
      win\unminimize!
      win\focus!
    hints.closeAllHints!

hints.init = ->
  modal = modal_hotkey.new({"cmd", "shift"}, "x")
  modal\bind({}, 'escape', hints.closeAllHints)
  for i, char in ipairs hints.CHARS
    modal\bind({}, char, hints.createHandler(char))

hints.init!

return hints