import 'package:flutter/material.dart';

class MyBrick extends StatelessWidget {
  final double brickX;
  final double brickY;
  final double brickHeight;
  final double brickWidth;
  final bool brickBroken;

  MyBrick({
    required this.brickX,
    required this.brickY,
    required this.brickHeight,
    required this.brickWidth,
    required this.brickBroken,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: brickBroken ? 0.0 : 1.0,
      child: Container(
        alignment:
            Alignment((2 * brickX + brickWidth) / (2 - brickWidth), brickY),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(5.0),
          ),
          height: MediaQuery.of(context).size.height * brickHeight / 2,
          width: MediaQuery.of(context).size.width * brickWidth / 2,
        ),
      ),
    );
  }
}
