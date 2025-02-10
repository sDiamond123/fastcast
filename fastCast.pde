int [][] map = {{1,1,1,1,1,1,1,1,1,1},{1,0,0,1,1,0,0,0,0,1},{1,0,0,1,0,0,0,0,0,1},{1,0,0,0,1,0,0,0,0,1},{1,0,0,0,0,0,0,0,0,1},{1,0,0,1,1,1,0,0,0,1},{1,0,0,1,0,1,0,0,0,1},{1,0,0,1,0,0,0,0,0,1},{1,0,0,0,0,0,0,0,0,1},{1,1,1,1,1,1,1,1,1,1},};
double angle = 30;
double x = 1.1;
double y = 1.1;
Camera p;
void setup(){
  surface.setTitle("Long's Word");
  surface.setResizable(true);
  int w = 1000;
  windowResize(w + 380,w);
  p = new Camera(x, y, angle, 90, 180, 8, 1010, 400, 4*90, 2 * 90);
  p.load(map);
}
void draw(){
  fill(255);
  rect (1010, 310, 4 * 90, 2 * 90);
    
  for (int i = 0; i < 10; i++){
    for (int j = 0; j < 10; j++){
      if (map[j][i] == 0){
        fill(255,255,255);
      }
      else{
        fill(0,0,0);
      }
      rect(i*100, j*100, 100, 100);
    }
  }
  for (double i = 0; i < 180; i++){
    double j = angle + i/2;
    j%=360;
    double [] xy = raycast_2(x,y,j,map);
    stroke(255,(float)(255*xy[3]),0);
    line ((float)x*100, (float)y*100, (float)xy[0] * 100, (float) xy[1] * 100);
  }
  fill(0,255,0);
  rect((float)x*100 - 4, (float)y*100 - 4, 8, 8);
  
  p.update(x,y,angle);
  p.render();
  stroke(0,0,0);

}

void keyPressed(){
  if (key == 'w'){
    y-=0.3;
  }
  else if (key == 's'){
    y+=0.3;
  }
  else if (key == 'a'){
    x-= 0.3;
  }
  else if (key == 'd'){
    x+=0.3;
  }
  else if (key == 'e'){
    angle += 5;
    if (angle >=360 ){
      angle = 0;
    }
  }
  else if (key == 'q'){
    angle -= 5;
    if (angle < 0){
      angle = 359;
    }
  }
}
