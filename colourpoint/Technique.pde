
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

      move(x, y);

      if (ratio > 0.8) {
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

      //stroke(255);
      //strokeWeight(4);
      //ellipse(x, y, 25, 25);

      // print some debug information
      if (showDebug) {
        fill(255);
        text(ratio, x + 15, y + 15);

        noFill();
        stroke(255);
        strokeWeight(5);
        for (PVector v : b.points) {
          point(v.x, v.y);
        }

        strokeWeight(1);
        noFill();
        rect(b.bb.x, b.bb.y, b.bb.width, b.bb.height);
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