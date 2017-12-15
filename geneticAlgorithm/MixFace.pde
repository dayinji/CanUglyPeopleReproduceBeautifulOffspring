class MixFace {
  int pairs[][];
  MixFace() {
    pairs = new int[177][3];
    String[] s = loadStrings("tra.txt");
    for (int i = 0 ; i < s.length ; i++) {
      String indices[] = s[i].split(" ");
      pairs[i][0] = int(indices[1]);
      pairs[i][1] = int(indices[2]);
      pairs[i][2] = int(indices[3]);
    }
  }
  
  String mix(int DNA[], String name, int generation) {
    Face face0 = DNAUnits[DNA[0]];
    PGraphics pg = createGraphics(face0.img.width, face0.img.height, P2D);
    pg.beginDraw();
    pg.noStroke();
    pg.noFill();
    for (int k = 0 ; k < DNA.length ; k++) {
      Face face = DNAUnits[DNA[k]];
      for (int i = 0; i < pairs.length; i++) {
        int index1 = pairs[i][0];
        int index2 = pairs[i][1];
        int index3 = pairs[i][2];
        
        float pos11[] = face0.getPosByPointIndex(index1);
        float pos12[] = face0.getPosByPointIndex(index2);
        float pos13[] = face0.getPosByPointIndex(index3);
        
        float pos21[] = face.getPosByPointIndex(index1);
        float pos22[] = face.getPosByPointIndex(index2);
        float pos23[] = face.getPosByPointIndex(index3);
        
        float amt = 1.0;
        if (k != 0) {
          amt = 1.0 / (k+1);
        }
        // Draw the other image blended with first
        pg.tint(255, amt*255);
        pg.textureMode(IMAGE);
        pg.beginShape();
        pg.texture(face.img);
        // Use morphed triangle with corresponding texture points on original triangle
        pg.vertex(pos11[0], pos11[1], pos21[0], pos21[1]);
        pg.vertex(pos12[0], pos12[1], pos22[0], pos22[1]);
        pg.vertex(pos13[0], pos13[1], pos23[0], pos23[1]);
        pg.endShape();
        //pg.text(""+index1, pos21[0], pos21[1]);
        //pg.text(""+index2, pos22[0], pos22[1]);
        //pg.text(""+index3, pos23[0], pos23[1]);
  
      }
    }
    pg.endDraw();
    String dnaStr = "";
    for (int i = 0 ; i < DNA.length ; i++) 
      dnaStr += "-" + DNA[i];
    String saveName = "GEN/Gen" + generation + "/" + name + dnaStr + ".jpg";
    pg.save(saveName);
    return saveName;
  }
}