
PImage originalImg;
PImage asciiImg;
PFont font;
/*char[] asciiChars = {'`', '^', ',', ':', ';', 'I', 'l', '!', 'i', '~', '+', '_', '-',
                     '?', ']', '[', '}', '{', '1', ')', '(', '|', '/', '█', '█', '▓',
                     '▒', '░', '#', '≡', '*', '#', '&', '8', '%', 'B', '@', '$'};*/
char[] asciiChars = {'█', '█', '▓', '▒', '░', '#', '≡', '%', '$', '@', '&'};

void setup() {
  size(1400, 500);
  originalImg = loadImage("./data/scooter.jpg");
  originalImg.resize(700, 500);
  font = createFont("Arial",16,true);
}

void convertAscii(PImage img, int resolution) {
  background(170);
  textFont(font,resolution);
  for(int i = 0; i < img.height; i+= resolution){
    for(int j = 0; j < img.width; j+= resolution){
      color textColor = img.get(int(j),int(i));
      fill(textColor);
      textAlign(CENTER);
      
      float value = brightness(textColor);
      char charac = asciiChars[int(value/25.5)];
      text(charac,(j),(i));
    }
  }
}

void draw() {
  int resolution = 1;
  
  originalImg.loadPixels();
  convertAscii(originalImg, resolution);
  image(originalImg, originalImg.width, 0);
}
