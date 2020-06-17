import processing.video.*;

Movie originalVid;
PImage asciiImg;
PFont font, f;
/*char[] asciiChars = {'`', '^', ',', ':', ';', 'I', 'l', '!', 'i', '~', '+', '_', '-',
                     '?', ']', '[', '}', '{', '1', ')', '(', '|', '/', '█', '█', '▓',
                     '▒', '░', '#', '≡', '*', '#', '&', '8', '%', 'B', '@', '$'};*/
char[] asciiChars = {'█', '█', '▓', '▒', '░', '#', '≡', '%', '$', '@', '&'};

void setup() {
  size(1600, 650);
  frameRate(30);
  background(51);
  font = createFont("Arial",16,true);
  f = createFont("Arial",16,true);
  originalVid = new Movie(this, "video.mp4");
  originalVid.loop();
  loadPixels();
}

void movieEvent(Movie movie) {
  movie.read();
}

void convertAscii(Movie vid, int resolution) {
  background(170);
  textFont(font,resolution);
  for(int i = 0; i < vid.width; i+= resolution){
    for(int j = 0; j < vid.height; j+= resolution){
      color textColor = vid.pixels[i + j*vid.width];
      fill(textColor);
      textAlign(CENTER);
      
      float value = brightness(textColor);
      char charac = asciiChars[int(value/25.5)];
      text(charac,(i),(j));
    }
  }
}

void frameRateFormat(int initialTextX, int initialTextY) {
  fill(51);
  rect(0, 650, 1500, 650);
  fill(255);
  textSize(16); 
  text("Frames per Second: " + String.format("%.2f", frameRate), initialTextX, initialTextY);
  text("Frames per Second: " + String.format("%.2f", frameRate), initialTextX * 2.3, initialTextY);
}

void draw() {
  originalVid.loadPixels();

  convertAscii(originalVid, 3);
  image(originalVid, 800, 0, 800, 600);
  frameRateFormat(650, 640);
}
