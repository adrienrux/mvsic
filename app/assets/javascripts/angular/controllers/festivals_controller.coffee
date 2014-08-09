app.controller 'FestivalsController', ['$http', '$timeout', '$scope', 'Festivals', 'MvsicPlayer', ($http, $timeout, $scope, Festivals, MvsicPlayer) ->
  groupBy = (array, size) ->
    lists = _.chain(array).groupBy((el, i) ->
      Math.floor(i/size)
    ).toArray().value()

  if Festivals.listEmpty()
    $http.get('/api/festivals.json', params: { sort_by: 'start_date', page: 1 }).success (data) ->
      $scope.festivalListFull = data
      $scope.festivalList = groupBy(data, 4)
      Festivals.setFestivalList(data)
  else
    $scope.festivalList = groupBy(Festivals.getFestivalList(), 4)

  carousel = ->
    $scope.slides = [
      { image: '/assets/wallpaper/hands.jpg', message: 'Nulla vitae elit libero, a pharetra augue.' }
      { image: '/assets/wallpaper/microphone.jpg', message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.' }
      { image: '/assets/wallpaper/vinyl.jpg', message: 'Integer posuere erat a ante venenatis dapibus posuere velit aliquet.' }
    ]
    adjustHeight('.slideshow .slide img')

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

  $scope.$on 'updateArtistCount', (event, data) ->
    artists = _($scope.festivalListFull).chain().pluck('top_artists').flatten().where({id: data.artist_id}).value()
    _(artists).each((artist) -> artist.play_count = data.count)

  carousel()
]
