angular
  .module \app
  .controller do
      * \app
      * ($scope, $xonom)->
          $xonom.app.test (err, data)->
            $scope.from-server = data