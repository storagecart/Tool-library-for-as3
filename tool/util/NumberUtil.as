/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.util 
{
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	* 递加数字
	* 
	* --CODE: import tool.util.NumberUtil;
	* --CODE: NumberUtil.setNumber(numTxt,100,20," % ...");
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class NumberUtil 
	{
		private static var _timer		:Timer;
		private static var _fun			:Function;
		
		public static function setNumber($txt:TextField, $int:int, $time:Number = 1000 / 30 , $b:String = ""  ):void 
		{
			var num:int = parseInt($txt.text);
			if (!_timer)
			{
				_timer = new Timer($time, 0);
				_timer.addEventListener(TimerEvent.TIMER, timerHandler);
				_timer.start();
			}else
			{
				_timer.removeEventListener(TimerEvent.TIMER, _fun);
				_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			}
			_fun = timerHandler;
			
			function timerHandler(e:TimerEvent):void
			{
				if (num < $int)
				{
					num++;
					
				}else if(num > $int)
				{
					num--;
				}else 
				{
					_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
					_timer.stop();
					_timer = null;
				}
				
				$txt.text = String(num) + $b;
			}
		}
		
		public static function stop():void
		{
			if (_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER, _fun);
				_timer.stop();
				_timer = null;
			}
		}
		
	}
	
}