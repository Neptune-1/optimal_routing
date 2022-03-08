import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  int currentLinesNumber = 0;
  final StreamController<int> currentNumOfLines = StreamController();
  final StreamController<int> timerStream = StreamController();
  final StreamController<bool> isGameOver = StreamController();
  final StreamController<bool> showAnswer = StreamController();
  late final Stream<bool> showAnswerStream;

  // late Timer timer;
  late int gameNum;
  final int answerShowTime = 5;

  @override
  void initState() {
    gameNum = Prefs.getInt(widget.level.toString()) ?? 0;
    if (gameNum != 0) gameNum -= 1;
    showAnswerStream = showAnswer.stream.asBroadcastStream();
    // timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   timerStream.add(timer.tick);
    // });

    super.initState();

    controller = AnimationController(
      value: 1,
      vsync: this,
      duration: Duration(seconds: answerShowTime),
    );
  }

  void startNewGame() {
    // timer.cancel();
    // timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   timerStream.add(timer.tick);
    // });
    currentNumOfLines.add(0);
    gameNum != trees[widget.level].length - 1 ? gameNum++ : null;
    isGameOver.add(false);
    setState(() {});
  }

  ifGameIsOver() {
    Prefs.setInt(widget.level.toString(), gameNum + 1);
    // timer.cancel();
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
  Widget build(BuildContext context) {
    Style.init(context);
    return Scaffold(
        backgroundColor: Style.backgroundColor,
        body: Stack(children: [
          Align(
              alignment: const Alignment(0, kIsWeb ? -0.95 : -0.9),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Style.blockM * 0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Style.blockM * 3,
                      height: Style.blockM * 1.5,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_back_ios, size: Style.blockM * 1.3, color: Style.primaryColor,),
                      ),
                    ),
                    StreamBuilder<int>(
                        stream: currentNumOfLines.stream,
                        builder: (context, snapshot) {
                          return SizedBox(
                            width: Style.blockM * 3,
                            child: Text(
                              "${(snapshot.data ?? 0)}/${trees[widget.level][gameNum][1]}",
                              style: GoogleFonts.quicksand(
                                  fontSize: Style.blockM * 0.7, fontWeight: FontWeight.w800, color: Style.primaryColor),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }),
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
                              child: Icon(Icons.remove_red_eye, size: Style.blockM * 1,
                                  color:Style.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // StreamBuilder<int>(
                    //     stream: timerStream.stream,
                    //     builder: (context, snapshot) {
                    //       String time = "00:00";
                    //
                    //       if (snapshot.hasData) {
                    //         String minutes = ((snapshot.data as int) ~/ 60).toString();
                    //         String seconds = ((snapshot.data as int) % 60).toString();
                    //         if (minutes.length == 1) minutes = '0' + minutes;
                    //         if (seconds.length == 1) seconds = '0' + seconds;
                    //         time = "$minutes:$seconds";
                    //         if ((snapshot.data as int) ~/ 60 > 60) {
                    //           time = "Reeally long";
                    //         }
                    //       }
                    //
                    //       return SizedBox(
                    //         width: Style.blockM * 3,
                    //         child: Text(
                    //           time,
                    //           style: GoogleFonts.quicksand(
                    //               fontSize: Style.blockM * 0.7, fontWeight: FontWeight.w800, color: Style.primaryColor),
                    //           textAlign: TextAlign.right,
                    //         ),
                    //       );
                    //     }),
                  ],
                ),
              )),

          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Field(
                  key: UniqueKey(),
                  currentNumOfLines: currentNumOfLines,
                  tree: trees[widget.level][gameNum],
                  isGameOver: isGameOver,
                  showAnswer: showAnswerStream),
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
                              padding:
                                  EdgeInsets.symmetric(vertical: Style.blockM * 0.5, horizontal: 2.5 * Style.blockM),
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
        ]));
  }
}
