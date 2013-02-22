/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.events 
{
	import flash.events.Event;
	
	/**
	* load相关的事件
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class LoadEvent extends Event 
	{
		public static const LOAD_ERROR:			String = "loadError";					//发生错误
		
		public static const LOAD_BEGIN:			String = "loadBegin";           		//下载操作开始
		
		public static const LOAD_PROGRESS:		String = "loadProgress";				//下载操作进行中
		
		public static const LOAD_INIT:			String = "loadInit";					//可以访问被加载的 SWF 文件的属性和方法时
		
		public static const LOAD_COMPLETE:		String = "loadComplete";   				//文件下载完成。complete事件在init事件之后调度
	
		public static const GROUP_LOAD_PROGRESS:String = "groupLoadProgress";   		//组文件下载中。。。
		
		public static const GROUP_LOAD_COMPLETE:String = "groupLoadComplete";   		//组文件下载完毕	
		
		private var _parameters:				Array ;               					//事件参数对象
		
		public function set parameters ($value:Array) :void
		{
			_parameters = $value;
		}
		
		public function get parameters () :Array
		{
			_parameters = _parameters == [] ? null:_parameters;
			return _parameters;
		}
		
		public function LoadEvent($type:String, $para_array:Array = null , $bubbles:Boolean = false, $cancelable:Boolean = false  ) 
		{
			super($type, $bubbles, $cancelable);
			_parameters = $para_array == null? null:$para_array;
		}
		
	}
	
}