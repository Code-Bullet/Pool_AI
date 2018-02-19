class table {//object containing all the cushions and the holes
  Cushions cushions;
  Hole[] holes;
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
 //constructor
  table(Box2DProcessing box) {
    //add the side cushions
    cushions = new Cushions(box);


    //add the holes
    holes = new  Hole[6];
    holes[0] = new Hole(15, 15);
    holes[1] = new Hole(width-15, 15);
    holes[2] = new Hole(width-15, height/2);
    holes[3] = new Hole(width-15, height-15);
    holes[4] = new Hole(15, height-15);
    holes[5] = new Hole(15, height/2);
  }
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //draw the table
  void show() {
    for (int i  =0; i< holes.length; i++) {
      holes[i].show();
    }
    cushions.show();
  }
}