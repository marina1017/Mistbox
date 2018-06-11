//ビデオライブラリのインポート
import processing.video.*;
Capture video;//インスタンス生成
//PFont font;//フォントを用意

int w=320;//画面幅
int h=240;//画面高
int tolerance=15;//色許容値用の変数（後で調整可）
color targetColor=color(255,0,0);//物体の色用の変数（後で変更可）

int x;//図形座標用変数
int y;
int xmin=w,xmax=0;//左端X座標、右端X座標
int ymin=h,ymax=0;//上端Y座標、下端Y座標

boolean detection=false;//物体検知のフラグ

void settings() {
  size(w, h);//画面サイズ設定
}

void setup(){
  smooth();//滑らかな描画に設定
  video = new Capture(this, w, h);//キャプチャ映像の設定
  video.start(); 
  //font=loadFont("Monaco-10.vlw");//フォントをロード
  //textFont(font);//フォントの設定
  noStroke();//外形線なし
}

void draw() {
  if(video.available()){//キャプチャ映像がある場合
    video.read();//映像読み込み
    //video.filter(BLUR,2);必要に応じてぼかしフィルタをつかう（ノイズ除去用）  
    video.filter(THRESHOLD);//モノクロにする関数  
    set(0,0,video);//映像表示
    
    detection=false;//物体検知のフラグをfalse（検知なし）にしておく

    for(int i=0;i<w*h;i++){//画面全体のピクセル数だけ繰り返し処理
      //物体の色と各ピクセルの色の差を求める（RGB３色分）
      float difRed=red(video.pixels[i]);
      float difGreen=abs(green(targetColor)-green(video.pixels[i]));
      float difBlue=abs(blue(targetColor)-blue(video.pixels[i]));

      //RGB各色が許容値以内の場合（近似色である場合）
      if(difRed<tolerance && difGreen<tolerance && difBlue<tolerance){
        //フラグを物体検知有りにする
        detection=true;

        //左端、右端のX座標、上端、下端のY座標を導く
        //今回の値と今までの値を比較し、最小値、最大値を調べる
        xmin=min(i%w,xmin);//左端（X最小値）
        xmax=max(i%w,xmax);//右端（X最大値）
        ymin=min(i/w,ymin);//上端（Y最小値）
        ymax=max(i/w,ymax);//下端（Y最大値）
      }
    }
    
    if(detection==true){//物体検知有りの場合
      x=(xmin+xmax)/2;//X座標を左端と右端の座標の中点とする
      y=(ymin+ymax)/2;//Y座標を上端と下端の座標の中点とする

      //左端、右端、上端、下端の座標値を初期化しておく
      xmin=w;
      xmax=0;
      ymin=h;
      ymax=0;
    }
  }
  
  fill(255,0,0);//塗り色：赤
  ellipse(x,y,10,10);//円描画（求めたXY座標を代入）

  //以下は設定内容の表示
  fill(targetColor);//指定した物体の色
  rect(0,0,10,10);//矩形表示
  
  String s;//物体検知有無表示の文字列変数
  if(detection==true){//物体検知有りの場合
    s="detected";//表示：「検知」
  }else{
    s="none";//表示：「なし」
  }
  text(tolerance+": "+s,20,10);//文字列表示（許容値：物体検知有無）
}

void mousePressed(){//クリックしたら
  //マウス座標上のピクセルの色（物体の色）を記憶しておく
  targetColor=video.pixels[mouseX+mouseY*w];
}

void keyPressed(){
  if(key=='c'){//「c」キーを押した場合
   // video.settings();//カメラセッティング
  }
  if(key==CODED){
    if(keyCode==LEFT){//左キーを押した場合
      tolerance-=1;   //許容値を-1する
    }
    if(keyCode==RIGHT){//右キーを押した場合
      tolerance+=1;    //許容値を+1する
    }
  }
}