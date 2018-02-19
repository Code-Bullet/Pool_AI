class Player {
  Genotype DNA;//the behaviour of the player
  int upToShot = 0;//which point in the shots array the player is up to 
  float fitness;// the quality of the player used for natural selection
  Ball whiteBall;
  Ball[] balls;  
  boolean gameOver = false;
  boolean won = false;//whether the player has sunk all the balls with the black ball last
  Box2DProcessing World;//the box2d world that the player is playing in

  //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //constructor
  Player(Box2DProcessing world) { 
    World = world;
    DNA = new Genotype();
    fitness =0;
    
    whiteBall = new Ball(200, 600, world, (255));//set white ball
    whiteBall.isWhite = true;
    
    //create all 15 balls
    balls = new Ball[15]; 
    //first row
    balls[0] = new Ball(200, 216, world, color(240, 0, 0));//red
    //second row
    balls[1] = new Ball(200-14, 216 - 16, world, color(0, 140, 0));//green
    balls[2] = new Ball(200 +  14, 216 - 16, world, color(0, 0, 240)); // blue
    //third row
    balls[3] = new Ball(200- (2*14), 216 - (2*16), world, color(253, 211, 0)); //yellow
    balls[4] = new Ball(200, 216 - (2*16), world, color(0)); //black
    balls[5] = new Ball(200+ (2*14), 216 - (2*16), world, color(255, 119, 10)); //orange    
    //forth row
    balls[6] = new Ball(200- (3*14), 216 - (3*16), world, color(253, 137, 168));//pink
    balls[7] = new Ball(200 - (14), 216 - (3*16), world, color(101, 1, 105));//purple
    balls[8] = new Ball(200+(14), 216 - (3*16), world, color(90, 0, 0));// maroon 
    balls[9] = new Ball(200 + (3*14), 216 - (3*16), world, color(122, 234, 242));//aqua
    //fifth row
    balls[10] = new Ball(200- (4*14), 216 - (4*16), world, color(55, 93, 93)); //like a bluey grey
    balls[11] = new Ball(200- (2*14), 216 - (4*16), world, color  (128, 128, 0));//olive
    balls[12] = new Ball(200, 216 - (4*16), world, color(186, 85, 211));//light purple i guess
    balls[13] = new Ball(200+(2*14), 216 - (4*16), world, color  (244, 164, 96));// sandy brown (im running out of colours) 
    balls[14] = new Ball(200 + (4*14), 216 - (4*16), world, color(0, 255, 150));//a different aqua
  }


  //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
  //called every step to update the balls
  void update() {
    //apply friction to the balls
    for (int i =0; i<balls.length; i++) {
      balls[i].update() ;
    }
    whiteBall.update();
    
    //check if able to shoot
    if (!gameOver && ballsStopped()) {
      shoot();
    } 
    
    //check if white ball is sunk
    if (whiteBall.isInHole()) {
      gameOver = true;
    }
    
    //check if the player has won
    if (gameFinished()) {
      gameOver = true;
    }
  }
  //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //apply a force to the white ball in the direction of the next vector in the DNA
  void shoot() {
    
    if (upToShot >= DNA.shots.length || gameOver) {//if all shots are done
      gameOver = true;//dont shoot
      return;
    }
    
    //apply the force
    whiteBall.applyForce(DNA.shots[upToShot]);
    upToShot +=1;
  }
  //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //draw all the balls
  void show() {
    whiteBall.show();
    for (int i =0; i<balls.length; i++) {
      balls[i].show() ;
    }
  }
  //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //sets the fitness based on where the balls ended up
  void calculateFitness(int ballsSunkPreviously) { //ballsSunkPreviously is the number of balls sunk before this shot

    fitness = 0;
    if (whiteBall.sunk) {
      return;//if white ball sunk then finish with the fitness =0
    }
    float totalDistance = 0;//the sum of all the distances of the balls
    int ballsSunk = 0;//number of balls in pockets
    for (int i =0; i<balls.length; i++) {
      if (!balls[i].sunk) { //if the ball isnt sunk calculate the distance to the closest hole
        float min = 1000;
        Vec2 ballPos = balls[i].world.getBodyPixelCoord(balls[i].body);
        for (int j= 0; j<6; j++) {
          if (dist(tables[0].holes[j].pos.x, tables[0].holes[j].pos.y, ballPos.x, ballPos.y) < min) {
            min = dist(tables[0].holes[j].pos.x, tables[0].holes[j].pos.y, ballPos.x, ballPos.y);
          }
        }
        totalDistance += min;//add the smallest distance to a whole to the total
      } else {//if the ball is sunk
        ballsSunk ++;
        if (i == 4 && !blackBallIsLast()) {//if the black ball is sunk and it isnt the last ball
          fitness = 0;//game over
          gameOver = true;
          return;
        }
      }
    }

    if ( totalDistance==0) { //if all balls sunk
      fitness = 1000;
    } else {
      fitness = ((1 +(ballsSunk - ballsSunkPreviously))*(1+(ballsSunk - ballsSunkPreviously)))/(totalDistance);//fitness function
    }
  }


  //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //returns a clone with the same DNA as this player
  Player clone(Box2DProcessing world) {
    Player clone = new Player(world);
    clone.DNA = DNA.clone();
    return clone;
  }
  //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //true if all the balls are stopped
  boolean ballsStopped() {
    if (!whiteBall.isStopped()) {
      return false;
    }
    for (int i =0; i<balls.length; i++) {
      if (!balls[i].sunk && !balls[i].isStopped()) {
        return false;
      }
    }
    return true;
  }
  //-----------------------------------------------------------------------------------------------------------------------------------------------
  //true if the game is won
  boolean gameFinished() {
    for (int i =0; i<balls.length; i++) {
      if (!balls[i].isInHole()) {//if any of the balls are not sunk then return false
        return false;
      }
    }
    //if non of the balls are not in a hole
    won = true;
 
    return true;
  }

  //-----------------------------------------------------------------------------------------------------------------------------------------------
  //true if the black ball is/was the last on the table
  boolean blackBallIsLast() {

    for (int i =0; i<balls.length; i++) {
      if (i != 4 && !balls[i].isInHole()) {
        return false;
      }
    }
    return true;
  }

  //-----------------------------------------------------------------------------------------------------------------------------------------------
  //returns the number of balls sunk
  int ballsSunk() {
    int ballsSunk = 0;
    for (int i =0; i<balls.length; i++) {
      if (balls[i].sunk) {
        ballsSunk+=1;
      }
    }

    return ballsSunk;
  }
}