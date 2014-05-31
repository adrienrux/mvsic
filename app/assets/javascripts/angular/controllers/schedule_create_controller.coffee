app.controller 'ScheduleCreateController', ['$http', '$scope', '$routeParams', ($http, $scope, $routeParams) ->
  festival_id = $routeParams.festival_id
  $scope.scheduleList = []

  $http.get("/api/festivals/#{festival_id}.json").success (data) ->
    $scope.festival = data

  $scope.$on 'addEventToSchedule', (event, data) ->
    if !eventExists(data.id)
      $scope.$apply($scope.scheduleList.push(data))

  eventExists = (event_id) ->
    _($scope.scheduleList).chain().pluck('id').contains(event_id).value()
]
