/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.debug
{
	import tool.debug.Debug;
	
	/**
	* traced应用于调试类Debug，且包含trace功能
	* 使用                              --CODE:traced(1,200,"好");
	*
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public function traced(...arguments):void 
	{
		trace(arguments);
		arguments.unshift("<font color='#cccccc'>" + (++Debug.line ) +"</font>" + "  <i>trace</i>::  ");             //前缀
		arguments.push("<br>");                                                                                      //后缀
		Debug.array = Debug.array.concat(arguments);
		Debug.write();
	}
	
}