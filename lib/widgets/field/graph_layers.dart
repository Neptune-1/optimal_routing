import 'dart:collection';

class Graph {
  HashMap graph = HashMap<int, HashSet<int>>();
  late final int fieldSize;

  Graph(this.fieldSize);

  addConnection(Point p0, Point p1) {
    if (graph[point2VertexNum(p0)] == null) graph[point2VertexNum(p0)] = HashSet<int>();
    if (graph[point2VertexNum(p1)] == null) graph[point2VertexNum(p1)] = HashSet<int>();
    graph[point2VertexNum(p0)].add(point2VertexNum(p1));
    graph[point2VertexNum(p1)].add(point2VertexNum(p0));
  }

  removeConnection(Point p0, Point p1) {
    graph[point2VertexNum(p0)].remove(point2VertexNum(p1));
    graph[point2VertexNum(p1)].remove(point2VertexNum(p0));
  }

  clear() {
    graph = HashMap<int, HashSet<int>>();
  }

  utilDFS(int p, HashSet<int> visited, List<int> targets) {
    visited.add(p);

    for (int pChild in (graph[p] ?? [])) {
      if (targets.contains(pChild)) targets.remove(pChild);

      if (!visited.contains(pChild)) {
        utilDFS(pChild, visited, targets);
      }
    }
  }

  bool areTargetsConnected(List<Point> targetPoints) {
    HashSet<int> visited = HashSet<int>();
    List<int> targets = targetPoints.map((p) => point2VertexNum(p)).toList().cast<int>();
    List<int> targetsCopy = [...targets];
    utilDFS(targets[0], visited, targets);
    return targets.isEmpty;
  }

  point2VertexNum(Point p) => p.x + p.y * fieldSize;
  
  printGraph(){
    print("START GRAPH #############################################");
    graph.forEach((key, value) => print("$key : $value"));
    print("END GRAPH ###############################################");

  }
}

class Point {
  late final int x;
  late final int y;

  Point(this.x, this.y);

  bool samePoint(Point point) {
    return point.x == x && point.y == y;
  }

  printPoint() {
    print("$x $y");
  }
}

class Direction {
  static const int right = 0;
  static const int left = 1;
  static const int up = 2;
  static const int down = 3;
}
