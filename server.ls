const http = 
  require \http
const path = 
  require \path
const express = 
  require \express
const fs = 
  require \fs

const body-parser = 
   require \body-parser



const router = 
  express!
  
const server = 
  http.create-server router


router.use express.static(path.resolve(__dirname, \../client))

router.use(body-parser.json!)

router.get new RegExp(/\/app\.js\?_\=[0-9]+/i), (req, resp)->
  resp.send ""


const recursive =
    require \recursive-readdir

do
  const xonom = 
    require(\xonom)
  xonom.object \$server, server
  xonom.object \$router, router
  xonom.object \$config, require( \./../config.json )
  recursive \./app, [], (err, files) ->
    const is-xonom = (it)->
      | it.index-of( \service.server.js ) > -1 => yes
      | _ => no
    const load = (path)->
      xonom.require(__dirname + \/ +  path)
    files.filter(is-xonom).for-each load
  console.log (__dirname + \/xonom.route.js)
  xonom.require(__dirname + \/xonom.route.js)


do

  recursive \./app, [], (err, files) ->
    const load = (path)->
      require(__dirname + \/ +  path)
    files.filter(-> it.index-of( \controller.server.js ) > -1).for-each load
    
server.listen do
  * process.env.PORT or 80
  * process.env.IP or '0.0.0.0'
  * ->
      const addr = server.address()
      console.log 'Server listening at', addr.address + \: + addr.port