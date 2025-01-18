
randRange = (min, max) ->
    Math.random() * (max - min) + min

randIntRange = (min, max) ->
    randRange(min, max)|0

distance = (x1, y1, x2, y2) ->
    Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2))

export {
    randRange, randIntRange, distance
}
