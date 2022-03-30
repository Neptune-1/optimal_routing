import 'dart:async';
import 'dart:math' as math;
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../consts/styles.dart';
import '../../data_structures.dart';

class FieldProjection extends StatefulWidget {
  final int layerNum;
  final StreamController<int> layerNumController;
  final Stream<FieldData> projectionDataStream;
  final Stream<int>? layerNumStream;
  final bool rotateAnimation;

  const FieldProjection(
      {Key? key,
      required this.layerNum,
      required this.layerNumController,
      required this.projectionDataStream,
      this.layerNumStream,
      this.rotateAnimation = false})
      : super(key: key);

  @override
  State<FieldProjection> createState() => _FieldProjectionState();
}

class _FieldProjectionState extends State<FieldProjection> with SingleTickerProviderStateMixin {
  final double initialSize = Style.blockM * 6;
  static const double initZAngle = -0.895;
  static const double initYAngle = 0.296;
  double zAngle = initZAngle;
  double yAngle = initYAngle;
  int selectedLayer = 0;
  FieldData? fieldData;
  late final Timer rotateAnimationTimer;

  @override
  void initState() {
    widget.projectionDataStream.listen((data) {
      if (mounted) setState(() => fieldData = data);
    });

    if (widget.layerNumStream != null)
      widget.layerNumStream!.listen((layerNum) => setState(() => selectedLayer = layerNum));

    if (widget.rotateAnimation) {
      rotateAnimationTimer =
          Timer.periodic(const Duration(milliseconds: 20), (timer) => setState(() => yAngle += 0.005));
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.rotateAnimation) rotateAnimationTimer.cancel();
  }

  getFieldImg(int thisLayerNum, FieldData fieldData) {
    double spacePointPoint = Style.blockM * 1;
    double pointDiameter = Style.blockM * 1.1;
    double showedPointDiameter = pointDiameter * 0.2;
    double spaceLinePoint = 0;
    double lineThick = Style.blockM * 0.1;

    final int fieldSize = fieldData.fieldSize;
    final bool isGameOver = fieldData.isGameOver;
    final bool routeIsConnected = fieldData.routeIsConnected;
    final routesV = fieldData.routesV;
    final routesH = fieldData.routesH;
    final points = fieldData.points;
    final chosenPoints = fieldData.targets;

    final double coef = initialSize / (fieldSize * pointDiameter + spacePointPoint * (fieldSize - 1)) * 0.85;
    spacePointPoint *= coef;
    pointDiameter *= coef;
    showedPointDiameter *= coef;
    spaceLinePoint *= coef;
    lineThick *= coef;
    return Column(
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
                              child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: spacePointPoint - spaceLinePoint,
                                  width: lineThick,
                                  decoration: BoxDecoration(
                                      color: routesV[thisLayerNum][x ~/ 2][y ~/ 2]
                                          ? (routeIsConnected ? Style.accentColor : Style.primaryColor.withOpacity(1))
                                          : (isGameOver ? Colors.transparent : Style.primaryColor.withOpacity(0)),
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
                              child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: spacePointPoint - spaceLinePoint,
                                  height: lineThick,
                                  decoration: BoxDecoration(
                                      color: routesH[thisLayerNum][x ~/ 2][y ~/ 2]
                                          ? (routeIsConnected ? Style.accentColor : Style.primaryColor.withOpacity(1))
                                          : (isGameOver ? Colors.transparent : Style.primaryColor.withOpacity(0)),
                                      borderRadius: BorderRadius.circular(100))),
                            ),
                          )
                        : SizedBox(
                            width: pointDiameter,
                            height: pointDiameter,
                            child: Center(
                              child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: showedPointDiameter *
                                      (((Point(x ~/ 2, y ~/ 2).isPointInList(chosenPoints[thisLayerNum])) ||
                                              points[thisLayerNum][x ~/ 2][y ~/ 2])
                                          ? 3
                                          : 1),
                                  height: showedPointDiameter *
                                      (((Point(x ~/ 2, y ~/ 2).isPointInList(chosenPoints[thisLayerNum])) ||
                                              points[thisLayerNum][x ~/ 2][y ~/ 2])
                                          ? 3
                                          : 1),
                                  decoration: BoxDecoration(
                                      color: (Point(x ~/ 2, y ~/ 2).isPointInList(chosenPoints[thisLayerNum])
                                          ? (routeIsConnected
                                              ? (isGameOver ? Style.accentColor : Style.primaryColor)
                                              : Style.accentColor)
                                          : (((Point(x ~/ 2, y ~/ 2).isPointInList(chosenPoints[thisLayerNum])) ||
                                                  points[thisLayerNum][x ~/ 2][y ~/ 2])
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
    );
  }

  getSupportFieldImg(FieldData fieldData) {
    double spacePointPoint = Style.blockM * 1;
    double pointDiameter = Style.blockM * 1.1;
    double showedPointDiameter = pointDiameter * 0.3;

    final int fieldSize = fieldData.fieldSize;
    final points = fieldData.points;
    final chosenPoints = fieldData.targets;
    chosenPoints
        .asMap()
        .forEach((layerNum, layer) => (layer.forEach((point) => points[layerNum][point.x][point.y] = true)));
    final List<List<bool>> supportPoints = List.generate(
        fieldSize,
        (x) => List.generate(fieldSize, (y) {
              int sum = 0;
              points.forEach((layer) => sum += layer[x][y] ? 1 : 0);
              return sum > 1;
            }));

    final double coef = initialSize / (fieldSize * pointDiameter + spacePointPoint * (fieldSize - 1)) * 0.85;
    spacePointPoint *= coef;
    pointDiameter *= coef;
    showedPointDiameter *= coef;
    return Column(
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
                          )
                        : SizedBox(
                            width: pointDiameter,
                            height: pointDiameter,
                            child: Center(
                              child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: showedPointDiameter * (supportPoints[x ~/ 2][y ~/ 2] ? 1 : 0),
                                  height: showedPointDiameter * (supportPoints[x ~/ 2][y ~/ 2] ? 1 : 0),
                                  decoration: BoxDecoration(
                                      color: Style.accentColor.withOpacity(supportPoints[x ~/ 2][y ~/ 2] ? 0.7 : 0),
                                      shape: BoxShape.circle)),
                            ),
                          ),
                  ))),
    );
  }

  Widget getPlane(bool viewFromBottom, bool selected, int num) {
    return GestureDetector(
      onTap: () => widget.layerNumController.add(num),
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: initialSize,
          height: initialSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Style.blockM * 0.5),
            boxShadow: [
              BoxShadow(
                  color: selected ? Style.accentColor.withOpacity(0.2) : Colors.black.withOpacity(0.08),
                  blurRadius: Style.blockM * 0.5,
                  blurStyle: BlurStyle.outer),
            ],
            color: viewFromBottom ? const Color(0xffeeeeee).withOpacity(0.8) : Style.secondaryColor.withOpacity(0.8),
            border: Border.all(
              width: Style.blockM * 0.1,
              color: Style.accentColor.withOpacity(selected ? 1 : 0),
              style: BorderStyle.solid,
            ),
          ),
          child: fieldData == null ? Container() : Center(child: getFieldImg(num, fieldData!))),
      // child: BackdropFilter(
      //     filter: ImageFilter.blur(sigmaX: Style.blockM * 0.1, sigmaY: Style.blockM * 0.1),
      //     child: SizedBox(
      //       width: initialSize,
      //       height: initialSize,
      //       child: Center(
      //         child: child,
      //       ),
      //     ))
      //),
    );
  }

  Widget getSupportPlane(bool viewFromBottom) {
    return SizedBox(
        width: initialSize,
        height: initialSize,
        child: (fieldData == null ? Container() : Center(child: getSupportFieldImg(fieldData!))));
  }

  List<Widget> getPlanes() {
    bool isReversed = zAngle % (2 * math.pi) < (math.pi * 1.5) && zAngle % (2 * math.pi) > (math.pi * 0.5);
    List<bool> mainOrSupport = [true];
    List<double> offsets = [0];
    switch (widget.layerNum) {
      case 2:
        mainOrSupport = [
          true,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          true
        ];
        offsets = [
          1,
          0.9,
          0.8,
          0.7,
          0.6,
          0.5,
          0.4,
          0.3,
          0.2,
          0.1,
          0,
          -0.1,
          -0.2,
          -0.3,
          -0.4,
          -0.5,
          -0.6,
          -0.7,
          -0.8,
          -0.9,
          -1
        ];
        break;
      case 3:
        mainOrSupport = [
          true,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          true,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          true
        ];
        offsets = [
          1,
          0.9,
          0.8,
          0.7,
          0.6,
          0.5,
          0.4,
          0.3,
          0.2,
          0.1,
          0,
          -0.1,
          -0.2,
          -0.3,
          -0.4,
          -0.5,
          -0.6,
          -0.7,
          -0.8,
          -0.9,
          -1
        ];
        break;
    }
    int mainIndex = -1;
    Widget supportPlane = getSupportPlane(isReversed);
    List<Widget> planes = List.generate(offsets.length, (index) {
      if (mainOrSupport[index]) mainIndex++;

      return Align(
          alignment: Alignment(0, offsets[offsets.length - 1 - index]),
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(zAngle)
              ..rotateZ(-yAngle),
            alignment: Alignment.center,
            child: mainOrSupport[index] ? getPlane(isReversed, mainIndex == selectedLayer, mainIndex) : supportPlane,
          ));
    });
    if (!isReversed) planes = planes.reversed.toList().cast<Widget>();
    return planes;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanUpdate: (details) => setState(() {
        if ((zAngle < 0 || details.delta.dy < 0) && (zAngle > -pi || details.delta.dy > 0)) {
          zAngle += details.delta.dy / initialSize * 2;
        }
        yAngle += details.delta.dx / initialSize * 2;
      }),
      child: Container(
        width: initialSize * 1.5,
        height: initialSize * (1 + widget.layerNum * 0.25),
        child: Stack(
          children: getPlanes(),
          //Text("z $zAngle")], Align(alignment: Alignment.bottomLeft, child: Text("y $yAngle"))],
        ),
      ),
    );
  }
}
