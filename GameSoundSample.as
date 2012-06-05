
var sound:GameSound = new GameSound();
sound.playBGM("サウンドのリンケージ名");

// アプリケーションが非アクティブになったら
stage.addEventListener(Event.DEACTIVATE , OnDeactivateHandler); 
// アプリケーションがアクティブになったら
stage.addEventListener(Event.ACTIVATE, OnActivateHandler);
// 非アクティブになったら
function OnDeactivateHandler(event:Event):void {
	sound.pauseAll();
	// 非アクティブで終了するとき↓
	// NativeApplication.nativeApplication.exit();
}
// アクティブになったら
function OnActivateHandler(event:Event):void {
	sound.resumeAll();
}
