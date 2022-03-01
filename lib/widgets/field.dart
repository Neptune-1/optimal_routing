import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../styles.dart';

class Field extends StatefulWidget {
  final StreamController<String> currentNumOfLines;
  final int level;

  const Field({Key? key, required this.currentNumOfLines, required this.level}) : super(key: key);

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  final int fieldSize = 8;
  final double spacePointPoint = Style.blockM * 1.3;
  final double pointDiameter = Style.blockM * 0.35;
  final double spaceLinePoint = Style.blockM * 0.3;
  final double lineThick = Style.blockM * 0.1;
  late List<List<bool>> routesH;
  late List<List<bool>> routesV;
  late List<List<bool>> points;
  List<Point?> chosenPoints = [];
  late List<Point?> filledPoints;
  int currentNumOfLines = 0;
  bool routeIsConnected = false;

  @override
  void initState() {
    super.initState();
    routesH = List.generate(fieldSize, (x) => List.generate(fieldSize, (y) => false));
    routesV = List.generate(fieldSize, (x) => List.generate(fieldSize, (y) => false));

    var rng = Random();
    for (var i = 0; i < 5; i++) {
      int x = rng.nextInt(fieldSize);
      int y = rng.nextInt(fieldSize);
      //TODO create check for duplicates random
      // wile (!(chosenPoints.firstWhere((e) => e!.x == x && e.y == y, orElse: () => null) != null)) {
      //   x = rng.nextInt(fieldSize);
      //   y = rng.nextInt(fieldSize);
      // }
      chosenPoints.add(Point(x, y));
    }
    filledPoints = [...chosenPoints];

    points = List.generate(
        fieldSize,
            (x) =>
            List.generate(
                fieldSize, (y) => (chosenPoints.firstWhere((e) => e!.x == x && e.y == y, orElse: () => null) != null)));
  }

  void chooseRout(int x, int y, String type) {
    setState(() {
      late bool currentState;
      if (type == "v") {
        currentState = routesV[x][y];
        routesV[x][y] = !currentState;

        points[x][y] = connectedPoint(x, y);
        if (y != fieldSize - 1) {
          points[x][y + 1] = connectedPoint(x, y + 1);
        }
      } else {
        currentState = routesH[x][y];
        routesH[x][y] = !currentState;

        points[x][y] = connectedPoint(x, y);
        if (x != fieldSize - 1) {
          points[x + 1][y] = connectedPoint(x + 1, y);
        }
      }
      routeIsConnected = connectedRout();
      print(routeIsConnected);
      currentNumOfLines += currentState ? -1 : 1;
      widget.currentNumOfLines.add("$currentNumOfLines/24");
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

  bool connectedRout() {
    List<Line> connectedPairs = [];

    routesH.asMap().forEach((x, row) {
      row.asMap().forEach((y, value) {
        if (value) connectedPairs.add(Line(Point(x, y), Point(x + 1, y)));
      });
    });

    routesV.asMap().forEach((x, row) {
      row.asMap().forEach((y, value) {
        if (value) connectedPairs.add(Line(Point(x, y), Point(x, y + 1)));
      });
    });

    List<Point?> target = [chosenPoints[0]];
    List<Point?> targetTemp = [];
    List<Point?> allPoints = [];

    for(int i=0; i<connectedPairs.length; i+=1){
      for (Line line in connectedPairs) {
        for (Point? tarPoint in target) {
          if (line.start.samePoint(tarPoint!)) {
            targetTemp.add(line.end);
          } else if (line.end.samePoint(tarPoint)) {
            targetTemp.add(line.start);
          }
        }
      }
      target = [...targetTemp];
      allPoints.addAll(targetTemp);
      targetTemp = [];
    }

    for(var point in chosenPoints){
      if(!isPointInList(point!, allPoints)) return false;
    }

    return true;
  }


  @override
  Widget build(BuildContext context) {
    Style.init(context);
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
              fieldSize * 2 - 1,
                  (y) =>
              y % 2 == 1
                  ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    fieldSize * 2 - 1,
                        (x) =>
                    x % 2 == 1
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
                                  color: routesV[x ~/ 2][y ~/ 2]
                                      ? (routeIsConnected
                                      ? Style.accentColor
                                      : Style.primaryColor.withOpacity(1))
                                      : Style.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(100))),
                        ),
                      ),
                    ),
                  ))
                  : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    fieldSize * 2 - 1,
                        (x) =>
                    x % 2 == 1
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
                                  color: routesH[x ~/ 2][y ~/ 2]
                                      ? (routeIsConnected
                                      ? Style.accentColor
                                      : Style.primaryColor.withOpacity(1))
                                      : Style.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(100))),
                        ),
                      ),
                    )
                        : AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: pointDiameter,
                        height: pointDiameter,
                        decoration: BoxDecoration(
                            color: (chosenPoints.firstWhere((e) => e!.x == x ~/ 2 && e.y == y ~/ 2,
                                orElse: () => null) !=
                                null)
                                ? (routeIsConnected ? Style.primaryColor : Style.accentColor)
                                : (points[x ~/ 2][y ~/ 2]
                                ? (routeIsConnected ? Style.accentColor : Style.primaryColor)
                                : Style.primaryColor.withOpacity(0.1)),
                            shape: BoxShape.circle)),
                  ))),
        ),
      ],
    );
  }
}

class Point {
  late final int x;
  late final int y;

  Point(this.x, this.y);

  bool samePoint(Point point) {
    return point.x == x && point.y == y;
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
