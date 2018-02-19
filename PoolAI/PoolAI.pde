
//import box2d physics engine
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;


Population pop;//the population of pool players
Box2DProcessing[] box2d;//each player needs an individual world so this array stores them
int popSize = 200;//the amount of players tested at once
table[] tables;//each player also needs a table
int speed = 60;//frameRate


boolean showSingle = false;//whether only one player needs to be shown because they are all the same
boolean saveFrames = true;//true if it the first gen after increasing the number of shots so it saves the full game not just the last shot
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
void setup() {
  size(400, 800);
  frameRate(speed);//set the initial frame rate

  //initialise worlds and tables
  box2d = new Box2DProcessing[popSize];
  tables = new table[popSize];



  for (int i = 0; i< box2d.length; i++) {//create each of the worlds and add a table to them
    box2d[i] = new Box2DProcessing(this);
    box2d[i].createWorld();
    box2d[i].setGravity(0, 0);//no gravity
    tables[i] = new table(box2d[i]);
  }
  pop = new Population(popSize);//create the population
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------
void draw() {
  background(0, 200, 0);//green background
  tables[0].show();//show the cushions and holes

  if (pop.foundWinner) {//if one of the population has sunk all the balls then replay it and record it

    if ((!pop.players[pop.bestPlayerNo].gameOver && !pop.players[pop.bestPlayerNo].won )|| !pop.players[pop.bestPlayerNo].ballsStopped()) {//while not done replaying
      box2d[pop.bestPlayerNo].step(); //step the world through time
      pop.players[pop.bestPlayerNo].update();//update the player
      pop.players[pop.bestPlayerNo].show(); // show the player
      saveFrame("output/15Ball/finalgame/frame_#######.png");//save the frame as an image
    }
  } else {//if solution not found
    if (!pop.done()) {//while players still playing
      stepBoxes();//step through time in the physics engine
      pop.update();//update players
      pop.show();//show balls
    } else {
      //genetic algorithm
      pop.calculateFitness();
      pop.setBestPlayer();//sets best player and checks if it won
      if (!pop.foundWinner) {//if the best player didnt win

        if (pop.generation % 5 == 0) {//every 5 generation
          pop.resetPopulation();//set all the population as the best player then add one shot to the end of them
          showSingle = true;//only show one of the players
          saveFrames = true;//save all of the next game to show which shot was added to the end
        } else {
          pop.naturalSelection();//create new generation based on fitness 
          showSingle = true;//only show one of the players
        }
      }
    }
  }
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
void keyPressed() {
  switch(key) {
  case '+'://increase game speed
    speed+= 10;
    frameRate(speed);
    break;
  case '-'://decrease game speed (to a min of 10)
    if (speed>10) {
      speed-= 10;
      frameRate(speed);
    }
    break;
  }
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
void stepBoxes() { //step through time in all the boxes

  for (int i = 0; i< box2d.length; i++) {
    box2d[i].step();
  }
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
void resetWorlds() {//reset all the worlds to remove all the bodies from them
  for (int i = 0; i< popSize; i++) {
    box2d[i] = new Box2DProcessing(this);
    box2d[i].createWorld();
    box2d[i].setGravity(0, 0);
    tables[i] = new table(box2d[i]);
  }
}