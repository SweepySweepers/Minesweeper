import math # for PI
import nimx.view
import nimx.image
import nimx.context
import nimx.animation
import nimx.window
import nimx.button

var field = [
    [0,0,0,0,0,0,1,0,0,0,0,0,0],
    [0,1,0,1,1,0,1,0,1,1,0,1,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,1,0,1,0,1,1,1,0,1,0,1,0],
    [0,0,0,1,0,0,1,0,0,1,0,0,0],
    [1,1,0,1,0,0,0,0,0,1,0,1,1],
    [0,0,0,0,0,1,1,1,0,0,0,0,0],
    [1,1,0,1,0,0,0,0,0,1,0,1,1],
    [0,0,0,0,0,0,1,0,0,0,0,0,0],
    [0,1,0,1,0,1,1,1,0,1,0,1,0],
    [0,0,0,1,0,0,1,0,0,1,0,0,0],
    [1,1,0,1,0,0,0,0,0,1,0,0,0],
    [0,0,0,0,0,1,1,1,0,0,0,0,0],
    [0,0,0,1,0,0,1,0,0,1,0,0,0],
    [0,1,1,1,1,0,1,0,1,1,1,1,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0],    
]

type AnimationSampleView = ref object of View
    animation: Animation
    
proc randomSwitch() =
    var x: int = random(13)
    var y: int = random(16)
    field[y][x] = 1-field[y][x]    
    
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


method draw(v: AnimationSampleView, r: Rect) =
    let c = currentContext()
    c.strokeWidth = 0
    let dd = v.bounds.height / 16
    for i in 0..<16:
        for j in 0..<13:
            if field[i][j] == 1:
                c.fillColor = newColor(0, 1, 0.3)
            else:
                c.fillColor = newColor(0, 0, 0)
            c.drawRect(newRect((j.float*dd).Coord, 
                               (i.float*dd).Coord, 
                               dd.Coord, 
                               dd.Coord))
    # c.drawRoundedRect(newRect(0, 0, 100, 200), 20)

method viewWillMoveToWindow*(v: AnimationSampleView, w: Window) =
    if w.isNil:
        v.animation.cancel()
    else:
        w.addAnimation(v.animation)


var fieldSample* = AnimationSampleView.new(newRect(0, 0, 160, 160))