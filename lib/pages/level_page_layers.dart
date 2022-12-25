import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:optimal_routing/pages/game_page_layers.dart';

import '../consts/styles.dart';
import 'explain_page.dart';

class LevelPage extends StatefulWidget {
  const LevelPage({Key? key}) : super(key: key);

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> with TickerProviderStateMixin {
  int level = 0;
  final InAppReview inAppReview = InAppReview.instance;

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
        body: SafeArea(
          bottom: true,
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(-1, -0.92),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Style.blockM * 0.2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () =>
                              inAppReview.openStoreListing(appStoreId: "1613405550") //async {
                          //if ((await inAppReview.isAvailable()) && Platform.isIOS)
                          //  inAppReview.requestReview();
                          //else
                          //}
                          ,
                          icon: Icon(
                            Icons.star_outline,
                            size: Style.blockM * 1.5,
                            color: Style.primaryColor,
                          ),
                          splashRadius: Style.blockM * 1,
                          splashColor: Style.accentColor.withOpacity(0.5)),
                      IconButton(
                        onPressed: () =>
                            Navigator.push(context, Style.pageRouteBuilder(const ExplainPage())),
                        icon: Icon(
                          Icons.info_outline,
                          size: Style.blockM * 1.3,
                          color: Style.primaryColor,
                        ),
                        splashRadius: Style.blockM * 1,
                        splashColor: Style.accentColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.02, -0.75),
                child: SvgPicture.asset(
                  "assets/logo.svg",
                  height: Style.blockM * 1.7,
                ),
              ),
              Align(
                alignment: const Alignment(0, 0.3),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                        kIsWeb ? 2 : 3,
                        (index) => GestureDetector(
                              onTap: () => choseLevel(index),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: Style.blockM * 0.1),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Style.blockM * 1.3,
                                          vertical: Style.blockM * 0.25),
                                      decoration: BoxDecoration(
                                          color: Style.accentColor
                                              .withOpacity(level == index ? 0.8 : 0),
                                          borderRadius: BorderRadius.circular(Style.blockM * 0.2)),
                                      child: Text(["Easy", "Middle", "Hard"][index],
                                          style: GoogleFonts.quicksand(
                                              fontSize: Style.blockM * 2,
                                              fontWeight: FontWeight.w800,
                                              color: Style.primaryColor)),
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
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Style.blockM * 0.2),
                        )),
                        minimumSize: MaterialStateProperty.all(Size.zero),
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                        backgroundColor: MaterialStateProperty.all(Style.primaryColor),
                        overlayColor:
                            MaterialStateProperty.all(Style.secondaryColor.withOpacity(0.1)),
                        elevation: MaterialStateProperty.all(0)),
                    onPressed: () =>
                        Navigator.push(context, Style.pageRouteBuilder(GamePage(level: level))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Style.blockM * 0.5, horizontal: 2.5 * Style.blockM),
                      child: Text("START",
                          style: GoogleFonts.quicksand(
                              fontSize: Style.blockM * 1.4,
                              fontWeight: FontWeight.w800,
                              color: Style.secondaryColor)),
                    ),
                  ))
            ],
          ),
        ));
  }
}
