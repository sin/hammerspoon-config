import application, hotkey, image, notify, spotify, timer from hs
import getCurrentAlbum, getCurrentTrack, getCurrentArtist, isPlaying, getDuration from spotify

bundleID = application.find('Spotify')\bundleID!
icon = image.imageFromAppBundle bundleID

prevArtist = getCurrentArtist!
prevAlbum = getCurrentAlbum!
prevTrack = getCurrentTrack!
prevPlaying = isPlaying!

formatTrackTime = (time) ->
  min = math.floor(time / 60)
  sec = math.floor(time % 60)
  sec = sec > 9 and sec or '0' .. sec

  min .. ':' .. sec, min, sec

showCurrentTrack = ->
  options = 
    title: getCurrentTrack! .. ' (' .. formatTrackTime(getDuration!) .. ')',
    subTitle: getCurrentAlbum!,
    informativeText: getCurrentArtist!,
    contentImage: icon

  notify.new(nil, options)\send!

showIfChanged = ->
  artist, album, track, playing = getCurrentArtist!, getCurrentAlbum!, getCurrentTrack!, isPlaying!

  if playing and (track != prevTrack or album != prevAlbum or artist != prevArtist or playing != prevPlaying)
    showCurrentTrack!
  
  prevTrack, prevAlbum, prevArtist, prevPlaying = track, album, artist, playing

return {
  showCurrentTrack: showCurrentTrack,
  showIfChanged: showIfChanged
}
