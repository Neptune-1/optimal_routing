import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optimal_routing/utils/ads.dart';
import 'package:optimal_routing/widgets/field/field_projection.dart';

import '../consts/styles.dart';
import '../data/trees.dart';
import '../data_structures.dart';
import '../utils/lamps.dart';
import '../utils/prefs.dart';

class GamePageV1 extends StatefulWidget {
  final int level;
  final bool example;

  const GamePageV1({Key? key, required this.level, this.example = false}) : super(key: key);

  @override
  State<GamePageV1> createState() => _GamePageV1State();
}

class _GamePageV1State extends State<GamePageV1> with TickerProviderStateMixin {
  late final AnimationController controller;
  late final AnimationController restartAnimationController;
  late final Animation restartAnimation;

  int currentLinesNumber = 0;
  int restartedTime = 0;
  final StreamController<LinesData> currentNumOfLines = StreamController();
  final StreamController<bool> isGameOver = StreamController();
  final StreamController<int> showTip = StreamController();
  final StreamController<int> layerNum = StreamController();
  late final Stream<int> showTipStream;
  late final Stream<int> layerNumStream;

  late final Stream<FieldData> projectionDataStream;
  late final Stream<bool> isGameOverStream;
  final StreamController<FieldData> projectionData = StreamController();

  late int gameNum;
  final int answerShowTime = 5;
  bool isAnsweredShowed = false;

  int currentLayer = 0;

  @override
  void initState() {
    super.initState();
    layerNum.add(0);
    gameNum = Prefs.getInt(widget.level.toString()) ?? 0;
    if (gameNum != 0) gameNum -= 1;
    showTipStream = showTip.stream.asBroadcastStream();
    layerNumStream = layerNum.stream.asBroadcastStream();
    projectionDataStream = projectionData.stream.asBroadcastStream();
    isGameOverStream = isGameOver.stream.asBroadcastStream();

    Lamps();

    controller = AnimationController(
      value: 1,
      vsync: this,
      duration: Duration(seconds: answerShowTime),
    );
    restartAnimationController = AnimationController(
      value: 0,
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    restartAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: restartAnimationController, curve: Curves.easeOutCubic));

    showTipStream.listen((event) => (event == 2) ? startNewGame() : null);
  }

  void startNewGame({restart = false}) {
    isAnsweredShowed = false;
    isGameOver.add(false);
    layerNum.add(0);
    (gameNum != trees[widget.level].length - 1) && !restart ? gameNum++ : null;

    setState(() {});
  }

  ifGameIsOver() {
    Prefs.setInt(widget.level.toString(), gameNum + 1);
  }

  @override
  void dispose() {
    controller.dispose();
    restartAnimationController.dispose();
    isGameOver.close();
    showTip.close();

    super.dispose();
  }

  linesInfoWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.level != 2
            ? Container()
            : StreamBuilder<int>(
                stream: layerNumStream,
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Container()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            2,
                            (layerNum) => SizedBox(
                                width: Style.blockM * 0.2,
                                height: Style.blockM * (widget.level != 2 ? 1.5 : 1),
                                child: Center(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: Style.blockM * 0.2,
                                    height: Style.blockM * 0.6,
                                    decoration: BoxDecoration(
                                        color: (snapshot.data ?? 0) == layerNum
                                            ? Style.accentColor
                                            : Style.primaryColor,
                                        borderRadius: BorderRadius.circular(Style.blockM * 0.3)),
                                  ),
                                )),
                          ));
                }),
        StreamBuilder<LinesData>(
            stream: currentNumOfLines.stream,
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Container()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        widget.level == 2 ? 2 : 1,
                        (layerNum) => SizedBox(
                          width: Style.blockM * (widget.level != 2 ? 4 : 2),
                          height: Style.blockM * (widget.level != 2 ? 1.5 : 1),
                          child: Center(
                            child: Text(
                              "${(snapshot.data!.currentLinesNum[layerNum])}/${snapshot.data!.fullLinesNum[layerNum]}",
                              style: GoogleFonts.josefinSans(
                                  fontSize: Style.blockM * 0.8,
                                  fontWeight: FontWeight.w800,
                                  color: Style.primaryColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ));
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Style.init(context);
    return Scaffold(
        backgroundColor: Style.backgroundColor,
        body: SafeArea(
          child: AnimatedContainer(
            color: Style.backgroundColor,
            duration: const Duration(milliseconds: 2000),
            child: Stack(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Style.blockM * 0.5),
                child: Column(
                  children: [
                    SizedBox(
                      height: Style.blockH * 0.3,
                    ),
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              if (!kIsWeb) Navigator.pop(context);
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                              width: Style.blockM * 4.4,
                              height: Style.blockM * 1.5,
                              padding: EdgeInsets.only(right: Style.blockM * 1.4),
                              child: widget.example || kIsWeb
                                  ? Container()
                                  : Icon(
                                      Icons.arrow_back_ios,
                                      size: Style.blockM * 1.2,
                                      color: Style.primaryColor,
                                    ),
                            ),
                          ),
                        ),
                        if (widget.level != 2)
                          Align(
                            alignment: Alignment.center,
                            child: linesInfoWidget(),
                          ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: Style.blockM *
                                    (Ads.rewardedAd == null || widget.example ? 3 : 1.4),
                                height: Style.blockM * 1.4,
                                child: Center(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      if (!restartAnimationController.isAnimating) {
                                        restartAnimationController.reset();
                                        restartAnimationController.forward();
                                      }
                                      restartedTime++;
                                      startNewGame(restart: true);
                                    },
                                    child: AnimatedBuilder(
                                        animation: restartAnimationController,
                                        builder: (context, _) {
                                          return Transform.rotate(
                                            angle: -pi * restartAnimation.value,
                                            child: Icon(
                                              Icons.cached,
                                              size: Style.blockM * 1.2,
                                              color: Style.primaryColor,
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ),
                              (Ads.rewardedAd == null || widget.example) && !kIsWeb
                                  ? const SizedBox()
                                  : SizedBox(
                                      width: Style.blockM * 3,
                                      height: Style.blockM * 1.4,
                                      child: Stack(
                                        children: [
                                          AnimatedBuilder(
                                              animation: controller,
                                              builder: (context, w) {
                                                return Center(
                                                    child: SizedBox(
                                                  width: Style.blockM * 1.4,
                                                  height: Style.blockM * 1.4,
                                                  child: CircularProgressIndicator(
                                                    value: 1 - controller.value,
                                                    color: Style.primaryColor,
                                                    strokeWidth: Style.blockM * 0.1,
                                                  ),
                                                ));
                                              }),
                                          Center(
                                            child: GestureDetector(
                                              behavior: HitTestBehavior.translucent,
                                              onTap: () => Lamps.showBottomSheet(context, showTip),
                                              child: Icon(Icons.lightbulb,
                                                  size: Style.blockM * 1.1,
                                                  color: Style.primaryColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder<bool>(
                        stream: isGameOverStream,
                        builder: (context, snapshot) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOutCubic,
                            height: (snapshot.data == true && widget.level == 2
                                ? Style.blockH * 5
                                : Style.blockM * 1.2),
                          );
                        }),
                    widget.level != 2
                        ? Container()
                        : FieldProjection(
                            layerNum: 2,
                            layerNumController: layerNum,
                            projectionDataStream: projectionDataStream,
                            layerNumStream: layerNumStream),
                    widget.level != 2
                        ? Container()
                        : SizedBox(
                            height: Style.blockM * 2.5,
                          ),
                    Flexible(
                      flex: 1,
                      child: StreamBuilder<bool>(
                          stream: isGameOverStream,
                          builder: (context, snapshot) {
                            return snapshot.data == true && widget.level == 2
                                ? Container()
                                : Align(
                                    alignment: widget.level != 2
                                        ? const Alignment(0, 0.3)
                                        : Alignment.topCenter,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 400),
                                      child: Pseudo3dCube(),
                                    ),
                                  );
                          }),
                    ),
                    SizedBox(
                      height: Style.blockM * 2,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: Style.blockM * 1,
                top: Style.blockH * 0.9 + Style.blockM * 2,
                child: widget.level != 2 ? Container() : linesInfoWidget(),
              ),
              widget.example
                  ? Container()
                  : Positioned(
                      bottom: Style.blockM * 2,
                      child: SizedBox(
                        width: 20 * Style.block,
                        child: Center(
                          child: StreamBuilder<bool>(
                              stream: isGameOverStream,
                              builder: (context, snapshot) {
                                ifGameIsOver();
                                return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: snapshot.data == true &&
                                            trees[widget.level].length > gameNum
                                        ? ElevatedButton(
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(Style.blockM * 0.2),
                                                )),
                                                minimumSize: MaterialStateProperty.all(Size.zero),
                                                padding: MaterialStateProperty.all(EdgeInsets.zero),
                                                backgroundColor:
                                                    MaterialStateProperty.all(Style.primaryColor),
                                                overlayColor: MaterialStateProperty.all(
                                                    Style.secondaryColor.withOpacity(0.1)),
                                                elevation: MaterialStateProperty.all(0)),
                                            onPressed: () {
                                              trees[widget.level].length - 1 == gameNum
                                                  ? Navigator.pop(context)
                                                  : startNewGame();
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: Style.blockM * 0.3,
                                                  horizontal: 2.5 * Style.blockM),
                                              child: Text(
                                                  trees[widget.level].length - 1 == gameNum
                                                      ? "Back"
                                                      : "Next",
                                                  style: GoogleFonts.josefinSans(
                                                      fontSize: Style.blockM * 1.4,
                                                      fontWeight: FontWeight.w800,
                                                      color: Style.secondaryColor)),
                                            ),
                                          )
                                        : Container());
                              }),
                        ),
                      ),
                    ),
              widget.example
                  ? Container()
                  : Positioned(
                      bottom: Style.blockM * 0.5,
                      left: Style.block * 2.5,
                      child: SizedBox(
                        width: Style.block * 15,
                        height: Style.blockM,
                        child: Center(
                          child: Text(
                            "Level ${gameNum + 1} / ${trees[widget.level].length}",
                            style: GoogleFonts.josefinSans(
                                fontSize: Style.blockM * 0.7,
                                fontWeight: FontWeight.w800,
                                color: Style.primaryColor),
                          ),
                        ),
                      ))
            ]),
          ),
        ));
  }
}

class Pseudo3dCube extends StatefulWidget {
  @override
  _Pseudo3dCubeState createState() => _Pseudo3dCubeState();
}

class _Pseudo3dCubeState extends State<Pseudo3dCube> {
  double originX = 0;
  double x = 0;

  void onDragStart(double originX) => setState(() {
    this.originX = originX;
  });

  void onDragUpdate(double x) => setState(() {
    this.x = originX - x;
  });

  double get turnRatio {
    const step = -150.0;
    var k = x / step;
    k = k > 1 ? 1 : (k < 0 ? 0 : k);
    return k;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (details) => onDragStart(details.globalPosition.dx),
      onPanUpdate: (details) => onDragUpdate(details.globalPosition.dx),
      child: Cube(
        children: [
          _Side(
            color: Colors.blueAccent,
            number: 1,
          ),
          _Side(
            color: Colors.redAccent.shade200,
            number: 2,
          ),
          _Side(
            color: Colors.greenAccent.shade100,
            number: 3,
          ),
          _Side(
            color: Colors.yellowAccent,
            number: 4,
          ),
          _Side(
            color: Colors.pinkAccent.shade200,
            number: 5,
          ),
          _Side(
            color: Colors.purpleAccent.shade100,
            number: 6,
          ),
        ],
        k: turnRatio,
      ),
    );
  }
}

class _Side extends StatelessWidget {
  const _Side({Key? key, required this.color, required this.number}) : super(key: key);

  final Color color;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
        width:150,
      height: 150,
      color: color,
      child: Center(
        child: Text(
          number.toString(),
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

class Cube extends StatelessWidget {
  Cube({
    Key? key,
    required this.children,
    required this.k,
  }) : super(key: key) {
    assert(children.length == 6, 'Wrong number of children');
  }

  final List<Widget> children;
  final double k;

  @override
  Widget build(BuildContext context) {
    var frontK = k;
    var backK = 1 - k;
    return Column(
      children: <Widget>[
// Front side
        Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.003)
            ..rotateY(pi / 2 * frontK),
          alignment: FractionalOffset.centerRight,
          child: children[0],
        ),
// Back side
        Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.003)
            ..rotateY(pi / 2 * backK + pi),
          alignment: FractionalOffset.centerRight,
          child: children[1],
        ),
// Left side
        Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.003)
            ..rotateY(pi / 2 * frontK - pi / 2),
          alignment: FractionalOffset.centerRight,
          child: children[2],
        ),
// Right side
        Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.003)
            ..rotateY(pi / 2 * frontK + pi / 2),
          alignment: FractionalOffset.centerRight,
          child: children[3],
        ),
// Top side
        Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.003)
            ..rotateX(pi / 2 * frontK - pi / 2),
          alignment: FractionalOffset.centerRight,
          child: children[4],
        ),
// Bottom side
        Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.003)
            ..rotateX(pi / 2 * frontK + pi / 2),
          alignment: FractionalOffset.centerRight,
          child: children[5],
        ),
      ],
    );
  }
}