//ライブラリインポート
import processing.video.*;

Capture video;

void setup() {
  size(160, 120);
  video = new Capture(this, width, height);
  video.start();  
  noStroke();//線なし
  smooth();
}

void draw() {
  if (video.available()) {//キャプチャ映像がある場合
  //２次元配列を用意
  boolean[][] isWhite = new  boolean[video.width][video.height];
    video.read();//映像読み込み
    video.filter(THRESHOLD);//必要に応じてぼかしフィルタをつかう（ノイズ除去用）
    
    image(video, 0, 0, width, height); // 画像のインスタンスを作成
    video.loadPixels();
    int index = 0;
    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {
        //ピクセルに格納されている色を取得する
       float red=red(video.pixels[index]);
       float green=green(video.pixels[index]);
       float blue=blue(video.pixels[index]);
       
       if(red>240 && green>240 && blue>240){
               isWhite[x][y] = true;
       }
        index++;
      }
    }
    
    
    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {
              if( isWhite[x][y]==true){
                    fill(255, 204, 0, 128);
                    ellipse(x, y, 1, 11);
              }
      }
    }
    
  }
}