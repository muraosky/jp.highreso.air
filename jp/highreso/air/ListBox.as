package jp.highreso.air {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author murao
	 */
	public class ListBox extends Sprite {
		private static var SCR_WIDTH		= 640;
		private static var SCR_HEIGHT		= 960;
		private static var BOX_HEIGHT_MAX	= 300;
		
		private var textList:Vector.<String>		= new Vector.<String>;
		private var itemList:Vector.<ListBoxItem>	= new Vector.<ListBoxItem>;
		private var selectCallback:Function			= null;
		private var selectItem:ListBoxItem			= null;
		private var selectIndex:int					= -1;

		private var background:Sprite	= null;
		private var listStage:MovieClip	= null;
		private var listMask:Sprite		= null;
		private var listClip:ClipUtil	= null;
		
		public function ListBox() {
			// 最初は非表示
			this.visible = false;
			
			background = new Sprite();
			background.graphics.beginFill(0x000000, 0);
			background.graphics.drawRect(0, 0, SCR_WIDTH, SCR_HEIGHT);
			background.graphics.endFill();
			background.buttonMode = true;
			background.addEventListener(MouseEvent.CLICK, hide);
			addChild(background);

			// リストのステージとなるものを作成
			listStage = new MovieClip();
			listStage.x = 0;
			listStage.y = SCR_HEIGHT;
			addChild(listStage);

			// マスクを設定
			listMask = new Sprite();
			listMask.graphics.beginFill(0xFFFFFF);
			listMask.graphics.drawRect(0, 0, SCR_WIDTH, BOX_HEIGHT_MAX);
			listMask.graphics.endFill();
			listMask.x = 0;
			listMask.y = SCR_HEIGHT - BOX_HEIGHT_MAX;
			// マスクとして設定
			listStage.mask = listMask;
			addChild(listMask);
		}
		
		/**
		 * テキストを追加する
		 * @param	text
		 */
		public function addText(text:String, selected:Boolean=false):void {
			var lbi:ListBoxItem = new ListBoxItem(text, selected, itemList.length);
			lbi.y = lbi.height * textList.length;
			lbi.buttonMode = true;
			lbi.addEventListener(MouseEvent.CLICK, onItemClick);
			listStage.addChild(lbi);
			
			// 選択中を保存
			if (selected) {
				if (selectIndex >= 0) {
					itemList[selectIndex].setCheckFlag(false);
				}
				selectItem = lbi;
				selectIndex = itemList.length;
			}
			// アイテムを保存
			itemList.push(lbi);
			// テキスト内容を保存
			textList.push(text);
		}
		
		/**
		 * 選択中のものを設定する
		 * @param	index
		 */
		public function setSelectNo(index:int):void {
			if (index < 0) return;
			if (index >= itemList.length) return;
			
			if (selectIndex >= 0) {
				itemList[selectIndex].setCheckFlag(false);
			}
			itemList[index].setCheckFlag(true);
			selectIndex = index;
		}

		/**
		 * 選択時のコールバックを設定する
		 * @param	func	Stringを引数に一つ持つ必要がある
		 */
		public function setCallback(func:Function):void {
			selectCallback = func;
		}
		/**
		 * アイテムクリックされた
		 * @param	event
		 */
		public function onItemClick(event:MouseEvent):void {
			selectItem = (event.currentTarget as ListBoxItem);
			if (selectItem == null) return;

			setSelectNo(selectItem.index);

			if (selectCallback != null) {
				selectCallback(selectItem.getText());
			}
			// クリックされたら閉じる
			hide();
		}
		
		/**
		 * 選択中のindexを取得する
		 * @return
		 */
		public function getSelectIndex():int {
			return selectIndex;
		}
		
		/**
		 * 表示する
		 */
		public function disp():void {
			if (visible) return;

			this.y = 0;

			var listLen = textList.length;
			var listHeight = ListBoxItem.LINE_HEIGHT * listLen;

			if (listStage.height > BOX_HEIGHT_MAX) {
				// 通常位置に置く
				listStage.y = SCR_HEIGHT - BOX_HEIGHT_MAX;
				if (listClip == null) listClip = new ClipUtil(listStage);
				listClip.setDragMode(new Rectangle(0, listStage.y, 0, -(listStage.height - BOX_HEIGHT_MAX)));
				// 選択を上に持ってくる
				var dispY:int = (selectIndex >= 0) ? selectIndex * ListBoxItem.LINE_HEIGHT:0;
				listStage.y -= dispY;
				if (listStage.height + listStage.y < SCR_HEIGHT) {
					// 画面端超えた
					listStage.y = SCR_HEIGHT - listStage.height;
				}
			} else {
				// スクロールなしでおさまる
				listStage.y = SCR_HEIGHT - listStage.height;
				if (listClip != null) {
					listClip.clipRemove();
					listClip = null;
				}
			}
			
			visible = true;
		}
		
		/**
		 * 非表示にする
		 */
		public function hide(event:MouseEvent = null):void {
			this.y = SCR_HEIGHT;
			this.visible = false;
		}
		
		
	}
}