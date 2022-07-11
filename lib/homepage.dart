import 'dart:async';

import 'package:brick_breaker/bricks.dart';
import 'package:brick_breaker/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum direction {
  UP,
  DOWN,
  LEFT,
  RIGHT,
  NULL,
}

class _HomeScreenState extends State<HomeScreen> {
  //Ball variables :-
  double ballX = 0.0;
  double ballY = 0.0;
  double ballSpeed = 0.01;
  direction ballXdir = direction.NULL;
  direction ballYdir = direction.DOWN;

  //Player variables :-
  double playerX =
      -0.2; // its value is -0.5 *(playerWidth) to ensure that the player bar initially remains in the centre
  double playerWidth = 0.4; // (out of 2)
  double playerSpeed =
      0.2; //(Three working values : 0.1, 0.2, 0.4, the larger, the faster it moves)

  //Brick variables :-
  double wallGap = 0.2;
  int numOfBricksPerRow = 4;
  static double firstBrickX = -0.5;
  static double firstBrickY = -0.9;
  static double brickWidth = 0.4;
  static double brickHeight = 0.05;
  double brickGap = 0.2;
  bool bb = false;

  //Game settings :-
  bool hasGameStarted = false;
  bool hasGameEnded = false;

  //ALL FUNCTIONS :-
  void startGame() {
    setState(() {
      hasGameStarted = true;
    });
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        //The ball must be moving constantly from the starting of the game till its over
        //Thus, every 10 milliseconds we move the ball and update its direction
        moveBall();
        updateBallDirection();

        //We must also keep checking if the ball has hit any bricks
        checkForBrokenBricks();
        //If at any point of the game, the player dies, we must :
        //  1. stop the timer,
        //  2. update the game state booleans

        if (isPlayerDead()) {
          timer.cancel();
          setState(() {
            hasGameEnded = true;
          });
        }
      });
    });
  }

  void checkForBrokenBricks() {
    if (ballX >= firstBrickX &&
            ballX <= firstBrickX + brickWidth &&
            ballY <= firstBrickY + brickHeight &&
            bb == false
        //&& ballY >= firstBrickY) {
        ) {
      setState(() {
        bb = true;
        //update ball's direction
        ballYdir = direction.DOWN;
      });
    }
  }

  bool isPlayerDead() {
    return (ballY > 0.96);
  }

  void updateBallDirection() {
    setState(() {
      //Bouncing ball upwards once it hits player bar
      if (ballX >= playerX && ballX <= playerX + playerWidth && ballY >= 0.9) {
        ballYdir = direction.UP;
        //If the ball hits the exact edges of the player bar, we show an angle in its reflection
        if (ballX == playerX) {
          ballXdir = direction.LEFT;
        } else if (ballX == playerX + playerWidth) {
          ballXdir = direction.RIGHT;
        }
      }
      //Bouncing ball downwards once it hits the top of the screen
      else if (ballY <= -1) {
        ballYdir = direction.DOWN;
      }
      //Bouncing ball right if it hits the left side of the screen
      if (ballX <= -1) {
        ballXdir = direction.RIGHT;
      }
      //Bouncing ball left if it hits the right side of the screen
      else if (ballX >= 1) {
        ballXdir = direction.LEFT;
      }
    });
  }

  void moveBall() {
    setState(() {
      //Vertical Movement :
      if (ballYdir == direction.DOWN) {
        ballY += ballSpeed;
      } else if (ballYdir == direction.UP) {
        ballY -= ballSpeed;
      }

      //Horizontal Movement :
      if (ballXdir == direction.RIGHT) {
        ballX += ballSpeed;
      } else if (ballXdir == direction.LEFT) {
        ballX -= ballSpeed;
      }
    });
  }

  void movePlayerLeft() {
    if (playerX - playerSpeed >= -1) {
      setState(() {
        playerX -= playerSpeed;
      });
    }
  }

  void movePlayerRight() {
    if (playerX + playerWidth + playerSpeed <= 1) {
      setState(() {
        playerX += playerSpeed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
            movePlayerLeft();
          } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
            movePlayerRight();
          }
        },
        child: GestureDetector(
          onTap: hasGameStarted ? null : startGame,
          child: Scaffold(
            backgroundColor: Colors.tealAccent,
            body: Center(
              child: Stack(
                children: [
                  //PLAYER INTERACTIVE SCREENS :

                  //1. Tap to Begin :-
                  Visibility(
                    visible: !hasGameStarted,
                    child: const Align(
                      alignment: Alignment(0.0, -0.2),
                      child: Text(
                        'Tap to Begin!',
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),

                  //2. Game Over :-
                  Visibility(
                      visible: hasGameEnded,
                      child: const Align(
                        alignment: Alignment(0.0, 0.0),
                        child: Text(
                          'G A M E  O V E R !',
                          style: TextStyle(
                            color: Colors.teal,
                          ),
                        ),
                      )),

                  //BALL
                  Container(
                    alignment: Alignment(ballX, ballY),
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor:
                          hasGameEnded ? Colors.tealAccent : Colors.teal,
                    ),
                  ),

                  //PLAYER
                  MyPlayer(
                    playerX: playerX,
                    playerWidth: playerWidth,
                  ),

                  //BRICKS
                  MyBrick(
                    brickX: firstBrickX,
                    brickY: firstBrickY,
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: bb,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
