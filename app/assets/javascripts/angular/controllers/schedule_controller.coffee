app.controller 'ScheduleController', ['$http', '$scope', '$routeParams', 'Time', ($http, $scope, $routeParams, Time) ->

  id = $routeParams.schedule_id

  $http.get("/api/schedules/#{id}.json").success (data) ->
    $scope.schedule = data
    $scope.eventsByDay = groupEventsByDay(data)

  groupEventsByDay = (schedule) ->
    _(schedule.schedule_events_attributes).chain()
      .pluck('event')
      .groupBy((e) -> e.date)
      .pairs()
      .map((day) ->
        date = if day[0] != 'null' then day[0]
        {
          date: date
          events: day[1]
        }
      )
      .value()

  $scope.timeDisplay = (date) ->
    Time.formatAMPM(new Date(date))
]
