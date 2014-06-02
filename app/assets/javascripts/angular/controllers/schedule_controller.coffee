app.controller 'ScheduleController', ['$http', '$scope', '$routeParams', ($http, $scope, $routeParams) ->

  id = $routeParams.schedule_id

  $http.get("/api/schedules/#{id}.json").success (data) ->
    $scope.schedule = data
]
