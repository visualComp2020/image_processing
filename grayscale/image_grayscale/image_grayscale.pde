
PImage img;
PImage averageGrayscaleImg;
PImage lumaGrayscaleImg;

void setup() {
  size(1400, 800);
  img = loadImage("./data/landscape.jpeg");
  img.resize(700, 400);
  background(51);
}

void averageGrayscale(PImage originalImg) {
  int originalSize = originalImg.width * originalImg.height;
  averageGrayscaleImg = createImage(originalImg.width, originalImg.height, RGB);

  for (int i = 0; i < originalSize; i++) {
    float pixelAvg = 0;

    pixelAvg = (red(originalImg.pixels[i]) + green(originalImg.pixels[i]) + blue(originalImg.pixels[i])) / 3;
    averageGrayscaleImg.pixels[i] = color(pixelAvg);
  }
}

void lumaGrayscale(PImage originalImg) {
  int originalSize = originalImg.width * originalImg.height;
  lumaGrayscaleImg = createImage(originalImg.width, originalImg.height, RGB);

  for (int i = 0; i < originalSize; i++) {
    float pixelLumaAvg = 0;

    pixelLumaAvg = red(originalImg.pixels[i]) * 0.299 + green(originalImg.pixels[i]) * 0.587 + blue(originalImg.pixels[i]) * 0.114;
    lumaGrayscaleImg.pixels[i] = color(pixelLumaAvg);
  }
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
  img.loadPixels();
  
  averageGrayscale(img);
  lumaGrayscale(img);
  
  image(img, 0, 0);
  histogram(img, 0, img.width);
  //image(averageGrayscaleImg, img.width, 0);
  //histogram(averageGrayscaleImg, averageGrayscaleImg.width, averageGrayscaleImg.width * 2);
  image(lumaGrayscaleImg, img.width, 0);
  histogram(lumaGrayscaleImg, lumaGrayscaleImg.width, lumaGrayscaleImg.width * 2);
  
  
}
