/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.util 
{
	
	/**
	* for循环函数体
	* 
	* --CODE: import tool.util.setFor;
	* --CODE: setFor(trace,20,1,"d");
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public function  setFor ($fun:Function, $num:uint, ...rest ):void
	{
		for (var i:uint = 0; i < $num; i++ )
		{
			$fun.apply(null, rest);
		}
		
	}
	
}