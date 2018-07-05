

color WHITE = color(255);
color BLACK = color(0);


PImage imageAnd(PImage a, PImage b) {

  PImage out = createImage(a.width, a.height, RGB);
  out.loadPixels();
  for (int i = 0; i < a.height * a.width; i++) {
    float ac = blue(a.pixels[i]);
    float bc = blue(b.pixels[i]);

    if (ac > 128 && bc > 128) {
      out.pixels[i] = WHITE;
    }
  }
  out.updatePixels();

  return out;
}

PImage imageMirror(PImage img) {

  PImage out = createImage(img.width, img.height, RGB);

  out.loadPixels();
  for (int i = 0; i < img.width; i++) {
    for (int j = 0; j < img.height; j++) {  
      out.pixels[j * img.width + i] = img.pixels[(img.width - i - 1) + j * img.width];
    }
  }
  out.updatePixels();

  return out;
}


PImage imageInRange(PImage img, Colour cMin, Colour cMax, float expand) {

  PImage out = createImage(img.width, img.height, RGB);

  out.loadPixels();
  Colour c = new Colour();
  for (int i = 0; i < img.height * img.width; i++) {

    c.fromColor(img.pixels[i]);

    if ((c.h > cMin.h - expand && c.h < cMax.h + expand) &&
      (c.s > cMin.s - expand && c.s < cMax.s + expand) &&
      (c.b > cMin.b - expand && c.b < cMax.b + expand)) {
      out.pixels[i] = WHITE;
    } else {
      out.pixels[i] = BLACK;
    }
  }
  out.updatePixels();

  return out;
}


void erode(int n) {
  for (int i = 0; i < n; i++) {
    opencv.erode();
  }
}


void dilate(int n) {
  for (int i = 0; i < n; i++) {
    opencv.dilate();
  }
}


void cross(float x, float y, float s) {
  line(x - s, y, x + s, y);
  line(x, y - s, x, y + s);
}


void drawPoints(ArrayList<PVector> p) {
  beginShape();
  for (int i = 0; i < p.size(); i++) {
    vertex(p.get(i).x, p.get(i).y);
  }
  endShape(CLOSE);
}

// retrieves the complete list of cameras
void getCameraList() {

  // this sometimes hangs, so make sure "done" eventually appears
  print("Getting list of cameras ... ");
  String[] cameras = Capture.list();
  println("done");

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
  } else if (cameras.length == 0) {
    println("There are no cameras available for capture.");
  } else {
    println("Available cameras:");
    printArray(cameras);
  }

  // exit after getting list
  // (you need to put a specific camera in the setup code above)
  exit();
}
