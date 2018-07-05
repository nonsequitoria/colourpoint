/* 
 * ColourPoint
 * A simple colour tracking framework and experiment runner for Processing. 
 * It was written for an afternoon workshop on "Applied Computer Vision for 
 * Human-Computer Interaction".
 *
 * Detailed information here:
 * https://github.com/nonsequitoria/colourpoint
 *
 */





// start from this example technique
// (give it a catchy name too)
class MyTechnique extends PointingTechnique {

  MyTechnique() {
    name = "mytechnique";
  }

  void handle(Blob[][] blobs) {

    displayName();

    // your code goes here

    // look at RatioClick or TwoColour techniques for ideas
    // (in "Technique" tab)


  }
  
}
