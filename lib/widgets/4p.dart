import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../consts/styles.dart';

class P4 extends StatefulWidget {
  final int n;

  const P4({Key? key, required this.n}) : super(key: key);

  @override
  State<P4> createState() => _P4State();
}

class _P4State extends State<P4> {
  List<bool> lights = [];
  double pointDiameter = Style.block * 0.5;
  double space = Style.block * 0.35;

  @override
  void initState() {
    super.initState();
    lights = List.generate(widget.n*widget.n, (index) => rng.nextBool());
    timer = Timer.periodic(const Duration(milliseconds: 1100), (_) {
      setState(() {
        lights = List.generate(widget.n*widget.n, (index) => rng.nextBool());
      });
    });
  }

  var rng = Random();

  late final Timer timer;

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: pointDiameter * widget.n + space * (widget.n - 1),
      height: pointDiameter * widget.n + space * (widget.n - 1),
      child: GridView.count(
        padding: EdgeInsets.zero,
        crossAxisSpacing: space,
        mainAxisSpacing: space,
        crossAxisCount: widget.n,
        children: List.generate(
          widget.n*widget.n,
          (index) => Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: pointDiameter * (lights[index] ? 1 : 0.7),
              height: pointDiameter * (lights[index] ? 1 : 0.7),
              decoration: BoxDecoration(
                  color: lights[index] ? Style.accentColor : Style.primaryColor,
                  shape: BoxShape.circle),
            ),
          ),
        ),
      ),
    );
  }
}
