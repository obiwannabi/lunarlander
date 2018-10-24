final float GRAVITY = 0.025;
final float AIR = 0.99;
final float TURN_VALUE = PI/40;
final float PROP = 0.03;
boolean usingfuel;
int fuel=3000;

Ship ship;



boolean[] keys = new boolean[4];

void setup() {
  ship = new Ship(new PVector(0, 0), 5);
  size(1200, 800);
 
 
   
}

void draw() {
  
  
  model();
   
  view();
 
}

// physics stuff
void model() {
  handleKeys();
  ship.move();
}

// drawing stuff
void view() {
  background(255);
  int x = fuel;
  textSize(32);
  fill(255,0,0);
  text(x, 500, 500); 
  
   float incAmount = 0.01;
   float n ;
   float y;
    for (float t = 0; t < incAmount*width; t += incAmount) {
         n = noise(t);
         y = map(n, 0, 1, 0, height/2);
        rect(t*100, height-y, 1, y);
    }
  translate(width/2, height/2);
  
 
  
  ship.draw();
  
}

void keyPressed() {
  if (key == CODED) {
    switch (keyCode) {
      case UP:
        keys[0] = true;
     usingfuel = true;
        break;
      case LEFT:
        keys[1] = true; 
       
        break;
      case RIGHT:
        keys[2] = true;
       
        break;
      
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    switch (keyCode) {
      case UP:
        keys[0] = false; 
        usingfuel = false;
        break;
      case LEFT:
        keys[1] = false; break;
      case RIGHT:
        keys[2] = false; break;
    }
  }
}

void decreasefuel(int fuel){

this.fuel -= 1;
}


void handleKeys() {
  if (keys[0]) ship.thrust();            // THRUST
  if (keys[1]) ship.turns(-TURN_VALUE);  // LEFT
  if (keys[2]) ship.turns(TURN_VALUE);   // RIGHT
  
  if(usingfuel){
  decreasefuel(fuel);
  }
}

class Ship {

  PVector pos;   // position
  float rot;     // rotation angle
  PVector dis;   // displacement
  float speed;   // speed
  
  int siz;       // size
  PVector[] pt;  // shape
  
  Ship(PVector pos, int siz) {
    this.pos = pos;
    this.siz = siz;
    dis = new PVector(0, 0);
    // the ship has its nose upwards
    rot = -PI/2;
    pt = new PVector[3];
    updatePoints();
  }
  
  /**
   * calculate the coordinates of the shape
   */
  void updatePoints() {
    // nose
    pt[0] = new PVector(pos.x+siz*cos(rot), pos.y+siz*sin(rot));
    // bottom left
    pt[1] = new PVector(pos.x+1.7*siz*cos(rot+(PI+0.7)), pos.y+1.7*siz*sin(rot+(PI+0.7)));
    // bottom right
    pt[2] = new PVector(pos.x+1.7*siz*cos(rot+(PI-0.7)), pos.y+1.7*siz*sin(rot+(PI-0.7)));
  }
  
  /**
   * display the ship on screen
   */
  void draw() {
     
    strokeWeight(1); stroke(0); fill(255);
    triangle(pt[0].x, pt[0].y, pt[1].x, pt[1].y, pt[2].x, pt[2].y);
  
  }
  
  void move() {
    // friction
    dis.mult(AIR);
    // gravity
    dis.y += GRAVITY;
    // propulsion
    if (keys[0]) dis.add(new PVector(PROP*cos(rot), PROP*sin(rot)));
    // deplacement
    pos.add(dis);
    updatePoints();
  }
  
  void turns(float angle) {
    rot += angle;
  }
  
  void thrust() {
    if (speed < 1) speed += 0.1;
  }
  
 

} 
