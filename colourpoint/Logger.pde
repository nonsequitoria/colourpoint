import java.util.*;
import java.text.*;


// writes a custom log file format 

// 

// # all lines begin with timestamp
// yyyyMMdd,HHmmss.S (e.g. 20130116,130011.438)

// CSV continuous data:
// special line to define the CSV column names
// A,colname,colname,colname,colname,...
// timestamp,A,val,val,val,val,...

// event data
// timestamp,[event,subevent,{param:val,param:val}]
// use brackets for CSV val data

// helper function
String joinString(String[] list, String separator)
{
  return join(list, separator);
}


// simple logging class
class Logger 
{

  boolean isRunning = false;

  long lastLogTime = 0;


  String path = "logs/";
  String filename = "";
  PrintWriter logfile = null;

  String header = "";

  // format for dates in log file
  SimpleDateFormat logDateFormater = new SimpleDateFormat("yyyyMMdd,HHmmss.S");

  SimpleDateFormat filenameDateFormater = new SimpleDateFormat("yyyy-MM-dd HH-mm-ss");

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  public String loggingTo() {
    if (logfile != null) {
      return filename;
    } else {
      return "NOT LOGGING";
    }
  }


  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  public Logger(String path)
  {
    path = path;
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  // must be even number of values
  public void logEvent(String type, Object ... values) {
    String[] list = new String[values.length / 2];

    int j = 0;
    for (int i = 0; i < list.length * 2; i += 2) {
      list[j] = values[i].toString() + ":" + values[i + 1].toString();
      j++;
    }
    log(type + ",{" + joinString(list, ",") + "}");
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  public void logEvent(String data) {
    log(data);
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  public void log(String s)
  {
    if (logfile != null) {
      long t = millis();
      logfile.println(t + "," + s);
      lastLogTime = t;
    } else {
      println("ERROR: log to closed file");
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  public void comment(String s)
  {
    if (logfile != null) {
      logfile.println("# " + s);
    }
  }


  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  private void close() {
    if (logfile != null) {
      logfile.flush();
      logfile.close(); 
      println("closed log");
      logfile = null;
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  private boolean newfile(String prefix)
  {
    close();
    long t = System.currentTimeMillis();
    filename = path + prefix + " " + filenameDateFormater.format(t) + ".txt";
    try
    {
      logfile = createWriter(filename);
      println("opened log: '" + filename);
      lastLogTime = t;
    }
    catch (Exception e)
    {
      return false;
    }
    return true;
    //comment(header);
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}