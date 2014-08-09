# Utility functions used in the app

_.templateSettings = interpolate: /\{\{(.+?)\}\}/g

window.adjustHeight = (selector) ->
  $(selector).css(height: $(window).height()- 30)
