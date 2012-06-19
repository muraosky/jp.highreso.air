package jp.highreso.air {
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterType;
	import flash.filters.DropShadowFilter;
	import flash.filters.GradientGlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author murao
	 */
	public class ListBoxItem extends Sprite {
		public static var LINE_WIDTH:int	= 640;	// 幅
		public static var LINE_HEIGHT:int	= 70;	// 高さ
		public static var RADIO_RADIUS:int	= 12;	// ラジオボタンの半径

		private var back:Sprite		= null;
		private var radio:Sprite	= null;
		private var check:Sprite	= null;
		private var text:TextField	= null;
		private var checked:Boolean	= false;
		public var index:int		= 0;
		public var value:String		= null;
		
		public function ListBoxItem(text:String, checked:Boolean = false, index:int = -1, value:String = null) {
			var g:Graphics = null;
			// 背景
			back = new Sprite();
			g = back.graphics;
			g.beginFill(0xCCCCCC);
			g.drawRect(0, 0, LINE_WIDTH, LINE_HEIGHT);
			g.endFill();
			g.beginFill(0x333333);
			g.drawRect(0, 0, LINE_WIDTH, LINE_HEIGHT - 1);
			g.endFill();
			addChild(back);
			// ラジオボタン
			radio = new Sprite();
			g = radio.graphics;
			g.beginFill(0xFFFFFF);
			g.drawCircle(0, 0, RADIO_RADIUS + 1);
			g.endFill();
			g.beginFill(0xCCCCCC);
			g.drawCircle(0, 0, RADIO_RADIUS);
			g.endFill();
			radio.x = 600;
			radio.y = LINE_HEIGHT / 2;
			addChild(radio);
			// ラジオチェックボタン
			check = new Sprite();
			g = check.graphics;
			g.beginFill(0x33FF00);
			g.drawCircle(0, 0, RADIO_RADIUS);
			g.endFill();
			check.x = 600;
			check.y = LINE_HEIGHT / 2;
			// 表示テキスト
			this.text = CreateBaseText();
			this.text.text = text;
			addChild(this.text);
			
			// 最後にチェック入れるかどうか
			setCheckFlag(checked);
			
			this.index = index;
			this.value = value;
		}
		
		/**
		 * チェックフラグをセットする
		 * @param	flag
		 */
		public function setCheckFlag(flag:Boolean):void {
			if (checked != flag) {
				if (checked) {
					removeChild(check);
				} else {
					addChild(check);
				}
				checked = flag;
			}
		}

		/**
		 * テキストを取得する
		 * @return
		 */
		public function getText():String {
			return text.text;
		}

		/**
		 * 破棄
		 */
		public function destroy():void {
			back			= null;
			radio			= null;
			check			= null;
		}
		
		/**
		 * 基本となるテキストフィールドを作成する
		 * @return
		 */
		public static function CreateBaseText():TextField {
			// テキストフィールドを作成
			var text:TextField = new TextField();
			text.x = 10;
			text.y = 21;
			text.multiline		= false;
			text.width			= 480;
			text.height			= 28;
			text.selectable		= false;
			text.mouseEnabled	= false;
			// テキストフォーマットを作成
			var tf:TextFormat = new TextFormat();
			tf.size = 24;
			tf.color = 0xFFFFFF;
			tf.align = TextFormatAlign.LEFT;
			// テキストフィールドに反映
			text.defaultTextFormat = tf;
			
			// グラデーショングロー
			var ggf:GradientGlowFilter = new GradientGlowFilter();
			ggf.blurX = 3;
			ggf.blurY = 3;
			ggf.strength = 10;	// 1000%
			ggf.type = BitmapFilterType.OUTER;
			
			// ドロップシャドウ
			var dsf:DropShadowFilter = new DropShadowFilter();
			dsf.angle = 45;
			dsf.distance = 1;
			dsf.color = 0x000000;

			// テキストフィールドに反映
			text.filters = [ggf, dsf];
			
			return text;
		}
		
		
	}

}