class Face {
  PImage img;
  int w, h, l, t;
  JSONObject landmark;
  String[] landmarkKeys;
  float bm, bf;
  float points[][];
  
  Face(int w, int h, int l, int t, float bm, float bf, JSONObject landmark, String[] landmarkKeys, PImage img) {
    this.w = w;
    this.h = h;
    this.l = l;
    this.t = t;
    this.bm = bm;
    this.bf = bf;
    this.landmark = landmark;
    this.landmarkKeys = landmarkKeys;
    this.img = img;
    this.points = new float[91][2];
    
    points[0][0] = 0;
    points[0][1] = 0;
    points[1][0] = img.width/2;
    points[1][1] = 0;
    points[2][0] = img.width;
    points[2][1] = 0;
    
    points[3][0] = 0;
    points[3][1] = img.height/2;
    points[4][0] = img.width;
    points[4][1] = img.height/2;
    
    points[5][0] = 0;
    points[5][1] = img.height;
    points[6][0] = img.width/2;
    points[6][1] = img.height;
    points[7][0] = img.width;
    points[7][1] = img.height;
    
    for (int i= 0 ; i < landmarkKeys.length ; i++) {
      String k = landmarkKeys[i];
      JSONObject pos1 = landmark.getJSONObject(k);
      points[i+8][0] = pos1.getFloat("x");
      points[i+8][1] = pos1.getFloat("y");
    }
    
  }
  
  float[] getPosByPointIndex(int index) {
    return points[index];
  }
  
  float getBeauty() {
    return (bm + bf) / 2;
  }
  
  int indexOf(float x, float y) {
    
    for (int i= 0 ; i < landmarkKeys.length ; i++) {
      String k = landmarkKeys[i];
      JSONObject pos1 = landmark.getJSONObject(k);
      if (pos1.getFloat("x") == x && pos1.getFloat("y") == y)
        return i+8;
    }
    if (x == 0 && y == 0)
      return 0;
    if (x == img.width/2 && y == 0)
      return 1;
    if (x == img.width && y == 0)
      return 2;
    if (x == 0 && y == img.height/2)
      return 3;
    if (x == img.width && y == img.height/2)
      return 4;
    if (x == 0 && y == img.height)
      return 5;
    if (x == img.width/2 && y == img.height)
      return 6;
    if (x == img.width && y == img.height)
      return 7;
    return -1;
  }
}