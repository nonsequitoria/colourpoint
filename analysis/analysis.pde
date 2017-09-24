// this is a very rough sketch to process the logs
// in a single "data.csv" file


boolean dropBoxDir = false;
String dir = "";

void setup() {

  if (dropBoxDir) {
    // set this to the absolute path of a Dropbox file request folder
    dir = "";
  } else {
    dir = sketchPath("logs");
  }

  String[] files = listFilenames(dir);

  PrintWriter out = createWriter(dir + "/data.csv"); 

  out.println("tech,part,block,target,time,error");

  String part;
  String tech;
  int block = 0;
  int lastTime = 0;
  int wasError = 0;

  for (String f : files) {

    if (!f.contains("txt")) 
      continue;

    if (dropBoxDir) {
      // assuming filename is pattern "Name - technique participant XXXXXXXXX.txt"
      String fn = f.trim().split("-")[1]; //[1];
      String[] tokens = fn.trim().split(" ");
      tech = tokens[0];
      part = tokens[1].toLowerCase();
    } else {
      String[] tokens = f.trim().split(" ");
      // assuming filename is pattern "technique participant XXXXXXXXX.txt"
      tech = tokens[0];
      part = tokens[1].toLowerCase();
    }

    println(tech, part);

    String[] lines = loadStrings(dir + "/" + f);

    for (String l : lines) {
      //println(l);

      String[] tokens = l.split(",");
      int t = int(tokens[0]);
      String e = tokens[1];
      int i = int(tokens[2]);

      if (e.equals("block")) {
        block = i;
      } else if (e.equals("target") && i == 1) {
        wasError = 0;
        lastTime = t;
      } else if (e.equals("error")) {
        wasError = 1;
      } else if (e.equals("target")) {

        String s = tech + "," + part + "," + block + "," + i + "," + (t - lastTime) + "," + wasError;
        println(s);
        out.println(s);
        lastTime = t;
        wasError = 0;
      }
    }
  }

  out.flush();
  out.close();
}


// This function returns all the files in a directory as an array of Strings  
String[] listFilenames(String dir) {
  File file = new File(dir);
  //println(file);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}