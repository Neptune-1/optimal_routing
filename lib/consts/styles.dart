import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'dart:html' as html;
class Style {
  static late double block;
  static late double blockH;
  static late double blockM;

  static Color backgroundColor = secondaryColor;

  static Color primaryColor = Colors.black;
  static Color secondaryColor = Colors.white;
  static Color accentColor = Colors.amber[500]!;
  static bool wideScreen = false;

  static toPallet1() {
    primaryColor = Colors.white;
    secondaryColor = Colors.grey.shade900;
    accentColor = Colors.cyanAccent.shade200;
    backgroundColor = secondaryColor;
  }

  static toPallet0() {
    primaryColor = Colors.black;
    secondaryColor = Colors.white;
    accentColor = Colors.amber[500]!;
    backgroundColor = secondaryColor;
  }

  static getTextStyle_1() {
    return GoogleFonts.quicksand(fontSize: Style.blockM * 1, fontWeight: FontWeight.w800, color: primaryColor);
  }

  static getTextStyle_2() {
    return GoogleFonts.quicksand(
        fontSize: Style.blockM * 1.5,
        fontWeight: FontWeight.w800,
        color: primaryColor,
        decoration: TextDecoration.none);
  }

  static getTextStyle_3({Color color = Colors.black}) {
    return GoogleFonts.quicksand(
        fontSize: Style.blockM * 1.5, fontWeight: FontWeight.w800, color: color, decoration: TextDecoration.none);
  }

  static init(BuildContext context) {
    //if(kIsWeb){
    //  block = html.window.screeen!.width! / 20;
    //  blockH = html.window.screen!.height! / 20;}

//
//  }
    block = MediaQuery.of(context).size.width / 20;
    blockH = MediaQuery.of(context).size.height / 20;
    blockM = block > blockH ? blockH : block;
    if (blockH < block) {
      wideScreen = true;
      blockM /= 1.5;
    }
  }
}
