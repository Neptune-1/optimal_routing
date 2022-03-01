import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optimal_routing/pages/game_page.dart';

import '../styles.dart';

class LevelPage extends StatefulWidget {
  const LevelPage({Key? key}) : super(key: key);

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  int level = 0;

  void choseLevel(int chosen) {
    setState(() {
      level = chosen;
    });
  }

  @override
  Widget build(BuildContext context) {
    Style.init(context);
    Style.toPallet1();
    return Scaffold(
        backgroundColor: Style.backgroundColor,
        body: Stack(
          children: [
            Align(
              alignment: const Alignment(0, -0.2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => choseLevel(0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: Style.blockM,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            width: level == 0 ? Style.blockM * 0.35 : 0,
                            height: level == 0 ? Style.blockM * 0.35 : 0,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.amber.shade500),
                          ),
                        ),
                        Text("Easy",
                            style: GoogleFonts.quicksand(fontSize: Style.blockM * 1, fontWeight: FontWeight.w800)),
                        SizedBox(
                          width: Style.blockM,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => choseLevel(1),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: Style.blockM,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            width: level == 1 ? Style.blockM * 0.35 : 0,
                            height: level == 1 ? Style.blockM * 0.35 : 0,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Style.accentColor),
                          ),
                        ),
                        Text("Middle",
                            style: GoogleFonts.quicksand(fontSize: Style.blockM * 1, fontWeight: FontWeight.w800, color: Style.primaryColor)),
                        SizedBox(
                          width: Style.blockM,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => choseLevel(2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: Style.blockM,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            width: level == 2 ? Style.blockM * 0.35 : 0,
                            height: level == 2 ? Style.blockM * 0.35 : 0,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Style.accentColor),
                          ),
                        ),
                        Text("Hard",
                            style: GoogleFonts.quicksand(fontSize: Style.blockM * 1, fontWeight: FontWeight.w800, color: Style.primaryColor)),
                        SizedBox(
                          width: Style.blockM,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.8),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Style.primaryColor),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    elevation: MaterialStateProperty.all(0)),
                onPressed: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GamePage(level: level))),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: Style.blockM * 0.3, horizontal: 5 * Style.blockM),
                  child: Text("Start",
                      style: GoogleFonts.quicksand(fontSize: Style.blockM * 0.7, fontWeight: FontWeight.w800, color: Style.primaryColor)),
                ),
              ),
            )
          ],
        ));
  }
}
