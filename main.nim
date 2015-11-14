import jester, asyncdispatch, htmlgen

routes:
    get "/":
        resp h1("Hello world")
    get "/ss":
        resp h2("Make me joke")
    get "/request":
        resp p(request.ip)

runForever()
