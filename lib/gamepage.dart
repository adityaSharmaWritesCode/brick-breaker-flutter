import 'dart:async';

import 'package:brick_breaker/bricks.dart';
import 'package:brick_breaker/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameScreen extends StatefulWidget {
  static const route = '/gameScreen';

  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

enum direction {
  UP,
  DOWN,
  LEFT,
  RIGHT,
  NULL,
}

class _GameScreenState extends State<GameScreen> {
  //Ball variables :-
  double ballX = 0.0;
  double ballY = 0.0;
  double ballSpeed = 0.022; //(0.010, 0.016, 0.022)
  direction ballXdir = direction.LEFT;
  direction ballYdir = direction.DOWN;

  //Player variables :-
  double playerX = -0.5 *
      (playerWidth); // its value is -0.5 *(playerWidth) to ensure that the player bar initially remains in the centre
  static double playerWidth = 0.4; // ( 0.4, 0.8, 1.2)
  double playerSpeed = 0.2;

  //Brick variables :-
  static double wallGap = 0.5 *
      (2 - numOfBricksPerRow * brickWidth - (numOfBricksPerRow - 1) * brickGap);
  static int numOfBricksPerRow = 4;
  static double firstBrickX = -1 + wallGap;
  static double firstBrickY = -0.9;
  static double brickWidth = 0.4;
  static double brickHeight = 0.1;
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
    // [
    //   firstBrickX + 0 * (brickWidth + brickGap),
    //   firstBrickY + 2 * (brickHeight + brickGap),
    //   false
    // ],
    // [
    //   firstBrickX + 1 * (brickWidth + brickGap),
    //   firstBrickY + 2 * (brickHeight + brickGap),
    //   false
    // ],
    // [
    //   firstBrickX + 2 * (brickWidth + brickGap),
    //   firstBrickY + 2 * (brickHeight + brickGap),
    //   false
    // ],
    // [
    //   firstBrickX + 3 * (brickWidth + brickGap),
    //   firstBrickY + 2 * (brickHeight + brickGap),
    //   false
    // ],
    // [
    //   firstBrickX + 0 * (brickWidth + brickGap),
    //   firstBrickY + 3 * (brickHeight + brickGap),
    //   false
    // ],
    // [
    //   firstBrickX + 1 * (brickWidth + brickGap),
    //   firstBrickY + 3 * (brickHeight + brickGap),
    //   false
    // ],
    // [
    //   firstBrickX + 2 * (brickWidth + brickGap),
    //   firstBrickY + 3 * (brickHeight + brickGap),
    //   false
    // ],
    // [
    //   firstBrickX + 3 * (brickWidth + brickGap),
    //   firstBrickY + 3 * (brickHeight + brickGap),
    //   false
    // ],
  ];

  //Game settings :-
  bool hasGameStarted = false;
  bool hasGameEnded = false;
  int brokenBrickCounter = 0;
  String endText = '';

  //ALL FUNCTIONS :-

  void loadDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      ballSpeed = prefs.getDouble('bs') ?? 1.0;
      playerWidth = prefs.getDouble('pw') ?? 1.0;
      if (ballSpeed == 0.5) {
        ballSpeed = 0.010;
      } else if (ballSpeed == 1.0) {
        ballSpeed = 0.016;
      } else if (ballSpeed == 1.5) {
        ballSpeed = 0.022;
      }

      if (playerWidth == 0.5) {
        playerWidth = 0.4;
      } else if (playerWidth == 1.0) {
        playerWidth = 0.8;
      } else if (playerWidth == 1.5) {
        playerWidth = 1.2;
      }

      playerX = -(0.5) * playerWidth;
    });
  }

  void startGame() {
    setState(() {
      hasGameStarted = true;
    });
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
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

        if (isPlayerDead() || areAllBricksBroken()) {
          timer.cancel();
          setState(() {
            hasGameEnded = true;
          });
        }
      });
    });
  }

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
    } else if ((mini - b).abs() < 0.01) {
      return 'b';
    }

    return '';
  }

  bool isPlayerDead() {
    if (ballY > 0.94) {
      setState(() {
        endText = 'G A M E  O V E R !';
      });
      return true;
    }
    return false;
  }

  bool areAllBricksBroken() {
    if (brokenBrickCounter == MyBricks.length) {
      setState(() {
        endText = 'Y O U  W O N !';
      });
      return true;
    }
    return false;
  }

  void updateBallDirection() {
    setState(() {
      //Bouncing ball upwards once it hits player bar
      if (ballX >= playerX && ballX <= playerX + playerWidth && ballY >= 0.88) {
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
        ballX += 1.5 * ballSpeed;
      } else if (ballXdir == direction.LEFT) {
        ballX -= 1.5 * ballSpeed;
      }
    });
  }

  void movePlayer(double position) {
    setState(() {
      playerX = position;
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
      ballXdir = direction.LEFT;
      ballYdir = direction.DOWN;
      playerX = -0.5 * (playerWidth);
      for (int i = 0; i < MyBricks.length; i++) {
        MyBricks[i][2] = false;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryObject = MediaQuery.of(context);
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
                    child: Align(
                      alignment: const Alignment(0.0, -0.2),
                      child: Text(
                        'tap to begin',
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  color: Colors.teal.shade700,
                                  fontSize: 16,
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
                            Text(
                              endText,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    fontSize:
                                        mediaQueryObject.size.width * 0.03,
                                    color: Colors.teal,
                                  ),
                            ),
                            SizedBox(
                                height: mediaQueryObject.size.height * 0.05),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.teal,
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          mediaQueryObject.size.width * 0.015,
                                      vertical:
                                          mediaQueryObject.size.height * 0.015,
                                    ),
                                  ),
                                  onPressed: resetGame,
                                  child: Text(
                                    'Play Again',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                          color: Colors.tealAccent,
                                          fontSize: 18,
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  width: mediaQueryObject.size.width * 0.02,
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.teal,
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              mediaQueryObject.size.width *
                                                  0.015,
                                          vertical:
                                              mediaQueryObject.size.height *
                                                  0.015,
                                        )),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Return to Home',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                            color: Colors.tealAccent,
                                            fontSize: 18,
                                          ),
                                    ))
                              ],
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
                  //GestureDetector(
                  // onHorizontalDragUpdate: ((details) {
                  //   print(details.delta.dx);
                  //   movePlayer(details.localPosition.dx);
                  //   // if (details.localPosition.dx > 0) {
                  //   //   movePlayerRight();
                  //   // } else if (details.delta.dx <= 0) {
                  //   //   movePlayerLeft();
                  //   // } else {
                  //   //   print('I DONT KNOW WHATS GOING ON');
                  //   // }
                  // }),
                  //child:
                  MyPlayer(
                    playerX: playerX,
                    playerWidth: playerWidth,
                  ),
                  //),

                  // Positioned(
                  //   bottom: mediaQueryObject.size.height * 0.025,
                  //   left: _ppX,
                  //   child: Draggable(
                  //     feedback: Container(),
                  //     child: MyPlayer(
                  //       playerX: _ppX,
                  //       playerWidth: playerWidth,
                  //     ),
                  //     onDragUpdate: (dragDetails) {
                  //       setState(() {
                  //         _ppX = dragDetails.localPosition.dx;
                  //       });
                  //     },
                  //   ),
                  // ),

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

                  //Row 3 :-
                  // MyBrick(
                  //   brickX: MyBricks[8][0],
                  //   brickY: MyBricks[8][1],
                  //   brickHeight: brickHeight,
                  //   brickWidth: brickWidth,
                  //   brickBroken: MyBricks[8][2],
                  // ),
                  // MyBrick(
                  //   brickX: MyBricks[9][0],
                  //   brickY: MyBricks[9][1],
                  //   brickHeight: brickHeight,
                  //   brickWidth: brickWidth,
                  //   brickBroken: MyBricks[9][2],
                  // ),
                  // MyBrick(
                  //   brickX: MyBricks[10][0],
                  //   brickY: MyBricks[10][1],
                  //   brickHeight: brickHeight,
                  //   brickWidth: brickWidth,
                  //   brickBroken: MyBricks[10][2],
                  // ),
                  // MyBrick(
                  //   brickX: MyBricks[11][0],
                  //   brickY: MyBricks[11][1],
                  //   brickHeight: brickHeight,
                  //   brickWidth: brickWidth,
                  //   brickBroken: MyBricks[11][2],
                  // ),

                  // //Row 4 :-
                  // MyBrick(
                  //   brickX: MyBricks[12][0],
                  //   brickY: MyBricks[12][1],
                  //   brickHeight: brickHeight,
                  //   brickWidth: brickWidth,
                  //   brickBroken: MyBricks[12][2],
                  // ),
                  // MyBrick(
                  //   brickX: MyBricks[13][0],
                  //   brickY: MyBricks[13][1],
                  //   brickHeight: brickHeight,
                  //   brickWidth: brickWidth,
                  //   brickBroken: MyBricks[13][2],
                  // ),
                  // MyBrick(
                  //   brickX: MyBricks[14][0],
                  //   brickY: MyBricks[14][1],
                  //   brickHeight: brickHeight,
                  //   brickWidth: brickWidth,
                  //   brickBroken: MyBricks[14][2],
                  // ),
                  // MyBrick(
                  //   brickX: MyBricks[15][0],
                  //   brickY: MyBricks[15][1],
                  //   brickHeight: brickHeight,
                  //   brickWidth: brickWidth,
                  //   brickBroken: MyBricks[15][2],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
