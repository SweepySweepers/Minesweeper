import dom

proc consolelog(a: cstring) {.importc:"""
	function consolelog(a){
            return window.console.log(a)
        }""".}

proc log(s: string) =
    consolelog(cstring(s))

type
  WebSocket* {.importc.} = object of RootObj
    onopen*: proc (event: ref TEvent) {.nimcall.}
    onmessage*: proc (event: ref MessageEvent) {.nimcall.}
    send: proc(val: cstring)
  MessageEvent {.importc.} = object of RootObj
    data*: cstring

proc newWebsocket(): WebSocket {.importc:""" function() {
    return new WebSocket('ws://' + location.hostname + ':8080', ['minesweeper'])
    }"""}

log("Hello")

var ws: WebSocket = newWebsocket()
ws.onopen = proc(ev: ref TEvent) =
    log("connected")