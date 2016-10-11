
/*
  Let's say Pnf the filtered position, Pn the non filtered position and
  Pn-1f the previous filtered position, Te the sampling period (in seconds)
  and tau a time constant calculated from the cut-off frequency fc.
  
 tau = 1 / (2 * pi * fc)
 Pnf = ( Pn + tau/Te * Pn-1f ) * 1/(1+ tau/Te)
 
 Attention: tau >= 10 * Te
 */

public class LowPassFilter
{
  // current value
  float value_;
  boolean reset_;

  float tau;
  float cutoffFreq;

  int time;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  public LowPassFilter(float cf)
  {
    setCutoffFreq(cf);
  }  

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   
  
  public float update(int v)
  {
    return update(float(v)); 
  }
  
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -     

  public float update(float v)
  {
    if (reset_)
    {
      time = millis(); 
      value_ = v;
      reset_ = false;
    }
    else
    {
      // the sampling period (in seconds)
      float te = (millis() - time) / 1000.0;
      time = millis(); 
      if (te != 0)
        value_ = (v + (tau/te) * value_) * (1.0 / (1.0 + tau/te));
    }
    
    return value_;
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  public float get()
  {
    return value_;
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  public void reset()
  {
    reset_ = true;
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  public void setCutoffFreq(float cf)
  {
    cutoffFreq = cf; 
    // a time constant calculated from the cut-off frequency
    tau = (float)(1.0 / (2 * Math.PI * cutoffFreq));
  }
}