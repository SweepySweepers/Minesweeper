import nimx.view
import nimx.system_logger
import nimx.app
import nimx.scroll_view
import nimx.table_view
import nimx.text_field
import sequtils
import intsets

import sample01

when defined js:
    import nimx.js_canvas_window
    type PlatformWindow = JSCanvasWindow
else:
    import nimx.sdl_window
    type PlatformWindow = SdlWindow

const isMobile = defined(ios) or defined(android)

template c*(a: string) = discard

var currentView : View = nil

proc startApplication() =
    var mainWindow : PlatformWindow
    mainWindow.new()

    when isMobile:
        mainWindow.initFullscreen()
    else:
        mainWindow.init(newRect(40, 40, 800, 600))

    mainWindow.title = "NimX Sample"

    
    currentView = fieldSample
    currentView.setFrame(newRect(140, 20, 
        mainWindow.bounds.width - 160, mainWindow.bounds.height-40))
    currentView.autoresizingMask = { afFlexibleWidth, afFlexibleHeight }
    mainWindow.addSubview(currentView)

    # let tableView = newTableView(newRect(20, 20, 100, mainWindow.bounds.height - 40))
    # tableView.autoresizingMask = { afFlexibleMaxX, afFlexibleHeight }
    # mainWindow.addSubview(newScrollView(tableView))

    # tableView.numberOfRows = proc: int = allSamples.len
    # tableView.createCell = proc (): TableViewCell =
    #     result = newTableViewCell(newLabel(newRect(0, 0, 100, 20)))
    # tableView.configureCell = proc (c: TableViewCell) =
    #     TextField(c.subviews[0]).text = allSamples[c.row].name
    # tableView.onSelectionChange = proc() =
    #     if not currentView.isNil: currentView.removeFromSuperview()
    #     let selectedRows = toSeq(items(tableVi&$w.selectedRows))
    #     if selectedRows.len > 0:
    #         let firstSelectedRow = selectedRows[0]
    #         currentView = allSamples[firstSelectedRow].view
    #         currentView.setFrame(newRect(140, 20, mainWindow.bounds.width - 160, mainWindow.bounds.height - 40))
    #         currentView.autoresizingMask = { afFlexibleWidth, afFlexibleHeight }
    #         mainWindow.addSubview(currentView)

    # tableView.reloadData()
    # tableView.selectRow(0)


when defined js:
    import dom
    window.onload = proc (e: ref TEvent) =
        startApplication()
        startAnimation()
    window.onmousedown = proc (e: ref TEvent) =
        if e.ctrlKey:
            switchPlaying(fieldSample)
        else:
            mousedown(fieldSample, e.clientX.Coord, e.clientY.Coord)
            # echo "("& $e.clientX & ", " & $e.clientY &")"
            
else:
    try:
        startApplication()
        runUntilQuit()
    except:
        logi "Exception caught: ", getCurrentExceptionMsg()
        logi getCurrentException().getStackTrace()
