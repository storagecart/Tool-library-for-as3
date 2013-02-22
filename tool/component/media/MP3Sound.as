/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.component.media 
{
	import flash.events.*;
    import flash.media.Sound;
    import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
    import flash.net.URLRequest;
	import tool.events.Mp3Event;
	
	import tool.events.LoadEvent;
	
	/**
	* 简单mp3播放器
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class MP3Sound extends EventDispatcher
	{
		private var _url:					String;
        private var _song:					SoundChannel;	
		private var _sound:					Sound;
		private var _position:				Number = 0;
		private var _length:				Number = 0;
		
		private var _playback:				Boolean;
		
		public function get length():Number
		{
			return _length;
		}
		
		public function get position():Number
		{
			_position = _song.position;
			return _position;
		}
		
		public function get song():SoundChannel
		{
			return _song;
		}
		
		public function get sound():Sound
		{
			return _sound;
		}
		
		public function set volume($volume:Number):void
		{
			_song.soundTransform.volume = $volume;
		}
		
		public function get volume():Number
		{
			return _song.soundTransform.volume;
		}
		
		public function MP3Sound($url:String, $bufferTime:Number = 1000 ):void
		{
			_url = $url;
            _sound = new Sound();
            _sound.addEventListener(Event.COMPLETE, 					completeHandler);
            _sound.addEventListener(Event.ID3, 							id3Handler);
            _sound.addEventListener(IOErrorEvent.IO_ERROR, 				ioErrorHandler);
            _sound.addEventListener(ProgressEvent.PROGRESS, 			progressHandler);
            _sound.load(new URLRequest(_url), new SoundLoaderContext($bufferTime, true) );
		}
		
		public function play($playback:Boolean = true ):void
		{
			_playback = $playback;
			_song = _sound.play();
			_song.addEventListener(Event.SOUND_COMPLETE, 				soundCompleteHandler);
		}
		public function playTo($second:Number)
		{
			_song.stop();
			_song.removeEventListener(Event.SOUND_COMPLETE, 				soundCompleteHandler);
			_song = null;
			_song = _sound.play($second);
			_song.addEventListener(Event.SOUND_COMPLETE, 				soundCompleteHandler);
		}
		
		public function replay():void
		{
			_song.stop();
			_song.removeEventListener(Event.SOUND_COMPLETE, 				soundCompleteHandler);
			_song = null;
			_song = _sound.play(_position);
			_song.addEventListener(Event.SOUND_COMPLETE, 				soundCompleteHandler);
		}
		
		public function pause():void
		{
			_position = _song.position;
			_song.stop();
		}
		
		public function stop():void
		{
			_song.stop();
		}
		
		private function soundCompleteHandler(e:Event):void
		{
			if (_playback)
				_sound.play(0);
			
			dispatchEvent(new Mp3Event(Mp3Event.SOUND_COMPLETE));
		}
		
		//load-events-----------------------
		private function completeHandler(event:Event):void 
		{
			_length = _sound.length;
            dispatchEvent(new LoadEvent(LoadEvent.LOAD_COMPLETE));
        }

        private function id3Handler(event:Event):void
		{
			dispatchEvent(new Event(Event.ID3));
        }

        private function ioErrorHandler(event:Event):void 
		{
            dispatchEvent(new LoadEvent(LoadEvent.LOAD_ERROR));
        }

        private function progressHandler(event:ProgressEvent):void
		{
            dispatchEvent(new LoadEvent(LoadEvent.LOAD_PROGRESS));
        }
		
	}
	
}