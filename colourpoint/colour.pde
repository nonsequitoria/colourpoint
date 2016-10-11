
// store, load, save, convert HSB colours
class Colour {

  float h;
  float s;
  float b;

  Colour() {
    this.h = 0;
    this.s = 0;
    this.b = 0;
  }

  Colour(float h, float s, float b) {
    this.h = h;
    this.s = s;
    this.b = b;
  }

  void fromColor(color c) {
    h = hue(c);
    s = saturation(c);
    b = brightness(c);
  }

  String toString() {
    return h + "," + s + "," + b;
  }

  Colour average(Colour c1, Colour c2) {
    return new Colour((c1.h + c2.h) / 2, 
      (c1.s + c2.s) / 2, 
      (c1.b + c2.b) / 2);
  }

  color toColor() {
    colorMode(HSB, 255, 255, 255, 255);
    color c = color(h, s, b);
    colorMode(RGB, 255, 255, 255, 255);
    return c;
  }

  void saveJSON(String name, JSONObject json) {
    json.setFloat(name + "_h", h);
    json.setFloat(name + "_s", s);
    json.setFloat(name + "_b", b);
  }

  void loadJSON(String name, JSONObject json) {
    h = json.getFloat(name + "_h");
    s = json.getFloat(name + "_s");
    b = json.getFloat(name + "_b");
  }
}