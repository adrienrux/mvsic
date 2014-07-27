app.controller 'MvsicPlayerController', ['$scope', '$timeout', 'MvsicPlayer',
  ($scope, $timeout, MvsicPlayer) ->
    $scope.mvsicPlayer = MvsicPlayer
    $scope.$on 'newTrack', (event, newTrack) ->
      $scope.currentTrack = newTrack
      $scope.$apply()

    $scope.updatePosition = (event) ->
      position = event.offsetX / 300 * 100
      MvsicPlayer.setPosition(position)
]
