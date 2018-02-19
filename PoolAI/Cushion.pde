//an object containing all the cushions on the pool table
class Cushions {
  Body[] bodies = new Body[6];//the cushions
  Box2DProcessing world;

//------------------------------------------------------------------------------------------------------------------------------------------------------------------
   //constructor
  Cushions ( Box2DProcessing box2d) {

    world = box2d;
    
    //Create left top cushion
    createCushion(0, 200, 0, 20, 0, 385, 20, 380, 20, 50, 0);
    //Create left bottom cushion
    createCushion(0, 600, 0, 415, 0, 780, 20, 750, 20, 420, 1);
    //create top
    createCushion(200, 0, 20, 0, 50, 20, 350, 20, 380, 0, 2);
    //right top
    createCushion(200, 0, 400, 20, 380, 50, 380, 380, 400, 385, 3);
    //right bottom
    createCushion(200, 0, 400, 415, 380, 420, 380, 750, 400, 780, 4);
    //bottom
    createCushion(200, 0, 20, 800, 380, 800, 350, 780, 50, 780, 5);
  }
  
//------------------------------------------------------------------------------------------------------------------------------------------------------------------  
 //creates a cushion in the box2d world with input position and dimensions 
  void createCushion(int posX, int posY, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4, int bodyNo) {
    //CREATE BODY DEFITION
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;//STATIC means that the body is fixed 
    bd.position.set(world.coordPixelsToWorld(posX, posY));

    //CREATE BODY
    bodies[bodyNo] = world.createBody(bd);//add body to the array

    //CREATE SHAPE 
    //a polygon with 4 vertices 
    PolygonShape ps = new PolygonShape();
    Vec2[] vertices = new Vec2[4];
    vertices[0] = world.vectorPixelsToWorld(new Vec2(x1-posX, y1-posY));
    vertices[1] = world.vectorPixelsToWorld(new Vec2(x2-posX, y2-posY));
    vertices[2] = world.vectorPixelsToWorld(new Vec2(x3-posX, y3-posY));
    vertices[3] = world.vectorPixelsToWorld(new Vec2(x4-posX, y4-posY));

    ps.set(vertices, vertices.length);
    //CREATE FIXTURE
    FixtureDef fd = new FixtureDef();
    fd.shape = ps;
    fd.density = 1;
    fd.friction = 0.0001;
    fd.restitution  = 0.9;//high restitution or bounciness 

    //ATTACH FIXTURE TO BODY
    bodies[bodyNo].createFixture(fd);
  }
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
 //draw the cushions as polygons
  void show() {
    
    fill(40);
    //top left cushion
    beginShape();
      vertex(0, 20);
      vertex(20, 50);
      vertex(20, 380);
      vertex(0, 385);
    endShape(CLOSE);
    
    //bottom left
    beginShape();
      vertex(0, 415);
      vertex(20, 420);
      vertex(20, 750);
      vertex(0, 780);
    endShape(CLOSE);
    
    //upper cushion
    beginShape();
      vertex(20, 0);
      vertex(380, 0);
      vertex(350, 20);
      vertex(50, 20);
    endShape(CLOSE);

    //top right
    beginShape();
      vertex(400, 20);
      vertex(380, 50);
      vertex(380, 380);
      vertex(400, 385);
    endShape(CLOSE);
    
    //bottom right
    beginShape();
      vertex(400, 415);
      vertex(380, 420);
      vertex(380, 750);
      vertex(400, 780);
    endShape(CLOSE);

    //bottom
    beginShape();
      vertex(20, 800);
      vertex(380, 800);
      vertex(350, 780);
      vertex(50, 780);
    endShape(CLOSE);
  }
}