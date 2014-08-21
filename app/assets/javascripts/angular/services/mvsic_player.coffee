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
          artistCache["#{artist.id}"] = {
            duration: response.duration
            sound: sound
            title: response.title
            permalink_url: response.permalink_url
          }
          if !_(currentTrack['sound']).isEmpty()
            currentTrack['sound'].stop()
          currentTrack = {
            artistId: artist.id
            artistName: artist.name
            artistUrl: artist.soundcloud_url
            duration: response.duration
            sound: sound
            title: response.title
            permalink_url: response.permalink_url
            error: false || sound._html5_
          }
          $rootScope.$apply(mvsicPlayer.currentTrack = currentTrack)
          mvsicPlayer.play()

  mvsicPlayer =
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
      mvsicPlayer.loading = true
      if !_(currentTrack['sound']).isEmpty()
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
        mvsicPlayer.currentTrack = currentTrack
        mvsicPlayer.play()
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
      mvsicPlayer.loading = false
      currentTrack.sound.play
        whileplaying: ->
          $rootScope.$apply(mvsicPlayer.currentTime = currentTrack.sound.position)
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

  mvsicPlayer

]