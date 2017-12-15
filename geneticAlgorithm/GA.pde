class GA {
  
  Man men[];
    
  int POP_SIZE = 100;
  float CROSS_RATE = 0.8;
  float MUTATION_RATE = 0.005;
  int currentGeneration = 0;
  
  float beautyGrades[];
  
  float BestInHistoryGrade = 0;
  int BestInHistoryGeneration = 0;
  String BestInHistoryName = "";
  String BestInHistoryDNA = "";

  GA() {
  }
  
  void init(int gen) {
    if (gen == 0) {
      men = new Man[POP_SIZE];
      for (int i = 0 ; i < men.length ; i++) {
        int DNA[] = new int[]{i, i, i, i, i, i, i, i, i, i};
        Man m = new Man(DNA, currentGeneration);
        men[i] = m;
      }
    } else {
      currentGeneration = gen;
      String stateDatas[] = loadStrings("GEN/Gen" + gen + "/stateData" + gen + ".txt");
      men = new Man[POP_SIZE];
      for (int i = 0 ; i < men.length ; i++) {
        String currentDNA[] = stateDatas[i].split("-");
        int DNA[] = new int[DNA_SIZE];
        for (int j = 0 ; j < DNA_SIZE ; j++)
          DNA[j] = int(currentDNA[j]);
        Man m = new Man(DNA, currentGeneration);
        men[i] = m;
      }
      BestInHistoryGrade = int(stateDatas[POP_SIZE]);
      BestInHistoryGeneration = int(stateDatas[POP_SIZE+1]);
      BestInHistoryName = stateDatas[POP_SIZE+2];
      BestInHistoryDNA = stateDatas[POP_SIZE+3];
    }
    calcuBeautyGrades();
  }
  
  void saveStateData() {
    
    String stateData = "";
    for (int i = 0 ; i < men.length ; i++) {
      stateData += men[i].DNAToStr() + "\n";
    }
    stateData += "" + BestInHistoryGrade + "\n";
    stateData += "" + BestInHistoryGeneration + "\n";
    stateData += BestInHistoryName + "\n";
    stateData += BestInHistoryDNA + "\n";
    
    String saveStr[] = stateData.split("\n");
    saveStrings("GEN/Gen" + currentGeneration + "/stateData" + currentGeneration + ".txt", saveStr);
  }
   
  float getFitness(Man man) {
    return man.getBeauty();
  }
  
  void select() {
    Man selectedMen[] = new Man[POP_SIZE];
    float beautyGradeSum = 0;
    for (int i = 0 ; i < beautyGrades.length ; i++) {
      beautyGradeSum += beautyGrades[i];
    }
    for (int i = 0 ; i < POP_SIZE ; i++) {
      float n = random(1)*beautyGradeSum;
      int selectedIndex = 0;
      float accumGrade = beautyGrades[selectedIndex];
      while(true) {
        if (accumGrade > n) {
          break;
        } else {
          selectedIndex++;
          accumGrade += beautyGrades[selectedIndex];
        }
      }
      selectedMen[i] = men[selectedIndex];
    }
    men = selectedMen;
  }
  
  void calcuBeautyGrades() {
    beautyGrades = new float[POP_SIZE];
    for (int i = 0 ; i < POP_SIZE ; i++) {
      beautyGrades[i] = men[i].getBeauty();
    }
  }
  
  int[] crossover(int[] newDNA) {
    if (random(1) < CROSS_RATE) {
      int otherParentIndex = floor(random(POP_SIZE));
      Man otherParent = men[otherParentIndex];
      for (int i = 0 ; i < newDNA.length ; i++) {
        newDNA[i] = random(1) < 0.5 ? newDNA[i] : otherParent.DNA[i];
      }
    }
    return newDNA;
  }
  
  int[] mutate(int[] newDNA) {
    for (int i = 0 ; i < newDNA.length ; i++) {
      newDNA[i] = random(1) < MUTATION_RATE ? floor(random(DNAUnitNum)) :  newDNA[i];
    }
    return newDNA;
  }
  
  void evolve() {
    println("Start Evolve...");
    currentGeneration++;
    println("currentGeneration: " + currentGeneration);
    println("SELECT...");
    select();
    int newDNAs[][] = new int[POP_SIZE][DNA_SIZE];
    for (int i = 0 ; i < men.length ; i++) {
      println("START PROCESS MAN " + i);
      Man m = men[i];
      int newDNA[] = newDNAs[i];
      System.arraycopy(m.DNA, 0, newDNA, 0, DNA_SIZE);
      println("Crossover...");
      newDNA = crossover(newDNA);
      println("Mutate...");
      newDNA = mutate(newDNA);
      println("FINISH PROCESS MAN " + i);
    }
    for (int i = 0 ; i < men.length ; i++) {
      println("GENERATE NEXT GENERATION CHINDREN " + i);
      Man m =  new Man(newDNAs[i], currentGeneration);
      println("DNA: " + m.DNAToStr());
      men[i] = m;
    }
    calcuBeautyGrades();
    updateHistory();
    saveStateData();
    println("Finish Evolve...");
    
  }
  void updateHistory() {
    
    int bestIndex = getBestIndex();
    
    if (beautyGrades[bestIndex] > BestInHistoryGrade) {
      BestInHistoryGrade = beautyGrades[bestIndex];
      BestInHistoryGeneration = currentGeneration;
      BestInHistoryName = men[bestIndex].name;
      BestInHistoryDNA = men[bestIndex].DNAToStr();
    }
  }
  
  void display() {
    int bestIndex = getBestIndex();
    
    textSize(18);
    fill(20);
    String info = "CurrentGeneration: " + currentGeneration + "\n"
      + "POP_SIZE: " + POP_SIZE + "\n"
      + "CROSS_RATE: " + CROSS_RATE + "\n"
      + "MUTATION_RATE: " + MUTATION_RATE + "\n"
      + "\nBestInHistoryGrade: " + BestInHistoryGrade + "\n"
      + "BestInHistoryGeneration: " + BestInHistoryGeneration + "\n"
      + "BestInHistoryName: " + BestInHistoryName + "\n"
      + "BestInHistoryDNA: " + BestInHistoryDNA + "\n"
      + "\nCurrent BEST BEAUTY: " + beautyGrades[bestIndex] + "\n"
      + "\nCurrent BEST NAME: " + men[bestIndex].name + "\n"
      + "Current BEST DNA: " + men[bestIndex].DNAToStr() + "\n";
    text(info, 10, 30);
    
    info += beautyToStr();
    String saveStr[] = info.split("\n");
    saveStrings("GEN/Gen" + currentGeneration + "/info.txt", saveStr);
    
    if (men[bestIndex].face != null) {
      image(men[bestIndex].face.img, 10, 400, 300, 400);
    }
    
  }
  
  int getBestIndex() {
    int bestIndex = 0;
    float bestGrade = beautyGrades[bestIndex];
    for (int i = 1 ; i < beautyGrades.length ; i++) {
      if (beautyGrades[i] > bestGrade) {
        bestGrade = beautyGrades[i];
        bestIndex = i;
      }
    }
    return bestIndex;
  }
  
  String beautyToStr() {
    String beautyStr = "";
    for (int i = 0 ; i < beautyGrades.length ; i++) {
      beautyStr += i == 0 ? beautyGrades[i] : "," + beautyGrades[i];
    }
    return beautyStr;
  }
  
}