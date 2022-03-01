import 'package:flutter/material.dart';
import 'package:optimal_routing/pages/game_page.dart';
import 'pages/level_page.dart';

void main() {
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
