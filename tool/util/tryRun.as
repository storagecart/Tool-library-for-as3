/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.util 
{
	/**
	* try catch运行函数
	* 
	* --CODE: import tool.util.tryRun;
	* --CODE: tryRun(fun1,fun2);
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	import flash.errors.*;
	
	public function tryRun (...rest):void
	{
		for (var i:uint = 0; i < rest.length; i++ )
		{
			try
			{
				rest[i]();
			}catch (e:Error)
			{
				//
			}
		}
	}
	
}