import Fireworks from './fireworks/index.coffee'
import Explosion from './fireworks/explosion.coffee'
import { randIntRange } from './fireworks/utils.coffee'

window.onload = ->
    firework = new Fireworks {
        id: 'fireworks-canvas'
        hue: 120
        particleCount: 100
        delay: 0
        minDelay: 20
        maxDelay: 40
        boundaries: {
            top: 50
            bottom: 240
            left: 50
            right: 590
        }
        fireworkSpeed: 2
        fireworkAcceleration: 1.05
        particleFriction: .95
        particleGravity: 1.5
    }
    firework.start()
    explosion = new Explosion 400, 300, {
        id: 'fireworks-canvas'
        particleFriction: .92
        particleGravity: 0
    }
    explosion.canvas.addEventListener 'click', (e) ->
        explosion.hue = randIntRange 0, 255
        explosion.reset e.clientX - e.target.offsetLeft, e.clientY - e.target.offsetTop
        explosion.run()
    explosion.run()
        
