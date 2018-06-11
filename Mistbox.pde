//ライブラリインポート
import processing.video.*;

Capture video;

void setup() {
  size(640, 480);
  video = new Capture(this, width, height);
  video.start();  
  noStroke();//線なし
  smooth();
}

void draw() {
  if (video.available()) {
    video.read();
    image(video, 0, 0, width, height); // 画像のインスタンスを作成
    int brightestX = 0; // X-coordinate of the brightest video pixel
    int brightestY = 0; // Y-coordinate of the brightest video pixel
    float brightestValue = 0; // Brightness of the brightest video pixel
    //最も明るいピクセルを検索する：ビデオイメージ内のピクセルの各行について、
    // y行目の各ピクセルについて、ビデオ内の各ピクセルのインデックスを計算する
    video.loadPixels();
    int index = 0;
    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {
        //ピクセルに格納されている色を取得する
        print("index:");
        print(index);
        print(",");
        int pixelValue = video.pixels[index];
        // ピクセルの明るさを決定する
        //色から輝度値を抽出する関数
        float pixelBrightness = brightness(pixelValue);
         print("pixelBrightness:");
        print(pixelBrightness);
        print(",");
         //その値が以前の値よりも明るい場合は、
         //そのピクセルの輝度だけでなく、その（x、y）の位置を代入する
        if (pixelBrightness > brightestValue) {
          brightestValue = pixelBrightness;
          brightestY = y;
          brightestX = x;
        }
        index++;
      }
    }
    // Draw a large, yellow circle at the brightest pixel
    fill(255, 204, 0, 128);
    ellipse(brightestX, brightestY, 200, 200);
  }
}