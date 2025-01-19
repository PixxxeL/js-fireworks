import Particle from './particle.coffee'
import store from './store.coffee'


class Explosion

    constructor: (x, y, options) ->
        @particleCount = options.particleCount or 50
        @hue = options.hue or 70
        @canvas = document.getElementById options.id or 'fireworks-canvas'
        @width = @canvas.width
        @height = @canvas.height
        @ctx = if @canvas.getContext then @canvas.getContext '2d' else null
        console.log options
        for prop in ['particleFriction', 'particleGravity']
            if options[prop] != undefined
                store[prop] = options[prop]
        console.log store
        @reset x, y

    reset: (x, y) ->
        @particles = []
        tmp = @particleCount
        while tmp--
            @particles.push new Particle(x, y, @ctx, @hue)

    run: ->
        if not @ctx or not @particles.length
            return
        @ctx.save()
        @ctx.globalCompositeOperation = 'destination-out'
        @ctx.fillStyle = 'rgba(0, 0, 0, 0.5)'
        @ctx.fillRect 0, 0, @width, @height
        @ctx.globalCompositeOperation = 'lighter'
        self = @
        tmp = @particles.length
        while tmp--
            @particles[tmp].draw()
            @particles[tmp].update ->
                self.particles.splice tmp, 1
        @ctx.restore()
        window.requestAnimationFrame @run.bind(@)


export default Explosion
