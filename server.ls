require(\xonom)
 .object \$config, require( \./../config.json )
 .run ($xonom)->
    #init router
    const express = require(\express)
    const router = express!
    $xonom.object \$router, router
    router.use express.static(require(\path).resolve(__dirname, \../client))
    router.use require(\body-parser).json!
    $xonom.object \$server, require(\http).create-server(router)
 .run "#__dirname/app/**/*.service.server.js"
 .run "#__dirname/app/**/*.route.server.js"
 .run "#__dirname/xonom.route.js"
 .run ($server)->
    #start server
    $server.listen do
      * process.env.PORT or 80
      * process.env.IP or '0.0.0.0'
      * ->
          const addr = $server.address!
          console.log 'Server listening at', addr.address + \: + addr.port