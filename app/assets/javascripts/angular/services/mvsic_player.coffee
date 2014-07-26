app.factory 'MvsicPlayer', ($http, $rootScope) ->

  CLIENT_ID = 'c8240aca09f3faa989201f76bcbbd7d0'

  SC.initialize({
      client_id: CLIENT_ID
    })

  playlist = {}
  currentTrack = {}

  getTrack = (artist) ->
    trackUrl = artist.soundcloud_track_url
    resolve = "http://api.soundcloud.com/resolve.json?url=#{trackUrl}&client_id=#{CLIENT_ID}"
    $.get(resolve)
      .success (response) ->
        SC.stream "#{response.stream_url}", (sound) ->
          unless sound.errors
            playlist["#{artist.id}"] = {
              sound: sound,
              title: response.title
              permalink_url: response.permalink_url
            }
            currentTrack = {
              artistName: artist.name
              sound: sound
              title: response.title
              permalink_url: response.permalink_url
              error: false
            }
            currentTrack['sound'].play()
            $rootScope.$broadcast 'newTrack', currentTrack
          else
            broadcastError(artist)
      .error (data) ->
        broadcastError(artist)

  broadcastError = (artist) ->
    currentTrack = {
      artistName: artist.name
      title: "Error 404 - Could not find track."
      sound: { playState: 0 }
      error: true
    }
    $rootScope.$broadcast 'newTrack', currentTrack

  mvsicPlayer =
    load: (artist) ->
      if !_(currentTrack['sound']).isEmpty() && currentTrack['sound'].playState
        currentTrack['sound'].stop()
      if track = playlist["#{artist.id}"]
        currentTrack = {
          artistName: artist.name
          sound: track.sound
          title: track.title
          permalink_url: track.permalink_url
          error: false
        }
        currentTrack['sound'].play()
        $rootScope.$broadcast 'newTrack', currentTrack
      else
        getTrack(artist)

    pause: ->
      if currentTrack.sound.playState
        currentTrack.sound.pause()
        currentTrack.sound.playState = 0
      else if !currentTrack.error
        currentTrack.sound.play()

  $rootScope.$on 'selectArtist', (event, artist) ->
    mvsicPlayer.load(artist)

  mvsicPlayer
