# Utility functions used in the app, not necessarily for angular.


# Set height of $elem to be window's height offset by 10%
window._pane = ($elem) ->
  $elem.height(Math.round($(window).height()) * 0.9)

