import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:optimal_routing/pages/game_page_layers.dart';

import '../consts/styles.dart';
import '../data_structures.dart';
import '../utils/prefs.dart';
import '../data/trees.dart';
import '../widgets/pallete.dart';
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
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Stack(
            children: [
              const Align(
                alignment: Alignment(0.90, -0.95),
                child: Palette(),
              ),
              Align(
                alignment: const Alignment(0.02, -0.5),
                child: GestureDetector(
                  child: Style.coloredSVG(
                    path: "assets/logo_1.svg",
                    context: context,
                    height: Style.blockH * 7,
                  ),
                ),
              ),
              //chose level
              Align(
                alignment: const Alignment(0, 0.45),
                child: SizedBox(
                  height: Style.blockH * 1,
                  child: PageView(
                    onPageChanged: choseLevel,
                    controller: levelsController,
                    children: levelsNames
                        .map((e) => SizedBox(
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
                                          color: Theme.of(context).colorScheme.primary),
                                    ),
                                    SizedBox(
                                      width: Style.block * 0.5,
                                    ),
                                    SizedBox(
                                      width: Style.block * 0.5,
                                      height: Style.block * 0.5,
                                      child: CircularProgressIndicator(
                                        value: ((Prefs.getInt(level.toString()) ?? 0) - 1) /
                                            trees[level].length,
                                        color: Theme.of(context).colorScheme.secondary,
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        strokeWidth: Style.block * 0.13,
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
                alignment: const Alignment(0, 0.45),
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
                          Theme.of(context).colorScheme.background,
                          Theme.of(context).colorScheme.background,
                          Theme.of(context).colorScheme.background.withOpacity(0),
                          Theme.of(context).colorScheme.background.withOpacity(0),
                          Theme.of(context).colorScheme.background.withOpacity(0),
                          Theme.of(context).colorScheme.background,
                          Theme.of(context).colorScheme.background
                        ])),
                  ),
                ),
              ),
              //arrows start
              Align(
                alignment: const Alignment(-0.9, 0.45),
                child: Material(
                  color: Theme.of(context).colorScheme.background,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => levelsController.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInCubic,
                    ),
                    splashRadius: 24,
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.9, 0.45),
                child: Material(
                  color: Theme.of(context).colorScheme.background,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => levelsController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInCubic,
                    ),
                    splashRadius: 24,
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, 0.75),
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Style.blockM * 0.2),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(Size.zero),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      backgroundColor:
                          MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
                      overlayColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary.withOpacity(0.1)),
                      elevation: MaterialStateProperty.all(0)),
                  onPressed: () => Navigator.push(
                    context,
                    Style.pageRouteBuilder(GamePage(
                      level: level,
                      layerNum: level == 3 ? 2 : 1,
                    )),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(Style.blockM * 2.5, Style.blockM * 0.7,
                        Style.blockM * 2.2, Style.blockM * 0.3),
                    child: Text(
                      "START",
                      style: GoogleFonts.josefinSans(
                          fontSize: Style.blockM * 1.3,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ),
              //how to play btn
              Align(
                alignment: const Alignment(0, 0.9),
                child: GestureDetector(
                  onTap: () => Navigator.push(context, Style.pageRouteBuilder(const ExplainPage())),
                  child: Text(
                    "How to play?",
                    style: GoogleFonts.josefinSans(
                        fontSize: Style.blockM * 1,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
