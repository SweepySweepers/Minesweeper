include "naketools"

proc runNimMain(arguments: varargs[string]) =
    var args = @[nimExe, "c", parallelBuild, "--stackTrace:on",
                "--lineTrace:on", nimVerbose, "-d:debug", "--opt:speed",
                "--passC:-g", "--threads:on", "--warning[LockLevel]:off"]
    args.add arguments
    args.add "main"
    direShell args

task "run", "Run our server":
    runNimMain "-r"
    #runNim "-r"
