

var listBox:ListBox = new ListBox();
for (var i:int = 0; i < 10; i++) {
	listBox.addText("リストID:" + i);
}
listBox.setCallback(listBoxSelect);
// 後始末のためにリストボックスの親を保存しておく
var listParent:Stage = this.stage;
listParent.addChild(listBox); // リストボックスはstageに追加してやる
var listSelected:int = 5;

function mypageLinkClick(e:MouseEvent):void {
	listBox.setSelectNo(listSelected);
	listBox.disp();
}
// キチンと後始末しないとまずい
MovieClip(topMC).addEventListener(Event.REMOVED_FROM_STAGE, function (e:Event):void {
	listParent.removeChild(listBox);
});
// リストボックスのコールバック
function listBoxSelect(text:String):void {
	// textは選択されたアイテムの表示テキスト
	listSelected = listBox.getSelectIndex();
}
