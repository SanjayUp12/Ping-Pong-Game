import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  double diam = 50;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diam,
      height: diam,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Colors.redAccent.shade400),
    );
  }
}