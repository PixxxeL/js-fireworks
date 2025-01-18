import { distance, randIntRange } from './utils.coffee'
import store from './store.coffee'


class Firework

    constructor: (x1, y1, x2, y2, ctx, hue) ->
        @x = x1
        @y = y1
        @sx = x1
        @sy = y1
        @dx = x2
        @dy = y2
        @ctx = ctx
        @hue = hue
        @totalDistance = distance @sx, @sy, @dx, @dy
        @currentDistance = 0
        @coordinates = []
        @coordinateCount = 3
        @angle = Math.atan2 @dy - @sy, @dx - @sx
        @speed = store.fireworkSpeed
        @acceleration = store.fireworkAcceleration
        @brightness = randIntRange 50, 70
        for n in [0...@coordinateCount]
            @coordinates.push [@x, @y]

    update: (callback) ->
        @coordinates.pop()
        @coordinates.unshift [@x, @y]
        @speed *= @acceleration
        vx = Math.cos(@angle) * @speed
        vy = Math.sin(@angle) * @speed
        @currentDistance = distance @sx, @sy, @x + vx, @y + vy
        if @currentDistance >= @totalDistance
            callback @dx, @dy, @hue
        else
            @x += vx
            @y += vy

    draw: ->
        last = @coordinates.length - 1
        @ctx.beginPath()
        @ctx.moveTo @coordinates[last][0], @coordinates[last][1]
        @ctx.lineTo @x, @y
        @ctx.strokeStyle = "hsl(#{@hue}, 100%, #{@brightness}%)"
        @ctx.stroke()


export default Firework
