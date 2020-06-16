
PImage originalImg, convolutedImg;


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
  size(1400, 800);
  originalImg = loadImage("./data/outdoor.jpg");
  originalImg.resize(700, 400);
  background(51);
}

void imgConvolution(float[][] filter, PImage originalImg){
  convolutedImg = createImage(originalImg.width, originalImg.height, RGB);
  int matrixSize = 3;

  for (int x = 0; x < originalImg.width; x++) {
    for (int y = 0; y < originalImg.height; y++ ) {
      color convolutedColor = convolutePixel(x, y, filter, matrixSize, originalImg);
      int pixelLocation = x + y * originalImg.width;
      
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


void histogram(PImage img, int drawFromX, int drawToX){
  int[] hist = new int[256];
  
  for (int i = drawFromX; i < drawToX; i++) {
    for (int j = 0; j < img.height; j++) {
      int bright = int(brightness(get(i, j)));
      hist[bright]++; 
    }
  }
  
  int histMax = max(hist);
  stroke(255);
  
  for (int i = 0; i < img.width; i += 2) {
    // Map i (from 0..img.width) to a location in the histogram (0..255)
    int which = int(map(i, 0, img.width, 0, 255));
    // Convert the histogram value to a location between img height
    int y = int(map(hist[which], 0, histMax, img.height * 2, img.height));
    line(i + drawFromX, img.height * 2, i + drawFromX, y);
  }
}

void draw() {
  originalImg.loadPixels();
  
  // Switch filters (saturation, highEdgeDetection, highDefinition, emboss and blur)
  imgConvolution(blur, originalImg);
  
  image(originalImg, 0, 0);
  histogram(originalImg, 0, originalImg.width);
  image(convolutedImg, originalImg.width, 0);
  histogram(convolutedImg, convolutedImg.width, convolutedImg.width * 2);
}
