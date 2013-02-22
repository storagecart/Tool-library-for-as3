/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.mouse 
{
	import flash.display.*;
	
	/**
	* 检查鼠标是否移动
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class MouseCheck 
	{
		
		private static  var _nowX:					Number;
		private static  var _nowY:					Number;
		private static  var _oldX:					Number;
		private static  var _oldY:					Number;
		
		/**
		* 检查鼠标是否移动
		* 
		*/
		public static function isMove($target:DisplayObjectContainer ):Boolean
		{
			_nowX = $target.mouseX;
			_nowY = $target.mouseY;
			if ((_nowY - _oldX) != 0 || (_nowY - _oldY) != 0)
			{
				
				if (!isNaN(_oldX) && !isNaN(_oldY))
				{
					_oldX = _nowY;
					_oldY = _nowY;
					return true;
				}else{
					_oldX = _nowY;
					_oldY = _nowY;
					return false;
				}
			} 
			
			return false;
		}
	}
	
}