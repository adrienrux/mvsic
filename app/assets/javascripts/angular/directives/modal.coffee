app.directive 'modal', ['$http', ($http) ->
  restrict: 'A'
  scope:
    show: '='
  replace: true
  link: (scope, element, attrs) ->
    window.re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    scope.buttonValue = 'Sign up for beta'
    scope.hideModal = ->
      scope.show = false
    scope.signup = ->
      $button = $('#confirm')
      if re.test(scope.email)
        scope.saving = true
        $('#beta-loader').css(visibility: 'visible')
        $http.post('/beta/signup.json',
          first_name: scope.firstName
          last_name: scope.lastName
          email: scope.email
        ).success((response) ->
          $('#beta-loader').css(visibility: 'hidden')
          scope.saving = false
          scope.error = false
          scope.saved = true
          scope.buttonValue = 'Signed Up :)'
          scope.$emit('signUpSuccess', scope.email)
        ).error((response) ->
          $('#beta-loader').css(visibility: 'hidden')
          scope.saving = false
          scope.saved = false
          scope.error = true
          scope.buttonValue = 'Error :('
        )
      else
        alert('Please use a valid email address')
  template: "
    <div class='ng-modal'>
      <div class='ng-modal-overlay' ng-class=\"{'show': show}\" ng-click='hideModal()'></div>
      <div class='ng-modal-dialog' ng-class=\"{'show': show}\">
        <div class='ng-modal-dialog-content'>
          <form id='sign-up-modal' ng-submit='signup()'>
            <div class='col half'>
              <input id='first-name' type='text' placeholder='Jono' size='30' ng-model='firstName'></input>
              <label for='first-name'>First name</label>
            </div>
            <div class='col half'>
              <input id='last-name' type='text' placeholder='Grant' size='30' ng-model='lastName'></input>
              <label for='last-name'>Last name</label>
            </div>
            <div class='col'>
              <input id='email' type='email' placeholder='jono@icloud.com' ng-model='email'></input>
              <label for='email'>Email address</label>
            </div>
            <div class='col'>
              <input id='confirm' class='button' type='submit' value='{{buttonValue}}' ng-class=\"{'saving': saving, 'saved': saved, 'error': error}\"></input>
            </div>
            <div id='beta-loader' class='loader'></div>
          </form>
        </div>
      </div>
    </div>
  "
]