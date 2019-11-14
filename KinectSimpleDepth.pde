import peasy.PeasyCam;

PeasyCam cam;

PImage depth, rgb;
PShape shp;

float threshold = 30;

void setup() {
  size(1280, 720, P3D);
  cam = new PeasyCam(this, width/2, height/2, 400, 50);
  
  depth = loadImage("depth.png");
  depth.loadPixels();
  rgb = loadImage("rgb.png");
  rgb.loadPixels();
  shp = createShape();
  
  shp.beginShape(POINTS);
  shp.strokeWeight(2);
  for (int y=0; y<depth.height; y++) {
    for (int x=0; x<depth.width; x++) {
      int loc = x + y * depth.width;
      float r = red(depth.pixels[loc]);
      if (r > threshold) {
        color col = rgb.pixels[loc];
        float z = getDistance(r) * 1000.0;
        shp.stroke(col);
        shp.vertex(x+width/4,y+height/4,z - 2000);
      }
    }
  }
  shp.endShape();
}

void draw() {
  background(0);
  shape(shp);
}

float maxDistance = -1.0;

void getMaxDistance() {
  for (int i=1; i<256; i++) {
    maxDistance += 1.0/i;
  }
}

float getDistance(float val) {
  if (maxDistance < 0) getMaxDistance();
  
  float returns = 0.0;

  for (int i=1; i<val+1; i++) {
    returns += 1.0/i;
  }
  
  return abs(maxDistance - returns) + 1.0;
}
