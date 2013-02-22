/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.events
{
	import flash.events.Event;
	
	/*
	* 基本事件模式
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class BasicEvent extends Event 
	{
		
		private var _parameters:Array;
		
		public function set parameters ($value:Array) :void
		{
			_parameters = $value;
		}
		
		public function get parameters () :Array
		{
			_parameters = _parameters == [] ? null:_parameters;
			return _parameters;
		}
		
		public function BasicEvent($type:String, $para_array:Array = null,$bubbles:Boolean = false, $cancelable:Boolean = false ) 
		{
			super($type, $bubbles, $cancelable);
			_parameters = $para_array == null? null:$para_array;
		}
	}
	
}