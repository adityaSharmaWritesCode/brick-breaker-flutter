# breakout-flutter
An interactive game developed only through flutter that is modelled after the popular arcade game *Breakout*. It can be played across platforms on ios, Android, and even on your desktop through the Web.

### Demo Link : 

### Web UI :

### Android UI :

### Code Explanation :

This game can be boiled down to the interactions between 3 separate objects : 
1. Wrecking Ball
2. Paddle (i.e, the player)
3. Bricks

#### The Wrecking Ball -

This game element constantly moves across the game but its movements cannot be controlled by the player (at least not directly). The game emulates the wrecking ball's movements by incrementing / decrementing variables that store the ball's X & Y coordinates with respect to the screen. These positional variables are updated every 10 milliseconds (until the user removes all the bricks or the ball's Y coordinate reaches below the player's X coordinate) to ensure that there is no lag and the user experience is smooth. 

The other important aspect of the ball's movements is its direction. Now, the direction needs to be updated whenever it "interacts" with another element, that are, the player paddle, the bricks, and the screen walls. Currently, this is being done by tracking the coordinates of all the elements. 

#### The Paddle -

This game element's movements are directly controlled by the user's inputs. To do this, a KeyBoardListener is used which consistenly checks for any inputs from the user. It is important to note that the Y coordinate of the paddle will always remain constant. Thus, only the X coordinate of the paddle needs to be decremented or incremented when the user presses the left arrow key or the right arrow key respectively.

#### The Bricks -

This is the only element of the game which always remains in the same position. However, we still need to keep track of the coordinate variables of each brick so as to update the ball's direction when it collides with a brick. There is also a need to maintain a counter of how many bricks have been destroyed by the ball, so that we can end the game once all the bricks have been destroyed.     

#### Implementing Game Settings - 

Currently, there are 2 separate game variables that can be changed by the user :
1. Speed of the ball
2. Width of the paddle

This is done by caching these two variables using the shared preferences plugin. 

