 class Ship {

  PVector pos;   // position
  float rot;     // rotation angle
  PVector dis;   // displacement
  float speed = 0;   // speed
  ///test speed*velocity///
  PVector velo; //velocity 
  PVector acceleration;
  float topSpeed;
  ////////////////////////
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
     
    strokeWeight(1); stroke(0); fill(255,0,0);
    triangle(pt[0].x, pt[0].y, pt[1].x, pt[1].y, pt[2].x, pt[2].y);
  
  }
  void stopship(){
  
  dis.add(new PVector(0,0));

  
  }
  void move() {
    ///test speed*velocity//
    velo = new PVector(0,0.01);
    topSpeed = 100;
    
    ////////////////
    // friction
    dis.mult(AIR);
    // gravity
    dis.y += GRAVITY;
    //velocity
   
   // velo.limit(topSpeed);
    dis.add(velo);
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
    if (speed < topSpeed) speed += 0.1;
  }
  
 

} 
