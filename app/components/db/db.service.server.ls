const mongojs = 
    require \mongojs
const recursive =
    require \recursive-readdir
const fs =
    require \fs

module.exports = ($xonom)->
    $xonom.service \$db, ($config)->
      const db = mongojs $config.db.connection-string
      recursive \./, [], (err, files) ->
            const load = (name)->
                db[name] = db.collection name
            const registered-tables = 
                files.filter(-> it.index-of( \mongo.server.js ) > -1)
                 .map(fs.read-file-sync _, \utf-8)
                 .map(eval)
                 .reduce (a, b)-> a ++ b
                 .for-each load
      db
    


