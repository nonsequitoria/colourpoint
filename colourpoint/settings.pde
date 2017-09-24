

// Keyboard Shortcuts
// - - - - - - - - - - - - - -
/*
 1, 2, 3, ... - choose technique
 d - toggle demo view 
     (D to randomize)
 E - start a new experiment
 e - toggle experiment view
 c - toggle colour calibration 
     (press 1 or 2 to switch colour to calibrate)
     (drag rectangle with mouse to pick area to sample colour)
     (C to reset current colour)
 s - save settings
 SPACE - toggle debug information
 */

// Useful Settings
// - - - - - - - - - - - - - -

// size of widow with targets and cursor (leave as is)
int mainWidth = 640;
int mainHeight = 480;

// smaller capture image to speed things up
int captureWidth = mainWidth / 2;
int captureHeight = mainHeight / 2;

// can make an even smaller processing image width if needed
int processWidth = captureWidth;
int processHeight = captureHeight;

// EXPERIMENT
// name of person clicking on targets in the experiment
// (leave blank to not log during experiment)
String experimentParticipant = "";

// filename for experiment target script
String scriptFilename = "data/script.txt";


// handles the keyboard even to pick from available techniques
void pickTechnique(char k) {

  switch (k) {
  case '0':
    technique = new PointingTechnique();
    break;
  case '1':
    technique = new MousePoint();
    break;
  case '2':
    technique = new ShowBlobFeatures();
    break;
  case '3':
    technique = new RatioClick();
    break;
  case '4':
    technique = new ColourPoint();
    break;
    
  // add your techniques here ...
  case '5':
    //technique = ;
    break;
  case '6':
    //technique = ;
    break;
  case '7':
    //technique = ;
    break;
  }
}