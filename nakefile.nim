import nake
import jester, asyncdispatch, browsers, closure_compiler # Stuff needed for JS target
#import jester, browsers, closure_compiler # Stuff needed for JS target

let parallelBuild = "--parallelBuild:1"
let nimVerbose = "--verbosity:0"

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
    var args = @[nimExe, "c", "--noMain", parallelBuild, "--stackTrace:on",
                "--lineTrace:on", nimVerbose, "-d:debug", "--opt:speed",
                "--passC:-g", "--threads:on", "--warning[LockLevel]:off"]
    args.add arguments
    args.add "main"
    direShell args

task defaultTask, "Build and run":
#    createSDLIncludeLink("nimcache", true)
    discard runNim

task "js", "Create Javascript version.":
    direShell nimExe, "js",
            "--stackTrace:off", "--warning[LockLevel]:off","main"
    closure_compiler.compileFileAndRewrite("nimcache/main.js", ADVANCED_OPTIMIZATIONS)
    let settings = newSettings(staticDir = getCurrentDir())
    routes:
        get "/": redirect "main.html"
    openDefaultBrowser "http://localhost:5000"
    runForever()
