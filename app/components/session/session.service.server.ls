const p = 
    require \prelude-ls

const store-session-id= (req, resp, _session) ->
        req.session._id = _session
        resp.cookie \sessionId, _session

module.exports = ($xonom)->
    $xonom.service \$session, ($db, $h)->
        create: (_user, ip, callback)->
            const session = 
                _id: $h.genid!
                _user: _user  
                ip: ip
            $db.session.save session, -> 
              callback session
            console.log "Session is created for user with id:" + session._user
        store-session-id: store-session-id
        get-user-by-user-id : (_user, callback) ->
            $db.user.find-one do 
              * _id: _user ? ""
              * (err, user) ->
                 if err? then throw err
                 if user is null
                   callback do 
                      * err
                      * email: \guest@guest.com
                 else
                   callback do
                      * err
                      * user
        ensure-user-by-session-id : (req, callback) ->
            $db.session.find-one do
              * _id: req.cookies.session-id ? ""
                #ip: req.ip ? ""
              * (err, session) ->
                  if session isnt null
                    
                   #SERVER_SESSION_ID
                   req.session._id  = req.cookies.session-id
                  else 
                   req.session._id  = undefined
                   callback 'Session is not found'
        get-user-by-session-id: (req, callback)->
              $db.session.find-one do
                * _id: req.cookies.session-id ? ""
                  #ip: req.ip ? ""
                * (err, session)->
                    if session isnt null
                      module.exports.get-user-by-user-id session.user-id, callback
                    else 
                      callback 'Session is not found'
        get-sessions-by-user-id: (_user, callback) ->
              $db.session.find do 
                 * user-id: _user
                 * (err, sessions)->
                    sessions |> p.map (._id) 
                             |> callback
        remove: (session-id) ->
            $db.session.remove _id: session-id
            console.log "Session " + sessionId + " is removed"