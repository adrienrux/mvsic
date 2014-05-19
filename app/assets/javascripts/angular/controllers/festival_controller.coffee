app.controller 'FestivalController', ['$http', '$scope', '$routeParams', ($http, $scope, $routeParams) ->

  id = $routeParams.festival_id

  $http.get("/api/festivals/#{id}.json").success (data) ->
    $scope.festival = data
]
