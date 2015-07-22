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

GLOBAL.import = (name)->
    require "./server-#{name}.js"
  
router.use express.static(path.resolve(__dirname, \../client))

router.use(body-parser.json!)

router.get new RegExp(/\/app\.js\?_\=[0-9]+/i), (req, resp)->
  resp.send ""

require(\./xonom.route.js) router

const recursive =
    require \recursive-readdir



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