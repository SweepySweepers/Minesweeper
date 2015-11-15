# Imports
import sockets, asyncio, jester, websockets, asyncdispatch
#import settings, utilities, models

# Import controllers
#import logincontroller,
#       homecontroller,
#       servicecontroller
import servicecontroller


# Fields
var ws: WebSocketServer


# Procedures
proc close*() {.noconv.} =
    ws.close()
    #jester.close()


proc initialize*(dispatch: Dispatcher) =

    # Instantiate a websocket server
    #ws = websockets.open(port = Port(settings.serviceport), isAsync = true)
    ws = open(port = sockets.Port(8080), isAsync = true)

    # Bind websocket server events
    servicecontroller.initialize(ws)

    # Register web service with dispatcher
    dispatch.register(ws)

    # Register jester with dispatcher
    #jester.register(dispatch, port = Port(settings.webPort), http = settings.useHTTP)
    #jester.register(dispatch, port = Port(5000), http = true)

    # Register a quit procedure
    addQuitProc(close)


let dispatch = asyncio.newDispatcher()


# Procedures
proc updateLoop() =
    while dispatch.poll(): discard


proc exit() {.noconv.} =
    quit(QuitSuccess)

#initialize dispatch




######################################
# Main entry point into iRC Familiar #
######################################
block main:

    # Initialize log
    #log.initialize()

    # Initialize IRC
    #manager.initialize(dispatch)

    # Initialize Web Service
    initialize(dispatch)

    # Spint dispatcher
    updateLoop()

    # Set up CTRL+C sigint
    setControlCHook(exit)
