package jp.highreso.air {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author murao
	 */
	public class ClipUtil {
		public var _mc:MovieClip = null;
		public var _stage:Stage = null;
		public var _rect:Rectangle = null;
		public var _overwrap:Sprite = null;
		public var _isDrag:Boolean = false;
		
		/**
		 * ムービークリップを使いこなすためのクラス
		 * @param	mc
		 */
		public function ClipUtil(mc:MovieClip) {
			if (mc == null) return;
			_mc = mc;
			_stage = mc.stage;
			_isDrag = false;

			// デストラクタ替わり
			_mc.addEventListener(Event.REMOVED_FROM_STAGE, clipRemove);
		}
		
		/**
		 * ムービークリップをドラッグ可能にする
		 * @param	rect	ドラッグ可能な範囲
		 */
		public function setDragMode(rect:Rectangle = null):void {
			_rect = rect;
			_isDrag = false;
			
			_mc.buttonMode = true;
			_mc.addEventListener(MouseEvent.MOUSE_DOWN, dragStart);
			_mc.addEventListener(MouseEvent.MOUSE_MOVE, dragMove);
			_stage.addEventListener(MouseEvent.MOUSE_UP, dragStop);
		}
		/**
		 * ドラッグ開始
		 * @param	event
		 */
		public function dragStart(event:MouseEvent):void {
			_mc.startDrag(false, _rect);
			_isDrag = true;
		}
		/**
		 * ドラッグで動いた
		 * @param	event
		 */
		public function dragMove(event:MouseEvent):void {
			if (_isDrag) {
				event.updateAfterEvent();
				// _overwrapを配置することでドラッグ後に下のボタンを押してしまう現象を回避する
				if (_overwrap == null) {
					_overwrap = new Sprite();
					_overwrap.graphics.beginFill(0x000000, 0);
					_overwrap.graphics.drawRect(0, 0, _mc.width, _mc.height);
					_overwrap.graphics.endFill();
					_mc.addChild(_overwrap);
				}
			}
		}
		/**
		 * ドラッグ終了
		 * @param	event
		 */
		public function dragStop(event:MouseEvent):void {
			_mc.stopDrag();
			_isDrag = false;
			if (_overwrap != null) {
				_mc.removeChild(_overwrap);
				_overwrap = null;
			}
		}
		
		/**
		 * 対象ムービークリップがステージから消えた時に呼び出される
		 * 主にイベントリスナーの後始末を行う
		 * @param	event
		 */
		public function clipRemove(event:Event):void {
			_mc.removeEventListener(MouseEvent.MOUSE_DOWN, dragStart);
			_mc.removeEventListener(MouseEvent.MOUSE_MOVE, dragMove);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, dragStop);
			_mc.removeEventListener(Event.REMOVED_FROM_STAGE, clipRemove);
		}
	}

}