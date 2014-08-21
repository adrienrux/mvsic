app.controller 'ScheduleController', ['$http', '$scope', '$routeParams', 'Time', 'MvsicPlayer', ($http, $scope, $routeParams, Time, MvsicPlayer) ->

  hashed_id = $routeParams.schedule_hashed_id

  $http.get("/api/schedules/#{hashed_id}.json").success (data) ->
    $scope.schedule = data
    $scope.eventsByDay = groupEventsByDay(data)
    shareLink = window.location.href
    tweet = "Here's my #{data.festival.current_state} for @#{data.festival.twitter_handle} via @mvsicio #{shareLink}"
    $scope.tweetHref = "https://twitter.com/intent/tweet?text=#{encodeURI(tweet)}"
    MvsicPlayer.artistList = _($scope.schedule.schedule_events_attributes).chain()
      .map((e) -> e.event)
      .map((e) -> e.artist)
      .value()

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
