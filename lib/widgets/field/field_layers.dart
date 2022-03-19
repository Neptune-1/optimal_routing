import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../consts/styles.dart';
import 'graph_layers.dart';

class Field extends StatefulWidget {
  final StreamController<int> currentNumOfLines;
  final List tree;
  final StreamController<bool> isGameOver;
  final Stream<bool> showAnswer;
  final bool showLines;
  final int layerFullNum;
  final Stream<int> layerNumStream;

  const Field(
      {Key? key,
      required this.currentNumOfLines,
      required this.tree,
      required this.isGameOver,
      required this.showAnswer,
      required this.layerFullNum,
      required this.layerNumStream,
      this.showLines = false})
      : super(key: key);

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  late final int fieldSize;
  double spacePointPoint = Style.wideScreen ? Style.blockM * 1.4 : Style.blockM * 1;
  double pointDiameter = Style.wideScreen ? Style.blockM * 1.2 : Style.blockM * 1.1;
  late final double showedPointDiameter;
  final double spaceLinePoint = Style.blockM * 0;
  final double lineThick = Style.blockM * 0.1;

  late List<List<List<bool>>> routesH;
  late List<List<List<bool>>> routesV;
  late List<List<List<bool>>> points;
  List<List<Point>> chosenPoints = [];
  int currentNumOfLines = 0;
  bool routeIsConnected = false;
  bool isGameOver = false;
  late final Graph graph;
  Point nullPoint = Point(100, 100);

  int currentLayer = 0;

  @override
  void initState() {
    super.initState();

    fieldSize = widget.tree[3];
    spacePointPoint *= 8 / fieldSize;
    showedPointDiameter = pointDiameter * 0.2;
    graph = Graph(fieldSize);
    routesH = List.generate(
        widget.layerFullNum, (n) => List.generate(fieldSize, (x) => List.generate(fieldSize, (y) => false)));
    routesV = List.generate(
        widget.layerFullNum, (n) => List.generate(fieldSize, (x) => List.generate(fieldSize, (y) => false)));

    List chosenPointsShuffle = (widget.tree[0] as List).map((e) => Point(e[0], e[1])).toList().cast<Point>();
    chosenPointsShuffle.shuffle();
    int step = chosenPointsShuffle.length ~/ widget.layerFullNum;
    for (int i = 0; i < widget.layerFullNum; i ++) {
      chosenPoints.add(chosenPointsShuffle
          .sublist(i*step, i+1!=widget.layerFullNum ? (i+1)*step : chosenPointsShuffle.length)
          .cast<Point>());
    }
    print(chosenPoints);


    points = List.generate(
        widget.layerFullNum, (n) => List.generate(fieldSize, (x) => List.generate(fieldSize, (y) => false)));

    widget.layerNumStream.listen((n) => setState(() => currentLayer = n));
  }

  void chooseRout(int x, int y, String type, {state}) {
    if ((type == "h" && x >= 0 && x < fieldSize - 1 && y >= 0) || (type == "v" && y >= 0 && y < fieldSize - 1)) {
      setState(() {
        late bool currentState;
        if (type == "v") {
          currentState = routesV[currentLayer][x][y];
          if (state ?? !currentState) {
            int s = 0;
            routesV.forEach((e) => s+= e[x][y] ? 1 : 0);
            if(s==0) graph.addConnection(Point(x, y), Point(x, y + 1));
          } else {
            int s = 0;
            routesV.forEach((e) => s+= e[x][y] ? 1 : 0);
            if(s==1) graph.removeConnection(Point(x, y), Point(x, y + 1));
          }
          routesV[currentLayer][x][y] = state ?? !currentState;
          points[currentLayer][x][y] = connectedPoint(x, y);
          if (y != fieldSize - 1) {
            points[currentLayer][x][y + 1] = connectedPoint(x, y + 1);
          }
        } else {
          currentState = routesH[currentLayer][x][y];
          if (state ?? !currentState) {
            int s = 0;
            routesH.forEach((e) => s+= e[x][y] ? 1 : 0);
            if(s==0) graph.addConnection(Point(x, y), Point(x + 1, y));
          } else {
            int s = 0;
            routesH.forEach((e) => s+= e[x][y] ? 1 : 0);
            if(s==1) graph.removeConnection(Point(x, y), Point(x + 1, y));
          }
          routesH[currentLayer][x][y] = state ?? !currentState;
          points[currentLayer][x][y] = connectedPoint(x, y);
          if (x != fieldSize - 1) {
            points[currentLayer][x + 1][y] = connectedPoint(x + 1, y);
          }
        }
        routeIsConnected = graph.areTargetsConnected(chosenPoints.expand((i) => i).toList());
        // print(routeIsConnected);
        if (state == null) {
          currentNumOfLines += currentState ? -1 : 1;
        } else if (state) {
          currentNumOfLines += currentState ? 0 : 1;
        } else if (!state) {
          currentNumOfLines += currentState ? -1 : 0;
        }
        widget.currentNumOfLines.add(currentNumOfLines);

        if (routeIsConnected && widget.tree[1] == currentNumOfLines) {
          widget.isGameOver.add(true);
          isGameOver = true;
        }
      });
    }
  }

  bool connectedPoint(x, y) {
    int r1 = (routesV[currentLayer][x][y]) ? 1 : 0;
    int r2 = (y != 0 ? routesV[currentLayer][x][y - 1] : false) ? 1 : 0;
    int r3 = (routesH[currentLayer][x][y]) ? 1 : 0;
    int r4 = (x != 0 ? routesH[currentLayer][x - 1][y] : false) ? 1 : 0;
    bool res = (r1 + r2 + r3 + r4) > 0;

    return res;
  }

  bool isInTargets(x, y) {
    return isPointInList(Point(x, y), chosenPoints[currentLayer]);
  }

  bool isPointInList(Point point, List<Point> l) {
    bool res = l.firstWhere((e) => (e.x == point.x && e.y == point.y), orElse: () => nullPoint) != nullPoint;
    return res;
  }

  Point? firstPoint;

  getField() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (details) {
        firstPoint = null;
      },
      onPanUpdate: (details) {
        // print("Update");
        Point? currentPoint;
        int y = (details.localPosition.dy) ~/ (pointDiameter + spacePointPoint);
        int x = (details.localPosition.dx) ~/ (pointDiameter + spacePointPoint);
        if (sqrt(pow(details.localPosition.dy % (pointDiameter + spacePointPoint), 2) +
                pow(details.localPosition.dx % (pointDiameter + spacePointPoint), 2)) <
            pointDiameter * 2) {
          currentPoint = Point(x, y);
        }

        firstPoint ??= currentPoint;

        if (currentPoint != null && !firstPoint!.samePoint(currentPoint)) {
          chooseRout(min(currentPoint.x, firstPoint!.x), min(currentPoint.y, firstPoint!.y),
              currentPoint.x == firstPoint!.x ? "v" : "h");

          firstPoint = Point(currentPoint.x, currentPoint.y);
        }
      },
      child: Column(
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
                                          color: routesV[currentLayer][x ~/ 2][y ~/ 2]
                                              ? (routeIsConnected
                                                  ? Style.accentColor
                                                  : Style.primaryColor.withOpacity(1))
                                              : (isGameOver
                                                  ? Colors.transparent
                                                  : Style.primaryColor.withOpacity(widget.showLines ? 0.1 : 0)),
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
                                          color: routesH[currentLayer][x ~/ 2][y ~/ 2]
                                              ? (routeIsConnected
                                                  ? Style.accentColor
                                                  : Style.primaryColor.withOpacity(1))
                                              : (isGameOver
                                                  ? Colors.transparent
                                                  : Style.primaryColor.withOpacity(widget.showLines ? 0.1 : 0)),
                                          borderRadius: BorderRadius.circular(100))),
                                ),
                              ),
                            )
                          : SizedBox(
                              width: pointDiameter,
                              height: pointDiameter,
                              child: Center(
                                child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: showedPointDiameter *
                                        (((isPointInList(Point(x ~/ 2, y ~/ 2), chosenPoints[currentLayer])) ||
                                                points[currentLayer][x ~/ 2][y ~/ 2])
                                            ? 3
                                            : 1),
                                    height: showedPointDiameter *
                                        (((isPointInList(Point(x ~/ 2, y ~/ 2), chosenPoints[currentLayer])) ||
                                                points[currentLayer][x ~/ 2][y ~/ 2])
                                            ? 3
                                            : 1),
                                    decoration: BoxDecoration(
                                        color: (isPointInList(Point(x ~/ 2, y ~/ 2), chosenPoints[currentLayer])
                                            ? (routeIsConnected
                                                ? (isGameOver ? Style.accentColor : Style.primaryColor)
                                                : Style.accentColor)
                                            : (((isPointInList(Point(x ~/ 2, y ~/ 2), chosenPoints[currentLayer])) ||
                                                    points[currentLayer][x ~/ 2][y ~/ 2])
                                                ? (routeIsConnected
                                                    ? Style.accentColor
                                                    : (isGameOver ? Style.accentColor : Style.primaryColor))
                                                : (isGameOver
                                                    ? Style.primaryColor.withOpacity(1)
                                                    : Style.primaryColor.withOpacity(0.5)))),
                                        shape: BoxShape.circle)),
                              ),
                            ),
                    ))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<bool>(
            stream: widget.showAnswer,
            builder: (context, snapshot) {
              List<List<List<int>>> answer = widget.tree[2];
              List<List<bool>> answerRoutesH = List.generate(fieldSize, (x) => List.generate(fieldSize, (y) => false));
              List<List<bool>> answerRoutesV = List.generate(fieldSize, (x) => List.generate(fieldSize, (y) => false));
              List<List<bool>> points =
                  List.generate(fieldSize, (x) => List.generate(fieldSize, (y) => isInTargets(x, y)));

              for (var line in answer) {
                Point p1 = Point(line[0][0], line[0][1]);
                Point p2 = Point(line[1][0], line[1][1]);
                if (p1.x == p2.x && p1.y != p2.y) {
                  answerRoutesH[min(p1.x, p2.x)][min(p2.y, p1.y)] = true;
                  points[min(p1.x, p2.x)][min(p2.y, p1.y)] = true;
                  if (min(p1.y, p2.y) != fieldSize - 1) {
                    points[min(p1.x, p2.x)][min(p2.y, p1.y) + 1] = true;
                  }
                } else if (p1.y == p2.y && p1.x != p2.x) {
                  answerRoutesV[min(p1.x, p2.x)][min(p2.y, p1.y)] = true;
                  points[min(p1.x, p2.x)][min(p2.y, p1.y)] = true;
                  if (min(p1.x, p2.x) != fieldSize - 1) {
                    points[min(p1.x, p2.x) + 1][min(p2.y, p1.y)] = true;
                  }
                }
              }
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: snapshot.data == true
                    ? Column(
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
                                          : SizedBox(
                                              height: spacePointPoint,
                                              width: pointDiameter,
                                              child: Center(
                                                child: Container(
                                                    height: spacePointPoint - spaceLinePoint,
                                                    width: lineThick,
                                                    decoration: BoxDecoration(
                                                        color: answerRoutesH[x ~/ 2][y ~/ 2]
                                                            ? Style.accentColor
                                                            : Style.primaryColor
                                                                .withOpacity(widget.showLines ? 0.2 : 0),
                                                        borderRadius: BorderRadius.circular(100))),
                                              ),
                                            ),
                                    ))
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      fieldSize * 2 - 1,
                                      (x) => x % 2 == 1
                                          ? SizedBox(
                                              width: spacePointPoint,
                                              height: pointDiameter,
                                              child: Center(
                                                child: Container(
                                                    width: spacePointPoint - spaceLinePoint,
                                                    height: lineThick,
                                                    decoration: BoxDecoration(
                                                        color: answerRoutesV[x ~/ 2][y ~/ 2]
                                                            ? Style.accentColor
                                                            : Style.primaryColor
                                                                .withOpacity(widget.showLines ? 0.1 : 0),
                                                        borderRadius: BorderRadius.circular(100))),
                                              ),
                                            )
                                          : SizedBox(
                                              width: pointDiameter,
                                              height: pointDiameter,
                                              child: Center(
                                                child: Container(
                                                    width: showedPointDiameter *
                                                        (isInTargets(x ~/ 2, y ~/ 2) || points[x ~/ 2][y ~/ 2] ? 3 : 1),
                                                    height: showedPointDiameter *
                                                        (isInTargets(x ~/ 2, y ~/ 2) || points[x ~/ 2][y ~/ 2] ? 3 : 1),
                                                    decoration: BoxDecoration(
                                                        color: isInTargets(x ~/ 2, y ~/ 2)
                                                            ? Style.primaryColor.withOpacity(1)
                                                            : (points[x ~/ 2][y ~/ 2]
                                                                ? Style.accentColor
                                                                : Style.primaryColor.withOpacity(0.5)),
                                                        shape: BoxShape.circle)),
                                              ),
                                            ),
                                    ))),
                      )
                    : getField(),
              );
            }),
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
