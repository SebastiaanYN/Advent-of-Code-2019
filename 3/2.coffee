input = require 'fs'
  .readFileSync 'input.txt'
  .toString()
  .split '\n'
  .map (x) => x.split ','

getPath = (moves) ->
  locs = new Set
  steps = new Map

  x = 0
  y = 0
  step = 0

  save = (x, y) ->
    loc = "#{x}:#{y}"
    locs.add loc
    steps.set loc, ++step

  moves.forEach (move) =>
    amount = Number move.slice(1)

    switch move[0]
      when 'U' then while amount-- > 0
        save x, --y
      when 'R' then while amount-- > 0
        save ++x, y
      when 'D' then while amount-- > 0
        save x, ++y
      when 'L' then while amount-- > 0
        save --x, y

  return { locs, steps }

findIntersects = (one, two) -> [...one].filter (loc) => two.has loc

findShortestSteps = (intersects, stepsOne, stepsTwo) ->
  shortest = Infinity

  intersects.forEach (inter) =>
    steps = (stepsOne.get inter) + stepsTwo.get inter
    shortest = steps if steps < shortest

  return shortest

pathOne = getPath input[0]
pathTwo = getPath input[1]
intersects = findIntersects pathOne.locs, pathTwo.locs
shortest = findShortestSteps intersects, pathOne.steps, pathTwo.steps
console.log shortest
