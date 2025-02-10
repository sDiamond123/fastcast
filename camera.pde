public class Camera{
  
  
  private double camX;
  private double camY;
  private double fov;
  private double drawStep;
  private int rayCount;
  private double angle;
  private double drawDist;
  private double [] zBuffer;
  private int [][] map;
  private int rayWidth;
  private int rayHeight;
  private int drawX;
  private int drawY;
  
  public Camera(double x, double y, double ang, double fov, int count, int drawDist, int boxX, int boxY, int boxW, int boxH){
    // init camera
    update(x,y,ang);
    this.fov = (fov);
    drawStep = fov/count;
    rayCount = count;
    this.drawDist = drawDist * drawDist;
    zBuffer = new double[count];
    // init render box
    drawX = boxX;
    drawY = boxY;
    rayWidth = boxW / count;
    rayHeight = boxH;
  }
  
  private double distance (double x_1, double x_2, double y_1, double y_2){
    return (x_1-x_2)*(x_1-x_2) + (y_1-y_2) * (y_1-y_2);
  }
  
  public void update(double newX, double newY, double newAngle){
    angle = newAngle;
    camX = newX;
    camY = newY;
  }
  
  public void render (){
    double rayAngle = angle;
    noStroke();
    for(int i = 0; i < rayCount; i++){
      rayAngle += drawStep;
      rayAngle %= 360;
      raycast(camX, camY, rayAngle, rayCount - i - 1);
    }
  }
  
  public void load(int [][] baseMap){
    map = baseMap;
  }
  
  
  
  private void drawRay(int xOffset, double distance, double offset, int h, int texture){
    if (distance < 1) distance = 1;
    if (offset != -1){
      int drawHeight =  (int) (rayHeight / Math.sqrt(distance));
      fill(255,(float)(255*offset),0);
      rect(drawX + xOffset * rayWidth, drawY - drawHeight/2, rayWidth, drawHeight);
    }
  }
  
private double[] raycast (double x, double y, double angle, int drawOffset){
  double offset = -1;
  double x0 = x;
  double y0 = y;
  double dy = Math.abs(Math.tan(Math.toRadians(angle)));
  double dx = 1/dy;
  double d2x = 0.0001 * Math.cos(Math.toRadians(angle));
  double d2y = 0.0001 * Math.sin(Math.toRadians(angle));
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
  drawRay(drawOffset, distance(x,x0,y,y0),offset, 1, 0);
  return new double []{x,y,distance(x,x0,y,y0),offset};
}
  
}
