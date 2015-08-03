angular.module('app').config(function($stateProvider, $urlRouterProvider){
  $urlRouterProvider.otherwise('/');
  return $stateProvider.state('root', {
    url: '/',
    views: {
      '': {
        templateUrl: 'app',
        controller: 'app'
      }
    }
  });
});