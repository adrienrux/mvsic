app.controller 'FestivalController', ['$http', '$location', '$scope', '$routeParams', '$timeout', 'Festivals', 'Time', 'MvsicPlayer',
  ($http, $location, $scope, $routeParams, $timeout, Festivals, Time, MvsicPlayer) ->
    signedUp = false
    $scope.saving = false
    $scope.sort = 'artist.play_count'
    $scope.saveMessage = 'Save Schedule'
    $scope.eventList = []
    $scope.newSchedule = {
      schedule_events_attributes: []
    }
    $scope.festivalSlug = $routeParams.festival_slug

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
      $scope.selectedDay = $scope.days[0]
      _($scope.newSchedule).extend({festival_id: data.id})

    $scope.$on 'addEvent', (event, data) ->
      $scope.$apply($scope.selectEvent(data))

    $scope.$on 'removeEvent', (event, data) ->
      $scope.$apply($scope.deselectEvent(data))

    $scope.toggleSelectEvent = (e) ->
      if e.selected
        $scope.deselectEvent(e)
      else
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

    $scope.clickSave = ->
      $scope.saveMessage = "Saving..."
      $timeout(openModal, 1000)

    openModal = ->
      if !signedUp
        $scope.showModal = true
      else if !$scope.newSchedule.id
        saveSchedule()
      else
        updateSchedule()

    $scope.$on 'signUpSuccess', (event, email) ->
      signedUp = true
      saveSchedule(email)

    $scope.playArtist = (artist) ->
      $scope.$emit('selectArtist', artist)

    $scope.$on 'updateArtistCount', (event, data) ->
      artists = _($scope.festival.events).chain().pluck('artist').flatten().where({id: data.artist_id}).value()
      _(artists).each((artist) -> artist.play_count = data.count)

    saveSchedule = (email) ->
      updateScheduleEvents()
      $http.post("/api/schedules.json", schedule: $scope.newSchedule, email: email)
        .success (schedule) ->
          _($scope.newSchedule).extend({id: schedule.id, hashed_id: schedule.hashed_id})
          $scope.newSchedule = schedule
          $scope.saveMessage = "Saved!"
          $location.path("/schedules/#{schedule.hashed_id}")
        .error (error) ->
          $scope.saveMessage = "Error :("

    updateSchedule = ->
      updateScheduleEvents()
      $http.put("/api/schedules/#{$scope.newSchedule.id}.json", schedule: $scope.newSchedule)
        .success (schedule) ->
          $scope.newSchedule = schedule
          $scope.saveMessage = "Saved!"
        .error (error) ->
          $scope.saveMessage = "Error :("

    $scope.dayDisplay = (day) ->
      dayDisplay = day.toUTCString().substr(0,3)

    $scope.timeDisplay = (date) ->
      UTCDate = new Date(date).toUTCString()
      day = UTCDate.substr(0,3)
      time = Time.formatAMPM(new Date(date))
      "#{day}, #{time}"
]
