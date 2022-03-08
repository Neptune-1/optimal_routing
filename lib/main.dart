import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:optimal_routing/consts/styles.dart';
import 'package:optimal_routing/pages/explain_page.dart';
import 'package:optimal_routing/utils/prefs.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'pages/level_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<void> initializeDefault() async {
    if(!Platform.isIOS) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAbn5MA2ZVal35qZBO0pvZRWCFj4X2K1kw",
            authDomain: "routes-ce6ef.firebaseapp.com",
            projectId: "routes-ce6ef",
            storageBucket: "routes-ce6ef.appspot.com",
            messagingSenderId: "655739182965",
            appId: "1:655739182965:web:4be3bddd18f675362f3d3c",
            measurementId: "G-5WDJ5DJHFX"),
      );
    } else {
      await Firebase.initializeApp();
    }
  }

  Future<bool> init(context) async {
    await initializeDefault();
    Prefs.init();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    await Prefs.clear();

    if (Prefs.getString("version") != version) {
      Prefs.clear();
      Prefs.setString("version", version);
    }
    print(4);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Routes',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: FutureBuilder(
          future: init(context),
          builder: (context, snapshot) {
            Style.init(context);
            //Style.toPallet1();

            return snapshot.hasData
                ? (Prefs.getBool("new") ?? true)
                    ? const ExplainPage()
                    : const LevelPage()
                : Container(
                    color: Style.accentColor,
                  );
          }),
    );
  }
}
