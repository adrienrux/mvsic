app.controller 'MvsicPlayerController', ['$scope', '$timeout', 'MvsicPlayer',
  ($scope, $timeout, MvsicPlayer) ->
    $scope.mvsicPlayer = MvsicPlayer

    $scope.updatePosition = (event) ->
      position = event.offsetX / 300 * 100
      MvsicPlayer.setPosition(position)
]
