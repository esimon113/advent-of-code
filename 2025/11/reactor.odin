package aoc25_11

import "core:fmt"
import os "core:os/os2"
import "core:strings"
import "core:strconv"


Graph :: map[string][]string


dfs :: proc(node: string, graph: Graph, dst: string, path: ^[dynamic]string, allPaths: ^[dynamic][]string) {
  append(path, node)

  if node == dst {
    pathCpy := make([]string, len(path))
    copy(pathCpy, path[:])
    append(allPaths, pathCpy)
  }
  else {
    for neighbour in graph[node] {
      if !strings.contains(strings.join(path[:], ","), neighbour) {
        dfs(neighbour, graph, dst, path, allPaths)
      }
    }
  }

  ordered_remove(path, len(path) - 1)
}


getNumberOfPaths :: proc(graph: Graph, src: string, dst: string) -> int {
  path: [dynamic]string
  defer delete(path)

  allPaths: [dynamic][]string
  defer {
    for p in &allPaths {
      delete(p)
    }
    delete(allPaths)
  }

  dfs(src, graph, dst, &path, &allPaths)

  return len(allPaths)
}


main :: proc() {
  filename := "input.data"

  data, ok := os.read_entire_file_from_path(filename, context.allocator)
  if ok != os.ERROR_NONE do return
  defer delete(data, context.allocator)

  G := make(Graph)
  defer delete(G)

  it := string(data)
  for line in strings.split_lines_iterator(&it) {
    kv := strings.split_n(line, ":", 2)
    neighbours := strings.split(kv[1][1:], " ")

    G[kv[0]] = neighbours
  }

  src := "you"
  dst := "out"

  result := getNumberOfPaths(G, src, dst)
  fmt.printfln("Number of Paths: %i", result)
}
