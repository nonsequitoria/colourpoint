/* 
 * Target
 * A simple target to display and interact with
 */

class Target {

  float x;
  float y;
  float s;

  color targetFill = color(255, 100);

  Target(float x, float y, float s) {
    this.x = x;
    this.y = y;
    this.s = s;  // size (diameter)
  }

  void draw() {
    stroke(0);
    strokeWeight(2);
    fill(targetFill);
    ellipse(x, y, s, s);
  }

  boolean isHit(float mx, float my) {
    return dist(mx, my, x, y) < s / 2;
  }
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


class ToggleTarget extends Target {

  boolean isOn = true;

  ToggleTarget(float x, float y, float s) {
    super(x, y, s);
  }

  void toggle() {
    println("toggle", isOn);
    if (isOn) {
      targetFill = color(0, 100);
    } else {
      targetFill = color(255, 100);
    }
    isOn = !isOn;
  }
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


class SequenceTarget extends Target {

  static final int NEXT = 0;
  static final int FUTURE = 1;
  static final int DONE = 2;

  int num;
  int state = NEXT;
  color textFill;
  boolean wasError = false;

  SequenceTarget(float x, float y, float s, int num) {
    super(x, y, s);
    this.num = num;
    reset();
  }

  void draw() {

    //if (wasError) {
    //  stroke(255, 0, 0);
    //  strokeWeight(4);
    //} else {
    stroke(0);
    strokeWeight(2);
    //}
    fill(targetFill);
    ellipse(x, y, s, s);
    fill(textFill);
    textSize(20);
    textAlign(CENTER, CENTER);
    text(num, x, y);
  }

  void reset() {
    wasError = false;
    setState(FUTURE);
  }

  void error() {
    wasError = true;
  }

  void setState(int s) {
    // fill is based on state
    switch(s) {
    case NEXT:
      targetFill = color(255, 200);
      textFill = color(0);
      break;

    case FUTURE:
      targetFill = color(160, 200);
      textFill = color(60);
      break;

    case DONE:
      targetFill = color(100, 200);
      textFill = color(150);
      break;
    }
    state = s;
  }
}
