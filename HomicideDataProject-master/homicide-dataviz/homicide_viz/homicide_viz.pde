// import UDP library
import hypermedia.net.*;

UDP udp;  // define the UDP object

PImage heatmap;
PImage maskImg;

void setup() {
  heatmap = loadImage("data/homiciderates cut2.png");
  maskImg = createImage(heatmap.width, heatmap.height, ARGB);
  maskImg.loadPixels();

  setupKinect();
  size(displayWidth, displayHeight);
  noStroke();
  udp = new UDP( this, 6000 );
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
}

void draw() {
  //int val = getAverageRate(heatmap, int(theX), int(theZ), 10);
  int val = getAverageRate(heatmap, mouseX, mouseY, 10);
  updateMask(mouseX,mouseY,100);
 // background(255-val);
  background(255);
  image(heatmap, 0, 0);

  kinectLoop();
  //println(val);
  sendUDPMessage(""+val);
}

void updateMask(int x, int y, int radius) {
  for (int i = 0; i < maskImg.pixels.length; i++) {
    float distance = dist(i%maskImg.width, i/maskImg.width, x, y);
    if (distance < radius) {
      maskImg.pixels[i] = color(map(distance, 0, radius, 255, 0));
    }
  }
  maskImg.updatePixels();
  heatmap.mask(maskImg);
}

int getAverageRate(PImage img, int x, int y, int boxSize) {

  float values[] = new float[4];

  float total = 0;

  for (int i = 0; i < 4; i++) {
    int currX = x + (i%2)*boxSize - boxSize/2;
    int currY = y + (i/2)*boxSize - boxSize/2;

    color c = img.get(currX, currY);

    fill(c);
    rect(currX, currY, boxSize/3, boxSize/3);

    if (green(c) == red(c)) values[i] = 0;
    else values[i] = 255-green(c);

    total += values[i];
  }

  int average = int(total/4);

  return average;
}