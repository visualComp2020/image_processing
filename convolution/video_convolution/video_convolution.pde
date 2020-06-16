import processing.video.*;

Movie originalVid;
PImage convolutedImg;
PFont font;

// Convolution filters
float[][] saturation = { { 0.33333, 0.33333, 0.33333 },
                         { 0.33333, 0.33333, 0.33333 },
                         { 0.33333, 0.33333, 0.33333 }}; 
                         
float[][] highEdgeDetection = { { -1, -1, -1 },
                                { -1, 8, -1 },
                                { -1, -1, -1 } };
                                
float[][] highDefinition = { { 0, -1, 0 },
                             { -1, 5, -1 },
                             { 0, -1, 0 } };
                         
float[][] emboss = { { -2, -1, 0 },
                     { -1, 1, 1 },
                     { 0, 1, 2 } };
                     
float[][] blur = { { 0.11111, 0.11111, 0.11111 },
                   { 0.11111, 0.11111, 0.11111 },
                   { 0.11111, 0.11111, 0.11111 } };

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

void videoConvolution(float[][] filter, Movie originalVid){
  convolutedImg = createImage(originalVid.width, originalVid.height, RGB);
  int matrixSize = 3;

  for (int x = 0; x < originalVid.width; x++) {
    for (int y = 0; y < originalVid.height; y++ ) {
      color convolutedColor = convolutePixel(x, y, filter, matrixSize, originalVid);
      int pixelLocation = x + y * originalVid.width;
      
      convolutedImg.pixels[pixelLocation] = convolutedColor;
    }
  }
}

color convolutePixel(int x, int y, float[][] filter, int matrixsize, PImage img)
{
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  
  for (int i = 0; i < matrixsize; i++){
    for (int j= 0; j < matrixsize; j++){
      // What pixel are we testing
      int pixelX = x+i-offset;
      int pixelY = y+j-offset;
      int pixelLocation = pixelX + img.width*pixelY;
      // Make sure we haven't walked off our image, we could do better here
      pixelLocation = constrain(pixelLocation, 0, img.pixels.length-1);
      // Calculate the convolution
      rtotal += (red(img.pixels[pixelLocation]) * filter[i][j]);
      gtotal += (green(img.pixels[pixelLocation]) * filter[i][j]);
      btotal += (blue(img.pixels[pixelLocation]) * filter[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Return the resulting color
  return color(rtotal, gtotal, btotal);
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
  
  // Switch filters (saturation, highEdgeDetection, highDefinition, emboss and blur)
  videoConvolution(blur, originalVid);

  image(originalVid, 0, 50, 750, 550);
  image(convolutedImg, 750, 50, 750, 550);
  frameRateFormat(550);
}
