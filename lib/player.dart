import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  final playerX;
  final playerWidth; //out of 2

  MyPlayer({this.playerX, this.playerWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      //alignment: Alignment(playerX, 0.9),
      alignment:
          Alignment((2 * playerX + playerWidth) / (2 - playerWidth), 0.9),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.teal,
        ),
        height: 10,
        width: MediaQuery.of(context).size.width * playerWidth / 2,
      ),
    );
  }
}
