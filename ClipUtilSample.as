import flash.display.Graphics;
import flash.display.MovieClip;
import flash.display.Sprite;

// 対象ムービークリップ
var mc:MovieClip = new MovieClip();
addChild(mc);
// テスト用に適当に配置してみる
var sp:Sprite = new Sprite();
var g:Graphics = sp.graphics;
g.beginFill(0xFFFFFF);
g.drawRect(0, 0, 480, 2048);
g.endFill();

g.beginFill(0xFF0000);
g.drawCircle(0, 0, 100);
g.endFill();

mc.addChild(sp);

// 縦480の枠に表示して縦にドラッグする設定
var rect:Rectangle = new Rectangle(0, 0, 0, -mc.height + 480);
var clip:ClipUtil = new ClipUtil(mc);
// ドラッグモード設定
clip.setDragMode(rect);
