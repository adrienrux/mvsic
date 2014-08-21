app.controller 'FestivalController', ['$http', '$location', '$scope', '$routeParams', '$timeout', 'Festivals', 'Time', 'MvsicPlayer', 'localStorageService',
  ($http, $location, $scope, $routeParams, $timeout, Festivals, Time, MvsicPlayer, localStorageService) ->
    signedUp = false
    $scope.saving = false
    $scope.email = localStorageService.get('email')
    $scope.eventList = []
    $scope.newSchedule = {
      schedule_events_attributes: []
    }
    $scope.festivalSlug = $routeParams.festival_slug
    window.re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/

    if Festivals.listEmpty()
      $http.get('/api/festivals.json').success (data) ->
        $scope.festivalId = _(data).findWhere({slug: $scope.festivalSlug}).id
        Festivals.setFestivalList(data)
        $http.get("/api/festivals/#{$scope.festivalId}.json").success (data) ->
          setupFestival(data)
    else
      $http.get("/api/festivals/#{Festivals.findId($scope.festivalSlug)}.json").success (data) ->
        setupFestival(data)

    setupFestival = (data) ->
      $scope.festival = data
      $scope.saveMessage = "Save #{data.current_state}"
      tweet = "Find your favorite artists and create a #{data.current_state} for @#{data.twitter_handle} via @mvsicio #{window.location.href}"
      $scope.tweetHref = "https://twitter.com/intent/tweet?text=#{encodeURI(tweet)}"

      if data.show_schedule
        $scope.sort = 'day'
        $scope.venueList = _(data.events).chain().pluck('venue').pluck('name').uniq().value()
        $scope.page = 0
        $scope.selectedVenues = $scope.venueList.slice($scope.page, $scope.page + 4)
      else
        $scope.sort = 'artist.play_count'

      $scope.days = _(data.events).chain()
        .pluck('start_time')
        .compact()
        .map((t) ->
          d = new Date(t)
          d.setHours(0)
          d.setMinutes(0)
        )
        .uniq()
        .map((t) ->
          new Date(t)
        )
        .sortBy((t) -> t)
        .value()

      MvsicPlayer.artistList = _.map(data.events, (e) -> e.artist)

      _($scope.newSchedule).extend(festival_id: data.id)
      $scope.selectedDay = $scope.days[0]

    $scope.$on 'addEvent', (event, data) ->
      $scope.$apply($scope.selectEvent(data))

    $scope.$on 'removeEvent', (event, data) ->
      $scope.$apply($scope.deselectEvent(data))

    $scope.pageLeft = ->
      $scope.page -= 1
      $scope.selectedVenues = $scope.venueList.slice($scope.page, $scope.page + 4)

    $scope.pageRight = ->
      $scope.page += 1
      $scope.selectedVenues = $scope.venueList.slice($scope.page, $scope.page + 4)

    $scope.toggleSelectEvent = (e) ->
      $timeout ->
        e.helperText = undefined
      , 2500
      if e.selected
        e.helperText = 'Removed from schedule'
        $scope.deselectEvent(e)
      else
        e.helperText = 'Added to schedule'
        $scope.selectEvent(e)

    $scope.selectEvent = (selectedEvent)->
      selectedEvent.selected = true
      $scope.eventList.push(selectedEvent)

    $scope.deselectEvent = (deselectedEvent) ->
      deselectedEvent.selected = false
      $scope.eventList = _($scope.eventList).without(deselectedEvent)
      $scope.$broadcast('deselectEvent', deselectedEvent)

    $scope.selectDay = (day) ->
      $scope.selectedDay = day

    eventExists = (event_id) ->
      _($scope.newSchedule.schedule_events_attributes)
        .chain()
        .pluck('event_id')
        .contains(event_id)
        .value()

    eventCount = ->
      $scope.eventList.length

    updateScheduleEvents = ->
      _($scope.newSchedule.schedule_events_attributes).each((scheduleEvent) ->
        if !_($scope.eventList).findWhere({id: scheduleEvent.event_id})
          scheduleEvent._destroy = 1
      )
      _($scope.eventList).each((event) ->
        if !_($scope.newSchedule.schedule_events_attributes).findWhere({event_id: event.id})
          $scope.newSchedule.schedule_events_attributes.push({event_id: event.id})
      )

    $scope.notDestroyed = (item) ->
      item._destroy != 1

    $scope.sortBy = (order) ->
      artistList = _.clone(MvsicPlayer.artistList)

      if order is 'day'
        $scope.sort = 'day'
      if order is 'artist.play_count'
        $scope.sort = 'artist.play_count'
        MvsicPlayer.artistList = _.sortBy(artistList, (a) -> a.play_count).reverse()
      if order is 'artist.name'
        $scope.sort = 'artist.name'
        MvsicPlayer.artistList = _.sortBy(artistList, (a) -> a.name).reverse()

    $scope.openModal = ->
      $scope.email = localStorageService.get('email')
      $scope.saveMessage = "Saving..."
      if !$scope.email
        $scope.showSignUpModal = true
      else if !$scope.newSchedule.id
        saveSchedule($scope.email)
      else
        updateSchedule()

    $scope.playArtist = (artist) ->
      $scope.$emit('selectArtist', artist)

    $scope.betaSignup = ->
      if re.test($scope.email)
        $http.post('/beta/signup.json',
          first_name: $scope.firstName
          last_name: $scope.lastName
          email: $scope.email
        ).success((response) ->
          localStorageService.set('email', $scope.email)
          saveSchedule($scope.email)
          $scope.showSignUpModal = false
        ).error((response) ->
          $scope.saveError = 'Error :('
        )
      else
        $scope.saveError = 'Please use a valid email address'

    saveSchedule = (email) ->
      updateScheduleEvents()
      $http.post("/api/schedules.json", schedule: $scope.newSchedule, email: email)
        .success (schedule) ->
          $scope.newSchedule = schedule
          $scope.saveMessage = "Saved!"
          $scope.showSuccessModal = true
        .error (error) ->
          $scope.saveMessage = "Error :("

    updateSchedule = ->
      updateScheduleEvents()
      $http.put("/api/schedules/#{$scope.newSchedule.id}.json", schedule: $scope.newSchedule)
        .success (schedule) ->
          $scope.newSchedule = schedule
          $scope.saveMessage = "Saved!"
          $scope.showSuccessModal = true
        .error (error) ->
          $scope.saveMessage = "Error :("

    $scope.dayDisplay = (day) ->
      dayDisplay = day.toUTCString().substr(0,3)

    $scope.timeDisplay = (date) ->
      UTCDate = new Date(date).toUTCString()
      day = UTCDate.substr(0,3)
      time = Time.formatAMPM(new Date(date))
      "#{day}, #{time}"

    $scope.eventTimeDisplay = (startTime, endTime) ->
      start = Time.formatAMPM(new Date(startTime))
      end = Time.formatAMPM(new Date(endTime))
      UTCDate = new Date(startTime).toUTCString()
      day = UTCDate.substr(0,3)
      "#{day} #{start} - #{end}"

    $scope.dayFilter = (event) ->
      $scope.dayDisplay(new Date($scope.selectedDay)) == $scope.dayDisplay(new Date(event.start_time))
]
