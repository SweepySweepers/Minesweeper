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
    (0,[0, 0, 0]),
    (1,[1, 0, 0]),
    (2,[0, 1, 0]),
    (3,[0, 0, 1])   
]

var field : array[0..(FIELD_HEIGHT-1),array[0..(FIELD_WIDTH-1), int]]

type AnimationSampleView = ref object of View
    animation: Animation
    isPlaying*: bool

proc randomSwitch() =
    var x: int = random(FIELD_WIDTH)
    var y: int = random(FIELD_HEIGHT)
    field[y][x] = 1-field[y][x]
    
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
        echo "Ogo"

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

method draw(v: AnimationSampleView, r: Rect) =
    let c = currentContext()
    c.strokeWidth = 0
    let dd = min(v.bounds.height / FIELD_HEIGHT, v.bounds.width / FIELD_WIDTH)
    for i in 0..(FIELD_HEIGHT-1):
        for j in 0..(FIELD_WIDTH-1):
            if field[i][j] == 1:
                c.fillColor = newColor(0, 1, 0.3)
            else:
                c.fillColor = newColor(0, 0, 0)
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