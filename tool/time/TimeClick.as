/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.time 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import tool.util.tryRun;
	
	/**
	* 计时器
	* 
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class TimeClick 
	{
		static public var fun:Function;
		static public var num:int = 0;
		static public var secend:int = 0;
		
		static private var _timer:Timer;
		
		static public function start($delay:int = 1 ) 
		{
			_timer = new Timer($delay*1000, 0);
			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		static private function timerHandler(e:TimerEvent):void 
		{
			tryRun(fun)
			num++;
			secend++;
			if (secend > 60) secend = 1;
		}
		
		static public function stop() 
		{
			_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			_timer.stop();
		}
	}

}