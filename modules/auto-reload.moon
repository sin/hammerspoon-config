import some from require 'lodash'
import pathwatcher, reload, configdir from hs

pathwatcher.new(configdir, (paths) ->
  some paths, (path) ->
    some {'.lua', '.moon'}, (ext) ->
      reload! if path\sub(-ext\len!) == ext
)\start!
