angular.module('app').run(['$templateCache',function($templateCache) {   'use strict';

  $templateCache.put('app',
    "<div class=\"app\">\n" +
    "  <h1>App is working!!!</h1>\n" +
    "  <p>Jade + SASS + Livescript + Grunt + Xonom + AngularJS</p>\n" +
    "  <hr/>\n" +
    "  <h2>Tests:</h2>\n" +
    "  <ul>\n" +
    "    <li>Data from server: {{fromServer}}</li>\n" +
    "  </ul>\n" +
    "</div>"
  );
 }])