import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture frame;
OpenCV opencv;

PImage img;
PImage lastFrame;

// the object that tracks coloured blobs
Tracker tracker = new Tracker();
// the experiment logging and task code
Experiment experiment = new Experiment();
// a simple demo to show how the pointing works
Demo demo = new Demo();
// the current pointing tecnique to use
// (all pointing tecniques inerit from te PointingTechnique base class)
PointingTechnique technique;

// various state flags
static final int TASK_NONE = 0;
static final int TASK_DEMO = 1;
static final int TASK_EXPERIMENT = 2;
int task = 0;
boolean showDebug = true;
boolean fake = false;

String settingsFilename = "data/settings.json";


void setup() {
  // create window
  surface.setResizable(true);
  surface.setSize(mainWidth * 2, int(mainHeight));

  PImage img = new PImage(mainWidth, mainHeight);
  PImage lastFrame = new PImage(mainWidth, mainHeight);

  // access the camera
  // (you may have to change this line to get it to work)
  // uncomment this to get list of cameras 
  // (program will exit after, you then need to put your camera 
  // into the code to open a camera below)
  //getCameraList();

  // create camera and start it up (other examples commented out)
  //frame = new Capture(this, "name=Logitech BRIO,size=1024x540,fps=15");
  //frame = new Capture(this, "name=Microsoft® LifeCam HD-3000,size=640x400,fps=30"); 
  frame = new Capture(this, captureWidth, captureHeight);

  // create the openCV processing object
  opencv = new OpenCV(this, processWidth, processHeight);

  frame.start();

  tracker.setup();
  experiment.setup();
  demo.setup();

  // load the last settings
  load();

  // default technique when started
  pickTechnique('4');
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

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// handle pointing events from current technique

float pointX;
float pointY;
boolean pointDown = false;

void down(float x, float y) {

  if (!pointDown) {
    println("click down at " + x + "," + y);

    pointX = x;
    pointY = y;
    pointDown = true;

    if (task == TASK_EXPERIMENT)
      experiment.down(x, y);

    if (task == TASK_DEMO)
      demo.down(x, y);
  }
}

void up(float x, float y) {
  if (pointDown) {
    println("click up at " + x + "," + y);

    pointX = x;
    pointY = y;
    pointDown = false;
  }
}

void move(float x, float y) {
  pointX = x;
  pointY = y;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// clumbsy control using keyboard keys

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
      //pickTechnique('1');
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
