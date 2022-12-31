import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:optimal_routing/pages/game_page_layers.dart';

import '../consts/styles.dart';
import '../widgets/4p.dart';
import 'explain_page.dart';

class LevelPageV2 extends StatefulWidget {
  const LevelPageV2({Key? key}) : super(key: key);

  @override
  State<LevelPageV2> createState() => _LevelPageV2State();
}

class _LevelPageV2State extends State<LevelPageV2> with TickerProviderStateMixin {
  int level = 0;
  final InAppReview inAppReview = InAppReview.instance;

  void choseLevel(int chosen) {
    // setState(() {
    //   level = chosen;
    Navigator.push(context, Style.pageRouteBuilder(GamePage(level: chosen)));
    // });
  }

  @override
  Widget build(BuildContext context) {
    Style.init(context);
    return OverflowBox(
      child: Scaffold(
          backgroundColor: Style.backgroundColor,
          body: Stack(
            children: [
              const Align(
                alignment: Alignment(0.8, 0.8),
                child: P4(n: 2,),
              ),
              const Align(
                alignment: Alignment(0.8, -0.1),
                child: P4(n: 2,),
              ),
              const Align(
                alignment: Alignment(-0.9, -0.3),
                child: P4(n: 3,),
              ),
              const Align(
                alignment: Alignment(-0.7, 0.9),
                child: P4(n: 4,),
              ),
              const Align(
                alignment: Alignment(-0.88, -0.9),
                child: P4(n: 2,),
              ),
              const Align(
                alignment: Alignment(0.85, -0.7),
                child: P4(n: 5,),
              ),
              Align(
                alignment: const Alignment(0, 0.7),
                child: GestureDetector(
                  onTap: () => Navigator.push(context, Style.pageRouteBuilder(const ExplainPage())),
                  child: Text(
                    "How to play?",
                    style: GoogleFonts.josefinSans(
                        fontSize: Style.blockM * 1.2,
                        fontWeight: FontWeight.w500,
                        color: Style.primaryColor),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, 0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                        kIsWeb ? 2 : 3,
                        (index) => GestureDetector(
                              onTap: () => choseLevel(index),
                              behavior: HitTestBehavior.translucent,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: Style.blockM * 0.5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      [Icons.grid_3x3, Icons.grid_4x4, Icons.layers][index],
                                      size: Style.block * 1.2,
                                      color: Style.primaryColor.withOpacity(0.9),
                                    ),
                                    SizedBox(
                                      width: Style.block * 0.8,
                                    ),
                                    Text(["easy", "middle", "hard"][index],
                                        style: GoogleFonts.josefinSans(
                                            fontSize: Style.blockM * 2,
                                            fontWeight: FontWeight.w800,
                                            color: Style.primaryColor)),
                                  ],
                                ),
                              ),
                            ))),
              ),
              // Align(
              //     alignment: const Alignment(0, 0.7),
              //     child: ElevatedButton(
              //       style: ButtonStyle(
              //           shape:
              //               MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(Style.blockM * 0.2),
              //           )),
              //           minimumSize: MaterialStateProperty.all(Size.zero),
              //           padding: MaterialStateProperty.all(EdgeInsets.zero),
              //           backgroundColor: MaterialStateProperty.all(Style.primaryColor),
              //           overlayColor:
              //               MaterialStateProperty.all(Style.secondaryColor.withOpacity(0.1)),
              //           elevation: MaterialStateProperty.all(0)),
              //       onPressed: () =>
              //           Navigator.push(context, Style.pageRouteBuilder(GamePage(level: level))),
              //       child: Padding(
              //         padding: EdgeInsets.symmetric(
              //             vertical: Style.blockM * 0.5, horizontal: 2.5 * Style.blockM),
              //         child: Text("START",
              //             style: GoogleFonts.josefinSans(
              //                 fontSize: Style.blockM * 1.4,
              //                 fontWeight: FontWeight.w800,
              //                 color: Style.secondaryColor)),
              //       ),
              //     ))
            ],
          )),
    );
  }
}
