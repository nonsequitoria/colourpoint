
// look at RatioClick PointingTechnique too
// (in "Technique" tab)


// start from this example ColourPoint techniques
// (give it a catch name too)
class ColourPoint extends PointingTechnique {

  ColourPoint() {
    name = "colourpoint";
  }

  void handle(Blob[][] blobs) {

    displayName();

    // use the largest blob of colour 0
    if (blobs[0][0] != null) {
      Blob b = blobs[0][0];

      float x = b.x;
      float y = b.y;

      float ratio = b.bb.width / float(b.bb.height);

      move(x, y + 50);
      
      float threshold = 0.8;

      // visualize feedback  
      stroke(255);
      strokeWeight(1);
      noFill();
      ellipse(x, y, threshold * 100, threshold * 100);

      if (ratio > threshold) {
        if (!isDown) {
          down(x, y); 
          isDown = true;
        }
      } else {
        if (isDown) {
          up(x, y);
          isDown = false;
        }
      }

      // visualize feedback
      ellipse(x, y, ratio * 100, ratio * 100);

      // print some debug information
      if (showDebug) {
        fill(255);
        text(ratio, x + 15, y + 15);
      }
    }
  }
}