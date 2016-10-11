

class Demo {

  ToggleTarget[] targets;

  int errorDisplay = -1001;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  void setup() {
    reset();
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  void reset() {
    int n = 5;
    targets = new ToggleTarget[n];

    float spacing = mainWidth / (n + 1.0);
    for (int i = 0; i < n; i++) {
      float x = (i + 1) * spacing;
      float y = random(spacing / 2, mainHeight - spacing / 2);
      float s = random(50, spacing);
      targets[i] = new ToggleTarget(x, y, s);
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  void draw() {
    for (Target t : targets) {
      t.draw();
    }

    if (millis() - errorDisplay < 250) {
      stroke(255, 0, 0);
      strokeWeight(6);
      noFill();
      rect(3, 3, mainWidth - 6, mainHeight - 6);
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  void down(float x, float y) {
    boolean error = true;
    for (ToggleTarget t : targets) {
      if (t.isHit(x, y)) {
        t.toggle();
        error = false;
        break;
      }
    }
    if (error) {
      errorDisplay = millis();
      println("error ");
    }
  }
}