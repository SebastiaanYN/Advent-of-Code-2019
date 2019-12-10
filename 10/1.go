package main

import (
  "fmt"
  "math"
  "strings"
  "io/ioutil"
)

func unique(slice []float64) []float64 {
    keys := make(map[float64]bool)
    list := []float64{}
    for _, entry := range slice {
        if _, value := keys[entry]; !value {
            keys[entry] = true
            list = append(list, entry)
        }
    }
    return list
}

type coord struct {
  x int
  y int
}

func NewCoord(x int, y int) coord {
  return coord{x: x, y: y}
}

type asteroid struct {
  coord coord
  visible int
}

func NewAsteroid(coord coord, visible int) asteroid {
  return asteroid{coord: coord, visible: visible}
}

func CoordsToAngle(a coord, b coord) float64 {
  return math.Atan2(float64(a.y - b.y), float64(a.x - b.x)) * 180 / math.Pi
}

func AsteroidsToAngles(asteroids []coord, base coord) []float64 {
  angles := []float64{}

  for _, a := range asteroids {
    if !(a.x == base.x && a.y == base.y) {
      angles = append(angles, CoordsToAngle(a, base))
    }
  }

  return angles
}

func MapToAsteroids(amap string) []coord {
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

func FindBestAsteroid(amap string) asteroid {
  asteroids := MapToAsteroids(amap)

  var coord coord
  max := 0

  for _, a := range asteroids {
    angles := AsteroidsToAngles(asteroids, a)
    visible := len(unique(angles))

    if visible > max {
      coord = a
      max = visible
    }
  }

  return NewAsteroid(coord, max)
}

func main() {
  file, _ := ioutil.ReadFile("input.txt")
  input := string(file)

  best := FindBestAsteroid(input)
  fmt.Printf("%+v\n", best)
}
