import 'dart:async';

import 'package:flutter/material.dart';

import '../data/trees.dart';
import '../graph.dart';
import '../styles.dart';

class Field extends StatefulWidget {
  final StreamController<int> currentNumOfLines;
  final int level;
  final int gameNum;
  final StreamController<bool> isGameOver;

  const Field({
    Key? key,
    required this.currentNumOfLines,
    required this.level,
    required this.gameNum,
    required this.isGameOver,
  }) : super(key: key);

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  final int fieldSize = 9;
  final double spacePointPoint = Style.blockM * 1.3;
  final double pointDiameter = Style.blockM * 0.5;
  final double spaceLinePoint = Style.blockM * 0.3;
  final double lineThick = Style.blockM * 0.1;

  late List<List<bool>> routesH;
  late List<List<bool>> routesV;
  late List<List<bool>> points;
  List<Point> chosenPoints = [];
  late List<Point?> filledPoints;
  int currentNumOfLines = 0;
  bool routeIsConnected = false;
  bool isGameOver = false;
  late final Graph graph;
  Point nullPoint = Point(100, 100);

  @override
  void initState() {
    super.initState();
    graph = Graph(fieldSize);
    routesH = List.generate(fieldSize, (x) => List.generate(fieldSize, (y) => false));
    routesV = List.generate(fieldSize, (x) => List.generate(fieldSize, (y) => false));

    chosenPoints =
        (trees[widget.level][widget.gameNum][0] as List).map((e) => Point(e[0], e[1])).toList().cast<Point>();

    filledPoints = [...chosenPoints];

    points = List.generate(
        fieldSize,
        (x) => List.generate(fieldSize,
            (y) => (chosenPoints.firstWhere((e) => e.x == x && e.y == y, orElse: () => nullPoint) != nullPoint)));
  }

  void chooseRout(int x, int y, String type) {
    setState(() {
      late bool currentState;
      if (type == "v") {
        currentState = routesV[x][y];
        if (!currentState) {
          graph.addConnection(Point(x, y), Point(x, y + 1));
        } else {
          graph.removeConnection(Point(x, y), Point(x, y + 1));
        }
        routesV[x][y] = !currentState;
        points[x][y] = connectedPoint(x, y);
        if (y != fieldSize - 1) {
          points[x][y + 1] = connectedPoint(x, y + 1);
        }
      } else {
        currentState = routesH[x][y];
        if (!currentState) {
          graph.addConnection(Point(x, y), Point(x + 1, y));
        } else {
          graph.removeConnection(Point(x, y), Point(x + 1, y));
        }
        routesH[x][y] = !currentState;
        points[x][y] = connectedPoint(x, y);
        if (x != fieldSize - 1) {
          points[x + 1][y] = connectedPoint(x + 1, y);
        }
      }
      routeIsConnected = graph.areTargetsConnected(chosenPoints);
      // print(routeIsConnected);
      currentNumOfLines += currentState ? -1 : 1;
      widget.currentNumOfLines.add(currentNumOfLines);

      if (routeIsConnected && trees[widget.level][widget.gameNum][1] == currentNumOfLines) {
        widget.isGameOver.add(true);
        isGameOver = true;
      }
    });
  }

  bool connectedPoint(x, y) {
    int r1 = (routesV[x][y]) ? 1 : 0;
    int r2 = (y != 0 ? routesV[x][y - 1] : false) ? 1 : 0;
    int r3 = (routesH[x][y]) ? 1 : 0;
    int r4 = (x != 0 ? routesH[x - 1][y] : false) ? 1 : 0;

    bool res = r1 + r2 + r3 + r4 > 1;
    if (res) {
      filledPoints.add(Point(x, y));
    } else {
      filledPoints.removeWhere((element) => (element!.x == x && element.y == y));
    }
    //print(filledPoints);
    return res;
  }

  bool isInTargets(x, y) {
    return isPointInList(Point(x, y), chosenPoints);
  }

  bool isPointInList(Point point, List<Point?>? l) {
    Point p = Point(0, 0);
    bool res = l!.firstWhere((e) => (e!.x == point.x && e.y == point.y), orElse: () => p) != p;
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
              fieldSize * 2 - 1,
              (y) => y % 2 == 1
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        fieldSize * 2 - 1,
                        (x) => x % 2 == 1
                            ? SizedBox(
                                width: spacePointPoint,
                              )
                            : GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => chooseRout(x ~/ 2, y ~/ 2, "v"),
                                child: SizedBox(
                                  height: spacePointPoint,
                                  width: pointDiameter,
                                  child: Center(
                                    child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        height: spacePointPoint - spaceLinePoint,
                                        width: lineThick,
                                        decoration: BoxDecoration(
                                            color: routesV[x ~/ 2][y ~/ 2] || isGameOver
                                                ? (routeIsConnected
                                                    ? Style.accentColor
                                                    : Style.primaryColor.withOpacity(1))
                                                : Style.primaryColor.withOpacity(0),
                                            borderRadius: BorderRadius.circular(100))),
                                  ),
                                ),
                              ),
                      ))
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        fieldSize * 2 - 1,
                        (x) => x % 2 == 1
                            ? GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => chooseRout(x ~/ 2, y ~/ 2, "h"),
                                child: SizedBox(
                                  width: spacePointPoint,
                                  height: pointDiameter,
                                  child: Center(
                                    child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        width: spacePointPoint - spaceLinePoint,
                                        height: lineThick,
                                        decoration: BoxDecoration(
                                            color: routesH[x ~/ 2][y ~/ 2] || isGameOver
                                                ? (routeIsConnected
                                                    ? Style.accentColor
                                                    : Style.primaryColor.withOpacity(1))
                                                : Style.primaryColor.withOpacity(0),
                                            borderRadius: BorderRadius.circular(100))),
                                  ),
                                ),
                              )
                            : AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: pointDiameter,
                                height: pointDiameter,
                                decoration: BoxDecoration(
                                    color: (chosenPoints.firstWhere((e) => e.x == x ~/ 2 && e.y == y ~/ 2,
                                                orElse: () => nullPoint) !=
                                            nullPoint)
                                        ? (routeIsConnected && !isGameOver ? Style.primaryColor : Style.accentColor)
                                        : (points[x ~/ 2][y ~/ 2] || isGameOver
                                            ? (routeIsConnected ? Style.accentColor : Style.primaryColor)
                                            : Style.primaryColor.withOpacity(0.1)),
                                    shape: BoxShape.circle)),
                      ))),
        ),
      ],
    );
  }
}

class Line {
  late final Point start;
  late final Point end;

  Line(this.start, this.end);

  printLine() {
    print("${start.x} ${start.y} | ${end.x} ${end.y}");
  }
}
