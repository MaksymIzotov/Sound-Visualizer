int sphereRadius;

float spherePrevX;
float spherePrevY;

int yOffset;

boolean initialStatic = true;
float[] extendingSphereLinesRadius;


void drawAll(float[] sum) {
  sphereRadius = 15 * round(unit);

  spherePrevX = 0;
  spherePrevY = 0;

  yOffset = round(sin(radians(150)) * sphereRadius);
  
  float x = 0;
  float y = 0;
  int surrCount = 1;
  
  boolean direction = false;
  
  while (x < width * 1.5 && x > 0 - width / 2) {

    float surroundingRadius;
    
    float surrRadMin = sphereRadius + sphereRadius * 1/2 * surrCount;
    float surrRadMax = surrRadMin + surrRadMin * 1/8;

    float surrYOffset;
    
    float addon = frameCount * 1.5;
    
    if (direction) {
      addon = addon * 1.5;
    }

    for (float angle = 0; angle <= 240; angle += 1.5) {
      
      surroundingRadius = map(sin(radians(angle * 7 + addon)), -1, 1, surrRadMin, surrRadMax); // Faster rotation through angles, radius oscillates
      
      surrYOffset = sin(radians(150)) * surroundingRadius;

      x = round(cos(radians(angle + 150)) * surroundingRadius + center.x);
      y = round(sin(radians(angle + 150)) * surroundingRadius + getGroundY(x) - surrYOffset);
    }

    direction = !direction;
    
    surrCount += 1;
  }

  float extendingLinesMin = sphereRadius * 1.3;
  float extendingLinesMax = sphereRadius * 3.5; 
  
  float xDestination;
  float yDestination;
  
  for (int angle = 0; angle <= 240; angle++) {

    float extendingSphereLinesRadius = map(noise(angle * 0.3), 0, 1, extendingLinesMin, extendingLinesMax);
        
    if (sum[0] != 0) {
      if (angle >= 0 && angle <= 30) {
        extendingSphereLinesRadius = map(sum[240 - round(map((angle), 0, 30, 0, 80))], 0, 0.8, extendingSphereLinesRadius - extendingSphereLinesRadius / 8, extendingLinesMax * 1.5); // Highs
      }
      
      else if (angle > 30 && angle <= 90) {
        extendingSphereLinesRadius = map(sum[160 - round(map((angle - 30), 0, 60, 0, 80))], 0, 3, extendingSphereLinesRadius - extendingSphereLinesRadius / 8, extendingLinesMax * 1.5); // Mids
      }
      
      else if (angle > 90 && angle <= 120) {
        extendingSphereLinesRadius = map(sum[80 - round(map((angle - 90), 0, 30, 65, 80))], 0, 40, extendingSphereLinesRadius - extendingSphereLinesRadius / 8, extendingLinesMax * 1.5); // Bass
      }
      
      else if (angle > 120 && angle <= 150) {
        extendingSphereLinesRadius = map(sum[0 + round(map((angle - 120), 0, 30, 0, 15))], 0, 40, extendingSphereLinesRadius - extendingSphereLinesRadius / 8, extendingLinesMax * 1.5); // Bass
      }
      
      else if (angle > 150 && angle <= 210) {
        extendingSphereLinesRadius = map(sum[80 + round(map((angle - 150), 0, 60, 0, 80))], 0, 3, extendingSphereLinesRadius - extendingSphereLinesRadius / 8, extendingLinesMax * 1.5); // Mids
      }
      
      else if (angle > 210) {
        extendingSphereLinesRadius = map(sum[160 + round(map((angle - 210), 0, 30, 0, 80))], 0, 0.8, extendingSphereLinesRadius - extendingSphereLinesRadius / 8, extendingLinesMax * 1.5); // Highs
      }
    }
    
    x = round(cos(radians(angle + 150)) * sphereRadius + center.x);
    y = round(sin(radians(angle + 150)) * sphereRadius + groundLineY - yOffset);

    xDestination = x;
    yDestination = y;

    for (int i = sphereRadius; i <= extendingSphereLinesRadius; i++) {
      int x2 = round(cos(radians(angle + 150)) * i + center.x);
      int y2 = round(sin(radians(angle + 150)) * i + groundLineY - yOffset);
      
        xDestination = x2;
        yDestination = y2;
    }
    
   
    
    float bColor = sqrt(pow(xDestination - x,2) + pow(yDestination - y,2));
    stroke(angle, 255-angle, 150,map(bColor, 100, 300, 50, 255));
   line(x, y, xDestination, yDestination);
  }
}

float getGroundY(float groundX) {

  float angle = 1.1 * groundX / unit * 10.24;

  float groundY = sin(radians(angle + frameCount * 2)) * unit * 1.25 + groundLineY - unit * 1.25;

  return groundY;
}
