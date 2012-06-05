package jp.highreso.air {
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author murao
	 */
	public class GameSound {
		// 定数定義
		// サウンドチャンネル
		// SE～MAXまではSEが複数使う
		public static const SOUND_CH_BGM:int	= 0;
		public static const SOUND_CH_VOICE:int	= 1;
		public static const SOUND_CH_SE:int		= 2;
		public static const SOUND_CH_MAX:int	= 4;
		
		// ボリューム
		private var volumeBgm:Number	= 0.5;
		private var volumeVoice:Number	= 0.8;
		private var volumeSe:Number		= 0.8;
		
		// サウンド本体
		private var sounds:Vector.<Sound>			= null;
		private var channels:Vector.<SoundChannel>	= null;
		// サウンドの状態など
		private var soundNames:Vector.<String>		= null;
		private var isLoop:Vector.<Boolean>			= null;
		private var positions:Vector.<Number>		= null;
		
		// コンストラクタ
		public function GameSound() {
			// 初期化
			sounds = new Vector.<Sound>;
			channels = new Vector.<SoundChannel>;
			
			soundNames = new Vector.<String>;
			isLoop = new Vector.<Boolean>;
			positions = new Vector.<Number>;
			for (var i = 0; i < SOUND_CH_MAX; i++) {
				sounds[i] = null;
				channels[i] = null;
				
				soundNames[i] = null;
				isLoop[i] = false;
				positions[i] = -1;
			}
		}
		/**
		 * BGMボリューム設定
		 * @param	volume	0～100
		 */
		public function setVolumeBGM(volume:int):void {
			volumeBgm = Number(volume) / 100;
			if (channels[SOUND_CH_BGM] != null) {
				channels[SOUND_CH_BGM].soundTransform.volume = volumeBgm;
			}
		}
		/**
		 * ボイスボリューム設定
		 * @param	volume	0～100
		 */
		public function setVolumeVoice(volume:int):void {
			volumeVoice = Number(volume) / 100;
			if (channels[SOUND_CH_VOICE] != null) {
				channels[SOUND_CH_VOICE].soundTransform.volume = volumeVoice;
			}
		}
		/**
		 * SEボリューム設定
		 * @param	volume	0～100
		 */
		public function setVolumeSe(volume:int):void {
			volumeSe = Number(volume) / 100;
			for (var ch:int = SOUND_CH_SE; ch < SOUND_CH_MAX; ch++) {
				if (channels[ch] != null) {
					channels[ch].soundTransform.volume = volumeSe;
				}
			}
		}
		
		/**
		 * BGMボリュームを取得
		 * @return
		 */
		public function getVolumeBGM():int {
			return int(volumeBgm * 100);
		}
		/**
		 * ボイスボリュームを取得
		 * @return
		 */
		public function getVolumeVoice():int {
			return int(volumeVoice * 100);
		}
		/**
		 * SEボリュームを取得
		 * @return
		 */
		public function getVolumeSE():int {
			return int(volumeSe * 100);
		}
		
		/**
		 * 内部的なボリュームを取得する
		 * @param	ch	チャンネル
		 * @return
		 */
		public function getInternalVolume(ch:int):Number {
			var ret:Number = 0;
			switch(ch) {
			case SOUND_CH_BGM:		ret = volumeBgm;	break;
			case SOUND_CH_VOICE:	ret = volumeVoice;	break;
			case SOUND_CH_SE:		ret = volumeSe;		break;
			default:				ret = volumeSe;		break;
			}
			return ret;
		}
		
		/**
		 * 動的にSoundを取得する
		 * @param	name	クラス名
		 * 	ライブラリ内サウンドのプロパティで「ActionScriptに書き出し」「1フレーム目に書き出し」にチェックを入れた時のクラス名で取得する
		 * @return
		 */
		public static function GetSound(name:String):Sound {
			var myClass:Class = getDefinitionByName(name) as Class;
			if (myClass == null) return null;
			var myInstance:Sound = new myClass();
			return myInstance;
		}
		
		/**
		 * BGM再生
		 * @param	name	クラス名
		 * 	ライブラリ内サウンドのプロパティで「ActionScriptに書き出し」「1フレーム目に書き出し」にチェックを入れた時のクラス名
		 * @param	loop = true	ループ設定
		 */
		public function playBGM(name:String, loop = true):void {
			play(SOUND_CH_BGM, name, loop);
		}
		/**
		 * ボイス再生
		 * @param	name	クラス名
		 * 	ライブラリ内サウンドのプロパティで「ActionScriptに書き出し」「1フレーム目に書き出し」にチェックを入れた時のクラス名
		 * @param	loop = true	ループ設定
		 */
		public function playVoice(name:String, loop = false):void {
			play(SOUND_CH_VOICE, name, loop);
		}
		/**
		 * SE再生
		 * @param	name	クラス名
		 * 	ライブラリ内サウンドのプロパティで「ActionScriptに書き出し」「1フレーム目に書き出し」にチェックを入れた時のクラス名
		 * @param	loop = true	ループ設定
		 */
		public function playSE(name:String, loop = false):void {
			var ch:int = SOUND_CH_SE;
			var pos:Number = 0;
			var allLooping:Boolean = true;
			var old:int = 0;
			var oldCh:int = SOUND_CH_SE;
			// SEだけは複数チャンネルある
			for (var i:int = SOUND_CH_SE; i < SOUND_CH_MAX; i++) {
				if (sounds[i] == null) {
					// 再生中でなければ即再生
					ch = i;
					break;
				}
				if (!isLoop[i]) {
					// ループ再生以外のサウンドで長く再生しているものから上書き再生する
					if (pos < channels[i].position) {
						pos = channels[i].position;
						ch = i;
					}
					allLooping = false;
				} else if (allLooping) {
					// ループ再生のサウンドでも古いものをとっておく
					if (old < channels[i].position) {
						old = channels[i].position;
						oldCh = i;
					}
				}
			}
			if (allLooping) {
				// 全てループだった場合はこちら
				play(oldCh, name, loop);
			} else {
				play(ch, name, loop);
			}
		}

		/**
		 * サウンドを再生する
		 * @param	ch	再生するチャンネル
		 * @param	name	クラス名
		 * 	ライブラリ内サウンドのプロパティで「ActionScriptに書き出し」「1フレーム目に書き出し」にチェックを入れた時のクラス名
		 * @param	loop = false	ループするか
		 * @param	startTime	開始ポジション
		 */
		public function play(ch:int, name:String, loop:Boolean = false, startTime:Number = 0):void {
			if (ch >= SOUND_CH_MAX) return;
			// とりあえず停止
			stop(ch);
			// サウンドを取得
			sounds[ch] = GetSound(name);
			if (sounds[ch] == null) return;
			var trans:SoundTransform = new SoundTransform();
			trans.volume = getInternalVolume(ch);
			channels[ch] = sounds[ch].play(startTime, 0, trans);
			channels[ch].addEventListener(Event.SOUND_COMPLETE, soundCompleteListener);

			soundNames[ch] = name;
			isLoop[ch] = loop;
			positions[ch] = -1;
		}
		
		/**
		 * もう一度再生する
		 * @param	ch
		 */
		public function replay(ch:int):void {
			play(ch, soundNames[ch], isLoop[ch]);
		}
		
		/**
		 * BGMを停止する
		 */
		public function stopBGM():void {
			stop(SOUND_CH_BGM);
		}
		/**
		 * ボイスを停止する
		 */
		public function stopVoice():void {
			stop(SOUND_CH_VOICE);
		}
		/**
		 * SEを停止する
		 */
		public function stopSE():void {
			for (var ch:int = SOUND_CH_SE; ch < SOUND_CH_MAX; ch++) {
				stop(ch);
			}
		}
		/**
		 * 全てのサウンドを停止する
		 */
		public function stopAll():void {
			for (var i:int = 0; i < SOUND_CH_MAX; i++) {
				stop(i);
			}
		}
		/**
		 * サウンドを停止する
		 * @param	ch
		 */
		public function stop(ch:int):void {
			if (isset(sounds[ch]) && sounds[ch] != null) {
				channels[ch].removeEventListener(Event.SOUND_COMPLETE, soundCompleteListener);
				channels[ch].stop();
				channels[ch] = null;
				sounds[ch] = null;
				
				soundNames[ch] = null;
				isLoop[ch] = false;
				positions[ch] = -1;
			}
		}
		
		/**
		 * 再生完了リスナー
		 * @param	event
		 */
		public function soundCompleteListener(event:Event):void {
			for (var ch = 0; ch < SOUND_CH_MAX; ch++) {
				if (channels[ch] == event.target as SoundChannel) {
					if (isLoop[ch]) {
						replay(ch);
					} else {
						stop(ch);
					}
				}
			}
		}
		
		/**
		 * BGMを一時停止する
		 */
		public function pauseBGM():void {
			pause(SOUND_CH_BGM);
		}
		/**
		 * ボイスを一時停止する
		 */
		public function pauseVoice():void {
			pause(SOUND_CH_VOICE);
		}
		/**
		 * SEを一時停止する
		 */
		public function pauseSE():void {
			for (var ch:int = SOUND_CH_SE; ch < SOUND_CH_MAX; ch++) {
				pause(ch);
			}
		}
		/**
		 * 全てのサウンドを一時停止する
		 */
		public function pauseAll():void {
			for (var i = 0; i < SOUND_CH_MAX; i++) {
				pause(i);
			}
		}
		/**
		 * サウンドを一時停止する
		 * @param	ch	停止するチャンネル
		 */
		public function pause(ch:int):void {
			if (isset(channels[ch]) && channels[ch] != null) {
				var pos:Number = channels[ch].position;
				var name:String = soundNames[ch];
				var loop:Boolean = isLoop[ch];
				
				stop(ch);
				
				soundNames[ch] = name;
				isLoop[ch] = loop;
				positions[ch] = pos;
			}
		}
		
		/**
		 * BGMを再開する
		 */
		public function resumeBGM():void {
			resume(SOUND_CH_BGM);
		}
		/**
		 * ボイスを再開する
		 */
		public function resumeVoice():void {
			resume(SOUND_CH_VOICE);
		}
		/**
		 * SEを再開する
		 */
		public function resumeSE():void {
			for (var ch:int = SOUND_CH_SE; ch < SOUND_CH_MAX; ch++) {
				resume(ch);
			}
		}
		/**
		 * 全てのサウンドを再開する
		 */
		public function resumeAll():void {
			for (var i = 0; i < SOUND_CH_MAX; i++) {
				resume(i);
			}
		}
		/**
		 * サウンドを再開する
		 * @param	ch
		 */
		public function resume(ch:int):void {
			if (positions[ch] != -1) {
				play(ch, soundNames[ch], isLoop[ch], positions[ch]);
			}
		}
	}

}