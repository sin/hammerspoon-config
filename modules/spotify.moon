import alert from hs

spotify = {}

spotify.tell = (cmd) ->
    handle = io.popen('osascript -e \'tell application "Spotify" to ' .. cmd .. "'")
    result = handle\read("*a")
    handle\close!
    return result

spotify.displayCurrentTrack = ->
    artist = string.gsub(spotify.tell('get the artist of the current track'), "%s$", "")
    track = string.gsub(spotify.tell('get the name of the current track'), "%s$", "")
    alert.show(artist .. " - " .. track, 1.5)

return spotify
