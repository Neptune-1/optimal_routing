import 'package:flutter/material.dart';
import 'package:optimal_routing/pages/game_page.dart';
import 'package:optimal_routing/prefs.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'pages/level_page.dart';

void main() async {
  Prefs.init();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  
  if(Prefs.getString("version") != version){
    Prefs.clear();
    Prefs.setString("version", version);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Routs',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const GamePage(level: 0,),
    );
  }
}
