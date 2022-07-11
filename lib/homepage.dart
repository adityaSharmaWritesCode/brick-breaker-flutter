import 'dart:async';
import 'dart:collection';
import 'dart:html';

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
  static double wallGap = 0.5 *
      (2 - numOfBricksPerRow * brickWidth - (numOfBricksPerRow - 1) * brickGap);
  static int numOfBricksPerRow = 4;
  static double firstBrickX = -1 + wallGap;
  static double firstBrickY = -0.9;
  static double brickWidth = 0.4;
  static double brickHeight = 0.05;
  static double brickGap = 0.05;

  List MyBricks = [
    [firstBrickX, firstBrickY, false],
    [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 3 * (brickWidth + brickGap), firstBrickY, false],
    [
      firstBrickX + 0 * (brickWidth + brickGap),
      firstBrickY + 1 * (brickHeight + brickGap),
      false
    ],
    [
      firstBrickX + 1 * (brickWidth + brickGap),
      firstBrickY + 1 * (brickHeight + brickGap),
      false
    ],
    [
      firstBrickX + 2 * (brickWidth + brickGap),
      firstBrickY + 1 * (brickHeight + brickGap),
      false
    ],
    [
      firstBrickX + 3 * (brickWidth + brickGap),
      firstBrickY + 1 * (brickHeight + brickGap),
      false
    ],
  ];

  //Game settings :-
  bool hasGameStarted = false;
  bool hasGameEnded = false;
  int brokenBrickCounter = 0;

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

        if (isPlayerDead() || brokenBrickCounter == MyBricks.length) {
          timer.cancel();
          setState(() {
            hasGameEnded = true;
          });
        }
      });
    });
  }

  // List<Widget> generateBricks() {
  //   List<Widget> sol = [];
  //   for (int i = 0; i < MyBricks.length; i++) {
  //     sol.add(
  //       MyBrick(
  //         brickX: MyBricks[i][0],
  //         brickY: MyBricks[i][1],
  //         brickHeight: brickHeight,
  //         brickWidth: brickWidth,
  //         brickBroken: MyBricks[i][2],
  //       ),
  //     );
  //   }

  //   return sol;
  // }

  void checkForBrokenBricks() {
    for (int i = 0; i < MyBricks.length; i++) {
      if (ballX >= MyBricks[i][0] &&
              ballX <= MyBricks[i][0] + brickWidth &&
              ballY <= MyBricks[i][1] + brickHeight &&
              MyBricks[i][2] == false
          // && ballY >= MyBricks[i][1]) {
          ) {
        setState(() {
          MyBricks[i][2] = true;
          brokenBrickCounter++;
          //Update ball's direction
          //Now to do this, we must determine which side of the brick has been hit
          // as that influences the direction in which the ball has to be reflected

          //To do this, we can compute the distance of the ball from each side of the brick
          //The shortest distance will correspond to the side of the brick that has been hit
          double leftSideDist = (MyBricks[i][0] - ballX).abs();
          double rightSideDist = (MyBricks[i][0] + brickWidth - ballX).abs();
          double topSideDist = (MyBricks[i][1] - ballY).abs();
          double bottomSideDist = (MyBricks[i][1] + brickHeight - ballY).abs();

          String min = findMinDist(
              leftSideDist, rightSideDist, topSideDist, bottomSideDist);
          print(min);
          switch (min) {
            case 'l':
              ballXdir = direction.LEFT;
              break;
            case 'r':
              ballXdir = direction.RIGHT;
              break;
            case 't':
              ballYdir = direction.UP;
              break;
            case 'b':
              ballYdir = direction.DOWN;
              break;
          }
        });
      }
    }
  }

  String findMinDist(double l, double r, double t, double b) {
    double mini = l;
    if (mini > r) mini = r;
    if (mini > t) mini = t;
    if (mini > b) mini = b;

    if ((mini - l).abs() < 0.01) {
      return 'l';
    } else if ((mini - r).abs() < 0.01) {
      return 'r';
    } else if ((mini - t).abs() < 0.01) {
      return 't';
    } else if ((mini - l).abs() < 0.01) {
      return 'b';
    }

    return '';
  }

  bool isPlayerDead() {
    return (ballY > 0.94);
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
        ballX += 2 * ballSpeed;
      } else if (ballXdir == direction.LEFT) {
        ballX -= 2 * ballSpeed;
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

  void resetGame() {
    setState(() {
      hasGameEnded = false;
      hasGameStarted = false;
      brokenBrickCounter = 0;
      ballX = 0.0;
      ballY = 0.0;
      direction ballXdir = direction.NULL;
      direction ballYdir = direction.DOWN;
      playerX = -0.2;
      for (int i = 0; i < MyBricks.length; i++) {
        MyBricks[i][2] = false;
      }
    });
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

                  //2. Game Over Screen :-
                  Visibility(
                      visible: hasGameEnded,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'G A M E  O V E R !',
                              style: TextStyle(
                                color: Colors.teal,
                              ),
                            ),
                            TextButton(
                              onPressed: resetGame,
                              child: Text('Retry?'),
                            ),
                          ],
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

                  //Row 1 :-
                  MyBrick(
                    brickX: MyBricks[0][0],
                    brickY: MyBricks[0][1],
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: MyBricks[0][2],
                  ),
                  MyBrick(
                    brickX: MyBricks[1][0],
                    brickY: MyBricks[1][1],
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: MyBricks[1][2],
                  ),
                  MyBrick(
                    brickX: MyBricks[2][0],
                    brickY: MyBricks[2][1],
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: MyBricks[2][2],
                  ),
                  MyBrick(
                    brickX: MyBricks[3][0],
                    brickY: MyBricks[3][1],
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: MyBricks[3][2],
                  ),

                  //Row 2 :-
                  MyBrick(
                    brickX: MyBricks[4][0],
                    brickY: MyBricks[4][1],
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: MyBricks[4][2],
                  ),
                  MyBrick(
                    brickX: MyBricks[5][0],
                    brickY: MyBricks[5][1],
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: MyBricks[5][2],
                  ),
                  MyBrick(
                    brickX: MyBricks[6][0],
                    brickY: MyBricks[6][1],
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: MyBricks[6][2],
                  ),
                  MyBrick(
                    brickX: MyBricks[7][0],
                    brickY: MyBricks[7][1],
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: MyBricks[7][2],
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
