import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../consts/styles.dart';
import '../../data_structures.dart';
import 'graph_layers.dart';

class Field extends StatefulWidget {
  final StreamController<LinesData> currentNumOfLines;
  final List tree;
  final StreamController<bool> isGameOver;
  final Stream<bool> showAnswer;
  final bool showLines;
  final int layerFullNum;
  final Stream<int> layerNumStream;
  final StreamController<FieldData> projectionData;

  const Field(
      {Key? key,
      required this.currentNumOfLines,
      required this.tree,
      required this.isGameOver,
      required this.showAnswer,
      required this.layerFullNum,
      required this.layerNumStream,
      required this.projectionData,
      this.showLines = false})
      : super(key: key);

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  late final int fieldSize;
  double spacePointPoint = Style.wideScreen ? Style.blockM * 1.4 : Style.blockM * 1;
  double pointDiameter = Style.wideScreen ? Style.blockM * 1.2 : Style.blockM * 1.25;
  late final double showedPointDiameter;
  final double spaceLinePoint = Style.blockM * 0;
  final double lineThick = Style.blockM * 0.1;

  late List<List<List<bool>>> routesH;
  late List<List<List<bool>>> routesV;
  late List<List<List<bool>>> points;
  List<List<Point>> chosenPoints = [];
  List<int> currentNumOfLines = [];
  List<int> fullLinesNum = [];
  bool routeIsConnected = false;
  bool isGameOver = false;
  late final Graph graph;

  int currentLayer = 0;

  @override
  void initState() {
    super.initState();

    fieldSize = widget.tree[3];
    spacePointPoint *= 6.5 / fieldSize;
    showedPointDiameter = pointDiameter * 0.15;
    graph = Graph(fieldSize);
    routesH = List.generate(
        widget.layerFullNum, (n) => List.generate(fieldSize, (x) => List.generate(fieldSize, (y) => false)));
    routesV = List.generate(
        widget.layerFullNum, (n) => List.generate(fieldSize, (x) => List.generate(fieldSize, (y) => false)));

    int fullNumLinesSum = widget.tree[1];

    for (int i = 0; i < widget.layerFullNum; i++) {
      int thisLayerLinesNum = ((widget.layerFullNum - 1 <= i)
          ? ((fullNumLinesSum ~/ (widget.layerFullNum)) + (fullNumLinesSum % (widget.layerFullNum)))
          : fullNumLinesSum ~/ (widget.layerFullNum));
      fullLinesNum.add(thisLayerLinesNum);
      currentNumOfLines.add(0);
    }

    // int fullNumLinesSum = widget.tree[1];
    //
    // for (int i = 0; i < widget.layerFullNum; i++) {
    //   int thisLayerLinesNum =
    //   ((widget.layerFullNum - 1 == i)
    //       ? fullNumLinesSum
    //       : Random().nextInt(fullNumLinesSum ~/ (widget.layerFullNum - i)));
    //   fullNumLinesSum -= thisLayerLinesNum;
    //   fullLinesNum.add(thisLayerLinesNum);
    //   currentNumOfLines.add(0);
    // }

    // int fullNumLinesSum = widget.tree[1];
    // var nums = List.generate(fullNumLinesSum-1, (index) => index+1);
    // nums.shuffle();
    // nums = nums.sublist(0, widget.layerFullNum-1);
    // nums.sort();
    //
    // for (int i = 0; i < widget.layerFullNum; i++) {
    //   fullLinesNum.add(thisLayerLinesNum);
    //   currentNumOfLines.add(0);
    // }
    widget.currentNumOfLines.add(LinesData(currentLinesNum: currentNumOfLines, fullLinesNum: fullLinesNum));

    List chosenPointsShuffle = (widget.tree[0] as List).map((e) => Point(e[0], e[1])).toList().cast<Point>();
    chosenPointsShuffle.shuffle();
    int step = chosenPointsShuffle.length ~/ widget.layerFullNum;
    for (int i = 0; i < widget.layerFullNum; i++) {
      chosenPoints.add(chosenPointsShuffle
          .sublist(i * step, i + 1 != widget.layerFullNum ? (i + 1) * step : chosenPointsShuffle.length)
          .cast<Point>());
    }
    print(chosenPoints);

    points = List.generate(
        widget.layerFullNum, (n) => List.generate(fieldSize, (x) => List.generate(fieldSize, (y) => false)));

    widget.layerNumStream.listen((n) => mounted ? setState(() => currentLayer = n) : null);
    widget.projectionData.add(FieldData(
        routesH: routesH,
        routesV: routesV,
        points: points,
        targets: chosenPoints,
        routeIsConnected: routeIsConnected,
        isGameOver: isGameOver,
        fieldSize: fieldSize));
  }

  void chooseRout(int x, int y, String type, {state}) {
    if ((type == "h" && x >= 0 && x < fieldSize - 1 && y >= 0) || (type == "v" && y >= 0 && y < fieldSize - 1)) {
      setState(() {
        late bool currentState;
        if (type == "v") {
          currentState = routesV[currentLayer][x][y];
          if (state ?? !currentState) {
            int s = 0;
            routesV.forEach((e) => s += e[x][y] ? 1 : 0);
            if (s == 0) graph.addConnection(Point(x, y), Point(x, y + 1));
          } else {
            int s = 0;
            routesV.forEach((e) => s += e[x][y] ? 1 : 0);
            if (s == 1) graph.removeConnection(Point(x, y), Point(x, y + 1));
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
            routesH.forEach((e) => s += e[x][y] ? 1 : 0);
            if (s == 0) graph.addConnection(Point(x, y), Point(x + 1, y));
          } else {
            int s = 0;
            routesH.forEach((e) => s += e[x][y] ? 1 : 0);
            if (s == 1) graph.removeConnection(Point(x, y), Point(x + 1, y));
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
          currentNumOfLines[currentLayer] += currentState ? -1 : 1;
        } else if (state) {
          currentNumOfLines[currentLayer] += currentState ? 0 : 1;
        } else if (!state) {
          currentNumOfLines[currentLayer] += currentState ? -1 : 0;
        }
        widget.currentNumOfLines.add(LinesData(currentLinesNum: currentNumOfLines, fullLinesNum: fullLinesNum));

        if (routeIsConnected && const DeepCollectionEquality().equals(currentNumOfLines, fullLinesNum)) {
          widget.isGameOver.add(true);
          isGameOver = true;
        }
      });
    }
    widget.projectionData.add(FieldData(
        routesH: routesH,
        routesV: routesV,
        points: points,
        targets: chosenPoints,
        routeIsConnected: routeIsConnected,
        isGameOver: isGameOver,
        fieldSize: fieldSize));
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
    return Point(x, y).isPointInList(chosenPoints[currentLayer]);
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
                                        (((Point(x ~/ 2, y ~/ 2).isPointInList(chosenPoints[currentLayer])) ||
                                                points[currentLayer][x ~/ 2][y ~/ 2])
                                            ? 3
                                            : 1),
                                    height: showedPointDiameter *
                                        (((Point(x ~/ 2, y ~/ 2).isPointInList(chosenPoints[currentLayer])) ||
                                                points[currentLayer][x ~/ 2][y ~/ 2])
                                            ? 3
                                            : 1),
                                    decoration: BoxDecoration(
                                        color: (Point(x ~/ 2, y ~/ 2).isPointInList(chosenPoints[currentLayer])
                                            ? (routeIsConnected
                                                ? (isGameOver ? Style.accentColor : Style.primaryColor)
                                                : Style.accentColor)
                                            : (((Point(x ~/ 2, y ~/ 2).isPointInList(chosenPoints[currentLayer])) ||
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
