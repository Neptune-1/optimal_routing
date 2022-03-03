import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/trees.dart';
import '../styles.dart';
import '../widgets/field.dart';

class GamePage extends StatefulWidget {
  final int level;

  const GamePage({Key? key, required this.level}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int currentLinesNumber = 0;
  final StreamController<int> currentNumOfLines = StreamController();
  final StreamController<int> timerStream = StreamController();
  final StreamController<bool> isGameOver = StreamController();
  late Timer timer;
  int gameNum = 0;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timerStream.add(timer.tick);
    });
    super.initState();
  }

  void startNewGame() {
    print("restartrestartrestartrestartrestart");
    timer.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timerStream.add(timer.tick);
    });
    currentNumOfLines.add(0);
    gameNum != trees[widget.level].length ? gameNum++ : null;
    isGameOver.add(false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Style.init(context);
    Style.toPallet1();
    return Scaffold(
        backgroundColor: Style.backgroundColor,
        body: Stack(children: [
          Align(
              alignment: const Alignment(0, -0.95),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Style.blockM * 0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder<int>(
                        stream: currentNumOfLines.stream,
                        builder: (context, snapshot) {
                          return SizedBox(
                            width: Style.blockM * 3,
                            child: Text(
                              "${snapshot.data ?? 0}/${trees[widget.level][gameNum][1]}",
                              style: GoogleFonts.quicksand(
                                  fontSize: Style.blockM * 0.6, fontWeight: FontWeight.w800, color: Style.primaryColor),
                            ),
                          );
                        }),
                    Text(
                      ["Easy", "Middle", "Hard"][widget.level],
                      style: GoogleFonts.quicksand(
                          fontSize: Style.blockM * 1, fontWeight: FontWeight.w800, color: Style.primaryColor),
                    ),
                    StreamBuilder<int>(
                        stream: timerStream.stream,
                        builder: (context, snapshot) {
                          String time = "00:00";

                          if (snapshot.hasData) {
                            String minutes = ((snapshot.data as int) ~/ 60).toString();
                            String seconds = ((snapshot.data as int) % 60).toString();
                            if (minutes.length == 1) minutes = '0' + minutes;
                            if (seconds.length == 1) seconds = '0' + seconds;
                            time = "$minutes:$seconds";
                            if ((snapshot.data as int) ~/ 60 > 60) {
                              time = "Reeally long";
                            }
                          }

                          return SizedBox(
                            width: Style.blockM * 3,
                            child: Text(
                              time,
                              style: GoogleFonts.quicksand(
                                  fontSize: Style.blockM * 0.6, fontWeight: FontWeight.w800, color: Style.primaryColor),
                            ),
                          );
                        }),
                  ],
                ),
              )),
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Field(
                  key: UniqueKey(),
                  currentNumOfLines: currentNumOfLines,
                  level: widget.level,
                  gameNum: gameNum,
                  isGameOver: isGameOver),
            ),
          ),
          StreamBuilder<bool>(
              stream: isGameOver.stream,
              builder: (context, snapshot) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: snapshot.data == true
                      ? Align(
                          alignment: const Alignment(0, 0.9),
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
                            onPressed: () {startNewGame();},
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: Style.blockM * 0.5, horizontal: 5 * Style.blockM),
                              child: Text("Next",
                                  style: GoogleFonts.quicksand(
                                      fontSize: Style.blockM * 0.7,
                                      fontWeight: FontWeight.w800,
                                      color: Style.secondaryColor)),
                            ),
                          ),
                        )
                      : Container(),
                );
              })
        ]));
  }
}
