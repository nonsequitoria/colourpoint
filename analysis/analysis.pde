


void setup() {

  //size(640, 480);

  String[] files = listFilenames(sketchPath("logs"));
  
  PrintWriter out = createWriter("logs/data.csv"); 

 out.println("tech,part,block,target,time,error");

  String part;
  String tech;
  int block = 0;
  int lastTime = 0;
  
  int wasError = 0;

  for (String f : files) {

    
    if (!f.contains("txt")) 
      continue;
    String[] tokens = f.trim().split(" ");
    part = tokens[1];
    tech = tokens[0];

    println(f);

    String[] lines = loadStrings("logs/" + f);



    for (String l : lines) {
      //println(l);

      tokens = l.split(",");
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
  println(file);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}