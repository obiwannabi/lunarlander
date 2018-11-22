int bground = 100;
int mdground =4;
int frground = 2;

//array length = all layers together
int total = bground+mdground+frground;

//size of balls in 3 layers
int bgsize = 5;
int mdsize = 35;
int frsize = 150;

//Initialize Color Array, colors by https://kuler.adobe.com/Retro-Rain-color-theme-2861967/
color[] colors= { 
  color(78, 40, 142), 
  color(131, 142, 20), 
  color(95, 5, 8), 
  color(12, 95, 5), 
  color(255, 104, 10),
};






class Ball {
  int size;  // size
  float r;   // radius
  float x, y; // location
  float xspeed; // speed
  color bcolor; // color

    // Constructor
  Ball(float tempR) {
    r = tempR;
    x = random(width);     //position the balls randomly on the canvas
    y = random(height);
    xspeed =  map(r, bgsize, frsize, 2, 8);     //map the speed in x-direction based on the size/layer of the balls
    bcolor = colors[(int) random(0, colors.length)];    //assign a random color value from the colors array
  }

  void move() {
    x += xspeed*0.1; // Increment x
   // y += map(mouseY, 0, height, -5, 5);

    // Check edges
    if (x > width+r || x < -r) {
      x= -r-random(width)/2;
      y = random(height);
    }
    if (y > height+r || y < -r) {
      x= -r-random(width)/2;
      y = random(height);
    }
  }
  void display() {  // Draw the ball
    noStroke();
    fill(bcolor);    // assign fill color
    pushMatrix();
    translate(x,y);     //translate in x and y direction
    ellipse(0, 0, r, r);     // draw the ball
    popMatrix();
  }
}
