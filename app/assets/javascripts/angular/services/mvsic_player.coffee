app.factory 'MvsicPlayer', ['$http', '$timeout', '$rootScope', '$window', ($http, $timeout, $rootScope, $window) ->

  CLIENT_ID = 'c8240aca09f3faa989201f76bcbbd7d0'

  SC.initialize({
      client_id: CLIENT_ID
    })

  artistCache = {}
  currentTrack = {}
  artistList = []

  getTrack = (artist) ->
    $http.post('/track.json', { artist_id: artist.id, subject: 'user_play' })
    trackUrl = artist.soundcloud_track_url
    resolve = "http://api.soundcloud.com/resolve.json?url=#{trackUrl}&client_id=#{CLIENT_ID}&callback=?"
    $.getJSON(resolve)
      .success (response) ->
        SC.stream "#{response.stream_url}", { useHTML5Audio: true, preferFlash: false }, (sound) ->
          unless sound.errors
            artistCache["#{artist.id}"] = {
              duration: response.duration
              sound: sound
              title: response.title
              permalink_url: response.permalink_url
            }
            currentTrack = {
              artistId: artist.id
              artistName: artist.name
              artistUrl: artist.soundcloud_url
              duration: response.duration
              sound: sound
              title: response.title
              permalink_url: response.permalink_url
              error: false
            }
            $rootScope.$apply()
            mvsicPlayer.play()
          else
            broadcastError(artist)
      .error (data, status, headers, config) ->
        broadcastError(artist)

  broadcastError = (artist) ->
    currentTrack = {
      artistName: artist.name
      title: "Error 404 - Could not find track."
      sound: { playState: 0 }
      error: true
    }
    $rootScope.$apply()

  mvsicPlayer =
    currentTime: ->
      if currentTrack && currentTrack.sound
        currentTrack.sound.position

    currentTrack: ->
      currentTrack

    currentDuration: ->
      if currentTrack && currentTrack.sound
        currentTrack.sound.duration

    totalDuration: ->
      if currentTrack
        currentTrack.duration

    setPosition: (percentage) ->
      newPosition = percentage / 100 * currentTrack.duration
      mvsicPlayer.pause()
      currentTrack.sound.setPosition(newPosition)
      mvsicPlayer.play()

    load: (artist) ->
      if !_(currentTrack['sound']).isEmpty() && currentTrack['sound'].playState
        currentTrack['sound'].stop()
      if track = artistCache["#{artist.id}"]
        currentTrack = {
          artistId: artist.id
          artistName: artist.name
          artistUrl: artist.soundcloud_url
          duration: track.duration
          sound: track.sound
          title: track.title
          permalink_url: track.permalink_url
          error: false
        }
        mvsicPlayer.play()
        $rootScope.$apply()
      else
        getTrack(artist)

    playNext: ->
      return unless mvsicPlayer.artistList.length > 1
      a = _.findWhere(mvsicPlayer.artistList, id: currentTrack.artistId)
      index = _.indexOf(mvsicPlayer.artistList, a)

      if index is (mvsicPlayer.artistList.length - 1) or index is -1
        nextIndex = 0
      else
        nextIndex = index + 1
      mvsicPlayer.load(mvsicPlayer.artistList[nextIndex])

    play: ->
      currentTrack.sound.play
        whileplaying: ->
          $rootScope.$apply()
        onfinish: ->
          mvsicPlayer.playNext()

    pause: ->
      currentTrack.sound.pause()
      currentTrack.sound.playState = 0

    togglePause: ->
      if currentTrack.sound.playState
        currentTrack.sound.pause()
        currentTrack.sound.playState = 0
      else if !currentTrack.error
        mvsicPlayer.play()

  $rootScope.$on 'selectArtist', (event, artist) ->
    mvsicPlayer.load(artist)

  mvsicPlayer

]