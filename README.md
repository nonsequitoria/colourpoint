# colourpoint
A simple colour tracking framework and experiment runner for Processing. It was written for an afternoon workshop on "Applied Computer Vision for Human-Computer Interaction." 

## Installation and Requirements

* Download and install (Processing)[www.processing.org/download]. Only tested with Processing 3.2.1.
* Add these libraries to you Processing installation:
  * Video Library
  * OpenCV for Processing

## Usage

* To create new pointing techniques, inherit from PointingTechnique: the ColourPoint class is an example technique.
* Log data during an experiment by providing a name for `experimentParticipant`.
* Process logs into a single CSV for analysis of speed and accuracy using the *analysis* sketch.

Keyboard shortcuts are in the "settings" tab when you open colourpoint:
```
 e - toggle experiment view (E to reset)
 d - toggle demo view (D to randomize)
 c - toggle colour calibration (C to reset)
 s - save settings
 (drag rectangle with mouse to pick area to sample colour)
 SPACE - toggle debug information
 1, 2, 3, ... - choose technique
```

## More Information

* [Undergraduate Research Opportunities Conference (UROC)](https://cs.uwaterloo.ca/conferences/uroc))
* [The UWaterloo Computer Science Human-Computer Interaction Lab](http://hci.cs.uwaterloo.ca/)
* [Cheriton School of Computer Science at The University of Waterloo](https://cs.uwaterloo.ca/)
* [Daniel Vogel's Research](http://www.nonsequitoria.com/)



