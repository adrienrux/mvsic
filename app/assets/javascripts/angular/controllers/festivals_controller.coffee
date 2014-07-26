app.controller 'FestivalsController', ['$http', '$timeout', '$scope', 'MvsicPlayer', ($http, $timeout, $scope, MvsicPlayer) ->
  $http.get('/api/festivals.json', params: { sort_by: 'start_date', page: 1 }).success (data) ->
    $scope.festivalList = groupBy(data, 4)

  groupBy = (array, size) ->
    lists = _.chain(array).groupBy((el, i) ->
      Math.floor(i/size)
    ).toArray().value()

  carousel = ->
    $scope.slides = [
      { image: '/assets/gradient.png', message: 'Nulla vitae elit libero, a pharetra augue.' }
      { image: '/assets/lights.jpg', message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.' }
      { image: '/assets/record.jpg', message: 'Integer posuere erat a ante venenatis dapibus posuere velit aliquet.' }
      { image: '/assets/sea.jpg', message: 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.' }
    ]

  $scope.openCard = (card) ->
    return if $scope.selectedFestival == card

    $scope.visibleFestival = null
    $timeout ->
      $scope.selectedFestival = card
    , 100
    $timeout ->
      $scope.visibleFestival = card
    , 300

  $scope.playArtist = (artist) ->
    $scope.$emit('selectArtist', artist)


  carousel()
]
