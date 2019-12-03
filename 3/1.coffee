input = require 'fs'
  .readFileSync 'input.txt'
  .toString()
  .split '\n'
  .map (x) => x.split ','

getLocations = (moves) ->
  locs = new Set

  x = 0
  y = 0

  save = (x, y) -> locs.add "#{x}:#{y}"

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

  return locs

findIntersects = (locsOne, locsTwo) -> [...locsOne].filter (loc) => locsTwo.has loc

findShortest = (intersects) ->  
  shortest = Infinity

  intersects.forEach (inter) =>
    dist = inter
      .split ':'
      .map (str) => Math.abs Number str
      .reduce (a, b) => a + b

    shortest = dist if dist < shortest

  return shortest

locsOne = getLocations input[0]
locsTwo = getLocations input[1]
intersects = findIntersects locsOne, locsTwo
shortest = findShortest intersects
console.log shortest
