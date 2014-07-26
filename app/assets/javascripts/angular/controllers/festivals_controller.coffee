app.controller 'FestivalsController', ['$http', '$timeout', '$scope', 'MvsicPlayer', ($http, $timeout, $scope, MvsicPlayer) ->
  $http.get('/api/festivals.json', params: { sort_by: 'start_date', page: 1 }).success (data) ->
    $scope.festivalList = data

  $scope.openCard = (card) ->
    $scope.selectedFestival = card
    $timeout ->
      $scope.visibleFestival = card
    , 300


  $scope.playArtist = (artist) ->
    $scope.$emit('selectArtist', artist)
]
