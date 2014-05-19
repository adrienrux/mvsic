app.controller 'FestivalsController', ['$http', '$scope', ($http, $scope) ->
  $http.get('/api/festivals.json').success (data) ->
    $scope.festivalList = data
]
