import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optimal_routing/data_structures.dart';
import 'package:optimal_routing/pages/game_page_layers.dart';
import 'package:optimal_routing/widgets/field/field_projection.dart';

import '../consts/styles.dart';
import '../data/trees.dart';
import '../utils/prefs.dart';
import '../widgets/field/field_layers.dart';
import 'level_page_layers.dart';

class ExplainPage extends StatefulWidget {
  const ExplainPage({Key? key}) : super(key: key);

  @override
  State<ExplainPage> createState() => _ExplainPageState();
}

class _ExplainPageState extends State<ExplainPage> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(keepPage: true);
  final StreamController<FieldData> fieldProjectionController = StreamController<FieldData>();
  late final Stream<FieldData> fieldProjectionStream;

  @override
  void initState() {
    fieldProjectionStream = fieldProjectionController.stream.asBroadcastStream();
    _pageController.addListener(() {
      if ((_pageController.page ?? 0).round() == 3) {
        Future.delayed(
            const Duration(milliseconds: 10),
            () => fieldProjectionController.add(FieldData(routesH: [
                  [
                    [false, true, false],
                    [false, false, false],
                    [false, false, false],
                  ],
                  [
                    [false, false, false],
                    [false, true, false],
                    [false, false, false],
                  ],
                ], routesV: [
                  [
                    [true, true, false],
                    [false, false, false],
                    [false, false, false],
                  ],
                  [
                    [false, false, false],
                    [false, false, false],
                    [true, true, false],
                  ],
                ], points: [
                  [
                    [false, true, false],
                    [false, true, false],
                    [false, false, false],
                  ],
                  [
                    [false, false, false],
                    [false, true, false],
                    [false, true, false],
                  ],
                ], targets: [
                  [const Point(0, 0), const Point(0, 2)],
                  [const Point(2, 2), const Point(2, 0)],
                ], routeIsConnected: false, fieldSize: 3, isGameOver: false)));
      }
    });
    fieldProjectionController.add(FieldData(routesH: [
      [
        [false, true, false],
        [false, false, false],
        [false, false, false],
      ],
      [
        [false, false, false],
        [false, true, false],
        [false, false, false],
      ],
    ], routesV: [
      [
        [true, true, false],
        [false, false, false],
        [false, false, false],
      ],
      [
        [false, false, false],
        [false, false, false],
        [true, true, false],
      ],
    ], points: [
      [
        [false, true, false],
        [false, true, false],
        [false, false, false],
      ],
      [
        [false, false, false],
        [false, true, false],
        [false, true, false],
      ],
    ], targets: [
      [const Point(0, 0), const Point(0, 2)],
      [const Point(2, 2), const Point(2, 0)],
    ], routeIsConnected: false, fieldSize: 3, isGameOver: false));

    super.initState();
  }

  getSelection(Widget child, activate) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Style.blockM * 0.5),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(
          width: Style.blockM * 0.15,
          color: Style.accentColor.withOpacity(activate ? 1 : 0),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Style.blockM * 0.2, vertical: Style.blockM * 0.1),
            child: child,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Style.init(context);
    return Scaffold(
        backgroundColor: Style.backgroundColor,
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: Style.blockH * 2.5,
                    ),
                    Text(
                      "How to play?",
                      style: Style.getTextStyle_2(),
                    ),
                    SizedBox(
                      height: Style.blockH * 4,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Just connect the ",
                        children: [
                          TextSpan(text: "yellow", style: Style.getTextStyle_1(color: Style.accentColor)),
                          const TextSpan(text: " dots")
                        ],
                        style: Style.getTextStyle_1(color: Style.primaryColor),
                      ),
                    ),
                    SizedBox(
                      height: Style.blockH * 3,
                    ),
                    Field(
                        currentNumOfLines: StreamController(),
                        tree: exampleTree,
                        isGameOver: StreamController(),
                        showTip: StreamController<int>().stream.asBroadcastStream(),
                        layerNumStream: StreamController<int>().stream.asBroadcastStream(),
                        layerFullNum: 1,
                        projectionData: StreamController())
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: Style.blockH * 2.5,
                    ),
                    Text(
                      "BUT",
                      style: Style.getTextStyle_2(),
                    ),
                    SizedBox(
                      height: Style.blockH * 1,
                    ),
                    Text(
                      "You can use only a definite number of lines",
                      style: Style.getTextStyle_1(),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: Style.blockH * 2,
                    ),
                    SvgPicture.asset(
                      "assets/explain_1_page_0.svg",
                      height: Style.blockH * 2.5,
                    ),
                    SizedBox(
                      height: Style.blockH * 2.5,
                    ),
                    SvgPicture.asset(
                      "assets/explain_1_page_1.svg",
                      height: Style.blockH * 3,
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
                // Stack(
                //   children: [
                //     const GamePage(
                //       example: true,
                //       level: 0,
                //     ),
                //     Align(
                //       alignment: const Alignment(0, -0.5),
                //       child: Text(
                //         "Tip: Connect targets using\nswipes or taps, repeat movement\nto remove the connection",
                //         style: Style.getTextStyle_1(),
                //         textAlign: TextAlign.center,
                //       ),
                //     )
                //   ],
                // ),
                Column(
                  children: [
                    SizedBox(
                      height: Style.blockH * 2,
                    ),
                    Text(
                      "Too easy?",
                      style: Style.getTextStyle_2(),
                    ),
                    SizedBox(
                      height: Style.blockH * 0.5,
                    ),
                    Text(
                      "Imagine you have 2 fields,\n which are connected",
                      textAlign: TextAlign.center,
                      style: Style.getTextStyle_1(),
                    ),
                    SizedBox(
                      height: Style.blockH * 0.5,
                    ),
                    Icon(
                      Icons.swipe,
                      size: Style.blockM,
                    ),
                    SizedBox(
                      height: Style.blockH * 0.5,
                    ),
                    FieldProjection(
                        layerNum: 2,
                        layerNumController: StreamController(),
                        projectionDataStream: fieldProjectionStream,
                        rotateAnimation: true),
                    SizedBox(
                      height: Style.blockH * 0.5,
                    ),
                    SvgPicture.asset(
                      "assets/explain_3_page_1.svg",
                      height: Style.blockH * 5,
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
                Stack(
                  children: [
                    const GamePage(
                      example: true,
                      level: 1,
                    ),
                    Align(
                      alignment: const Alignment(0, 0.65),
                      child: Text(
                        "Tip: for selection\ntap on a layer on the 3D projection",
                        style: Style.getTextStyle_1(),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                )
              ],
            ),
            Align(
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
                onPressed: () {
                  if ((_pageController.page)!.round() != 3) {
                    _pageController.animateToPage((_pageController.page)!.round() + 1,
                        duration: const Duration(milliseconds: 300), curve: Curves.linearToEaseOut);
                  } else {
                    Prefs.setBool("new", false);
                    Navigator.pushAndRemoveUntil(
                      context,
                      Style.pageRouteBuilder(const LevelPage()),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: Style.blockM * 0.5, horizontal: 2.5 * Style.blockM),
                  child: AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        int page = 0;
                        if (_pageController.positions.isNotEmpty) page = (_pageController.page ?? 0).round();
                        return Text(
                            _pageController.positions.isEmpty
                                ? "Next"
                                : ([
                                    "Next",
                                    // "Try",
                                    "Next",
                                    "Try",
                                    "GO",
                                  ][page]),
                            style: GoogleFonts.quicksand(
                                fontSize: Style.blockM * 1.4,
                                fontWeight: FontWeight.w800,
                                color: Style.secondaryColor));
                      }),
                ),
              ),
            ),
            Positioned(
              top: Style.blockH * 1,
              left: Style.blockM * 0.5,
              child: AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    bool show = false;
                    if (_pageController.positions.isNotEmpty) if ((_pageController.page ?? 0) != 0) show = true;
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: show
                          ? SizedBox(
                              width: Style.blockM * 2.5,
                              child: GestureDetector(
                                onTap: () => _pageController.animateToPage((_pageController.page)!.round() - 1,
                                    duration: const Duration(milliseconds: 300), curve: Curves.linearToEaseOut),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: Style.blockM * 1.3,
                                  color: Style.primaryColor,
                                ),
                              ),
                            )
                          : Container(),
                    );
                  }),
            ),
            Align(
                alignment: const Alignment(0, 0.965), child: PageIndicator(pagesNumber: 4, controller: _pageController))
          ],
        ));
  }
}

class PageIndicator extends StatelessWidget {
  final int pagesNumber;
  final PageController controller;

  const PageIndicator({Key? key, required this.pagesNumber, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double diameter = Style.blockM * 0.55;
        double indicatorDiameter = diameter * 1;
        double spacer = diameter * 0.7;
        double pageNumDouble = controller.page ?? 0.0;
        return SizedBox(
          height: indicatorDiameter,
          width: pagesNumber * (diameter + spacer) - spacer + indicatorDiameter - diameter,
          child: Stack(
            children: [
              Row(
                children: List.generate(
                    pagesNumber,
                    (index) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: diameter,
                              width: diameter,
                              child: Center(
                                child: Container(
                                  height: diameter * 0.5,
                                  width: diameter * 0.5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Style.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            index != (pagesNumber - 1)
                                ? SizedBox(
                                    width: spacer,
                                  )
                                : Container()
                          ],
                        )),
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
              Positioned(
                left: pageNumDouble * (diameter + spacer),
                child: Container(
                  height: indicatorDiameter,
                  width: indicatorDiameter,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Style.accentColor,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
