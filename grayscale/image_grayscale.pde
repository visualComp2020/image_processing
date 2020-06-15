
PImage img;
PImage averageGrayscaleImg;
PImage lumaGrayscaleImg;

void setup() {
  size(1600, 1000);
  img = loadImage("../balloon.jpg");
  img.resize(800, 500);
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

void draw() {
  img.loadPixels();
  
  averageGrayscale(img);
  lumaGrayscale(img);
  
  image(img, img.width / 2, 0);
  image(averageGrayscaleImg, 0, img.height);
  image(lumaGrayscaleImg, img.width, img.height);
}
