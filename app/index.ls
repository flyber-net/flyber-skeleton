#document.write('<script src="//' + (location.hostname || \localhost) + ':35729/livereload.js?snipver=1"></script>')

angular.module do
    * \app
    * * \ui.router
      * \xonom
      * \ngMaterial
      ...

angular
  .module \app
  .config ($location-provider, $md-theming-provider)->
    #$location-provider.html5Mode(yes).hashPrefix('!')
    $md-theming-provider
      .theme \default
      .primary-palette \teal

    
