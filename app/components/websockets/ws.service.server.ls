const p = 
    require \prelude-ls
const send = (args, item) -->
    const model = args[1] |> JSON.stringify |> encodeURIComponent
    item.emit args[0], model
const send-all = ->
    clients |> p.map (.socket) |> p.each (send arguments)

const disconnect = (socket, context) -->
    const client =
        clients |> p.filter (-> it.socket.id is socket.id) 
                |> p.head
    if client
        session.get-user-by-session-id do
            * cookies: session-id: client._session
            * (err, user) ->
                  const index =
                    clients.index-of client
                  clients.splice index, 1
                  if user?
                    send-all do 
                       * \user-offline
                       * user._id
                 
module.exports = ($xonom)->
 $xonom.service \$ws, ($server, $db)->
     const io = require(\socket.io) $server
     io.on \connection, (socket) ->
          socket.emit do 
            * \is-authorised
          socket.on \authorise, (_session) ->
            clients.push do
                socket: socket
                _socked: socket.id
                _session: _session
            session.get-user-by-session-id do
                * cookies: session-id: _session
                * (err, user) ->
                    if user?
                      send-all do 
                         * \user-online
                         * user._id
          const wrap = 
             disconnect socket
          socket.on \deauthorise, wrap
          socket.on \disconnect, wrap
     online-users: (callback) ->
        $db.session
          .find do 
            * _id: $in: clients |> p.map (._session)
            * (err, res)->
                res |> p.map (.user-id) |> callback
     on: io.on
     send-all: send-all
     send: (_user, event, data) ->
        const notify = (socket)->
            send [event, data], socket
        session.get-sessions-by-user-id do
          * _user
          * (_sessions) ->
                const available = 
                    clients |> p.filter ( -> _sessions.index-of(it._session) > -1 )
                            |> p.map (.socket)
                available |> p.each notify
        