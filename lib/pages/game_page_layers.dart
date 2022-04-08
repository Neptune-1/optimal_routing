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
import '../widgets/field/field_layers.dart';

class GamePage extends StatefulWidget {
  final int level;
  final bool example;

  const GamePage({Key? key, required this.level, this.example = false}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
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

  // showAnswerAndHide({bool isAdsShowed = true}) {
  //   if (isAdsShowed) isAnsweredShowed = true;
  //   controller.forward(from: 0);
  //   showAnswer.add(true);
  //   Future.delayed(Duration(seconds: answerShowTime), () {
  //     if (!showAnswer.isClosed) showAnswer.add(false);
  //     if (!controller.isDismissed) {
  //       controller.value = 1;
  //       controller.stop(canceled: false);
  //     }
  //   });
  // }

  // onPressedEye(BuildContext context) {
  //   if (!controller.isAnimating) {
  //     if (!kIsWeb && !isAnsweredShowed && !widget.example) {
  //       Ads.showPreAdDialog(context, showAnswerAndHide);
  //     } else {
  //       showAnswerAndHide();
  //     }
  //   }
  // }

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
        widget.level == 0
            ? Container()
            : StreamBuilder<int>(
                stream: layerNumStream,
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Container()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            widget.level + 1,
                            (layerNum) => SizedBox(
                                width: Style.blockM * 0.2,
                                height: Style.blockM * (widget.level == 0 ? 1.5 : 1),
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
                        widget.level + 1,
                        (layerNum) => SizedBox(
                          width: Style.blockM * (widget.level == 0 ? 4 : 2),
                          height: Style.blockM * (widget.level == 0 ? 1.5 : 1),
                          child: Center(
                            child: Text(
                              "${(snapshot.data!.currentLinesNum[layerNum])}/${snapshot.data!.fullLinesNum[layerNum]}",
                              style: GoogleFonts.quicksand(
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
        body: AnimatedContainer(
      color: Style.backgroundColor,
      duration: const Duration(milliseconds: 2000),
      child: Stack(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Style.blockM * 0.5),
          child: Column(
            children: [
              SizedBox(
                height: Style.blockH * 0.9,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      width: Style.blockM * 4.4,
                      height: Style.blockM * 1.5,
                      padding: EdgeInsets.only(right: Style.blockM * 1.4),
                      child: widget.example
                          ? Container()
                          : Icon(
                              Icons.arrow_back_ios,
                              size: Style.blockM * 1.2,
                              color: Style.primaryColor,
                            ),
                    ),
                  ),
                  widget.level != 0 ? Container() : linesInfoWidget(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width:  Style.blockM * (Ads.rewardedAd == null || widget.example  ? 3 : 1.4),
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
                                builder: (context, snapshot) {
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
                      Ads.rewardedAd == null || widget.example ? const SizedBox() : SizedBox(
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
                                child: Icon(Icons.lightbulb, size: Style.blockM * 1.1, color: Style.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              StreamBuilder<bool>(
                      stream: isGameOverStream,
                      builder: (context, snapshot) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutCubic,
                          height: (snapshot.data == true && widget.level != 0 ? Style.blockH * 5 : Style.blockM * 1.2),
                        );
                      }),
              widget.level == 0
                  ? Container()
                  : FieldProjection(
                      layerNum: widget.level + 1,
                      layerNumController: layerNum,
                      projectionDataStream: projectionDataStream,
                      layerNumStream: layerNumStream),
              widget.level == 0
                  ? Container()
                  : SizedBox(
                      height: Style.blockM * 2.5,
                    ),
              Flexible(
                flex: 1,
                child: StreamBuilder<bool>(
                    stream: isGameOverStream,
                    builder: (context, snapshot) {
                      return snapshot.data == true && widget.level != 0
                          ? Container()
                          : Align(
                              alignment: widget.level == 0 ? const Alignment(0, 0.3) : Alignment.topCenter,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                child: Field(
                                    key: Key("${widget.level} $gameNum $restartedTime"),
                                    currentNumOfLines: currentNumOfLines,
                                    tree: widget.example ? exampleTree : trees[widget.level][gameNum],
                                    isGameOver: isGameOver,
                                    showTip: showTipStream,
                                    layerNumStream: layerNumStream,
                                    layerFullNum: widget.level + 1,
                                    projectionData: projectionData),
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
          child: widget.level == 0 ? Container() : linesInfoWidget(),
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
                              child: snapshot.data == true && trees[widget.level].length > gameNum
                                  ? ElevatedButton(
                                      style: ButtonStyle(
                                          shape:
                                              MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(Style.blockM * 0.2),
                                          )),
                                          minimumSize: MaterialStateProperty.all(Size.zero),
                                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                                          backgroundColor: MaterialStateProperty.all(Style.primaryColor),
                                          overlayColor:
                                              MaterialStateProperty.all(Style.secondaryColor.withOpacity(0.1)),
                                          elevation: MaterialStateProperty.all(0)),
                                      onPressed: () {
                                        trees[widget.level].length - 1 == gameNum
                                            ? Navigator.pop(context)
                                            : startNewGame();
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: Style.blockM * 0.3, horizontal: 2.5 * Style.blockM),
                                        child: Text(trees[widget.level].length - 1 == gameNum ? "Back" : "Next",
                                            style: GoogleFonts.quicksand(
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
                      "Level ${gameNum + 1}",
                      style: GoogleFonts.quicksand(
                          fontSize: Style.blockM * 0.7, fontWeight: FontWeight.w800, color: Style.primaryColor),
                    ),
                  ),
                ))
      ]),
    ));
  }
}
