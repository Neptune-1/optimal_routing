import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  StreamController<String> currentNumOfLines = StreamController();

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
                    StreamBuilder<String>(
                      stream: currentNumOfLines.stream,
                      builder: (context, snapshot) {
                        return  SizedBox(
                          width: Style.blockM*3,
                          child: Text(
                            snapshot.data ?? "??/??",
                            style: GoogleFonts.quicksand(fontSize: Style.blockM * 0.6, fontWeight: FontWeight.w800, color: Style.primaryColor),
                          ),
                        );
                      }
                    ),
                    Text(
                      ["Easy", "Middle", "Hard"][widget.level],
                      style: GoogleFonts.quicksand(fontSize: Style.blockM * 1, fontWeight: FontWeight.w800, color: Style.primaryColor),
                    ),
                    SizedBox(
                      width: Style.blockM*3,
                      child: Text(
                        "00:00",
                        style: GoogleFonts.quicksand(fontSize: Style.blockM * 0.6, fontWeight: FontWeight.w800, color: Style.primaryColor),
                      ),
                    ),
                  ],
                ),
              )),
          Center(
            child: Field(currentNumOfLines: currentNumOfLines, level:widget.level),
          )
        ]));
  }
}
