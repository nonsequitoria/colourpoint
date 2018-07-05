
// data strcuture for each blob found in the scene
class Blob {
  
  // the colour index of the blob
  int colour;
  // no blob detected
  boolean empty = true;
  // centroid of blob points
  float x;
  float y;
  // area of blob in sq pixels
  float area;
  // bounding box
  Rectangle bb;
  // all enclosing points
  ArrayList<PVector> points;
  // simplifed enclosing points
  ArrayList<PVector> simplePoints;
  // convex hull points
  ArrayList<PVector> convexHullPoints;
}
