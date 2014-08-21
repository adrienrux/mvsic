app.controller 'FestivalsController', ['$http', '$timeout', '$scope', '$location', '$anchorScroll', 'Festivals', 'MvsicPlayer', ($http, $timeout, $scope, $location, $anchorScroll, Festivals, MvsicPlayer) ->
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

  anchorScroll = ->
    if $location.$$path.match(/about/)
      $timeout ->
        $location.hash('about')
        $anchorScroll()
        $location.hash('')
    else if $location.$$path.match(/festivals\/?$/)
      $timeout ->
        $location.hash('upcoming-festivals')
        $anchorScroll()
        $location.hash('')
    else
      $timeout ->
        $location.hash('slideshow')
        $anchorScroll()
        $location.hash('')

  $scope.playArtist = (artist) ->
    $scope.$emit('selectArtist', artist)

  anchorScroll()
]
