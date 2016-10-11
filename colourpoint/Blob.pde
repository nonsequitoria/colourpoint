
class Blob {
  int colour;

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