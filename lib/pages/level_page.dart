import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optimal_routing/pages/game_page.dart';

import '../consts/styles.dart';

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
    return Scaffold(
        backgroundColor: Style.backgroundColor,
        body: Stack(
          children: [
            Align(
              alignment: const Alignment(0, -0.2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                  List.generate(2, (index) => GestureDetector(
                    onTap: () => choseLevel(index),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: Style.blockM,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            width: level == index ? Style.blockM * 0.5 : 0,
                            height: level == index ? Style.blockM * 0.5 : 0,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.amber.shade500),
                          ),
                        ),
                        Text(["Classical", "Just one touch"][index],
                            style: GoogleFonts.quicksand(
                                fontSize: Style.blockM * 1.5, fontWeight: FontWeight.w800, color: Style.primaryColor)),
                        SizedBox(
                          width: Style.blockM,
                        ),
                      ],
                    ),
                  ))

              ),
            ),
            Align(
              alignment: const Alignment(0, 0.8),
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
                onPressed: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => GamePage(level: level),
                    transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                    transitionDuration: Duration(milliseconds: 300),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: Style.blockM * 0.5, horizontal: 2.5 * Style.blockM),
                  child: Text("START",
                      style: GoogleFonts.quicksand(
                          fontSize: Style.blockM * 1.4, fontWeight: FontWeight.w800, color: Style.secondaryColor)),
                ),
              ),
            )
          ],
        ));
  }
}
