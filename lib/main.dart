import 'package:flutter/material.dart';
import 'ping_pong.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: SafeArea(child: PingPong())));
  }
}