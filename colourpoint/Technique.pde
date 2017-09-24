
class PointingTechnique {

  String name = "no technique";

  boolean isDown = false;

  // 5%
  float minBlobArea = 0.005 * processWidth * processHeight;

  // how blurry to make the frame before colour subtractions
  // (high blur will slow things down, 0 turns bluring off (but you'll get more noise)
  int blurIterations = 0;

  // morphological operations to clean up noise
  // (usually want erode and dilate iterations to be the same)
  int erodeIterations = 4;
  int dilateIterations = 4;

  void displayName() {

    fill(255);
    textAlign(LEFT, TOP);
    textSize(12);
    text(name, 5, 5);
  }

  void handle(Blob[][] blobs) {
    displayName();
  }
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// This technique tracks a shape with narrow width 
// compared to its height (low aspect ratio)
// when the aspect ratio is closer to 1, then it
// clicks down
class RatioClick extends PointingTechnique {

  RatioClick() {
    name = "ratioclick";
  }

  void handle(Blob[][] blobs) {

    displayName();

    // use the largest blob of colour 0
    if (blobs[0][0] != null) {
      Blob b = blobs[0][0];

      float x = b.x;
      float y = b.y;

      float ratio = b.bb.width / float(b.bb.height);
      
      float threshold = 1.0;

      move(x, y);

      if (ratio > threshold) {
        if (!isDown) {
          down(x, y); 
          isDown = true;
        }
        noFill();
      } else {
        if (isDown) {
          up(x, y);
          isDown = false;
        }
        fill(200);
      }

      // visualize feedback  
      stroke(255);
      strokeWeight(1);
      noFill();
      ellipse(x, y, threshold * 100, threshold * 100);

      // visualize feedback
      ellipse(x, y, ratio * 100, ratio * 100);

    }
  }
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Not really a technique, but shows how to get 
// Blob information
class ShowBlobFeatures extends PointingTechnique {

  ShowBlobFeatures() {
    name = "showblobfeatures";
  }

  void handle(Blob[][] blobs) {

    displayName();

    // put cursor in centre
    move(mainWidth/2, mainHeight/2);

    if (blobs[0][0] != null) {
      Blob b = blobs[0][0];


      noFill();
      strokeWeight(1);
      stroke(255);
      ellipse(b.x, b.y, 10, 10); 

      // bounding box
      strokeWeight(1);
      noFill();
      stroke(255);
      rect(b.bb.x, b.bb.y, b.bb.width, b.bb.height);

      // convext hull   
      stroke(255, 0, 0);
      strokeWeight(6);
      for (PVector v : b.convexHullPoints) {
        point(v.x, v.y);
      }       

      // smplified  points
      stroke(0, 255, 0);
      strokeWeight(4);
      for (PVector v : b.simplePoints) {
        point(v.x, v.y);
      }  

      // All points
      stroke(0, 0, 255);
      strokeWeight(2);
      for (PVector v : b.points) {
        point(v.x, v.y);
      }
    }
  }
}



// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// for faking mouse input when testing
class MousePoint extends PointingTechnique {

  MousePoint() {
    name = "mousepoint";
  }

  void handle(Blob[][] blobs) {

    displayName();

    float x = mouseX;
    float y = mouseY;

    move(x, y);

    if (mousePressed && !isDown) {
      down(x, y);
      isDown = true;
    } else if (!mousePressed && isDown) {
      up(x, y);
      isDown = false;
    }
  }
}