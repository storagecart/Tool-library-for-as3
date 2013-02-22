/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.url 
{
	import flash.external.*;
	/**
	* 这是一个和所在页面的javascript交互的类...
	* 
	* 调用页面javascript函数。                  
	* --CODE:JavaScript.callJavaScript("javaScriptFunction",_arr1,_arr2);
	*
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class JavaScript 
	{	
		public function JavaScript():void
		{
			throw(new Error("这是静态类无法被实例化!"));
		}
		
		/**
		* 调用网页的js函数。
		* 如果所需的函数不可用，则调用返回 null；否则，将返回由该函数提供的值。
		*
		* @param		$function	        String				* 指定要导航到哪个 URL
		* @param		... arguments	    *    				* "_self" 指定当前窗口中的当前帧。
		* @return							*   				如果所需的函数不可用，则调用返回 null；否则，将返回由该函数提供的值。
		*/
		public static function callJavaScript($function:String,... arguments):* 
		{
			if (ExternalInterface.available) 
            ExternalInterface.call($function, arguments);
			else
			return null;
		}
	}
	
}