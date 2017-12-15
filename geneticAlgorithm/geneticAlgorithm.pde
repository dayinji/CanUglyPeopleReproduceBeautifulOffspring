import megamu.mesh.*;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Base64;
import http.requests.*;


String api_key = "";
String api_secret = "";

String filePrefix = "E:/MY WORKS/Can i birth cool child/geneticAlgorithm/";
MixFace mf;
GA ga;
int N_GENERATIONS = 200;
int DNA_SIZE = 10;
int DNAUnitNum = 100;
Face DNAUnits[];

String nameWords = "日、月、青、有、旺、清、早、明、昆、易、星、昌、春、昶、是、映、洵、晃、晁、时、晨、晶、景、普、晴、晰、暑、暖、晖、伟、刚、"
  +"勇、毅、俊、峰、强、军、平、保、东、文、辉、力、明、永、健、世、广、志、义、兴、良、海、山、仁、波、宁、贵、福、生、龙、元、全、国、胜、"
  +"学、世、舜、丞、主、产、仁、仇、仓、仕、仞、任、伋、众、伸、佐、佺、侃、侪、促、俟、信、俣、修、倝、倡、倧、偿、储、僖、僧、僳、儒、俊、"
  +"伟、列、则、刚、创、前、剑、助、劭、势、勘、参、叔、吏、嗣、士、壮、孺、守、宽、宾、宋、宗、宙、宣、实、宰、尊、峙、峻、崇、崈、川、州、"
  +"巡、帅、庚、战、才、承、拯、操、斋、昌、晁、暠、曹、曾、珺、玮、珹、琒、琛、琩、琮、琸、瑎、玚、璟、璥、瑜、生、畴、矗、矢、石、磊、砂、"
  +"碫、示、社、祖、祚、祥、禅、稹、穆、竣、竦、综、缜、绪、舱、舷、船、蚩、襦、轼、辑、轩、子、杰、榜、碧、葆、莱、蒲、天、乐、东、钢、铎、"
  +"铖、铠、铸、铿、锋、镇、键、镰、馗、旭、骏、骢、骥、驹、驾、骄、诚、诤、赐、慕、端、征、坚、建、弓、强、彦、御、悍、擎、攀、旷、昂、晷、"
  +"健、冀、凯、劻、啸、柴、木、林、森、朴、骞、寒、函、高、魁、魏、鲛、鲲、鹰、丕、乒、候、冕、勰、备、宪、宾、密、封、山、峰、弼、彪、彭、"
  +"旁、日、明、昪、昴、胜、汉、涵、汗、浩、涛、淏、清、澜、浦、澉、澎、澔、濮、濯、瀚、瀛、灏、沧、虚、豪、豹、辅、辈、迈、邶、合、部、阔、"
  +"雄、霆、震、韩、俯、颁、颇、频、颔、风、飒、飙、飚、马、亮、仑、仝、代、儋、利、力、劼、勒、卓、哲、喆、展、帝、弛、弢、弩、彰、征、律、"
  +"德、志、忠、思、振、挺、掣、旲、旻、昊、昮、晋、晟、晸、朕、朗、段、殿、泰、滕、炅、炜、煜、煊、炎、选、玄、勇、君、稼、黎、利、贤、谊、"
  +"金、鑫、辉、墨、欧、有、友、闻、问、伟、刚、勇、毅、俊、峰、强、军、平、保、东、文、辉、力、明、永、健、世、广、志、义、兴、良、海、山、"
  +"仁波、宁、贵、福、生、龙、元、全、国、胜、学、祥、才、发、武、新、利、清、飞、彬、富、顺、信、子、杰、涛昌、成、康、星、光、天、达、安、"
  +"岩、中、茂、进、林、有、坚、和、彪、博、诚、先、敬、震、振、壮、会、思群、豪、心、邦、承、乐、绍、功、松、善、厚、庆、磊、民、友、裕、河、"
  +"哲、江、超、浩、亮、政、谦、亨、奇固、之、轮、翰、朗、伯、宏、言、若、鸣、朋、斌、梁、栋、维、启、克、伦、翔、旭、鹏、泽、晨、辰、士、以建、"
  +"家、致、树、炎、德、行、时、泰、盛、雄、琛、钧、冠、策、腾、楠、榕、风、航、弘";
String nameWordsArr[] = nameWords.split("、");

void setup(){
  size(600, 800, P2D);
  
  mf = new MixFace();
  
  println("Process DNAUnits");
  DNAUnits = new Face[DNAUnitNum];
  for (int i = 0 ; i < DNAUnits.length ; i++) {
    String imgName = "originRenameImage/" + i + ".jpg";
    Face face = detectFace(imgName);
    if (face != null) {
      DNAUnits[i] = face;
    } else {
      i--;
      println("CANNOT DETECT " + imgName);
    }
    println("Process DNAUnits\t" + i/float(DNAUnitNum) + "  " + i);
  }
  
  ga = new GA();
  ga.init(0);

  
}
 
void draw(){
  background(255);
  
  ga.evolve();
  ga.display();
}

Face detectFace(String imgName) {
  
  Face result = null;
  PImage img = loadImage(imgName);
 
  String s[] = new String[1];
  s[0] = encoder(filePrefix + imgName);
  
  int maxRequestCount = 5;
  for (int i = 0 ; i < maxRequestCount ; i++) {
    PostRequest post = new PostRequest("https://api-cn.faceplusplus.com/facepp/v3/detect");
    post.addData("api_key", api_key);
    post.addData("api_secret", api_secret);
    post.addData("image_base64", s[0]);
    post.addData("return_landmark", "1");
    post.addData("return_attributes", "gender,age,beauty");
    post.send();
    JSONObject json = parseJSONObject(post.getContent());
    
    result = processData(json, img);
    
    if (result != null)
      break;
  }
  return result;
}

Face processData(JSONObject json, PImage img) {
  //println(json);
  if (json.hasKey("faces") && json.getJSONArray("faces").size() != 0) {
    JSONObject face = json.getJSONArray("faces").getJSONObject(0);
    JSONObject landmark = face.getJSONObject("landmark");
    String[] landmarkKeys = (String[]) landmark.keys()
      .toArray(new String[json.size()]);
    JSONObject faceRectangle = face.getJSONObject("face_rectangle");
    int w = faceRectangle.getInt("width");
    int h = faceRectangle.getInt("height");
    int l = faceRectangle.getInt("left");
    int t = faceRectangle.getInt("top");
    float bm = face.getJSONObject("attributes").getJSONObject("beauty").getFloat("male_score");
    float bf = face.getJSONObject("attributes").getJSONObject("beauty").getFloat("female_score");
    return new Face(w, h, l, t, bm, bf, landmark, landmarkKeys, img);
  } else {
    return null;
  }
}

String encoder(String imagePath) {
  String base64Image = "";
  File file = new File(imagePath);
  try {
    FileInputStream imageInFile = new FileInputStream(file);
    // Reading a Image file from file system
    byte imageData[] = new byte[(int) file.length()];
    imageInFile.read(imageData);
    base64Image = Base64.getEncoder().encodeToString(imageData);
  } catch (FileNotFoundException e) {
    System.out.println("Image not found" + e);
  } catch (IOException ioe) {
    System.out.println("Exception while reading the Image " + ioe);
  }
  return base64Image;
}

String getRandomName() {
  String result = "";
  for (int i = 0 ; i < 2 ; i++) {
    result += nameWordsArr[floor(random(nameWordsArr.length))];
  }
  return result;
}