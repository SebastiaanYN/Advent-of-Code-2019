package main

import (
  "os"
  "fmt"
  "sort"
  "math"
  "strings"
  "strconv"
  "io/ioutil"
)

type coord struct {
  x int
  y int
}

func NewCoord(x int, y int) coord {
  return coord{x: x, y: y}
}

type asteroid struct {
  coord coord
  angle float64
}

func NewAsteroid(coord coord, angle float64) asteroid {
  return asteroid{coord: coord, angle: angle}
}

func CoordsToAngle(a coord, b coord) float64 {
  angle := math.Atan2(float64(a.y - b.y), float64(a.x - b.x)) * 180 / math.Pi

  if angle < 0 {
    angle = 360 - math.Abs(angle)
  }

  angle = angle + 90

  if angle >= 360 {
    return angle - 360
  } else {
    return angle
  }
}

func MapToCoords(amap string) []coord {
  coords := []coord{}

  for y, s := range strings.Split(amap, "\n") {
    for x, c := range s {
      if c == '#' {
        coords = append(coords, NewCoord(x, y))
      }
    }
  }

  return coords
}

func CoordsToAstroids(coords []coord, base coord) []asteroid {
  asteroids := []asteroid{}

  for _, c := range coords {
    if !(c.x == base.x && c.y == base.y) {
      asteroids = append(asteroids, NewAsteroid(c, CoordsToAngle(c, base)))
    }
  }

  return asteroids
}

func FindAsteroid(asteroids []asteroid) asteroid {
  sort.Slice(asteroids, func(i, j int) bool { return asteroids[i].angle < asteroids[j].angle })

  count := 0
  for {
    i := 0

    for i < len(asteroids) {
      count++

      if count >= 200 {
        return asteroids[i]
      }

      // Store current angle
      angle := asteroids[i].angle

      // Remove current asteroid
      asteroids = append(asteroids[:i], asteroids[i + 1:]...)

      // Skip asteroids with the same angle
      for i < len(asteroids) && asteroids[i].angle == angle {
        i++
      }
    }
  }
}

func main() {
  file, _ := ioutil.ReadFile("input.txt")
  input := string(file)

  x, _ := strconv.Atoi(os.Args[1])
  y, _ := strconv.Atoi(os.Args[2])

  station := NewCoord(x, y)
  coords := MapToCoords(input)
  asteroids := CoordsToAstroids(coords, station)

  asteroid := FindAsteroid(asteroids)
  fmt.Printf("%d\n", asteroid.coord.x * 100 + asteroid.coord.y)
}
