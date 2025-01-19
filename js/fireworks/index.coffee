import Firework from './firework.coffee'
import Particle from './particle.coffee'
import store from './store.coffee'
import { randRange, randIntRange } from './utils.coffee'


class Fireworks

    constructor: (options) ->
        @canvas = document.getElementById options.id or 'fireworks-canvas'
        @ctx = if @canvas.getContext then @canvas.getContext '2d' else null
        @width = @canvas.width
        @height = @canvas.height
        @hue = options.hue or 120
        @isRunning = false
        @fireworks = []
        @particles = []
        @particleCount = options.particleCount or 50
        @tick = 0
        @delay = options.delay or 30
        @minDelay = options.minDelay or 30
        @maxDelay = options.maxDelay or 90
        @boundaries = options.boundaries or {
            top: 50
            bottom: @height * .5
            left: 50
            right: @width - 50
        }
        storeProps = [
            'fireworkSpeed'
            'fireworkAcceleration'
            'particleFriction'
            'particleGravity'
        ]
        for prop in storeProps
            if options[prop]
                store[prop] = options[prop]
        @render.bind @

    start: ->
        @isRunning = true
        @fireworks = []
        @particles = []
        @render()

    stop: ->
        @isRunning = false
        @clear()

    clear: ->
        if not @ctx
            return
        @ctx.globalCompositeOperation = 'source-over'
        @ctx.fillStyle = 'rgba(0, 0, 0, 0.5)'
        @ctx.fillRect 0, 0, @width, @height

    render: ->
        if not @ctx or not @isRunning
            return
        window.requestAnimationFrame @render.bind(@)
        self = @
        @hue += .5
        @ctx.globalCompositeOperation = 'destination-out'
        @ctx.fillStyle = 'rgba(0, 0, 0, 0.5)'
        @ctx.fillRect 0, 0, @width, @height
        @ctx.globalCompositeOperation = 'lighter'
        tmp = @fireworks.length
        # render fireworks
        while tmp--
            @fireworks[tmp].draw()
            @fireworks[tmp].update (x, y, hue) ->
                count = self.particleCount
                while count--
                    self.particles.push new Particle(x, y, self.ctx, hue)
                self.fireworks.splice tmp, 1
        # render particles
        tmp = @particles.length
        while tmp--
            @particles[tmp].draw()
            @particles[tmp].update ->
                self.particles.splice tmp, 1
        # spawn firework
        if @tick == @delay
            @fireworks.push new Firework(
                @width * .5,
                @height,
                randIntRange(@boundaries.left, @boundaries.right),
                randIntRange(@boundaries.top, @boundaries.bottom),
                @ctx,
                @hue
            )
            @delay = randIntRange @minDelay, @maxDelay
            @tick = 0
        @tick++


export default Fireworks
