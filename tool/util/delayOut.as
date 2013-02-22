/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.util 
{
	import flash.utils.setTimeout;
	
	/**
	* 延迟函数
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public function delayOut($fun:Function, $time:Number = 1000, $var:*= null ):void
	{
		if($var)
			setTimeout($fun, $time, $var );
		else
			setTimeout($fun, $time );
	}
	
}