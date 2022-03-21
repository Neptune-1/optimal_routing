import 'package:flutter/foundation.dart';
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                      kIsWeb ? 2 : 4,
                      (index) => GestureDetector(
                            onTap: () => choseLevel(index),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: Style.blockM * 0.3),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: EdgeInsets.symmetric(horizontal: Style.blockM * 0.3),
                                    decoration: BoxDecoration(
                                        color: Style.accentColor.withOpacity(level == index ? 0.7 : 0),
                                        borderRadius: BorderRadius.circular(Style.blockM * 0.2)),
                                    height: level == index ? Style.blockM * 3 : Style.blockM * 2,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(["Classical", "Just one touch", "One direction", "Day-Night"][index],
                                            style: GoogleFonts.quicksand(
                                                fontSize: Style.blockM * 1.5,
                                                fontWeight: FontWeight.w800,
                                                color: Style.primaryColor)),
                                        level == index
                                            ? Flexible(
                                                child: Text(
                                                    [
                                                      "Just connect all targets",
                                                      "Don't take your finger off the screen",
                                                      "Connect targets according to showed direction",
                                                      "Connect ALL targets (you'll see them with 5s delay)"
                                                    ][index],
                                                    overflow: TextOverflow.fade,
                                                    style: GoogleFonts.quicksand(
                                                        fontSize: Style.blockM * 0.7,
                                                        fontWeight: FontWeight.w800,
                                                        color: Style.primaryColor.withOpacity(0.7))),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))),
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
                    transitionsBuilder: (c, anim, a2, child) => ScaleTransition(
                        scale: Tween<double>(begin: 0.3, end: 1).animate(CurvedAnimation(
                          parent: anim,
                          curve: Curves.easeInOutExpo,
                          reverseCurve: Curves.easeInOutExpo,
                        )),
                        child: Opacity(
                          child: child,
                          opacity: Tween<double>(begin: 0, end: 1)
                              .animate(CurvedAnimation(
                                parent: anim,
                                curve: Curves.easeInOutExpo,
                                reverseCurve: Curves.easeInOutExpo,
                              ))
                              .value,
                        )),
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
