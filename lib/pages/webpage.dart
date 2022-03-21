import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optimal_routing/pages/privacy_policy_page.dart';

import '../consts/styles.dart';
import '../utils/prefs.dart';
import 'explain_page.dart';
import 'level_page.dart';

class Website extends StatefulWidget {
  const Website({Key? key}) : super(key: key);

  @override
  State<Website> createState() => _WebsiteState();
}

class _WebsiteState extends State<Website> {
  double block = 20;
  double blockH = 20;
  double blockM = 20;

  Widget frostedContainer(Size size, Widget child) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Style.blockM * 0.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: Style.blockM * 0.5, blurStyle: BlurStyle.outer),
          ],
          color: Colors.white.withOpacity(0.15)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Style.blockM * 0.5),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: Style.blockM * 0.4, sigmaY: Style.blockM * 0.4),
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Center(
                child: child,
              ),
            )),
      ),
    );
  }

  Widget getPoint() {
    return Container(
      width: blockM * 9,
      height: blockM * 9,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Style.accentColor),
      child: Center(
        child: Container(
          width: blockM * 2,
          height: blockM * 2,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Style.primaryColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Style.init(context);
    block = blockH = blockM = Style.block / 2.4;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: block * 40,
          height: block * 25,
          child: Stack(
            children: [
              Positioned(left: block * 5, top: blockH * 5, child: Transform.scale(scale: 1, child: getPoint())),
              Positioned(
                  left: block * 8.5 + blockM * 17,
                  top: blockH * 6,
                  child: Transform.scale(scale: 0.7, child: getPoint())),
              Positioned(
                  left: block * 4.3 + blockM * 17,
                  top: blockH * 4 + blockM * 10,
                  child: Transform.scale(scale: 0.5, child: getPoint())),
              Positioned(
                  left: blockM * 7.6,
                  top: blockH * 3.5 + blockM * 10,
                  child: Transform.rotate(
                      angle: pi * 0.151,
                      child: Container(color: Style.primaryColor, width: block * 19.5, height: block * 0.3))),
              Positioned(
                  left: blockM * 23.5,
                  top: blockH * 4.5 + blockM * 10,
                  child: Transform.rotate(
                      angle: pi * 0.65,
                      child: Container(color: Style.primaryColor, width: block * 8.5, height: block * 0.3))),
              Positioned(
                  left: blockM * 8.6,
                  top: blockH + blockM * 9,
                  child: Transform.rotate(
                      angle: pi * 0.015,
                      child: Container(color: Style.primaryColor, width: block * 22, height: block * 0.3))),
              Center(
                  child: frostedContainer(
                      Size(
                        block * 20,
                        blockH * 12,
                      ),
                      Text(
                        "Optimal Routes",
                        style: GoogleFonts.sarala(fontSize: blockM * 1.2, fontWeight: FontWeight.bold),
                      ))),
              Positioned(
                  left: 0,
                  top: blockH + blockM * 3,
                  child: frostedContainer(
                      Size(
                        block * 9,
                        blockH * 3,
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Send me an E-Mail",
                              style: GoogleFonts.sarala(fontSize: blockM * 0.55, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: block * 0.2,
                            ),
                            SelectableText(
                              "phobos2019@gmail.com",
                              style: GoogleFonts.sarala(fontSize: blockM * 0.4, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ))),
              Positioned(
                  right: blockM * 2.5,
                  top: blockH + blockM * 5,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => const PrivacyPage(),
                          transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                          transitionDuration: const Duration(milliseconds: 300),
                        )),
                    child: frostedContainer(
                        Size(
                          block * 6.5,
                          blockH * 2.5,
                        ),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Privacy Policy",
                                style: GoogleFonts.sarala(fontSize: blockM * 0.55, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                  )),
              Positioned(
                  right: blockM * 14,
                  top: blockM * 19.5,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) =>
                              ((Prefs.getBool("new") ?? true) ? const ExplainPage() : const LevelPage()),
                          transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                          transitionDuration: const Duration(milliseconds: 300),
                        )),
                    child: frostedContainer(
                        Size(
                          block * 6.5,
                          blockH * 2.5,
                        ),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Try the game NOW",
                                style: GoogleFonts.sarala(fontSize: blockM * 0.55, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
