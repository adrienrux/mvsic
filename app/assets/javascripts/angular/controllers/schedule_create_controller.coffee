app.controller 'ScheduleCreateController', ['$http', '$scope', '$routeParams', '$timeout', 'Time', ($http, $scope, $routeParams, $timeout, Time) ->
  festival_id = $routeParams.festival_id
  $scope.saving = false
  $scope.eventList = []
  $scope.newSchedule = {
    schedule_events_attributes: []
  }

  $http.get("/api/festivals/#{festival_id}.json").success (data) ->
    $scope.festival = data
    $scope.saveMessage = "Save #{data.current_state}"
    $scope.days = _(data.venues).chain()
      .pluck('events')
      .flatten()
      .pluck('start_time')
      .map((t) ->
        d = new Date(t)
        d.setHours(0)
        d.setMinutes(0)
      )
      .uniq()
      .map((t) ->
        new Date(t)
      )
      .value()
    $scope.selectedDay = $scope.days[0] || 'All'
    _($scope.newSchedule).extend({festival_id: data.id})

  $scope.$on 'addEvent', (event, data) ->
    $scope.$apply($scope.eventList.push(data))

  $scope.$on 'removeEvent', (event, data) ->
    $scope.$apply($scope.eventList = _($scope.eventList).without(data))

  $scope.deselectEvent = (deselectedEvent) ->
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
    $scope.saving = true
    $timeout(saveSchedule, 1000)

  saveSchedule = ->
    if _.isEmpty($scope.eventList)
      $scope.saveMessage = "Add A Show!"
      $scope.saving = false
    else if !$scope.newSchedule.id
      updateScheduleEvents()
      $http.post("/api/schedules.json", schedule: $scope.newSchedule)
        .success (schedule) ->
          _($scope.newSchedule).extend({id: schedule.id})
          $scope.newSchedule = schedule
          $scope.saveMessage = "Saved!"
          $scope.saving = false
        .error (error) ->
          $scope.saveMessage = "Error :("
          $scope.saving = false
    else
      updateScheduleEvents()
      $http.put("/api/schedules/#{$scope.newSchedule.id}.json", schedule: $scope.newSchedule)
        .success (schedule) ->
          $scope.newSchedule = schedule
          $scope.saveMessage = "Saved!"
          $scope.saving = false
        .error (error) ->
          $scope.saveMessage = "Error :("
          $scope.saving = false

  $scope.dayDisplay = (day) ->
    dayDisplay = day.toUTCString().substr(0,3)

  $scope.timeDisplay = (date) ->
    UTCDate = new Date(date).toUTCString()
    day = UTCDate.substr(0,3)
    time = Time.formatAMPM(new Date(date))
    "#{day}, #{time}"
]
