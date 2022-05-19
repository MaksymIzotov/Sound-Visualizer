int cols, rows;
int w = 2000;
int h = 1600;

boolean changeScl;

float flying = 0;

float[][] terrain;

void start() {
  cols = w / 20;
  rows = h / 20;
  changeScl = true;
  terrain = new float[cols][rows];
}


void drawTerrain(float[] scl) {
 
  flying -= 0.1;

  float yoff = flying;
  for (int i = 0; i < rows; i++) {
    float xoff = 0;
    for (int j = 0; j < cols; j++) {
      terrain[j][i] = map(noise(xoff, yoff), 0, 1, -50,50);
      xoff += 0.2;
    }
    yoff += 0.2;
  }
  
  int mult = 4;
  
  stroke(255);
  noFill();

  translate(width/2, height/2+50);
  rotateX(PI/3);
  translate(-w/2, -h/2);
  for (int i = 0; i < rows-1; i++) { 
    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j < cols;j++) {
      if(j<10)
    mult = 8;
      else
    mult = 4;
    
      vertex(j*20, i * 20, terrain[j][i] * scl[j+15]/mult);
      vertex(j*20, (i+1) * 20, terrain[j][i+1] * scl[j+15]/mult);     
    }
    endShape();
  }
}
