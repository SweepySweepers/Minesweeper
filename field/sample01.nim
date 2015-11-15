import math # for PI
import nimx.view
import nimx.image
import nimx.context
import nimx.animation
import nimx.window
import nimx.button

# var field = [
#     [0,0,0,0,0,0,1,0,0,0,0,0,0],
#     [0,1,0,1,1,0,1,0,1,1,0,1,0],
#     [0,0,0,0,0,0,0,0,0,0,0,0,0],
#     [0,1,0,1,0,1,1,1,0,1,0,1,0],
#     [0,0,0,1,0,0,1,0,0,1,0,0,0],
#     [1,1,0,1,0,0,0,0,0,1,0,1,1],
#     [0,0,0,0,0,1,1,1,0,0,0,0,0],
#     [1,1,0,1,0,0,0,0,0,1,0,1,1],
#     [0,0,0,0,0,0,1,0,0,0,0,0,0],
#     [0,1,0,1,0,1,1,1,0,1,0,1,0],
#     [0,0,0,1,0,0,1,0,0,1,0,0,0],
#     [1,1,0,1,0,0,0,0,0,1,0,0,0],
#     [0,0,0,0,0,1,1,1,0,0,0,0,0],
#     [0,0,0,1,0,0,1,0,0,1,0,0,0],
#     [0,1,1,1,1,0,1,0,1,1,1,1,0],
#     [0,0,0,0,0,0,0,0,0,0,0,0,0],    
# ]

const FIELD_WIDTH = 30
const FIELD_HEIGHT = 30
const FIELD_COLORS = [
    newColor(0, 0, 0),
    newColor(1, 0, 0),
    newColor(0, 1, 0),
    newColor(0, 0, 1)   
]

var field : array[0..(FIELD_HEIGHT-1),array[0..(FIELD_WIDTH-1), int]]

type AnimationSampleView = ref object of View
    animation: Animation
    isPlaying*: bool



proc switchCell(x, y: int) = 
    if field[y][x] > 0: 
        field[y][x] = 0 
    else: 
        field[y][x] = 1 

proc randomSwitch() =
    # var x: int = random(FIELD_WIDTH)
    # var y: int = random(FIELD_HEIGHT)
    # field[y][x] = 1-field[y][x]
    
    proc myMax(a, b: int): int = 
        if a > b: 
            return a 
        else: 
            return b
    proc myMin(a, b: int): int = 
        if a < b: 
            return a 
        else: 
            return b 

    proc toRightX(x: int): int = 
        if x == -1:
            return FIELD_WIDTH-1
        else:
            if x == FIELD_WIDTH:
                return 0
            else:
                return x
    proc toRightY(y: int): int = 
        if y == -1:
            return FIELD_HEIGHT-1
        else:
            if y == FIELD_HEIGHT:
                return 0
            else:
                return y
    
    var nfield: array[0..(FIELD_HEIGHT-1), array[0..(FIELD_WIDTH-1), int]]
    for i in 0..(FIELD_HEIGHT-1):
        for j in 0..(FIELD_WIDTH-1):
            var zh: int = 0
            for i1 in (i-1)..(i+1):
                for j1 in (j-1)..(j+1):
                    if i != i1 or j != j1:
                        if (field[toRightY(i1)][toRightX(j1)] > 0):
                            zh += 1
            if (field[i][j] > 0):
                if (zh < 2 or zh > 3):
                    nfield[i][j] = 0
                else:
                    nfield[i][j] = field[i][j]
            else:
                if (zh == 3):
                    nfield[i][j] = random(3)+1
                else:
                    nfield[i][j] = 0
    for i in 0..(FIELD_HEIGHT-1):
        for j in 0..(FIELD_WIDTH-1):
            field[i][j] = nfield[i][j]
    
method startAnimation(v: AnimationSampleView) {.base.} =
    v.window.addAnimation(v.animation)    

method init*(v: AnimationSampleView, r: Rect) = 
    procCall v.View.init(r)
    v.animation = newAnimation()
    v.animation.timingFunction = bezierTimingFunction(0.53,-0.53,0.38,1.52)
    v.animation.onAnimate = proc(p: float) =
        randomSwitch()
    v.animation.loopDuration = 2.0
    v.animation.onComplete do():
        echo ""
        # echo "Ogo"

    v.animation.continueUntilEndOfLoopOnCancel = true
    # let startStopButton = newButton(newRect(20, 20, 30, 30))
    # startStopButton.title = "Stop"
    # startStopButton.onAction do():
    #     if v.animation.finished:
    #         startAnimation(v)
    #     else:
    #         v.animation.cancel()

method stopPlaying*(v: AnimationSampleView) {.base.} =
    v.isPlaying = false
    v.animation.cancel()

method isPlaying*(v: AnimationSampleView): bool {.base.} = v.isPlaying

method switchPlaying*(v: AnimationSampleView) {.base.} =
    v.isPlaying = not v.isPlaying
    if v.isPlaying:
        startAnimation(v)
    else:
        cancel(v.animation)

method mousedown*(v: AnimationSampleView; x, y: Coord) =
    let dd = min(v.bounds.height / FIELD_HEIGHT, v.bounds.width / FIELD_WIDTH)
    let cx = ((x-145) / dd).int
    let cy = ((y-25) / dd).int
    # echo($(v.bounds.x.int) & ", " & $(v.bounds.y.int))
    # echo($cx & ", " & $cy)
    if (cx < 0 or cx >= FIELD_WIDTH):
        return
    if (cy < 0 or cy >= FIELD_HEIGHT):
        return

    switchCell(cx, cy)
    draw(v, newRect(0,0,v.bounds.width,v.bounds.height))


method draw(v: AnimationSampleView, r: Rect) =
    let c = currentContext()
    
    let dd = min(v.bounds.height / FIELD_HEIGHT, v.bounds.width / FIELD_WIDTH)
    c.strokeWidth = 5
    if v.isPlaying:
        c.strokeColor = newColor(0.2, 0.7, 0.3)
    else:
        c.strokeColor = newColor(0.7, 0.2, 0.3)
    c.drawRect(newRect(-5, -5, dd*FIELD_WIDTH+10, dd*FIELD_HEIGHT+10))
    c.strokeWidth = 0
    for i in 0..(FIELD_HEIGHT-1):
        for j in 0..(FIELD_WIDTH-1):
            let color = FIELD_COLORS[field[i][j]] 
            c.fillColor = color
            c.drawRoundedRect(newRect((j.float*dd).Coord, 
                               (i.float*dd).Coord, 
                               dd.Coord, 
                               dd.Coord), 4)
    # c.drawRoundedRect(newRect(0, 0, 100, 200), 20)

method viewWillMoveToWindow*(v: AnimationSampleView, w: Window) =
    if w.isNil:
        v.animation.cancel()
    else:
        if isPlaying(v):
            startAnimation(v)


var fieldSample* = AnimationSampleView.new(newRect(0, 0, 160, 160))