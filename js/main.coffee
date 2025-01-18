import Fireworks from './fireworks/index.coffee'

window.onload = ->
    firework = new Fireworks {
        id: 'fireworks-canvas'
        hue: 120
        particleCount: 50
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
