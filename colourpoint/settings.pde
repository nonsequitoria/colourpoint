

// Keyboard Shortcuts
// - - - - - - - - - - - - - -
/*
 e - toggle experiment view (E to reset)
 d - toggle demo view (D to randomize)
 c - toggle colour calibration (C to reset)
 s - save settings
 (drag rectangle with mouse to pick area to sample colour)
 SPACE - toggle debug information
 1, 2, 3, ... - choose technique
 
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



void pickTechnique(char k) {

  switch (k) {
  case '0':
    technique = new PointingTechnique();
    break;
  case '1':
    technique = new MousePoint();
    break;
  case '2':
    technique = new RatioClick();
    break;
  case '3':
    technique = new ColourPoint();
    break;
    
  // add your techniques here ...
  case '4':
    //technique = ;
    break;
  case '5':
    //technique = ;
    break;
  case '6':
    //technique = ;
    break;
  }
}