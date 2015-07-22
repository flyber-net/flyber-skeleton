const mongojs = 
    require \mongojs
const config = 
    require \./../config.json
const recursive =
    require \recursive-readdir
const fs =
    require \fs

module.exports =
      mongojs config.db.connection-string

return
recursive \./app, [], (err, files) ->
    const load = (name)->
        module.exports[name] = module.exports.collection name
    const registered-tables = 
        files.filter(-> it.index-of( \mongo.server.js ) > -1)
         .map(fs.read-file-sync _, \utf-8)
         .map(eval)
         .reduce (a, b)-> a ++ b
         .for-each load
    


