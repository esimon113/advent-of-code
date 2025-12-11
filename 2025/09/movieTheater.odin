package aoc25_09

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:math"
import "core:time"

Vec2 :: [2]int

main :: proc() {
  filename := "input.data"

  data, ok := os.read_entire_file(filename, context.allocator)
  if !ok do return
  defer delete(data, context.allocator)

  points: [dynamic]Vec2
  defer delete(points)

  it := string(data)
  for line in strings.split_lines_iterator(&it) {
    splitted := strings.split(line, ",")
    p1, ok1 := strconv.parse_int(splitted[0])
    p2, ok2 := strconv.parse_int(splitted[1])

    if !ok1 || !ok2 {
      fmt.eprintln("An Error occurred while converting string to int for a point.")
      return
    }
    
    append(&points, Vec2{p1, p2})
  }

  maxArea: int = 0

  for p1 in points {
    for p2 in points {
      dx := math.abs(p2.x - p1.x) + 1
      dy := math.abs(p2.y - p1.y) + 1
      area := dx * dy

      maxArea = area if area > maxArea else maxArea
    }
  }

  fmt.printfln("Final max area: %i", maxArea)
}
