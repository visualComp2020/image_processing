import processing.video.*;

Movie originalVid;
PImage averageGrayscaleImg;
PImage lumaGrayscaleImg;
PFont font;

void setup() {
  size(1500, 600);
  frameRate(30);
  background(51);
  font = createFont("Arial",16,true);
  
  originalVid = new Movie(this, "video.mp4");
  originalVid.loop();
  loadPixels();
}

void movieEvent(Movie movie) {
  movie.read();
}

void averageGrayscale(Movie originalVid) {
  averageGrayscaleImg = createImage(originalVid.width, originalVid.height, RGB);

  for (int i = 0; i < originalVid.width; i++) {    
    for (int j = 0; j < originalVid.height; j++) {      
      // Calculate the 1D location from a 2D grid
      int pixelLocation = i + j * originalVid.width;      
    
      float r = red(originalVid.pixels[pixelLocation]);      
      float g = green(originalVid.pixels[pixelLocation]);      
      float b = blue(originalVid.pixels[pixelLocation]);         
    
      float pixelAvg = (r + g + b) / 3;  
      averageGrayscaleImg.pixels[pixelLocation] = color(pixelAvg);    
    }  
  }  
}

void lumaGrayscale(Movie originalVid) {
  lumaGrayscaleImg = createImage(originalVid.width, originalVid.height, RGB);

  for (int i = 0; i < originalVid.width; i++) {    
    for (int j = 0; j < originalVid.height; j++) {      
      // Calculate the 1D location from a 2D grid
      int pixelLocation = i + j * originalVid.width;      
    
      float r = red(originalVid.pixels[pixelLocation]) * 0.299;      
      float g = green(originalVid.pixels[pixelLocation]) * 0.587;      
      float b = blue(originalVid.pixels[pixelLocation]) * 0.114;         

      lumaGrayscaleImg.pixels[pixelLocation] = color(r + g + b);    
    }  
  }  
}

void frameRateFormat(int initialTextX) {
  fill(51);
  rect(0, 0, 1500, 50);
  fill(255);
  text("Frames per Second: " + String.format("%.2f", frameRate), initialTextX, 40);
  text("Frames per Second: " + String.format("%.2f", frameRate), initialTextX * 2.3, 40);
}

void draw() {
  originalVid.loadPixels();
  textFont(font,16); 
  
  averageGrayscale(originalVid);
  lumaGrayscale(originalVid);

  image(originalVid, 0, 50, 750, 550);
  image(averageGrayscaleImg, 750, 50, 750, 550);
  image(lumaGrayscaleImg, 750, 50, 750, 550);
  frameRateFormat(550);
}
