import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../consts/styles.dart';
import '../data/trees.dart';
import '../utils/prefs.dart';
import '../widgets/field/field.dart';

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
  final StreamController<bool> toNight = StreamController();
  late final Stream<bool> showAnswerStream;
  late final Stream<bool?> toNightStream;
  late final AnimationController dayNightController;
  late final Timer dayNightTimer;

  int direction = Random().nextInt(4);
  late int gameNum;
  final int answerShowTime = 5;
  final int dayNightTime = 5;

  @override
  void initState() {
    Style.toPallet0();
    gameNum = Prefs.getInt(widget.level.toString()) ?? 0;
    if (gameNum != 0) gameNum -= 1;
    showAnswerStream = showAnswer.stream.asBroadcastStream();
    toNightStream = toNight.stream.asBroadcastStream();
    super.initState();

    controller = AnimationController(
      value: 1,
      vsync: this,
      duration: Duration(seconds: answerShowTime),
    );

    dayNightController = AnimationController(
      value: 0,
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    if (widget.level == 3) {
      dayNightTimer = Timer.periodic(Duration(seconds: dayNightTime), (timer) {
        toNight.add(timer.tick % 2 == 0);
      });
      toNightStream.listen((event) {

          if (event ?? true) {
            if (dayNightController.value == 0) {
              dayNightController.forward(from: 0);
              Style.toPallet1();
              setState(() { });
            }
          } else {
            if (dayNightController.value == 1) {
              dayNightController.reverse(from: 1);
              Style.toPallet0();
              setState(() { });
            }
          }
      });
    }
  }

  void startNewGame() {
    toNight.add(false);
    direction = Random().nextInt(4);
    currentNumOfLines.add(0);
    gameNum != trees[widget.level].length - 1 ? gameNum++ : null;
    isGameOver.add(false);
    setState(() {});
  }

  ifGameIsOver() {
    Prefs.setInt(widget.level.toString(), gameNum + 1);
  }

  showAnswerAndHide() {
    if (!controller.isAnimating) {
      controller.forward(from: 0);
      showAnswer.add(true);
      Future.delayed(Duration(seconds: answerShowTime), () {
        showAnswer.add(false);
        controller.value = 1;
        controller.stop(canceled: false);
      });
    }
  }

  @override
  void dispose(){
    controller.dispose();
    dayNightController.dispose();
    isGameOver.close();
    showAnswer.close();
    toNight.close();
    if(widget.level ==3) dayNightTimer.cancel();

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
            alignment: const Alignment(0, kIsWeb ? -0.95 : -0.9),
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
                      SizedBox(
                        height: widget.level == 2 || widget.level == 3 ? Style.blockM * 2 : 0,
                      ),
                      widget.level == 2
                          ? Transform.rotate(
                              angle: [0, pi, -pi / 2, pi / 2][direction].toDouble(),
                              child: Icon(
                                Icons.arrow_right,
                                size: Style.blockM * 4,
                                color: Style.accentColor,
                              ),
                            )
                          : (widget.level == 3
                              ? Lottie.asset('assets/sun_moon_animation.json',
                                  width: Style.blockM * 4, height: Style.blockM * 4, controller: dayNightController)
                              : Container()),
                      SizedBox(
                        height: widget.level == 3 ? Style.blockM * 1 : 0,
                      ),
                      widget.level == 3 ? StreamBuilder<bool?>(
                          stream: toNightStream,
                          builder: (context, snapshot) {
                            return AnimatedContainer(
                              duration: Duration(seconds: dayNightTime),
                              width: (snapshot.data ?? true) ? Style.blockM * 2 : Style.blockM * 0.2,
                              height: Style.blockM * 0.2,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                decoration: BoxDecoration(
                                    color: Style.accentColor, borderRadius: BorderRadius.circular(Style.blockM * 0.1)),
                              ),
                            );
                          }) : Container()
                    ],
                  ),
                  SizedBox(
                    width: Style.blockM * 3,
                    height: Style.blockM * 1.5,
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            width: Style.blockM * 1.5,
                            height: Style.blockM * 1.5,
                            child: AnimatedBuilder(
                                animation: controller,
                                builder: (context, w) {
                                  return Center(
                                      child: CircularProgressIndicator(
                                    value: 1 - controller.value,
                                    color: Style.primaryColor,
                                    strokeWidth: Style.blockM * 0.1,
                                  ));
                                }),
                          ),
                        ),
                        Center(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => showAnswerAndHide(),
                            child: Icon(Icons.remove_red_eye, size: Style.blockM * 1, color: Style.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Field(
                key: Key("${widget.level} $gameNum"),
                currentNumOfLines: currentNumOfLines,
                tree: trees[widget.level][gameNum],
                isGameOver: isGameOver,
                showAnswer: showAnswerStream,
                oneTouchMode: widget.level == 1,
                direction: widget.level == 2 ? direction : null,
                toNightStream: widget.level == 3 ? toNightStream : null),
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
                        alignment: const Alignment(0, kIsWeb ? 0.9 : 0.8),
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
