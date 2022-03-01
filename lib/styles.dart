import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' as io;

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

  static toPallet1(){
    backgroundColor = Colors.grey.shade900;
    primaryColor = Colors.white;
    secondaryColor = Colors.black;
    accentColor = Colors.amber[500]!;
  }

  static getTextStyle_1(){
    return GoogleFonts.quicksand(fontSize: Style.blockM * 1, fontWeight: FontWeight.w800);
  }


  static init(BuildContext context) {
    //if(kIsWeb){
    //  block = html.window.screeen!.width! / 20;
    //  blockH = html.window.screen!.height! / 20;}

//
//  }
    block = MediaQuery.of(context).size.width / 20;
    blockH = MediaQuery.of(context).size.height / 20;
    blockM = block>blockH ? blockH : block;
  }
}
