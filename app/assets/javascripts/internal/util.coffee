# Utility functions used in the app, not necessarily for angular.


$(document).ready ->

  window.re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/

  # Beta signup
  setTimeout ->
    $('#sign-up #go').click (event) ->
      $button = $(event.target or event.srcElement)
      email = $('#sign-up input').val()

      if re.test($('#sign-up input').val())
        $button.text('Working...').removeClass('error saved').addClass('saving')

        $.ajax(
          url: '/beta/signup'
          type: 'POST'
          data:
            email: email
          success: (response) ->
            $button.text('Saved :)').removeClass('error saving').addClass('saved')
          error: (response) ->
            $button.text('Error :(').removeClass('saved saving').addClass('error')
        )
      else
        alert('Please use a valid email address')
  , 5000

