# Imports
#import sockets, asyncio, jester, websockets
import websockets
#import settings, utilities, models

# Import controllers
#import logincontroller,
#       homecontroller,
#       servicecontroller


# Fields
#var ws: TWebSocketServer


# Procedures
#proc close*() {.noconv.} =
#    ws.close()
    #jester.close()


#proc initialize*(dispatch: PDispatcher) {.closure, gcsafe.} =

    # Instantiate a websocket server
    #ws = websockets.open(port = TPort(settings.serviceport), isAsync = true)
    #ws = open(port = TPort(8080), isAsync = true) {.closure, gcsafe.}

    # Bind websocket server events
    #servicecontroller.initialize(ws)

    # Register web service with dispatcher
    #dispatch.register(ws)

    # Register jester with dispatcher
    #jester.register(dispatch, port = TPort(settings.webPort), http = settings.useHTTP)
    #jester.register(dispatch, port = TPort(5000), http = true)

    # Register a quit procedure
    #addQuitProc(close)
