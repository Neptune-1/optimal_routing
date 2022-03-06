import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optimal_routing/pages/level_page.dart';

import '../data/trees.dart';
import '../prefs.dart';
import '../styles.dart';
import '../widgets/field.dart';

class ExplainPage extends StatefulWidget {
  const ExplainPage({Key? key}) : super(key: key);

  @override
  State<ExplainPage> createState() => _ExplainPageState();
}

class _ExplainPageState extends State<ExplainPage> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  int currentLinesNumber = 0;
  final StreamController<int> currentNumOfLines = StreamController();
  List tree = [[[0, 0], [2, 0], [2, 2], [0, 2]], 6, [[[0, 0], [0, 1]], [[0, 1], [0, 2]], [[0, 1], [1, 1]], [[1, 1], [2, 1]], [[2, 0], [2, 1]], [[2, 1], [2, 2]]], 3];
  //final StreamController<int> timerStream = StreamController();
  final StreamController<bool> isGameOver = StreamController();
  final StreamController<bool> showAnswer = StreamController();
  late final Stream<bool> showAnswerStream;
  int explainStep = 0;
  List<String> explainTexts = ["Tap on the gray lines to connect the neighboring points", "To complete the level, connect all the marked points with a certain number of lines \n(Tap on the 'eye' to see the answer, if you need help)", ];

  // late Timer timer;

  final int answerShowTime = 5;

  @override
  void initState() {
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
    isGameOver.add(false);
    setState(() {});
  }

  ifGameIsOver() {
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
  getSelection(Widget child, activate){
    return Container(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Style.blockM*0.5),color: Colors.white.withOpacity(0.1), border: Border.all(
          width: Style.blockM*0.15,
          color: Style.accentColor.withOpacity(activate ? 1 : 0),
          style: BorderStyle.solid,
        ),),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Style.blockM*0.2, vertical: Style.blockM*0.1),
              child:child,
            ),
          ],
        ),
      ),
    );
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
                        onTap: (){
                          Prefs.setBool("new", false);
                          Navigator.push(context, PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => const LevelPage(),
                            transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                            transitionDuration: const Duration(milliseconds: 300),
                          ));},
                        child: Text(
                          "skip",
                          style: GoogleFonts.quicksand(
                              fontSize: Style.blockM * 1, fontWeight: FontWeight.w800, color: Style.primaryColor),
                        ),
                      ),
                    ),

                    getSelection(
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
                                        color: Colors.black,
                                        strokeWidth: Style.blockM * 0.1,
                                      ));
                                    }),
                              ),
                            ),
                            Center(
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => showAnswerAndHide(),
                                child: Icon(Icons.remove_red_eye, size: Style.blockM * 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                        explainStep == 1
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
         Align(
            alignment: const Alignment(0, -0.8),
            child: StreamBuilder<int>(
                stream: currentNumOfLines.stream,
                builder: (context, snapshot) {
                  if(snapshot.hasData && explainStep == 0){
                    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() => explainStep=1));
                  }
                  return getSelection(Text(
                    "${(snapshot.data ?? 0)}/${tree[1]}",
                    style: GoogleFonts.quicksand(
                        fontSize: Style.blockM * 0.7, fontWeight: FontWeight.w800, color: Style.primaryColor),
                    textAlign: TextAlign.center,
                  ), explainStep==1);
                }),
          ),
          Center(
            child: getSelection(
               SizedBox(
                 width: Style.blockM*10,
                 height:  Style.blockM*10,
                 child: Field(
                    currentNumOfLines: currentNumOfLines,
                    tree: tree,
                    isGameOver: isGameOver,
                    showLines: true,
                    showAnswer: showAnswerStream),
               ),
            explainStep==0),
          ),
          StreamBuilder<bool>(
              stream: isGameOver.stream,
              builder: (context, snapshot) {
                ifGameIsOver();
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: snapshot.data == true
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
                              Prefs.setBool("new", false);
                              Navigator.push(context, PageRouteBuilder(
                              pageBuilder: (c, a1, a2) => const LevelPage(),
                              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                              transitionDuration: const Duration(milliseconds: 300),
                            ));},
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: Style.blockM * 0.5, horizontal: 2.5 * Style.blockM),
                              child: Text("GO",
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
          Align(
            alignment: const Alignment(0, -0.5),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Style.blockM*2),
              child: Text(
                explainTexts[explainStep%explainTexts.length],
                style: GoogleFonts.quicksand(
                    fontSize: Style.blockM * 0.7, fontWeight: FontWeight.w800, color: Style.primaryColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),

        ]));
  }
}
