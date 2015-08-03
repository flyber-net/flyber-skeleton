angular.module('app').controller('app', function($scope, $xonom){
  return $xonom.app.test(function(err, data){
    return $scope.fromServer = data;
  });
});