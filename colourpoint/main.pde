import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture frame;
OpenCV opencv;



PImage img = new PImage(mainWidth, mainHeight);
PImage lastFrame = new PImage(mainWidth, mainHeight);


static final int TASK_NONE = 0;
static final int TASK_DEMO = 1;
static final int TASK_EXPERIMENT = 2;
int task = 0;

Tracker tracker = new Tracker();
Experiment experiment = new Experiment();
Demo demo = new Demo();

PointingTechnique technique;

boolean showDebug = true;
boolean fake = false;


String settingsFilename = "data/settings.json";


void setup() {

  surface.setResizable(true);
  surface.setSize(mainWidth * 2, int(mainHeight));

  frame = new Capture(this, captureWidth, captureHeight);
  opencv = new OpenCV(this, processWidth, processHeight);

  frame.start();

  tracker.setup();
  experiment.setup();
  demo.setup();

  // load the last settings
  load();
  
  
  pickTechnique('1');
}



void draw() {
  if (frame.available()) {
    frame.read();

    img = imageMirror(frame);
    lastFrame = img.copy();

    image(lastFrame, 0, 0, mainWidth, mainHeight);

    //background(0);
    tracker.track(img);


    tracker.draw();


    if (task == TASK_EXPERIMENT)
      experiment.draw();

    if (task == TASK_DEMO)
      demo.draw();


    if (task != TASK_NONE) {
      // cursor crosshair
      float s = 20;
      noFill();
      strokeWeight(3);
      stroke(0);
      cross(pointX, pointY, s);
      strokeWeight(1);
      stroke(255);
      cross(pointX, pointY, s);
      if (pointDown) {
        strokeWeight(3);
        stroke(0);
        ellipse(pointX, pointY, s, s);
        strokeWeight(1);
        stroke(255);
        ellipse(pointX, pointY, s, s);
      }
    }

    fill(255);
    textSize(14);
    textAlign(RIGHT, BOTTOM);
    text(round(frameRate), mainWidth - 10, mainHeight - 10);
  }
}



float pointX;
float pointY;
boolean pointDown = false;

void down(float x, float y) {
  pointX = x;
  pointY = y;
  pointDown = true;

  if (task == TASK_EXPERIMENT)
    experiment.down(x, y);

  if (task == TASK_DEMO)
    demo.down(x, y);
}

void up(float x, float y) {
  pointX = x;
  pointY = y;
  pointDown = false;
}

void move(float x, float y) {
  pointX = x;
  pointY = y;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


void keyPressed() {
  tracker.keyPressed();

  // keyboard commands
  switch (key) {

    // toggle debug
  case ' ':
    showDebug = !showDebug;
    break;

  case 'e':
    if (task != TASK_EXPERIMENT)
      task = TASK_EXPERIMENT;
    else
      task = TASK_NONE;
    break;

  case 'E':
    task = TASK_EXPERIMENT;
    experiment.reset();
    break;

  case 'd':
    if (task != TASK_DEMO) 
      task = TASK_DEMO;
    else
      task = TASK_NONE;
    break;

  case 'D':
    task = TASK_DEMO;
    demo.reset();
    break;

  case 'c':
    tracker.calibrate = !tracker.calibrate;
    if (tracker.calibrate) {
      pickTechnique('1');
      task = TASK_NONE;
    }
    break;

    // save settings
  case 's':
    save();
    break;
  }
  
  
  if (!tracker.calibrate) {
   pickTechnique(key); 
  } else {

    
  }
  
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

void keyReleased() {
  tracker.keyReleased();
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

void mousePressed() {
  tracker.mousePressed();
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

void mouseReleased() {
  tracker.mouseReleased();
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

void mouseDragged() {
  tracker.mouseDragged();
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

void mouseMoved() {
}



// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

void save() {

  println("saving " + settingsFilename);
  JSONObject json = new JSONObject();

  tracker.save(json);

  saveJSONObject(json, settingsFilename);
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

void load() {
  println("loading " + settingsFilename);
  JSONObject json = new JSONObject();
  try {
    json = loadJSONObject(settingsFilename);
    tracker.load(json);
  } 
  // HACK: should catch just exception from bad json or missing file
  catch (Exception e) {
    println(e);
    println("Error loading " + settingsFilename);
  }
}