/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.display 
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	/**
	* 缩放函数
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class setScale($target:DisplayObject, $speed):Number
	{
		$target.scaleX += $speed;
		$target.scaleY += $speed;
		var targetRect:Rectangle = $target.getBounds($target);
	}

}