import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:optimal_routing/pages/game_page_layers.dart';

import '../consts/styles.dart';
import '../widgets/4p.dart';
import 'explain_page.dart';

class LevelPageV3 extends StatefulWidget {
  const LevelPageV3({Key? key}) : super(key: key);

  @override
  State<LevelPageV3> createState() => _LevelPageV3State();
}

class _LevelPageV3State extends State<LevelPageV3> with TickerProviderStateMixin {
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
    return Scaffold(
        backgroundColor: Style.backgroundColor,
        body: Padding(
          padding: EdgeInsets.only(top: Style.blockH * 2),
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: Style.block * 0.7,
                  height: Style.block * 0.7,
                  decoration: BoxDecoration(
                    color: Style.accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: Style.blockH * 9,
                left: Style.block * 10 - Style.block * 0.1,
                child: Container(
                  height: Style.block * 13,
                  width: Style.block * 0.2,
                  decoration: BoxDecoration(
                      color: Style.accentColor, borderRadius: BorderRadius.circular(Style.block)),
                ),
              ),
              Align(
                alignment: const Alignment(0, 0),
                child: Ring(
                  size: Style.block * 15,
                  children: [
                    Align(
                      alignment: const Alignment(0, 0.1),
                      child: Text(
                        "7x7",
                        style: GoogleFonts.josefinSans(
                          fontSize: Style.blockM * 0.6,
                          fontWeight: FontWeight.w800,
                          color: Style.primaryColor,
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, 0.1),
                      child: Text(
                        "8x8",
                        maxLines: 1,
                        style: GoogleFonts.josefinSans(
                          fontSize: Style.blockM * 0.6,
                          fontWeight: FontWeight.w800,
                          color: Style.primaryColor,
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, 0.1),
                      child: Text(
                        "9x9",
                        maxLines: 1,
                        style: GoogleFonts.josefinSans(
                          fontSize: Style.blockM * 0.6,
                          fontWeight: FontWeight.w800,
                          color: Style.primaryColor,
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, 0),
                      child: Text(
                        "10x10",
                        maxLines: 1,
                        style: GoogleFonts.josefinSans(
                          fontSize: Style.blockM * 0.45,
                          fontWeight: FontWeight.w800,
                          color: Style.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: const Alignment(0, 0),
                child: Ring(
                  size: Style.block * 9.8,
                  children: [
                    Icon(
                      Icons.square_outlined,
                      color: Style.primaryColor,
                      size: Style.block * 1.6 * 0.5,
                    ),
                    // Icon(
                    //   Icons.change_history,
                    //   color: Style.deactivatedColor,
                    //   size: Style.block * 1.6 * 0.55,
                    // ),
                    // Icon(
                    //   Icons.circle_outlined,
                    //   color: Style.primaryColor,
                    //   size: Style.block * 1.6 * 0.5,
                    // ),
                  ],
                ),
              ),
              Align(
                alignment: const Alignment(0, 0),
                child: Ring(
                  size: Style.block * 5,
                  children: [
                    Icon(
                      Icons.square,
                      color: Style.primaryColor,
                      size: Style.block * 1.6 * 0.4,
                    ),
                    Icon(
                      Icons.layers,
                      color: Style.primaryColor,
                      size: Style.block * 1.6 * 0.55,
                    ),
                  ],
                ),
              ),
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
                      overlayColor:
                          MaterialStateProperty.all(Style.secondaryColor.withOpacity(0.1)),
                      elevation: MaterialStateProperty.all(0)),
                  onPressed: () => Navigator.push(
                    context,
                    Style.pageRouteBuilder(GamePage(level: 0)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(Style.blockM * 2.5, Style.blockM * 0.7,
                        Style.blockM * 2.2, Style.blockM * 0.3),
                    child: Text("START",
                        style: GoogleFonts.josefinSans(
                            fontSize: Style.blockM * 1.3,
                            fontWeight: FontWeight.w800,
                            color: Style.primaryColor)),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class Ring extends StatefulWidget {
  final List<Widget> children;
  final double size;

  const Ring({Key? key, required this.children, required this.size}) : super(key: key);

  @override
  State<Ring> createState() => _RingState();
}

class _RingState extends State<Ring> with SingleTickerProviderStateMixin {
  final double iconSize = Style.block * 1.6;

  final scale = 1.32;

  int selectedItem = 0;

  late final AnimationController restartAnimationController;
  late final Animation restartAnimation;

  @override
  void initState() {
    restartAnimationController = AnimationController(
      value: 0,
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    restartAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: restartAnimationController, curve: Curves.easeOutCubic));
    super.initState();
  }

  @override
  void dispose() {
    restartAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * scale,
      height: widget.size * scale,
      child: AnimatedBuilder(
          animation: restartAnimationController,
          builder: (context, _) {
            return Stack(
              children: [
                Center(
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Style.primaryColor, width: 2.5, strokeAlign: StrokeAlign.center)),
                  ),
                ),
                ...List.generate(widget.children.length, (index) {
                  double y = (widget.size / 2) *
                          (scale +
                              sin(2 * pi / widget.children.length * ((index - (selectedItem))) +
                                  pi / 2)) -
                      iconSize / 2;
                  double x = (widget.size / 2) *
                          (scale +
                              cos(2 * pi / widget.children.length * ((index - (selectedItem))) +
                                  pi / 2)) -
                      iconSize / 2;

                  double scale1 = (((restartAnimation.value * 2) - 1)).abs() *
                      (((restartAnimation.value * 2) - 1)).abs();
                  return Positioned(
                    top: y,
                    left: x,
                    child: GestureDetector(
                      onTap: () {
                        if (!restartAnimationController.isAnimating && index != selectedItem) {
                          selectedItem = index;
                          restartAnimationController.reset();
                          restartAnimationController.forward();
                        }
                      },
                      child: Container(
                        width: iconSize,
                        height: iconSize,
                        child: Center(
                          child: Container(
                            width: iconSize * 0.666 * (0.5 + scale1),
                            height: iconSize * 0.666 * (0.5 + scale1),
                            color: Style.secondaryColor,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black
                                    .withOpacity(1.0 - scale1 * scale1 * scale1 * scale1 * scale1),
                                border: Border.all(
                                  color: Style.primaryColor,
                                  width: 2,
                                  strokeAlign: StrokeAlign.center,
                                ),
                              ),
                              child: Transform.scale(
                                scale: scale1,
                                child: widget.children[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            );
          }),
    );
  }
}
