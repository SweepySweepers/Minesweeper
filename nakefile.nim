import nake
import jester, asyncdispatch, browsers, closure_compiler # Stuff needed for JS target

let parallelBuild = "--parallelBuild:1"
let nimVerbose = "--verbosity:0"

let frontendModule = "frontend"
let wsModule = "field/wsserver"

when defined(Windows):
    const silenceStdout = "2>nul"
else:
    const silenceStdout = ">/dev/null"

if dirExists("nimcache"):
    direShell "rm", "-rf", "nimcache"

if dirExists(".git") or dirExists("Minesweeper.nimble"): # Install nimx
    direShell "nimble", "-y", "install", silenceStdout
#
#proc trySymLink(src, dest: string) =
#    try:
#        createSymlink(src, dest)
#    except:
#        discard
#
#proc createSDLIncludeLink(dir: string, preferInstalledSDL: bool) =
#    createDir dir
#    if preferInstalledSDL and dirExists("/usr/local/include/SDL2"):
#        trySymLink("/usr/local/include/SDL2", dir/"SDL2")
#    else:
#        trySymLink(sdlRoot/"include", dir/"SDL2")

proc runNim(arguments: varargs[string]) =
    var args = @[nimExe, "c", parallelBuild, "--stackTrace:on",
                "--lineTrace:on", nimVerbose, "-d:debug", "--opt:speed",
                "--passC:-g", "--threads:on", "--warning[LockLevel]:off"]
    args.add arguments
    args.add "main"
    direShell args

task defaultTask, "Build js and run server":
#    createSDLIncludeLink("nimcache", true)
    runTask "js"
    openDefaultBrowser "http://localhost:5000"
    runTask "run"

task "run", "Run our server":
    runNim "-r"

task "js", "Build frontend js files":
    direShell nimExe, "js", #"-o:/dev/null", "-d:posix",
              "--stackTrace:off", "--warning[LockLevel]:off", frontendModule
    copyFile("nimcache/" & frontendModule & ".js",
             "public/static/js/" & frontendModule & ".js")
    #closure_compiler.compileFileAndRewrite("nimcache/frontend.js",
    #                                       ADVANCED_OPTIMIZATIONS)
    #let settings = newSettings(staticDir = getCurrentDir())
    #routes:
    #    get "/": redirect "main.html"
    #openDefaultBrowser "http://localhost:5000"
    #runForever()

task "ws", "Run ws server":
    direShell nimExe, "c", "-r",
              "--lineTrace:on", nimVerbose, "-d:debug", "--opt:speed",
              #"--threads:on",  # Don't add this arg since it leads to
                                # Error: ':anonymous' is not GC-safe
              "--passC:-g", "--warning[LockLevel]:off", wsModule
