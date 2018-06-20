import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2); 
  
  //startBackgroundSubtraction(history, nMixtures, backgroundRatio)
  opencv.startBackgroundSubtraction(5, 3, 0.5);

  video.start();
  frameRate(1);
}

void draw() {
  //プログラムが始まって終了するまで時間をカウントする
  int time = millis();
  scale(2);
  opencv.loadImage(video);

  image(video, 0, 0 );
  //現在の画像で基準を更新
  opencv.updateBackground();
  //現在の画像の形を太くする
  opencv.dilate();
  //現在のイメージのシェイプを細くします。
  //opencv.dilate（）と組み合わせて使用すると、穴が閉じられます。
  opencv.erode();
  
  noFill();
  stroke(0, 255, 0);
  strokeWeight(1);


         //現在のグレー画像に基づいて輪郭を検索します。
          for (Contour contour : opencv.findContours()) {
          //print("contour.area()",contour.area());
          contour.draw();
                  print(contour.area());
                  text(int(contour.area()), 10, 35);
           
  } 
}

void captureEvent(Capture c) {
  c.read();
}