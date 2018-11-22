import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
Box2DProcessing box2d;

import processing.sound.*;

PinkNoise noise;

ArrayList<Box> boxes;

ArrayList<Integer> terrain;


final float GRAVITY = 0.007;
final float AIR = 0.99;
final float TURN_VALUE = PI/40;
final float PROP = 0.02;
boolean usingfuel;
boolean empty = false;
int fuel=0;
boolean usingsound = false;
boolean explosed = false;
boolean win ;
boolean end;

//particle///
ArrayList plist = new ArrayList();
int MAX = 15;


//ship///
Ship ship;


//ball array
Ball[] balls;

boolean[] keys = new boolean[4];

//////sound//////
int nb_axe = 25;

void setup() {
  ship = new Ship(new PVector(width/2, height/2), 10);
  size(1200, 800,P3D); 
  fuel = 400;
   noise = new PinkNoise(this);
  frameRate(25);
  smooth();
  win = false;
  explosed= false;
  end = false;
  ////box2d////gaz box///////
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, -10);

  // Create ArrayLists  
  boxes = new ArrayList<Box>();
  
  ///////mountain/////
  
  terrain = new ArrayList<Integer>(nb_axe);
  
  
   float variation = 0.25;
   float n;
   float y;
    for (float i = 0; i < nb_axe; i++) {
         n = noise(variation*i);
         y = map(n, 0, 1, 0, height/3);
       
       terrain.add(height - (int)y);
    }
  
  
  //we fill the Ball array backrgound, midground, foreground
  balls = new Ball[total];
  for (int i = 0; i < balls.length; i++) {
    if (i < bground) {
      balls[i] = new Ball(bgsize);
    } else if (i < mdground+bground) {
      balls[i] = new Ball(mdsize);
    } else if (i >= mdground) {
      balls[i] = new Ball(frsize);
    }
  }
  
  
}


void draw() {
    background(0,0,100);
  // Move and display balls parralax
  for (int i = 0; i < balls.length; i++) {
    balls[i].move();
    balls[i].display();
  }
 box2d.step();
 
 
 
 
 if(keyPressed){

  if(key == 'R'||key == 'r'){
    setup();
  }
  
}else{ ship.speed --;}
  
  view(); 
  /////sound/////
  noise.pan( 0.9);
  noise.amp( 0.3);
  
  model();  
  
   for (Box b: boxes) {
            b.display();
          }
          
          //////colision//////
          if(!explosed) {
          
          
    float x = ship.pos.x / width * nb_axe;
     if(Math.floor(x) == Math.ceil(x)) {
       //entier///
       float yterrain = terrain.get((int)x);      
       println(yterrain); 
       }else{                  
       ///pas entier
       
      int x2 = (int)Math.ceil(x);
      int x1 = (int)Math.floor(x);
      int y2 = terrain.get(x2);
      int y1 = terrain.get(x1);
      
        float a = (y2-y1)/(x2-x1);           //pente
                                         
        float b = y2 - a*x2 ;  
        
        float ys = a*x+b;
               
       // System.out.println(" X: " + x + " X1: " + x1 + " X2: " + x2 + " Y1: " + y1 + " Y2: " + y2 + " a: " + a + " b: " + b + "  Ship: " +ship.pos.y + " line: " + yship);////test console
 
         if(ship.pos.y >= ys){
           
          end = true;
         
           if(ship.dis.y*10 >=4 && ship.dis.y*10 <= 6){
          
              text("Partie Gagner vous avez poser le ship  " , width/3, 300); 
              
              win = true;
           
              
           }else{
           
           
              explosed = true;
              System.out.println("hi");
              for (int j = 0; j < MAX; j ++) {
                    plist.add(new Particle(ship.pos.x,ship.pos.y)); // fill ArrayList with particles//changer mettre pos.vaisseau              
                }     
           
             text("GAME OVER" , width/3, 300); 
           
           
           }
         
         
         }
       }         
 }
          
    for(int i = 0; i < plist.size(); i++) {
    Particle p = (Particle) plist.get(i); 
    //makes p a particle equivalent to ith particle in ArrayList
    p.run();
    p.update();
    p.gravity();
  } 
  
   //////sound////
 if(usingsound){
      noise.play();
 }else noise.stop();
 
   ///destroy gazbox/////
     for (int i = boxes.size()-1; i >= 0; i--) {
    Box b = boxes.get(i);
    if (b.done()) {
      boxes.remove(i);
    }
  }
  /////////////mountain vertx/////////
  fill(85,33,3,255);
  stroke(250);
  
  beginShape();
  
  for(int i = 0; i < terrain.size(); i++) {
    vertex(width / terrain.size() * i, terrain.get(i));  
 
  }
  
  vertex(width, terrain.get(terrain.size() - 1));
  vertex(width, height);
  vertex(0, height);
  
  endShape(CLOSE);
  
  ////////////////////vie du ship////
 
   if (!empty && !explosed){
      ship.draw();
  }else if(empty && !explosed){
      ship.draw();
  }
  
}


// physics 
void model() {
  if(win == false){
   handleKeys();
   ship.move();
  }else{
  
  ship.stopship();
  
  }
 
}


// drawing ship data
void view() {

  int x = fuel;
  textSize(32);
  fill(255,0,0);
  
   text("fuel : " + fuel+" kg", width-200, 250); 
 
   text("Pour gagner vous devez poser le ship avec une vitesse de 4 a 7" , 0, 100); 
    if (end == false){
    
   
 
  text("speed :"+ ship.dis.y*10,width-250,300);
 
 
    }
  
 
   /////////
  fill(255);
  //text(ship.pos.y,ship.pos.x +10,ship.pos.y);
  
  /////////
  
  
}

void keyPressed() {
 
  if(!empty){
      if (key == CODED) {
        switch (keyCode) {
          case UP:
            keys[0] = true;
            usingfuel = true;
            usingsound = true;
            ship.speed ++;
         
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
}

void keyReleased() {
  if (key == CODED) {
    switch (keyCode) {
      case UP:
        keys[0] = false; 
        usingfuel = false; 
         usingsound = false;
        
        break;
      case LEFT:
        keys[1] = false; break;
      case RIGHT:
        keys[2] = false; break;
    }
  }
}


 
 
 
 

void decreasefuel(int fuel){

    if(fuel >0){    
        this.fuel --;
       }      
       if(fuel == 0){    
         empty = true;
         
        }
     }
           



void handleKeys() {
  
  
  if (keys[0]) ship.thrust();            // THRUST
  if (keys[1]) ship.turns(-TURN_VALUE);  // LEFT
  if (keys[2]) ship.turns(TURN_VALUE);   // RIGHT
  
  if(usingfuel){
    
      decreasefuel(fuel);
          
          if (random(1) < 0.2) {
             Box p = new Box(ship.pos.x,ship.pos.y+10);
             boxes.add(p);
           }
         
    }
  
  
  
}
