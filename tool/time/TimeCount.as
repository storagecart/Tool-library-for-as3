/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.time 
{
	import flash.utils.getTimer;
	
	/**
	* 计时器、计数器
	* 
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/

	public class TimeCount
	{
		private static var _begin			:int = 0;
		
		public static function begin():void
		{
			_begin = getTimer();
		}
		
		public static function end():int
		{
			return getTimer() - _begin ;
		}
	}
	
}