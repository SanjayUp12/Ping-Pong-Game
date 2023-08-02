import 'package:flutter/material.dart';
import 'ball.dart';
import 'bat.dart';
import 'dart:math';

enum Direction { up, down, left, right }

class PingPong extends StatefulWidget {
  @override
  State<PingPong> createState() => _PingPongState();
}

class _PingPongState extends State<PingPong> with TickerProviderStateMixin {
  int score = 0;
  double height = 0;
  double width = 0;
  double posX = 0;
  double posY = 0;
  double randX = 1;
  double randY = 1;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;
  Animation<double>? animation;
  AnimationController? controller;
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;

  double randomNum() {
    var ran = new Random();
    int myNum = ran.nextInt(101);
    return (50 + myNum) / 100;
  }

  void checkBorders() {
    double diameter = 50;
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNum();
    }
    if (posX >= width - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNum();
    }
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randY = randomNum();
    }
    if (posY >= height - diameter - batHeight && vDir == Direction.down) {
      if (posX >= batPosition - diameter &&
          posX <= batPosition + batWidth + 50) {
        vDir = Direction.up;
        randY = randomNum();
        score = score + 10;
      } else {
        controller!.stop();
        showMessage(context);
      }
    }
  }

  @override
  void initState() {
    posX = 0;
    posY = 0;
    controller =
        AnimationController(duration: Duration(seconds: 10000), vsync: this);
    animation = Tween<double>(begin: 0, end: 100).animate(controller!);
    animation!.addListener(() {
      setState(() {
        (hDir == Direction.right)
            ? posX += ((2 * randX).round())
            : posX -= ((2 * randX).round());
        (vDir == Direction.down)
            ? posY += ((2 * randY).round())
            : posY -= ((2 * randY).round());
      });
      checkBorders();
    });
    controller!.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      height = constraints.maxHeight;
      width = constraints.maxWidth;
      batHeight = height / 20;
      batWidth = width / 5;
      return Stack(
        children: [
          Positioned(
            child: Text(
              'Score: ' + score.toString(),
              style: TextStyle(fontSize: 20),
            ),
            top: 0,
            left: 24,
          ),
          Positioned(
            child: Ball(),
            top: posY,
            left: posX,
          ),
          Positioned(
            bottom: 0,
            left: batPosition,
            child: GestureDetector(
              onHorizontalDragUpdate: (DragUpdateDetails update) {
                moveBat(update);
              },
              child: Bat(
                height: batHeight,
                width: batWidth,
              ),
            ),
          ),
        ],
      );
    });
  }

  moveBat(DragUpdateDetails update) {
    setState(() {
      batPosition += update.delta.dx;

      // Get the screen width
      double screenWidth = MediaQuery.of(context).size.width;

      // Limit the batPosition to stay within the screen bounds
      if (batPosition < 0) {
        batPosition = 0;
      } else if (batPosition + batWidth > screenWidth) {
        batPosition = screenWidth - batWidth;
      }
    });
  }

  void showMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game over!'),
            content: Text('Would you like to play again'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    posX = 0;
                    posY = 0;
                    score = 0;
                    Navigator.of(context).pop();
                    controller!.repeat();
                  });
                },
                child: Text('Yes'),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    dispose();
                  },
                  child: Text("No"))
            ],
          );
        });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}