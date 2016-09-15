angular.module('app').controller('app', function($scope, $flyber){
  return $flyber.app.test(function(err, data){
    return $scope.fromServer = data;
  });
});