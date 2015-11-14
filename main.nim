import os
import jester, asyncdispatch, htmlgen

#let settings = newSettings(staticDir = getCurrentDir() & "/static")

routes:
    get "/":
        resp h1("Hello world")
    get "/ss":
        resp h2("Make me joke")
    get "/request":
        resp p(request.ip)

runForever()
