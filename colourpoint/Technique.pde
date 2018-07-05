/* 
 * Classes to build and demonstrate different pointing techniques
 */


// This is the base class for all pointing techniques
class PointingTechnique {

  String name = "no technique";

  boolean isDown = false;

  // 5% of image area usually works well
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

// This technique uses first colour blob for cursor position
// and clicks whenever it sees a second colour blob
class TwoColour extends PointingTechnique {

  TwoColour() {
    name = "twocolour";
  }

  void handle(Blob[][] blobs) {

    displayName();

    // check if at least one blob is found for the first colour 
    if (blobs[0][0] != null) {

      // use the largest blob of colour 0 (the first colour)
      Blob b = blobs[0][0];

      // this is the centre position of the blob
      float x = b.x;
      float y = b.y;

      //  move the cursor to that position
      move(x, y);

      // now, check if at least one blob is found for the second colour 
      if (blobs[1][0] != null) {
        // if other colour blob is found, then click down
        down(x, y);
      } else {
        // otherwise there was no second colour, so click up
        up(x, y);
      }
    }
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

    // check if at least one blob is found for the first colour 
    if (blobs[0][0] != null) {

      // use the largest blob of colour 0 (the first colour)
      Blob b = blobs[0][0];

      // this is the centre position of the blob
      float x = b.x;
      float y = b.y;

      //  move the cursor to that position
      move(x, y);

      // calculate the ratio from blob width and height
      float ratio = b.bb.width / float(b.bb.height);

      // if the ratio is greater than "square" then click
      float threshold = 1.0;

      if (ratio > threshold) {
        down(x, y);
      } else {
        up(x, y);
      }

      // visualize feedback with some circles 
      noFill();
      stroke(200);
      strokeWeight(1);
      ellipse(x, y, threshold * 100, threshold * 100);
      stroke(255);  
      strokeWeight(2);
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

      // bounding box of blob
      strokeWeight(1);
      noFill();
      stroke(255);
      rect(b.bb.x, b.bb.y, b.bb.width, b.bb.height);

      // convext hull of blob
      stroke(255, 0, 0);
      strokeWeight(6);
      for (PVector v : b.convexHullPoints) {
        point(v.x, v.y);
      }       

      // simplified  points of blob shape
      stroke(0, 255, 0);
      strokeWeight(4);
      for (PVector v : b.simplePoints) {
        point(v.x, v.y);
      }  

      // all points of blob shape
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
