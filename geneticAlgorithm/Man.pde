class Man {
  String name;
  int generation;
  int DNA[];
  Face face;
  
  Man(int[] DNA, int generation) {
    this.DNA = DNA;
    this.generation = generation;
    this.name = getRandomName();
    generateFace();
  }
  
  float getBeauty() {
    if (face == null)
      return 0;
    return face.getBeauty();
  }
  
  void generateFace() {
    String fileName = mf.mix(DNA, name, generation);
    face = detectFace(fileName);
  }
  
  String DNAToStr() {
    String dnaStr = "";
    for (int i = 0 ; i < DNA.length ; i++) 
      dnaStr += i == 0 ? DNA[i] : "-" + DNA[i];
    return dnaStr;
  }
  
}