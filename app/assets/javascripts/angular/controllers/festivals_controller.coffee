app.controller 'FestivalsController', ['$http', '$scope', 'MvsicPlayer', ($http, $scope, MvsicPlayer) ->
  $http.get('/api/festivals.json').success (data) ->
    $scope.festivalList = data
]
