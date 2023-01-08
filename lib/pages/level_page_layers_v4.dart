import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:optimal_routing/pages/game_page_layers.dart';

import '../consts/styles.dart';
import '../data_structures.dart';
import '../utils/prefs.dart';
import '../widgets/field/field_projection.dart';
import '../data/trees.dart';
import 'explain_page.dart';

class LevelPageV4 extends StatefulWidget {
  const LevelPageV4({Key? key}) : super(key: key);

  @override
  State<LevelPageV4> createState() => _LevelPageV4State();
}

class _LevelPageV4State extends State<LevelPageV4> with TickerProviderStateMixin {
  int level = 0;
  final InAppReview inAppReview = InAppReview.instance;
  late final List<Widget> allLevelFields;
  late final PageController levelsController;

  final List<String> levelsNames = ["Easy", "Medium", "Hard", "Extra Hard"];

  late final List<StreamController<FieldData>> fieldProjectionControllers;

  //late final List<Stream<FieldData>> fieldProjectionStreams;

  void choseLevel(int chosen) {
    setState(() {
      level = chosen;
    });
  }

  @override
  void initState() {
    super.initState();
    levelsController = PageController(keepPage: true, initialPage: level);
  }

  @override
  Widget build(BuildContext context) {
    Style.init(context);
    return Scaffold(
        backgroundColor: Style.backgroundColor,
        body: Stack(
          children: [
            Align(
              alignment: const Alignment(0.02, -0.5),
              child: SvgPicture.asset(
                "assets/logo_1.svg",
                height: Style.blockH * 7,
              ),
            ),
            //chose level
            Align(
              alignment: const Alignment(0, 0.4),
              child: SizedBox(
                height: Style.blockH * 1,
                child: PageView(
                  onPageChanged: choseLevel,
                  controller: levelsController,
                  children: levelsNames
                      .map((e) =>
                      SizedBox(
                        height: Style.blockH,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                e,
                                style: GoogleFonts.josefinSans(
                                    fontSize: Style.blockM * 1.3,
                                    fontWeight: FontWeight.w800,
                                    color: Style.primaryColor),
                              ), SizedBox(
                                width: Style.block * 0.5,),
                              SizedBox(
                                width: Style.block * 0.5,
                                height: Style.block * 0.5,

                                child: CircularProgressIndicator(
                                  value: ((Prefs.getInt(level.toString()) ?? 0) - 1) /
                                      trees[level].length,
                                  color: Style.accentColor,
                                  backgroundColor: Style.primaryColor,
                                  strokeWidth: 2.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                      .toList(),
                ),
              ),
            ),

            //fog
            Align(
              alignment: const Alignment(0, 0.4),
              child: IgnorePointer(
                ignoring: true,
                child: Container(
                  height: Style.blockH * 4,
                  width: Style.block * 20,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            Colors.white,
                            Colors.white,
                            Colors.white.withOpacity(0),
                            Colors.white.withOpacity(0),
                            Colors.white.withOpacity(0),
                            Colors.white,
                            Colors.white
                          ])),
                ),
              ),
            ),
            //arrows start
            Align(
              alignment: const Alignment(-0.9, 0.4),
              child: Material(
                color: Style.backgroundColor,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () =>
                      levelsController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInCubic,
                      ),
                  splashRadius: 24,
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0.9, 0.4),
              child: Material(
                color: Style.backgroundColor,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () =>
                      levelsController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInCubic,
                      ),
                  splashRadius: 24,
                ),
              ),
            ),
            //arrows end
            //progress line
            // Align(
            //   alignment: const Alignment(0, 0.5),
            //   child: IgnorePointer(
            //     ignoring: true,
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         AnimatedContainer(
            //           height: Style.blockH * 0.05,
            //           width: Style.blockH *
            //               4 *
            //               ((Prefs.getInt(level.toString()) ?? 0) - 1) /
            //               trees[level].length,
            //           color: Colors.amber.shade300,
            //           duration: const Duration(milliseconds: 400),
            //           curve: Curves.easeInCubic,
            //         ),
            //         AnimatedContainer(
            //           height: Style.blockH * 0.05,
            //           width: Style.blockH *
            //               4 *
            //               (1 - (((Prefs.getInt(level.toString()) ?? 0) - 1) / trees[level].length)),
            //           color: Colors.black,
            //           duration: const Duration(milliseconds: 400),
            //           curve: Curves.easeInCubic,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            //start btn
            Align(
              alignment: const Alignment(0, 0.7),
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Style.blockM * 0.2),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(Size.zero),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    backgroundColor: MaterialStateProperty.all(Style.accentColor),
                    overlayColor: MaterialStateProperty.all(Style.secondaryColor.withOpacity(0.1)),
                    elevation: MaterialStateProperty.all(0)),
                onPressed: () =>
                    Navigator.push(
                      context,
                      Style.pageRouteBuilder(GamePage(level: level)),
                    ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(Style.blockM * 2.5, Style.blockM * 0.7,
                      Style.blockM * 2.2, Style.blockM * 0.3),
                  child: Text(
                    "START",
                    style: GoogleFonts.josefinSans(
                        fontSize: Style.blockM * 1.3,
                        fontWeight: FontWeight.w800,
                        color: Style.primaryColor),
                  ),
                ),
              ),
            ),
            //how to play btn
            Align(
              alignment: const Alignment(0, 0.85),
              child: GestureDetector(
                onTap: () => Navigator.push(context, Style.pageRouteBuilder(const ExplainPage())),
                child: Text(
                  "How to play?",
                  style: GoogleFonts.josefinSans(
                      fontSize: Style.blockM * 1,
                      fontWeight: FontWeight.w500,
                      color: Style.primaryColor),
                ),
              ),
            ),
          ],
        ));
  }
}
