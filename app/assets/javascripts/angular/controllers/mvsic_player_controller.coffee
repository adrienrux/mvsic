app.controller 'MvsicPlayerController', ['$scope', 'MvsicPlayer',
  ($scope, MvsicPlayer) ->
    $scope.mvsicPlayer = MvsicPlayer
    $scope.$on 'newTrack', (event, newTrack) ->
      $scope.currentTrack = newTrack
      $scope.$apply()
]
