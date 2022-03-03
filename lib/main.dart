import 'package:flutter/material.dart';
import 'package:optimal_routing/prefs.dart';
import 'package:optimal_routing/styles.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'pages/level_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> init(context) async {
    print(0);
    Prefs.init();
    print(1);

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    print(2);
    print(3);

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
      title: 'Routs',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: FutureBuilder(
          future: init(context),
          builder: (context, snapshot) {
            Style.init(context);

            return snapshot.hasData ? const LevelPage() : Container();
          }),
    );
  }
}
