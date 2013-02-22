/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.events
{
	import flash.events.*;
	
	/**
	* FLV相关的事件
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class FLVEvent extends Event
	{
		public static const FLV_BEGIN_LOAD:			String = "flvBeginLoad";        //开始加载
		public static const FLV_LOADED:				String = "flvLoaded";			//加载完毕
		public static const FLV_BEGIN:				String = "flvBegin";			//开始播放
		public static const FLV_STOP:				String = "flvStop";				//停止播放
		public static const FLV_PLAYING:			String = "flvPlaying";			//播放中。
		public static const FLV_COMPLETED:			String = "flvCompleted";		//播放结束
		public static const MEDIA_INFO:				String = "medisInfo";			//获取到信息了 
		public static const BUFFER:					String = "buffer";				//缓冲
		public static const BUFFER_OVER:			String = "bufferOver";			//缓冲结束
		
		private var _value:							* = null;
		
		public function get value():*
		{
			return _value;
		}
		
		public function FLVEvent(type:String, $value:*= null , bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			_value = $value;
		}
		
	}
	
}