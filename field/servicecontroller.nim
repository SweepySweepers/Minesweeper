# Imports
import websockets, cookies, marshal, strutils
#import ../ircclient/manager, ../ircclient/log
#import utilities, settings

from times import getTime
#from logincontroller import is_authenticated


# Types
type TClientMessage = object
    target: string
    server: string
    message: string


# Fields
var service*: WebSocketServer


# Procedures
proc onBeforeConnect(ws: WebSocketServer, client: WebSocket, headers: StringTableRef): bool = true
    # Retrieve request's cookies
    #let c    = cookies.parseCookies(headers["Cookie"])
    #let auth = c["AUTH"]

    # Validate user is logged in
    #return auth != "" and
    #       logincontroller.is_authenticated(auth)


proc onMessage(ws: WebSocketServer, client: WebSocket, message: WebSocketMessage) =
    # Save client message & send to IRC manager
    var e       = to[TClientMessage](message.data)
    var message = e.message
    echo message

    #if message.toLower.startsWith("/me "):
    #    message = message.encodeAction()

    #manager.sendMessage(message, e.server, e.target)

    # Log message if it is not a command
    #if message.find('/') != 0:
    #    log.append TIRCEvent(
    #        typ:        EvMsg,
    #        cmd:        MPrivMsg,
    #        nick:       settings.ircNick,
    #        servername: e.server,
    #        origin:     e.target,
    #        params:     @[e.target, message],
    #        timestamp:  getTime()
    #    )


proc onConnected(ws: WebSocketServer, client: WebSocket, message: WebSocketMessage) =
    echo "Connected"
    #echo to[TClientMessage](message.data)
    ws.send(client, "Hi, there!")


proc onDisconnected(ws: WebSocketServer, client: WebSocket, message: WebSocketMessage) = discard


proc initialize*(ws: var WebSocketServer) =
    # Bind websocket server events
    ws.onBeforeConnect = onBeforeConnect
    ws.onConnected     = onConnected
    ws.onMessage       = onMessage
    ws.onDisconnected  = onDisconnected

    service = ws

    # Bind websocket to IRC log
    #log.setIRCEventCallback(proc (e: string) =
    #    for client in service.clients:
    #        service.send(client, e)
    #)
