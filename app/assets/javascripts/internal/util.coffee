# Utility functions used in the app, not necessarily for angular.


$(document).ready ->

  window.re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/

  # Beta signup
  setTimeout ->
    $('#beta').submit (event) ->
      $button = $('#beta #confirm')
      firstName = $('#beta #first-name').val()
      lastName = $('#beta #last-name').val()
      email = $('#beta #email').val()

      if re.test(email)
        $button.removeClass('error saved').addClass('saving')
        $('#beta-loader').css(visibility: 'visible')

        $.ajax(
          url: '/beta/signup'
          type: 'POST'
          data:
            first_name: firstName
            last_name: lastName
            email: email
          success: (response) ->
            $('#beta-loader').css(visibility: 'hidden')
            $button.val('Signed up :)').removeClass('error saving').addClass('saved')
          error: (response) ->
            $('#beta-loader').css(visibility: 'hidden')
            $button.val('Error :(').removeClass('saved saving').addClass('error')
        )
      else
        alert('Please use a valid email address')

    $('#learn-more').click (event) ->
      $('html, body').animate(
        scrollTop: $('#message').offset().top
      , 500)

    $('#beta-link').click (event) ->
      $('html, body').animate(
        scrollTop: $('#sign-up').offset().top
      , 500)

  , 2000


