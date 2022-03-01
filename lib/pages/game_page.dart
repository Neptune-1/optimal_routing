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
  final StreamController<String> currentNumOfLines = StreamController();
  final StreamController<int> timerStream = StreamController();
  late final Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timerStream.add(timer.tick);
    });
    super.initState();
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
                    StreamBuilder<int>(
                        stream: timerStream.stream,
                        builder: (context, snapshot) {
                          String time = "00:00";

                          if(snapshot.hasData){
                            String minutes = ((snapshot.data  as int)~/60).toString();
                            String seconds = ((snapshot.data  as int)%60).toString();
                            if(minutes.length==1) minutes = '0' + minutes;
                            if(seconds.length==1) seconds = '0' + seconds;
                            time = "$minutes:$seconds";
                            if((snapshot.data  as int)~/60 > 60){
                              time = "Reeally long";
                            }
                          }

                          return SizedBox(
                            width: Style.blockM*3,
                            child: Text(
                              time,
                              style: GoogleFonts.quicksand(fontSize: Style.blockM * 0.6, fontWeight: FontWeight.w800, color: Style.primaryColor),
                            ),
                          );
                        }
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
