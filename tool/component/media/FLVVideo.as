/*
  Copyright (c) 2009, www.a-jie.cn  a-jie.cn@msn.c0m
  All rights reserved.
*/
  
package tool.component.media 
{
	import flash.display.*;
	import flash.events.*
	import flash.media.*;
	import flash.net.NetStream;
	import flash.net.NetConnection;
	import flash.utils.*;
	
	import tool.events.FLVEvent;
	
	/**
	* FLV播放器
	*  
	* 导入类                            				 
	* --CODE:import tool.component.media.FLVVideo;
	* 
	* 两种声明方法  
	* --CODE:（1）var flv=new FLVVideo("first.flv",300,30);
	* --CODE:（2）var flv=new FLVVideo("first.flv",300,30,true,true);
	* 
	* 添加到场景
	* --CODE: addChild(flv);
	* 
	* 还可以重新设置以下属性
	* --CODE: flv.scaling=true;              												//按比例缩放
	* --CODE: flv.playBack=true;															//自动回放
	* 
	* 事件类型
	* --CODE: flv.addEventListener(FLVEvent.FLV_BEGIN_LOAD,beginLoadHandler);				//加载开始
	* --CODE: flv.addEventListener(FLVEvent.FLV_LOADED,loadedHandler);						//加载完毕
	* --CODE: flv.addEventListener(FLVEvent.FLV_BEGIN,beginHandler);						//播放开始
	* --CODE: flv.addEventListener(FLVEvent.FLV_STOP,stopHandler);							//播放停止
	* --CODE: flv.addEventListener(FLVEvent.FLV_PLAYING,playingHandler);             		//播放中
	* --CODE: flv.addEventListener(FLVEvent.FLV_COMPLETED,completedHandler);            	//播放结束
	* 
	* 公共方法
	* --CODE: flv.playFLV(); 																//开始视频播放
	* --CODE: flv.stopFLV(); 																//停止视频播放
	* --CODE: flv.pauseFLV(); 																//暂停视频播放
	* --CODE: flv.resumeFLV(); 																//恢复视频播放
	* --CODE: flv.seekFLV(); 																//搜寻最接近于指定位置的关键帧，并流恢复播放。
	* --CODE: flv.togglePauseFLV(); 														//暂停或恢复流的回放
	* --CODE: flv.closeFLV(); 																//关闭并清除
	* 
	* 公共属性
	* --CODE: flv.time; 																	//当前播放头的时间
	* --CODE: flv.duration;																	//视频的总时长                                    
	* --CODE: flv.width ,flv.height															//视频的宽和高
	* --CODE: flv.volume  																	//视频的声音
	* --CODE: flv.playProgress																//视频的播放进度
	* --CODE: flv.loadedScale  																//加载的进度 
	* --CODE: flv.videoHeight, flv.videoHeight 												//视频的实际宽和高
	* --CODE: flv.bufferTime  																//指定在开始显示流之前需要多长时间将消息存入缓冲区
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class FLVVideo extends Sprite 
	{
		private var _url:					String;
		private var _width:					Number;					//视频宽度
		private var _height:				Number;					//视频高度
		private var _scaling:				Boolean;				//是否按比例缩放
		private var _playBack:				Boolean;				//是否回放
		
        private var _connection:			NetConnection;
        private var _stream:				NetStream;
		private var _video:					Video;
		private var _timer:					Timer;
		private var _timerLoader:			Timer;
		
		private var _videoWidth:			Number = 0;           	//视频真实宽度
		private var _videoHeight:			Number = 0;				//视频真实高度
		private var _duration:				Number = 0;				//视频的总时长
		private var _framerate:				Number = 0;				//视频播放频率
		private var _loadedScale:			Number = -1;            //加载的进度比例
		private var _value:                 Number;
		private var _bufferTime:			Number = 0;
		private var _playProgress:          Number = 0;
		private var _smoothing:				Boolean = false;
		
		public var onXMPData;
		
		public function set url($url:String):void
		{
			_url = $url;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width($value:Number):void
		{
			$value = $value <= 0?1:$value;
			_width = $value;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height($value:Number):void
		{
			$value = $value <= 0?1:$value;
			_height = $value;
		}
		
		public function set smoothing($bool:Boolean):void
		{
			_smoothing = $bool;
			if(_video)
				_video.smoothing = $bool;
		}
		
		public function get smoothing():Boolean
		{
			if(_video)
				return _video.smoothing;
			else 
				return _smoothing;
		}
		
		public function set playBack($playBack:Boolean ):void
		{
			_playBack = $playBack;
			
			if (_playBack)
			addEventListener(FLVEvent.FLV_COMPLETED, flvCompletedHandler);
			else
			removeEventListener(FLVEvent.FLV_COMPLETED, flvCompletedHandler);
		}
		
		public function get playBack():Boolean
		{
			return _playBack;
		}
		
		public function set scaling($scaling:Boolean ):void
		{
			_scaling = $scaling;
		}
		
		public function get scaling():Boolean
		{
			return _scaling;
		}
		
		public function set volume($value:Number):void
		{
			$value = $value <= 0 ? 0 : $value;
			_stream.soundTransform = new SoundTransform($value);
		}
		
		public function get volume():Number
		{
			return _stream.soundTransform.volume;
		}
		
		public function get time():Number
		{
			return _stream.time;
		}
		
		public function get duration():Number
		{
			return _duration;
		}
		
		public function get playProgress():Number
		{
			if (_duration == 0)
			{
				return 0;
			}else {
				_playProgress = _stream.time / _duration;
				return Math.min(_playProgress, 1);
			}
		}
		
		public function set playProgress($value:Number):void 
		{
			$value = $value <= 0?0:$value;
			$value = $value >= 1?1:$value;
			_playProgress = $value;
			seekFLV(_playProgress * duration);
			resumeFLV();
		}
		
		public function get netStream():NetStream
		{
			return	_stream;
		}
		
		public function get loadedScale():Number
		{
			return _loadedScale;
		}
		
		public function get videoWidth():Number
		{
			return _videoWidth;
		}
		
		public function get videoHeight():Number
		{
			return _videoHeight;
		}
		
		public function set bufferTime ($time:Number):void
		{
			_bufferTime = $time;
		}
		
		public function get bufferTime ():Number
		{
			return _bufferTime;
		}
		
		public function get video():Video
		{
			return _video;
		}
			
		//=================================================================================================================================
		/**
		* 构造函数
		* @param		$url		      	  	String		 				 * 开始回放外部视频 (FLV) 地址
		* @param		$width		        	Number		        		 * 视频 (FLV)的显示宽度
		* @param		$height		       	 	Number		     		     * 视频 (FLV)的显示高度
		* @param		$scaling		        Boolean		      			 * 视频 (FLV)是否按比例缩放
		* @param		$playBack		        Boolean		         		 * 视频 (FLV)是否回放
		*/  
		public function FLVVideo($url:String = "" , $width:Number = 320, $height:Number = 240, $scaling:Boolean = false, $playBack:Boolean = false ) 
		{
			_url = $url;
			_width = $width;
			_height = $height;
			_scaling = $scaling;
			_playBack = $playBack;
			_timer = new Timer(1000 / 40, 0);
			_timerLoader = new Timer(1000 / 40, 0);
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
		}
		
		/**
		* 开始视频播放
		*/
		public function playFLV($url:String = ""):void
		{
			closeFLV();
			if ($url != "" )_url = $url;
			_connection = new NetConnection();
            _connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            _connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            _connection.connect(null);
		}
		
		/**
		* 停止视频播放
		*/
		public function stopFLV():void
		{
			_stream.pause();
			_stream.seek(0);
			dispatchEvent(new FLVEvent(FLVEvent.FLV_STOP));
		}
		
		/**
		* 暂停视频
		*/
		public function pauseFLV():void
		{
			_stream.pause();
			dispatchEvent(new FLVEvent(FLVEvent.FLV_STOP));
		}
		
		/**
		* 恢复暂停后的视频播放
		*/
		public function resumeFLV():void
		{
			_stream.resume();
			timerAddEvent();
		}
		
		/**
		* 搜寻最接近于指定位置的关键帧，并流恢复播放。
		*/
		public function seekFLV($time:Number):void
		{
			_stream.seek($time);
			if ($time == 0) dispatchEvent(new FLVEvent(FLVEvent.FLV_BEGIN));
			timerAddEvent();
		}
		
		/**
		* 暂停或恢复流的回放。（开/关）
		*/
		public function togglePauseFLV():void
		{
			_stream.togglePause();
		}
		
		/**
		* 关闭并清除
		*/
		public function closeFLV() :void
		{
			if (_connection == null) return;
			try {
				_connection.close();
				_timerLoader.removeEventListener(TimerEvent.TIMER, timerHandler);
				_timerLoader.stop();
				_timer.removeEventListener(TimerEvent.TIMER, playingFUN);
				_timer.stop();
				_stream.close();
				_video.clear();
				removeChild(_video);	
			}catch (e:Error) {	
			}
		}
		
		private function removeFromStageHandler(e:Event):void
		{
			closeFLV();
		}
		
		private function connectStream():void 
		{
            _stream = new NetStream(_connection);
            _stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            _stream.client = this;
			_stream.play(_url);
			_stream.bufferTime = _bufferTime;
			
			_video = new Video();
			_video.smoothing = _smoothing;
            _video.attachNetStream(_stream);
			_video.width = _width;
			_video.height = _height;
            addChild(_video);
			
			_timerLoader.addEventListener(TimerEvent.TIMER, timerHandler);
			_timerLoader.start();
			dispatchEvent(new FLVEvent(FLVEvent.FLV_BEGIN_LOAD));
			if (_playBack) addEventListener(FLVEvent.FLV_COMPLETED, flvCompletedHandler);
        }
		
		private function timerHandler(e:TimerEvent):void
		{
			if (_stream.bytesTotal <= .1) {
				_timerLoader.removeEventListener(TimerEvent.TIMER, timerHandler);
				_timerLoader.stop();
			}else {
				_loadedScale = _stream.bytesLoaded / _stream.bytesTotal;
				if (_stream.bytesTotal == _stream.bytesLoaded)
				{
					dispatchEvent(new FLVEvent(FLVEvent.FLV_LOADED));
					_timerLoader.removeEventListener(TimerEvent.TIMER, timerHandler);
					_timerLoader.stop();
				}
			}
		}
		
		private function netStatusHandler(event:NetStatusEvent):void 
		{
            switch (event.info.code) {
                case "NetConnection.Connect.Success":
                    connectStream();
                    break;
					
                case "NetStream.Play.StreamNotFound":
                    trace("地址无效!");
                    break;
					
				case "NetStream.Play.Start":
					_timer.start();
					dispatchEvent(new FLVEvent(FLVEvent.FLV_BEGIN));
					timerAddEvent();
					break;
					
				case "NetStream.Buffer.Empty":
					dispatchEvent(new FLVEvent(FLVEvent.BUFFER));
					break;
					
				case "NetStream.Buffer.Full":
					dispatchEvent(new FLVEvent(FLVEvent.BUFFER_OVER));
					break;
					
				case "NetStream.Play.Stop":
					dispatchEvent(new FLVEvent(FLVEvent.FLV_STOP));
					dispatchEvent(new FLVEvent(FLVEvent.FLV_COMPLETED));
					break;
					
            }
        }
		
		private function timerAddEvent():void
		{
			if (!_timer.hasEventListener(TimerEvent.TIMER))
			_timer.addEventListener(TimerEvent.TIMER, playingFUN);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
            trace("安全错误!" );
        }
		
		private function flvCompletedHandler(e:FLVEvent):void
		{
			_stream.seek(0);
		}
		
		private function playingFUN(e:TimerEvent):void
		{
			dispatchEvent(new FLVEvent(FLVEvent.FLV_PLAYING));
		}
		
		//元数据
		public function onMetaData(info:Object):void 
		{
			_videoWidth = info.width;
			_videoHeight = info.height;
			_duration = info.duration;
			_framerate = info.framerate;
			
			if (_scaling)
			{
				_height = _videoHeight / _videoWidth * _width;
				_video.height = _height;
			}
			dispatchEvent(new FLVEvent(FLVEvent.MEDIA_INFO));
		}
	
		//遇到提示点时进行调度。
		public function onCuePoint(info:Object):void 
		{
			///////////////////////////////////////////////////////
		}
	
	}
	
}
