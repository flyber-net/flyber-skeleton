require(\xonom)
 .object \$config, require( \./../config.json )
 .run ($xonom)->
    #init router
    const express = require(\express)
    const router = express!
    const path = 
       require \path
    const body-parser = 
       require \body-parser
    $xonom.object \$router, router
    router.use express.static(path.resolve(__dirname, \../client))
    router.use body-parser.json!
    const http = 
       require \http
    const server = 
       http.create-server(router)
    $xonom.object \$server, server
 .run ($xonom)->
    #load all services
    require(\recursive-readdir) \./app, [], (err, files) ->
      files
        .filter (it)-> it.index-of( \service.server.js ) > -1
        .for-each (it)-> $xonom.require(__dirname + \/ +  it)
 .run ($xonom)->
    #load generated rautes
    $xonom.require(__dirname + \/xonom.route.js)
 .run ($server)->
    #start server
    $server.listen do
      * process.env.PORT or 80
      * process.env.IP or '0.0.0.0'
      * ->
          const addr = $server.address!
          console.log 'Server listening at', addr.address + \: + addr.port