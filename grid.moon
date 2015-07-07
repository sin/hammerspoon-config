window = require "mjolnir.window"

grid = {}

grid.MARGINX = 0
grid.MARGINY = 0
grid.WIDTH = 12
grid.HEIGHT = 6

grid.get = (win) ->
  frame = win\frame!
  screen = win\screen!\frame!
  cellwidth = screen.w / grid.WIDTH
  cellheight = screen.h / grid.HEIGHT

  return {
    x: math.floor((frame.x - screen.x) / cellwidth + 0.5)
    y: math.floor((frame.y - screen.y) / cellheight + 0.5)
    w: math.max(1, math.floor(frame.w / cellwidth + 0.5))
    h: math.max(1, math.floor(frame.h / cellheight + 0.5))
  }

grid.set = (win, cell, screen) ->
  screen = screen\frame!
  cellwidth = screen.w / grid.WIDTH
  cellheight = screen.h / grid.HEIGHT

  frame = {
    x: (cell.x * cellwidth) + screen.x
    y: (cell.y * cellheight) + screen.y
    w: cell.w * cellwidth
    h: cell.h * cellheight
  }

  frame.x = frame.x + grid.MARGINX
  frame.y = frame.y + grid.MARGINY
  frame.w = frame.w - (grid.MARGINX * 2)
  frame.h = frame.h - (grid.MARGINY * 2)

  win\setframe(frame)

return grid