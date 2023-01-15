import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Style {
  static late double block;
  static late double blockH;
  static late double blockM;

  static bool wideScreen = false;

  static ThemeData theme1 = ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.light,
    primaryColor: Colors.black,
    colorScheme: ThemeData()
        .colorScheme
        .copyWith(secondary: Colors.amber[500]!, primary: Colors.black, background: Colors.white),
  );

  static pageRouteBuilder(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (c, a1, a2) => page,
      transitionsBuilder: (c, anim, a2, child) => ScaleTransition(
          scale: Tween<double>(begin: 1.5, end: 1).animate(CurvedAnimation(
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
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  static getTextStyle_1({Color? color, required BuildContext context}) {
    color ??= Theme.of(context).colorScheme.primary;
    return GoogleFonts.josefinSans(
        fontSize: Style.blockM * 1, fontWeight: FontWeight.w800, color: color);
  }

  static getTextStyle_2({required BuildContext context}) {
    return GoogleFonts.josefinSans(
        fontSize: Style.blockM * 1.5,
        fontWeight: FontWeight.w800,
        color: Theme.of(context).colorScheme.primary,
        decoration: TextDecoration.none);
  }

  static getTextStyle_3({Color color = Colors.black, required BuildContext context}) {
    return GoogleFonts.josefinSans(
        fontSize: Style.blockM * 1.5,
        fontWeight: FontWeight.w800,
        color: color,
        decoration: TextDecoration.none);
  }

  static changeStatusBarColor(BuildContext context) {
    bool dark = true;

    if (Platform.isIOS) dark = !dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: dark ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: dark ? Brightness.dark : Brightness.light,
    ).copyWith(systemNavigationBarColor: Theme.of(context).colorScheme.background));
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

  static Widget coloredSVG(
      {required String path, required BuildContext context, double? width, double? height}) {
    return FutureBuilder<String>(
        future: DefaultAssetBundle.of(context).loadString(path),
        builder: (context, snapshot) {
          return SvgPicture.string(
            (snapshot.data ??
                    "<svg version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1 1\"></svg>")
                .replaceAll("#000000",
                    '#${Theme.of(context).colorScheme.primary.value.toRadixString(16).padLeft(6, '0').toUpperCase()}')
                .replaceAll("#FFFFFF",
                    '#${Theme.of(context).colorScheme.secondary.value.toRadixString(16).padLeft(6, '0').toUpperCase()}'),
            height: height,
            width: width,
          );
        });
  }
}
