class Genotype { //the encoded form of each players behaviour
  Vec2[] shots;//each player can be represented by a vector array
  //using Vec2s because thats what box2d uses

  //-----------------------------------------------------------------------------------------------------------------------------
  //constructor
  Genotype() {
    shots = new Vec2[1];//only starts with a single shot
    randomize();//set all the shots as random vectors
  }
  //------------------------------------------------------------------------------------------------------------------------------
  //Mutation function for genetic algorithm
  void mutate() {
    int i = shots.length -1; //only mutate the very last shot
    float mutationRate =0.8; //mutate 80% of the players

    float rand = random(1);
    if (rand<mutationRate) {//80% of the time mutate the player
      if (rand<mutationRate/5) {
        //20% of the time change the vector to a random vector
        shots[i] = new Vec2(random(-1, 1), random(-1, 1));
      } else {
        //80% of the time rotate the vector a small amount
        PVector temp = new  PVector(shots[i].x, shots[i].y);//convert to PVector because i don't know how to do this with Vec2s
        temp.rotate(randomGaussian()/30);//rotate it 
        shots[i] = new Vec2(temp.x, temp.y);//convert it back
      }
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------
  //randomizes all vectors in shots
  void randomize() {
    for (int i = 0; i < shots.length; i++) {
      shots[i] = new Vec2(random(-1, 1), random(-1, 1));
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------
//returns a clone
  Genotype clone() {
    Genotype clone = new Genotype();
    clone.shots = shots.clone();
    return clone;
  }
  //------------------------------------------------------------------------------------------------------------------------------
  //increases the number of shots by 1
  void increaseShotLength() {
    Vec2[] newShots = new Vec2[shots.length  +1];//create a new array which is one bigger than the current shots array
    for (int i = 0; i < shots.length; i++) {//for each element of shots copy it into newShots
      newShots[i] = new Vec2(shots[i].x, shots[i].y);
    }
    
    newShots[shots.length] =  new Vec2(random(-1, 1), random(-1, 1));//randomise the last Vec2
    shots = newShots.clone();//set shots as newShots
  }
}