/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.timeline
{
	import flash.display.*;
	import flash.media.*;
	import flash.events.*;
	
	/**
	* 
	* Timeline类用于处理时间轴的特效操作
	* 
	* 停止元件所有孩子的播放                 	  	
	* --CODE:Timeline.stopAllThings(this.root);
	* 
	* 继续元件所有孩子的播放                		
	* --CODE:Timeline.playAllThings(this.root);
	* 
	* 元件所有孩子反向播放                  		 
	* --CODE:Timeline.prevAllThings(this.root);
	* 
	* 移除元件所有孩子反向播放               		 
	* --CODE:Timeline.removePrevAllThings(this.root,false);
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class Timeline
	{
		private static const SOUND:Boolean = true;
		private static const STOP:Boolean = false;
		
		public function Timeline():void
		{
			throw(new Error("这是静态类无法被实例化!"));
		}
		
		/**
		* 停止元件所有孩子的播放
		*
		* @param		$target	            DisplayObjectContainer				* 要处理的对象
		* @param		$soundStop	        Boolean		                    	* 是否停止声音
		*/
		public static function stopAllThings($target:DisplayObjectContainer = null, $soundStop:Boolean = false ):void
		{
			Timeline.removePrevAllThings($target, true);                        //移除反向播放
			if ($soundStop) SoundMixer.stopAll();
			var depth:Number = $target.numChildren;
			if ($target == null) return ;
			if ($target is MovieClip) MovieClip($target).stop();
			if (depth == 0) return  ;
			for (var i:uint = 0; i < depth; i++ )
			{
				var sub:DisplayObject = $target.getChildAt(i);
				if(sub is DisplayObjectContainer)
				stopAllThings(sub as DisplayObjectContainer);
			}
		}
		
		/**
		* 继续元件所有孩子的播放
		*
		* @param		$target	            DisplayObjectContainer				* 要处理的对象
		*/
		public static function playAllThings($target:DisplayObjectContainer = null ):void
		{
			Timeline.removePrevAllThings($target, true);                        //移除反向播放
			var depth:Number = $target.numChildren;
			if ($target == null) return ;
			if ($target is MovieClip) MovieClip($target).play();
			if (depth == 0) return  ;
			for (var i:uint = 0; i < depth; i++ )
			{
				var sub:DisplayObject = $target.getChildAt(i);
				if(sub is DisplayObjectContainer)
				playAllThings(sub as DisplayObjectContainer);
			}
		}

		/**
		* 元件所有孩子反向播放
		*
		* @param		$target	            DisplayObjectContainer				* 要处理的对象
		*/
		public static function prevAllThings($target:DisplayObjectContainer = null ):void
		{
			var depth:Number = $target.numChildren;
			if ($target == null) return ;
			if ($target is MovieClip) prevMovie(MovieClip($target));
			if (depth == 0) return  ;
			for (var i:uint = 0; i < depth; i++ )
			{
				var sub:DisplayObject = $target.getChildAt(i);
				if(sub is DisplayObjectContainer)
				prevAllThings(sub as DisplayObjectContainer);
			}
			
			function prevMovie($target:MovieClip):void
			{
				$target.addEventListener(Event.ENTER_FRAME, Timeline.enterFrameHandler);
			}
		}
		
		private static function enterFrameHandler(e:Event):void
		{
			Timeline.prevAllThings(e.currentTarget as DisplayObjectContainer);
			e.currentTarget.prevFrame();
			if (e.currentTarget.currentFrame == 1)
			e.currentTarget.removeEventListener(Event.ENTER_FRAME, Timeline.enterFrameHandler); e.currentTarget.stop();
		}
		
		/**
		* 移除元件所有孩子反向播放
		*
		* @param		$target	            DisplayObjectContainer				* 要处理的对象
		* @param		$play	            Boolean             				* 移除后是否继续播放
		*/
		public static function removePrevAllThings($target:DisplayObjectContainer = null, $play:Boolean = true ):void
		{
			var depth:Number = $target.numChildren;
			if ($target == null) return ;
			if ($target is MovieClip) removePrevMovie(MovieClip($target), $play);
			if (depth == 0) return  ;
			for (var i:uint = 0; i < depth; i++ )
			{
				var sub:DisplayObject = $target.getChildAt(i);
				if(sub is DisplayObjectContainer)
				removePrevAllThings(sub as DisplayObjectContainer, $play);
			}
			
			function removePrevMovie($target, $play ):void
			{
				$target.removeEventListener(Event.ENTER_FRAME, Timeline.enterFrameHandler);
				if (!$play)
				$target.stop();
				else 
				$target.play();
			}
		}
		
	}
	
}