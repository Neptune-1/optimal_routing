import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optimal_routing/utils/ads.dart';

import '../consts/styles.dart';
import '../data/trees.dart';
import '../utils/prefs.dart';
import '../widgets/field/field_layers.dart';

class GamePage extends StatefulWidget {
  final int level;

  const GamePage({Key? key, required this.level}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  late final AnimationController controller;
  int currentLinesNumber = 0;
  final StreamController<int> currentNumOfLines = StreamController();
  final StreamController<bool> isGameOver = StreamController();
  final StreamController<bool> showAnswer = StreamController();
  final StreamController<int> layerNum = StreamController();
  late final Stream<bool> showAnswerStream;
  late final Stream<int> layerNumStream;

  late int gameNum;
  final int answerShowTime = 5;
  bool isAnsweredShowed = false;

  int currentLayer = 0;

  @override
  void initState() {
    super.initState();

    Style.toPallet0();

    if (!kIsWeb) Ads.createRewardedAd();
    gameNum = Prefs.getInt(widget.level.toString()) ?? 0;
    if (gameNum != 0) gameNum -= 1;
    showAnswerStream = showAnswer.stream.asBroadcastStream();
    layerNumStream = layerNum.stream.asBroadcastStream();

    controller = AnimationController(
      value: 1,
      vsync: this,
      duration: Duration(seconds: answerShowTime),
    );
  }

  void startNewGame() {
    isAnsweredShowed = false;
    currentNumOfLines.add(0);
    isGameOver.add(false);
    layerNum.add(0);
    gameNum != trees[widget.level].length - 1 ? gameNum++ : null;

    setState(() {});
  }

  ifGameIsOver() {
    Prefs.setInt(widget.level.toString(), gameNum + 1);
  }

  showAnswerAndHide({bool isAdsShowed = true}) {
    if (isAdsShowed) isAnsweredShowed = true;
    controller.forward(from: 0);
    showAnswer.add(true);
    Future.delayed(Duration(seconds: answerShowTime), () {
      if (!showAnswer.isClosed) showAnswer.add(false);
      if (!controller.isDismissed) {
        controller.value = 1;
        controller.stop(canceled: false);
      }
    });
  }

  onPressedEye(BuildContext context) {
    if (!controller.isAnimating) {
      if (!kIsWeb && !isAnsweredShowed) {
        Ads.showPreAdDialog(context, showAnswerAndHide);
      } else {
        showAnswerAndHide();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    isGameOver.close();
    showAnswer.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Style.init(context);
    return Scaffold(
        body: AnimatedContainer(
      color: Style.backgroundColor,
      duration: const Duration(milliseconds: 2000),
      child: Stack(children: [
        Align(
            alignment: Alignment(0, Style.wideScreen ? -0.92 : -0.9),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Style.blockM * 0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Style.blockM * 3,
                    height: Style.blockM * 1.5,
                    child: GestureDetector(
                      onTap: () {
                        Style.toPallet0();
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: Style.blockM * 1.3,
                        color: Style.primaryColor,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StreamBuilder<int>(
                          stream: currentNumOfLines.stream,
                          builder: (context, snapshot) {
                            return SizedBox(
                              width: Style.blockM * 3,
                              child: Text(
                                "${(snapshot.data ?? 0)}/${trees[widget.level][gameNum][1]}",
                                style: GoogleFonts.quicksand(
                                    fontSize: Style.blockM * 0.7,
                                    fontWeight: FontWeight.w800,
                                    color: Style.primaryColor),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }),
                      widget.level == 0 ? Container() :SizedBox(
                        height: Style.blockM*2,
                      ),
                      widget.level == 0? Container() : Row(
                          children: List.generate(
                              widget.level + 1,
                              (index) => Padding(
                                    child: GestureDetector(
                                      onTap: ()=>layerNum.add(index),
                                      child: StreamBuilder<Object>(
                                        stream: layerNumStream,
                                        builder: (context, snapshot) {
                                          return AnimatedContainer(
                                            duration: const Duration(milliseconds: 200),
                                            decoration: BoxDecoration(shape: BoxShape.circle, color: (snapshot.data ?? 0 )==index ? Style.accentColor : Colors.white),
                                            width: Style.blockM*1.5,
                                            height: Style.blockM*1.5,

                                            child: Center(child: Text(index.toString(), style: Style.getTextStyle_1(),)),
                                          );
                                        }
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: Style.blockM * 0.5),
                                  ))),
                    ],
                  ),
                  SizedBox(
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
                            onTap: () => onPressedEye(context),
                            child: Icon(Icons.remove_red_eye, size: Style.blockM * 1, color: Style.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        Align(
          alignment: Alignment(0, Style.wideScreen ? 0 : 0.2),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Field(
              key: Key("${widget.level} $gameNum"),
              currentNumOfLines: currentNumOfLines,
              tree: trees[widget.level][gameNum],
              isGameOver: isGameOver,
              showAnswer: showAnswerStream,
              layerNumStream: layerNumStream,
              layerFullNum: widget.level+1,
            ),
          ),
        ),
        StreamBuilder<bool>(
            stream: isGameOver.stream,
            builder: (context, snapshot) {
              ifGameIsOver();
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: snapshot.data == true && trees[widget.level].length > gameNum
                    ? Align(
                        alignment: Alignment(0, Style.wideScreen ? 0.9 : 0.8),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Style.blockM * 0.2),
                              )),
                              minimumSize: MaterialStateProperty.all(Size.zero),
                              padding: MaterialStateProperty.all(EdgeInsets.zero),
                              backgroundColor: MaterialStateProperty.all(Style.primaryColor),
                              overlayColor: MaterialStateProperty.all(Style.secondaryColor.withOpacity(0.1)),
                              elevation: MaterialStateProperty.all(0)),
                          onPressed: () {
                            trees[widget.level].length - 1 == gameNum ? Navigator.pop(context) : startNewGame();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: Style.blockM * 0.5, horizontal: 2.5 * Style.blockM),
                            child: Text(trees[widget.level].length - 1 == gameNum ? "Back" : "Next",
                                style: GoogleFonts.quicksand(
                                    fontSize: Style.blockM * 1.4,
                                    fontWeight: FontWeight.w800,
                                    color: Style.secondaryColor)),
                          ),
                        ),
                      )
                    : Container(),
              );
            }),
        Positioned(
            bottom: Style.blockM * 1,
            left: Style.block * 2.5,
            child: SizedBox(
              width: Style.block * 15,
              height: Style.blockM,
              child: Center(
                child: Text(
                  "Level ${gameNum + 1} from ${trees[widget.level].length}",
                  style: GoogleFonts.quicksand(
                      fontSize: Style.blockM * 0.7, fontWeight: FontWeight.w800, color: Style.primaryColor),
                ),
              ),
            ))
      ]),
    ));
  }
}
