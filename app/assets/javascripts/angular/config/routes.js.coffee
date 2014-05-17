mvsic.config ($routeProvider, $logProvider, $locationProvider, $httpProvider) ->
  # Use History API to push new URLs
  $locationProvider.html5Mode true
  $logProvider.debugEnabled(false)

  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken

  $routeProvider
    .when '/',
      controller: 'LandingController'
      templateUrl: '../assets/landing.html'
    .otherwise redirectTo: '/'
