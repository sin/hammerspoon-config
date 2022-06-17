-- File:        ~/.hammerspoon/main.moon
-- Description: Hammerspoon configuration file

import alert, application, window, hotkey from hs

require 'modules/auto-reload'
spotify = require 'modules/spotify'
grid = require 'modules/grid'

mash = {'ctrl', 'alt', 'cmd'}
definitions = {}
recentmin = nil

w = grid.WIDTH
h = grid.HEIGHT

grids = {
  fullscreen:  { x: 0,     y: 0,    w: w,     h: h     }
  medium:      { x: w/12,  y: h/6,  w: w/6*5, h: h/3*2 }
  top:         { x: 0,     y: 0,    w: w,     h: h/2   }
  bottom:      { x: 0,     y: h/2,  w: w,     h: h/2   }
  left:        { x: 0,     y: 0,    w: w/2,   h: h     }
  leftnarrow:  { x: 0,     y: 0,    w: w/3,   h: h     }
  leftwide:    { x: 0,     y: 0,    w: w/3*2, h: h     }
  right:       { x: w/2,   y: 0,    w: w/2,   h: h     }
  rightnarrow: { x: w/3*2, y: 0,    w: w/3,   h: h     }
  rightwide:   { x: w/3,   y: 0,    w: w/3*2, h: h     }
  topleft:     { x: 0,     y: 0,    w: w/2,   h: h/2   }
  topright:    { x: w/2,   y: 0,    w: w/2,   h: h/2   }
  bottomleft:  { x: 0,     y: h/2,  w: w/2,   h: h/2   }
  bottomright: { x: w/2,   y: h/2,  w: w/2,   h: h/2   }
}

apps = {
  a: 'Affinity Designer'
  c: 'Visual Studio Code'
  t: 'iTerm'
  f: 'Firefox'
  g: 'Google Chrome'
  m: 'Finder'
  s: 'Spotify'
}

gridlists = {
  { key: 'up',    list: {'fullscreen', 'top', 'medium'} }
  { key: 'down',  list: {'bottom', 'medium'} }
  { key: 'left',  list: {'left', 'leftwide', 'leftnarrow'} }
  { key: 'right', list: {'right', 'rightwide', 'rightnarrow'} }
  { key: '1',     list: {'topleft'} }
  { key: '2',     list: {'topright'} }
  { key: '3',     list: {'bottomleft'} }
  { key: '4',     list: {'bottomright'} }
}

minimize = ->
  win = window.focusedwindow!
  if win == nil return
  win\minimize!
  recentmin = win

compare = (a, b) ->
  if a.x ~= b.x or a.y ~= b.y or a.w ~= b.w or a.h ~= b.h return false
  return true

gridset = (list, key) ->
  return ->
    win = window.focusedwindow!
    if (win == nil or win\isstandard ~= true) and recentmin and key == 'up'
      win = recentmin
      win\unminimize!
      recentmin = nil
      return
    elseif win == nil or win\isfullscreen! == true return
    current_grid = grid.get(win)
    index = nil
    for i, grid in ipairs list
      if i > 1 and compare(current_grid, list[i - 1])
        index = i
    if index == nil
      index = 1
    grid.set(win, list[index], win\screen!)

init = ->
  for i, grid in pairs gridlists
    list = {}
    for i, string in pairs grid.list
      list[i] = grids[string]
    definitions[grid.key] = gridset(list, grid.key)

  for key, app in pairs apps
    definitions[key] = ->
      application.launchorfocus(app)

  for key, fun in pairs definitions
    hotkey.bind(mash, key, fun)

  hotkey.bind(mash, 'M', minimize)
  hotkey.bind(mash, '=', spotify.displayCurrentTrack)
)

init!
