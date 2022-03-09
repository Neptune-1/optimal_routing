import 'dart:collection';


class Graph {
  HashMap graph = HashMap<int, HashSet<int>>();
  List historyX = [];
  List historyY = [];
  int? direction;
  late final int fieldSize;

  Graph(this.fieldSize, this.direction);

  addConnection(Point p0, Point p1) {
    if (graph[point2VertexNum(p0)] == null) graph[point2VertexNum(p0)] = HashSet<int>();
    if (graph[point2VertexNum(p1)] == null) graph[point2VertexNum(p1)] = HashSet<int>();
    graph[point2VertexNum(p0)].add(point2VertexNum(p1));
    graph[point2VertexNum(p1)].add(point2VertexNum(p0));
    //int dopX = type == "h" ? 1 : 0;
    //int dopY = type == "v" ? 1 : 0;
    print("${p0.x} ${p1.x}");
    bool dopCase = true;
    if(historyX.isNotEmpty) dopCase = (historyX[historyX.length-1]>((p0.x + p1.x )/ 2)); // for this case

    historyX.add((p0.x < p1.x) ? point2VertexNum(p0) : point2VertexNum(p1));

    dopCase = true;
    if(historyY.isNotEmpty) dopCase = (historyY[historyY.length-1]>((p0.y + p1.y )/ 2)); // for this case
    historyY.add((p0.y < p1.y) ? point2VertexNum(p0) : point2VertexNum(p1));
  }

  removeConnection(Point p0, Point p1) {
    graph[point2VertexNum(p0)].remove(point2VertexNum(p1));
    graph[point2VertexNum(p1)].remove(point2VertexNum(p0));


    historyX.remove(p0.x < p1.x ? point2VertexNum(p0) : point2VertexNum(p1));
    historyY.remove(p0.y < p1.y ? point2VertexNum(p0) : point2VertexNum(p1));
  }

  clear() {
    graph = HashMap<int, HashSet<int>>();
    historyY = [];
    historyX = [];
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

  bool checkDirection() {
    bool rightDirection = true;
    List<int> xx = historyX.map((p) => p%fieldSize).toList().cast<int>();
    List<int> yy = historyY.map((p) => p~/fieldSize).toList().cast<int>();

    if(direction == Direction.right){
      xx.asMap().forEach((i, e) { if(i!=0) if(e<xx[i-1]) rightDirection = false;});
    }
    else if(direction == Direction.left){
      xx.asMap().forEach((i, e) { if(i!=0) if(e>xx[i-1]) rightDirection = false;});
    }
    else if(direction == Direction.up){
      yy.asMap().forEach((i, e) { if(i!=0) if(e>yy[i-1]) rightDirection = false;});
    }
    else if(direction == Direction.down){
      yy.asMap().forEach((i, e) { if(i!=0) if(e<yy[i-1]) rightDirection = false;});
    }
    return rightDirection;
  }

  point2VertexNum(Point p) => p.x + p.y * fieldSize;
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
