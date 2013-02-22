/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.time 
{
	
	/**
	*
	* TimeFormat类用来格式化时间对象       
	* 
	* 获取形如"10:41"(分:秒)格式的时间                                	 --CODE: var _time:String = TimeFormat.getClickTime(getTimer());
	* 
	* 获取形如"221:10:41"(时:分:秒)格式的时间                            --CODE: var _time:String = TimeFormat.getFullClickTime(getTimer());
	* 
	* 获取当前时间，并转换为形如2009.12.12格式                       	 --CODE: trace(TimeFormat.getFullDate()); 
	*
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class TimeFormat 
	{
		
		public function TimeFormat() 
		{
			throw(new Error("这是静态类无法被实例化!"));
		}
		
		/**
		* 获取形如"10:41"(分:秒)格式的时间。
		* @param		$time		        Number				* 要转换的时间(注:毫秒数)
		* @return							String				转换后的时间
		*/
		public static function getClickTime($time:Number):String 
		{
			var s = Math.round($time / 1000);
			var m = 0;
			if (s > 0) {
				while (s > 59) {
					m++;
					s -= 60;
				}
				return (m < 10?"0":"") + m + ":" +( s < 10?"0":"") + s;
			} else {
				return "00:00";
			}
		}
		
		/**
		* 获取形如"221:10:41"(时:分:秒)格式的时间。
		* @param		$time		        Number				* 要转换的时间(注:毫秒数)
		* @return							String				转换后的时间
		*/
		public static function getFullClickTime($time:Number):String 
		{
			var s = Math.round($time / 1000);
			var m = 0;
			var h = 0;
			
			if (s > 0) {
				while (s > 59) {
					m++;
					s -= 60;
				}
				
				while (m > 59) {
					h++;
					m -= 60;
				}
				return h + ":" + (m < 10?"0":"") + m + ":" +( s < 10?"0":"") + s;
			} else {
				return "000:00:00";
			}
		}
		
		/**
		* 获取当前时间，并转换为形如2009.12.12格式
		* @return							String				转换后的时间
		*/
		public static  function getFullDate():String 
		{
			var date = new Date();
			var _year = date.getFullYear();
			var _month = date.getMonth()+1;
			var _date = date.getDate();
			if (_month < 10)
			_month = "0" + _month.toString();
			if (_date < 10)
			_date = "0" + _date.toString();
			
			return _year + "." + _month + "." + _date;
		}
	}
	
}