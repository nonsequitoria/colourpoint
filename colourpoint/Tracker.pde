
boolean on = true;



class Tracker {


  boolean calibrate = false;

  int numColours = 2;
  int calibrateColour = 0;
  Colour[] trackMin = new Colour[numColours];
  Colour[] trackMax = new Colour[numColours];

  int trackExpand = 10;


  ArrayList<Contour> contours;


  int maxBlobsPerColour = 5;



  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  void setup() {
    contours = new ArrayList<Contour>();
    for (int i = 0; i < numColours; i++) {
      trackMin[i] = new Colour();
      trackMax[i] = new Colour();
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


  void train(int x, int y, int w, int h, boolean clear) {

    if (w < 0) {
      x  = x + w;
      w = abs(w);
    }

    if (h < 0) {
      y  = y + h;
      h = abs(h);
    }

    println("train ", x, y, w, h);
    println("clear ", clear);

    float ratio = captureWidth / float(mainWidth);

    PImage img = lastFrame.get(int(x * ratio), int(y * ratio), int(w * ratio), int(h * ratio));

    //img.filter(BLUR, 3);
    img.loadPixels();

    if (clear) {
      trackMin[calibrateColour] = new Colour(256, 256, 256);
      trackMax[calibrateColour] = new Colour(-1, -1, -1);
    }

    Colour c = new Colour();

    for (int j = 0; j < img.height * img.width; j++) {

      c.fromColor(img.pixels[j]);

      if (c.h < trackMin[calibrateColour].h) 
        trackMin[calibrateColour].h = c.h;
      if (c.h > trackMax[calibrateColour].h) 
        trackMax[calibrateColour].h = c.h;
      if (c.s < trackMin[calibrateColour].s) 
        trackMin[calibrateColour].s = c.s;
      if (c.s > trackMax[calibrateColour].s) 
        trackMax[calibrateColour].s = c.s;
      if (c.b < trackMin[calibrateColour].b) 
        trackMin[calibrateColour].b = c.b;
      if (c.b > trackMax[calibrateColour].b) 
        trackMax[calibrateColour].b = c.b;
    }

    println("min", trackMin[calibrateColour].toString());
    println("max", trackMax[calibrateColour].toString());
    //img.updatePixels();
  }


  PImage temp;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  void track(PImage img) {

    // scale down the image
    if (captureWidth != processWidth)
      img.resize(processWidth, processHeight);

    int scale = mainWidth / processWidth;

    img.filter(BLUR, technique.blurIterations);

    Blob[][] blobs = new Blob[numColours][maxBlobsPerColour];

    // for each colour
    for (int i = 0; i < numColours; i++) {

      PImage mask = imageInRange(img, trackMin[i], trackMax[i], trackExpand);

      // morphological operations
      int k;
      for (k = 0; k < technique.erodeIterations; k++)
        mask.filter(ERODE);
      for (k = 0; k < technique.dilateIterations; k++)
        mask.filter(DILATE);

      opencv.loadImage(mask);
      contours = opencv.findContours(true, true);

      int j = 0;

      if (showDebug) {
        pushMatrix();
        translate(mainWidth, 0);
        scale(scale, scale);

        image(mask, 0, 0);
        fill(0, 200);
        noStroke();
        rect(0, 0, mainWidth, mainHeight);

        stroke(trackMax[i].toColor());
        noFill();
        strokeWeight(3);
      }

      for (Contour contour : contours) {

        // contours are sorted, so break when they get too small
        if (contour.area() < technique.minBlobArea || j >= maxBlobsPerColour)
          break;

        Rectangle r = contour.getBoundingBox();

        if (showDebug) {
          // draw the blob for debug
          stroke(trackMax[i].toColor());
          noFill();
          strokeWeight(3);
          contour.draw();

          strokeWeight(1);
          rect(r.x, r.y, r.width, r.height);
        }

        // set the blob data
        Blob b = new Blob();
        b.empty = false;
        b.area = contour.area() * scale * scale;

        b.bb = r;
        b.bb.x *= scale;
        b.bb.y *= scale;
        b.bb.width *= scale;
        b.bb.height *= scale;
        b.x = r.x + r.width / 2;
        b.y = r.y + r.height / 2;

        //println(contour.getPolygonApproximationFactor());
        contour.setPolygonApproximationFactor(0.5);
        Contour allPoints = contour.getPolygonApproximation();
        b.points =  allPoints.getPoints();

        contour.setPolygonApproximationFactor(5);
        Contour approxContour = contour.getPolygonApproximation();
        b.simplePoints =  approxContour.getPoints();

        b.convexHullPoints = contour.getConvexHull().getPoints();

        for (PVector v : b.points) {
          v.x *= scale;
          v.y *= scale;
        }

        for (PVector v : b.convexHullPoints) {
          v.x *= scale;
          v.y *= scale;
        }

        for (PVector v : b.simplePoints) {
          v.x *= scale;
          v.y *= scale;
        }

        blobs[i][j] = b;
        j++;
      }
      if (showDebug) 
        popMatrix();
    }

    if (showDebug) {

      pushMatrix();
      translate(mainWidth, 0);


      for (int i = 0; i < blobs.length; i++) 
        for (int j = 0; j < blobs[i].length; j++) {
          Blob b = blobs[i][j];

          if (b != null) {


            // draw the blob for debug
            stroke(trackMax[i].toColor());
            fill(255, 120);
            strokeWeight(3);
            // draw contour
            drawPoints(b.points);

            noFill();
            strokeWeight(1);
            rect(b.bb.x, b.bb.y, b.bb.width, b.bb.height);


            int x = b.bb.x + b.bb.width + 5;
            int y = b.bb.y + b.bb.height - 30;

            //stroke(255);
            //strokeWeight(1);
            //line(x - 10, y -10, b.x + r.width / 4, b.y + r.height / 4);
            fill(255);
            textSize(14);
            textAlign(LEFT, BOTTOM);
            text("colour " + i + " blob " + j, x, y);
            y += 15;
            text(" area: " + int(b.area), x, y); 
            y += 15;
            text(" size: " + int(b.bb.width) + " x " + int(b.bb.height), x, y);
          }
        }


      popMatrix();
    }
    // call the technique
    if (technique != null)
      technique.handle(blobs);


    //// <9> Check to make sure we've found any contours
    //if (contours.size() > 0) {
    //  // <9> Get the first contour, which will be the largest one
    //  Contour biggestContour = contours.get(0);

    //  contour.draw();

    //  // <10> Find the bounding box of the largest contour,
    //  //      and hence our object.
    //  Rectangle r = biggestContour.getBoundingBox();

    //  //// <11> Draw the bounding box of our object
    //  //dbg.noFill(); 
    //  //dbg.strokeWeight(2); 
    //  //dbg.stroke(255, 0, 0);
    //  //dbg.rect(r.x, r.y, r.width, r.height);

    //  //// <12> Draw a dot in the middle of the bounding box, on the object.
    //  //dbg.noStroke(); 
    //  //dbg.fill(255, 0, 0);
    //  //dbg.ellipse(r.x + r.width/2, r.y + r.height/2, 30, 30);
    //}
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  void draw() {

    if (calibrate) {
      stroke(255);
      int t = 4;
      if (clearCalibration) {
        t = 8;
      }
      strokeWeight(t);
      noFill();
      rect(t/2, t/2, mainWidth - t, mainHeight - t);

      if (drawSample) {
        stroke(255);
        strokeWeight(1);
        noFill();
        rect(sampleSize[0], sampleSize[1], sampleSize[2], sampleSize[3]);
      }
    }

    if (showDebug) {
      // draw colour samples
      noFill();
      int s = 40;
      for (int i = 0; i < numColours; i++) { 


        noStroke();
        fill(trackMin[i].toColor());
        rect(mainWidth + i * s, mainHeight - s - 1, s/2, s);
        fill(trackMax[i].toColor());
        rect(mainWidth + (i * s) + 20, mainHeight - s - 1, s/2, s);

        if (calibrateColour == i && calibrate) {
          noFill();
          stroke(255);
          strokeWeight(1);
          rect(mainWidth + i * s, mainHeight - s - 1, s, s);
        }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  void save(JSONObject json) {

    for (int i = 0; i < numColours; i++) {
      trackMin[i].saveJSON("trackMin" + i, json); 
      trackMax[i].saveJSON("trackMax" + i, json);
    }
    json.setInt("trackExpand", trackExpand);
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  void load(JSONObject json) {

    for (int i = 0; i < numColours; i++) {
      trackMin[i].loadJSON("trackMin" + i, json); 
      trackMax[i].loadJSON("trackMax" + i, json);
    }
    trackExpand = json.getInt("trackExpand");
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // drawing rect when sampling colour area

  boolean drawSample = false; 
  int[] sampleSize = new int[4]; 
  boolean clearCalibration = false; 

  void mousePressed() {
    if (calibrate) {
      drawSample = true; 
      sampleSize[0] = mouseX; 
      sampleSize[1] = mouseY; 
      sampleSize[2] = 0; 
      sampleSize[3] = 0;
    }
  }

  void mouseDragged() {
    if (calibrate) {
      sampleSize[2] = mouseX - sampleSize[0]; 
      sampleSize[3] = mouseY - sampleSize[1];
    }
  }

  void mouseMoved() {
  }

  void mouseReleased() {
    if (calibrate) {
      drawSample = false; 
      tracker.train(sampleSize[0], sampleSize[1], sampleSize[2], sampleSize[3], clearCalibration);
      clearCalibration = false;
    }
  }

  void keyPressed() {

    switch (key) {
    case 'C':
      clearCalibration = true;
      trackMin[calibrateColour] = new Colour(256, 256, 256);
      trackMax[calibrateColour] = new Colour(-1, -1, -1);

      break;
    case '1':
      calibrateColour = 0;
      break;

    case '2':
      calibrateColour = 1;
      break;
    }
    //if (key == CODED && keyCode == SHIFT) {
    //  shiftDown = true;
    //}
  }

  void keyReleased() {
    //shiftDown = false;
  }
}