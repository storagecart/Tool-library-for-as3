/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.display 
{
	import flash.display.*;
	import flash.geom.Point;
	
	/**
	* 变换注册点
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class Registration 
	{
		public static const TOP_LEFT:			String = "TOP_LEFT";
		public static const TOP_RIGHT:			String = "TOP_RIGHT";
		public static const CENTER:				String = "CENTER";
		public static const BOTTOM_LEFT:		String = "BOTTOM_LEFT";
		public static const BOTTOM_RIGHT:		String = "BOTTOM_RIGHT";
			
		/**
		* 
		*
		* @param		$target		        DisplayObjectContainer				* 要处理的对象/可以传入数组[mc1,mc2,...]
		* @return							Boolean								成功返回true,否则false
		*/
		public static function addNew($target:DisplayObjectContainer, $point:*, $y:Number = 0 ) :Boolean
		{
			var depth:Number = $target.numChildren;
			if (depth == 0) return false;
			
			var _x:Number,_y:Number;
			if ($point is Point)
			{
				_x = $point.x;
				_y = $point.y;
			}
			else if ($point is Number)
			{
				_x = $point;
				_y = $y;
			}
			for (var i:uint = 0; i < depth; i++ )
			{
				var target:DisplayObject = $target.getChildAt(i);
				target.x -= _x;
				target.y -= _y;
			}
			if ($target.parent != null)
			{
				$target.x += _x;
				$target.y += _y;
			}
			return true;
		}
		
	}
	
}