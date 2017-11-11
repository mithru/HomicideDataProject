// import UDP library
import hypermedia.net.*;

UDP udp;  // define the UDP object

PImage heatmap;

void setup() {
  heatmap = loadImage("data/homiciderates cut2.png");
  setupKinect();
  size(displayWidth, displayHeight);
  noStroke();
  udp = new UDP( this, 6000 );
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
}

void draw() {
  int val = getAverageRate(heatmap, int(theX), int(theZ), 10);
  background(255-val);
  image(heatmap, 0, 0);

  kinectLoop();
  //println(val);
  sendUDPMessage(""+val);
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