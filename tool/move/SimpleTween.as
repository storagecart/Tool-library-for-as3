/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package  tool.move
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	* SIMPLE_TWEEN
	* 
	* --CODE: 
	* --CODE: 
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class SimpleTween 
	{
		static public var INTERVAL:Number = 1000 / 40;
		static private var DIC:Dictionary;
		
		static public function go($target:Object, $time:Number , $property:String, $propertyEnd:*, $ease:Function = null , $completeFun:Function = null ):* 
		{
			if (!Object($target).hasOwnProperty($property)) return;
			if (!DIC) DIC = new Dictionary;
			
			var propertyStart = $target[$property];
			var timer:Timer = new Timer(INTERVAL, 0);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.start();
			if (!DIC[$target]) DIC[$target] = new Array;
			var obj = new Object;
			obj.timer = timer;
			obj.timerHandler = timerHandler;
			obj.timerCompleteHandler = timerCompleteHandler;
			DIC[$target].push(obj);
			
			function timerHandler(e:TimerEvent):void 
			{
				var currentTime = timer.currentCount * INTERVAL;
				var ease = $ease == null?Linear.easeNone: $ease;
				var factor=$ease(currentTime , 0, 1, $time  );
				$target[$property] = propertyStart +  ($propertyEnd - propertyStart) * factor;
				
				if (currentTime + INTERVAL > $time || currentTime == $time)
				{
					timer.stop();
					timerCompleteHandler();
				}
			}
			
			function timerCompleteHandler():void
			{
				$target[$property] = $propertyEnd;
				if ($completeFun != null )$completeFun();
				timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			}
		}
		
		
		static public function kill($target)
		{
			if (!DIC) return;
			if (!DIC[$target]) return;
			for (var i = 0; i < DIC[$target].length; i++ )
			{
				DIC[$target][i].timer.removeEventListener(TimerEvent.TIMER, DIC[$target][i].timerHandler);
				DIC[$target][i].timer.stop();
			}
		}
		
		
	}

}