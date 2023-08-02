import 'package:flutter/material.dart';

class Bat extends StatelessWidget {
  Bat({this.width, this.height});
  double? width;
  double? height;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: Colors.indigo.shade300),
      ),
    );
  }
}