class Line {
  late final Point start;
  late final Point end;

  Line(this.start, this.end);

  printLine() {
    print("${start.x} ${start.y} | ${end.x} ${end.y}");
  }
}

class FieldRoute {
  late final int x;
  late final int y;
  late final String direction;

  FieldRoute(this.x, this.y, this.direction);
}

class FieldData {
  late List<List<List<bool>>> routesH;
  late List<List<List<bool>>> routesV;
  late List<List<List<bool>>> points;
  late List<List<Point>> targets;
  late bool routeIsConnected;
  late int fieldSize;
  late bool isGameOver;

  FieldData({
    required this.routesH,
    required this.routesV,
    required this.points,
    required this.targets,
    required this.routeIsConnected,
    required this.fieldSize,
    required this.isGameOver,
  });
}

const Point nullPoint = Point(100, 100);

class Point {
  final int x;
  final int y;

  const Point(this.x, this.y);

  bool samePoint(Point point) {
    return point.x == x && point.y == y;
  }

  bool isPointInList(List<Point> l) {
    bool res = l.firstWhere((e) => (e.x == x && e.y == y), orElse: () => nullPoint) != nullPoint;
    return res;
  }

  printPoint() {
    print("$x $y");
  }
}

class LinesData {
  late List<int> currentLinesNum;
  late List<int> fullLinesNum;

  LinesData({
    required this.currentLinesNum,
    required this.fullLinesNum,
  });
}

class Direction {
  static const int right = 0;
  static const int left = 1;
  static const int up = 2;
  static const int down = 3;
}
