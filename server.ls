require \xonom
 .object \$config, require( \./../config.json )
 .run ($xonom)->
    #init router
    express = require \express
    router = express!
    $xonom.object \$router, router
    router.use express.static(require(\path).resolve(__dirname, \../client))
    router.use require(\body-parser).json!
    $xonom.object \$server, require(\http).create-server(router)
 .run "#__dirname/app/**/*.service.server.js"
 .run "#__dirname/app/**/*.route.server.js"
 .run "#__dirname/xonom.route.js"
 .run ($server, $config)->
    #start server
    $server.listen do
      * process.env.PORT or $config.server.port
      * process.env.IP or $config.server.ip
      * ->
          addr = $server.address!
          console.log 'Server listening at', addr.address + \: + addr.port