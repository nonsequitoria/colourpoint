# colourpoint
A simple colour tracking framework and experiment runner for Processing. It was written for an afternoon workshop on "Applied Computer Vision for Human-Computer Interaction".

## Installation and Requirements

1. Download and install [Processing](www.processing.org/download). Tested with Processing 3.3.6.

2. Add these libraries to you Processing installation:
  * Video Library
  * OpenCV for Processing

## Usage

### Creating New Techniques

You create new techniques by extending the `PointingTechnique` class, and writing code in the `handle` method. It's easiest to start from one of the example techniques:

* `RatioClick` (in "Techniques" tab) tracks a single colour object and clicks when the object is roughly square (aspect ratio near 1).
* `ColourPoint` (in "ColourPoint" tab) is (mostly) the same as `RatioClick` with some extra feedback showing how to retrieve more detected features.
* To make it easy to switch between multiple techniques, add your technique to the switch list in the `pickTechnique` function (in "settings" tab).

The central idea is to use `Blob` features to make your technique work:

* Every frame, your technique's `handle` is called with a two-dimensional `blobs` array. 
* The first dimension is colour index: currently, this can only be 0 or 1.
* the second dimension is the index of the detected blobs (type `Blob`) for that colour. These are sorted by descending size (i.e. area).
* Each `Blob` has multiple features, see the definition in the "Blob" tab

### Calibrating and Testing

You'll need to calibrate for the colour(s) you want to use. Since lighting conditions vary, and the paper reflects light at different intensities depending on angle relative to a light source, you need to add multiple samples. 

* Press 'c' to enter calibration mode. 
* Pick the colour to calibrate by pressing '1' or '2'
* Now drag the mouse on the camera window to define a bounding box where the coloured object is. Do this multiple times while holding the object at different angles and positions in the frame.
* When it looks good, press 's' to save your calibration.
* NOTE: you can clear the current colour's calibration with 'C'

The underlying algorithm uses very simple HLS threhsolding, so if you add the wrong colour or the range gets too large, you'll detect too many blobs and have to start again.  


### Running The Experiment

* Log data during an experiment by providing a name for `experimentParticipant` in "settings" tab.
* Press 'E' to start a new experiment. You can toggle experiment mode using 'e'.
* Experiment log ('txt' file) will be saved to `colourpoint/logs/` sub directory.
* Copy logs you want to analyze for speed and accuracy to `analysis/logs/` sub directory, and use *analysis* sketch to process them into a single CSV.

## Keyboard Shortcuts

Keyboard shortcuts are in the "settings" tab when you open colourpoint:
```
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
```

## Issues

* There's a bug when you run an experiment and the full log filename is not set. For a workaround, just press `E` to *reset* the experiment state before starting the experiment.
* Debug mode can be really slow, press SPACE to turn it on/off.

## More Information and Related Links

* [Undergraduate Research Opportunities Conference (UROC)](https://cs.uwaterloo.ca/conferences/uroc/2017)
* [Computer Science Human-Computer Interaction Lab](http://hci.cs.uwaterloo.ca/)
* [Cheriton School of Computer Science at The University of Waterloo](https://cs.uwaterloo.ca/)
* [Daniel Vogel's Research](http://www.nonsequitoria.com/)



