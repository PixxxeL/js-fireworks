import { randRange, randIntRange } from './utils.coffee'
import store from './store.coffee'


PI2 = Math.PI * 2

class Particle

    constructor: (@x, @y, @ctx, @hue) ->
        @coordinates = []
        @coordinateCount = 5
        @angle = randIntRange 0, PI2
        @speed = randIntRange 1, 10
        @hue = randIntRange @hue - 20, @hue + 20
        @friction = store.particleFriction
        @gravity = store.particleGravity
        @brightness = randIntRange 50, 80
        @alpha = 1
        @decay = randRange .015, .03
        for n in [0...@coordinateCount]
            @coordinates.push [@x, @y]

    update: (callback) ->
        @coordinates.pop()
        @coordinates.unshift [@x, @y]
        @speed *= @friction
        @x += Math.cos(@angle) * @speed
        @y += Math.sin(@angle) * @speed + @gravity
        @alpha -= @decay
        if @alpha <= @decay
            callback()

    draw: ->
        last = @coordinates.length - 1
        @ctx.beginPath()
        @ctx.moveTo @coordinates[last][0], @coordinates[last][1]
        @ctx.lineTo @x, @y
        @ctx.strokeStyle = "hsla(#{@hue}, 100%, #{@brightness}%, #{@alpha})"
        @ctx.stroke()

export default Particle
