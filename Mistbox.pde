import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;


ArrayList<Contour> contours;


void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2); 

  
  //println("found " + contours.size() + " contours");


  //startBackgroundSubtraction(history, nMixtures, backgroundRatio)
  opencv.startBackgroundSubtraction(5, 3, 0.5);

  video.start();
}

void draw() {
  //プログラムが始まって終了するまで時間をカウントする
  int time = millis();
  int sum = 0;
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
contours = opencv.findContours();
print(" contoursの数:",contours.size());



  ////現在のグレー画像に基づいて輪郭を検索します。
   for (Contour contour : contours) {
         //print("contour.area()",contour.area());
         //1つの点につき1つの頂点を持つ閉じた形状として等高線を描きます。
         contour.draw();
           //Contourの境界ボックスの領域。 ほとんどの場合、これはContourの領域の良い近似値です。
           sum += int(contour.area());
    }
     text(sum, 10, 35);
}

void captureEvent(Capture c) {
  c.read();
}