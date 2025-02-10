
double distance (double x_1, double x_2, double y_1, double y_2){
  return (x_1-x_2)*(x_1-x_2) + (y_1-y_2) * (y_1-y_2);
}

double[] raycast (double x, double y, double angle, int [][] map){
  double x0 = x;
  double y0 = y;
  double dy = Math.abs(Math.tan(Math.toRadians(angle)));
  double dx = 1/dy;
  double d2x = 0.01 * Math.cos(Math.toRadians(angle));
  double d2y = 0.01 * Math.sin(Math.toRadians(angle));
  if (dy > 300){
    dy = 300;
  }
  if (dx > 300){
    dx = 300;
  }
  int x_increase = 1;
  int y_increase = 1;
  
  
  if (angle > 180) {
    y_increase = -1;
  }
 while(distance(x,x0, y, y0) <= 64){
     if (map[(int)y][(int)x] == 1){
       //println("HIT");
       break;
     }
      double x_n = 1 + (int)x - x;
     if (angle > 90 && angle < 270){
      x_n = x-(int)x;
      x_increase = -1;
    }
    double y_n = dy * x_n;
      if (y+y_n*y_increase < (int) y + 1 && y+y_n*y_increase > (int) y){
        x= (int)x;
        if (x_increase >0){
         x+= 1;
        }
        y+=y_increase * y_n;
      }
      else {
        double projected= y + y_n*y_increase;
        y= (int)y;
        if (y_increase >0){
          y+= 1;
        }
        if (angle%90 != 0){
          double delta_x = Math.abs(y - projected) * dx * x_increase;
          //println("\tprojected:"+(projected)+" cot theta:"+ dx+" diff:"+Math.abs(y - projected) + " dx" +delta_x);
          x= (int)x;
          if (x_increase >0){
           x+= 1;
          }
          x-= delta_x;
          }
      }
      x+=d2x;
      y+=d2y;
  }
  return new double []{x,y};
}

/*
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
  for (double i = 0; i < 100; i++){
    double j = angle + i/3;
    j%=360;
    double [] xy = raycast_2(x,y,j,map);
    stroke(255,(float)(255*xy[3]),0);
    line ((float)x*100, (float)y*100, (float)xy[0] * 100, (float) xy[1] * 100);
  }
  
  fill(255,0,0);
  stroke(0,0,0);
  rect((float)x*100 - 4, (float)y*100 - 4, 8, 8);
*/

double[] raycast_2 (double x, double y, double angle, int [][] map){
  double offset = 255;
  double x0 = x;
  double y0 = y;
  double dy = Math.abs(Math.tan(Math.toRadians(angle)));
  double dx = 1/dy;
  double d2x = 0.00001 * Math.cos(Math.toRadians(angle));
  double d2y = 0.00001 * Math.sin(Math.toRadians(angle));
  if (dy > 1000) dy = 1000;
  if (dx > 1000) dx = 1000;
  int x_increase = 1;
  int y_increase = 1;
  if (angle > 180) y_increase = -1;
  if (angle > 90 && angle < 270) x_increase = -1;
  while(distance(x,x0, y, y0) <= 64){
     if (map[(int)y][(int)x] != 0){
      double offsetX = Math.abs(x - (int) x);
      if (offsetX > 0.5) offsetX = 1 - offsetX;
      double offsetY = Math.abs(y - (int) y);
      if (offsetY > 0.5) offsetY = 1- offsetY;
      offset = Math.abs(y - (int) y);
      if (offsetY < offsetX) offset = Math.abs(x - (int) x);
       break;
     }
     double x_n = 1 + (int)x - x;
     if (x_increase<0) x_n = x-(int)x;
     double proj_y = y + dy * x_n * y_increase;
     boolean ang_check = angle != 0 && angle !=90 && angle != 180 && angle !=270;
     if (ang_check){
          x= (int)x;
          if (x_increase >0){
           x+= 1;
          }
     }
     if (proj_y < (int)y + 1 && proj_y > (int) y){
       y=proj_y;
     }
     else {
        y= (int)y;
        if (y_increase >0){
          y+= 1;
        }
        if (ang_check){
          x-= Math.abs(y - proj_y) * dx * x_increase;
        }
      }
      x+=d2x;
      y+=d2y;
  }
  return new double []{x,y,distance(x,x0,y,y0),offset};
}
