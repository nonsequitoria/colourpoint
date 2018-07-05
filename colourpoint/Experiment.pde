/*
 * Experiment
 * Displays a sequence of targets in a certain order and size
 * for people to click on so we can measure the speed and 
 * accuracy of a given technique.
 */

class Experiment {

  // relative logging path (can be absolute)
  String logPath = "logs/";

  // the global logger object
  Logger logger = new Logger(logPath);


  int targetToHit = 0;
  SequenceTarget[] targets;

  String[] script;
  int scriptLine = 0;
  int block = 0;

  int errorDisplay = -1001;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  void setup() {
    reset();
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  void reset() {

    // start the log
    String tn = "";
    if (technique != null)
      tn = technique.name;

    if (!experimentParticipant.equals(""))
      logger.newfile(tn + " " + experimentParticipant); 

    // load the script
    script = loadStrings(scriptFilename);
    scriptLine = 0;
    newBlock();
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


  void newBlock() {
    // next line is block or end
    String[] token = script[scriptLine].split(",");

    if (token[0].equals("block")) {
      println(token[0]);
      block = int(token[1]);

      logger.logEvent("block," + block);

      int num = int(token[2]);
      println("block " + block + " targets " + num);
      targets = new SequenceTarget[num];

      // get all the targets
      scriptLine++;
      for (int i = 0; i < num; i++) {
        println(script[scriptLine]);
        token = script[scriptLine].split(",");
        float x = float(token[1]);
        float y = float(token[2]);
        float s = float(token[3]); 
        targets[i] = new SequenceTarget(x, y, s, i + 1);
        scriptLine++;
      }
      // set first target to start
      targets[0].setState(SequenceTarget.NEXT);
      targetToHit = 1;
    } else {
      logger.close(); 
      targetToHit = -1;
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  void draw() {
    if (targetToHit > 0) {
      for (SequenceTarget t : targets) {
        t.draw();
      }
    } else {
      fill(255);
      textSize(60);
      textAlign(CENTER, CENTER);
      text("done", mainWidth/2, mainHeight/2);
      textSize(15);
    }

    if (millis() - errorDisplay < 250) {
      stroke(255, 0, 0);
      strokeWeight(6);
      noFill();
      rect(3, 3, mainWidth - 6, mainHeight - 6);
    }

    textAlign(CENTER, TOP);
    textSize(13);
    fill(255);
    text("log: " + logger.loggingTo(), mainWidth / 2, 5);
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  void down(float x, float y) {

    if (targetToHit > 0) {
      boolean error = true;
      for (SequenceTarget t : targets) {
        if (t.isHit(x, y) && t.num == targetToHit) {
          error = false;
          break;
        }
      }
      if (!error) {
        println("success " + targetToHit);
        SequenceTarget t = targets[ targetToHit - 1];
        logger.logEvent("target," + targetToHit);
        targets[ targetToHit - 1].setState(SequenceTarget.DONE);
        targetToHit++;
        if (targetToHit - 1 >= targets.length) {
          newBlock();
        } else {
          targets[targetToHit - 1].setState(SequenceTarget.NEXT);
        }
      } else {
        println("error " + targetToHit);
        logger.logEvent("error," + targetToHit);
        errorDisplay = millis();
      }
    }
  }
}
