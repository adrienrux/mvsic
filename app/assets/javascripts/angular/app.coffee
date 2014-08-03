window.app = angular.module('app', [
  'ngResource',
  'ngRoute',
  'ui.bootstrap',
  'localStorageModule'
]);

# Makes turbolinks work with Angular
$(document).on 'page:load', ->
  angular.bootstrap($('#mvsic-app[ng-app]'), ['app'])
