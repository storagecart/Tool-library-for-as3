/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.geom 
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	* 控制目标对象在一个矩形区域内
	* 
	* --CODE: import tool.geom.Rectangular;
	* --CODE: Rectangular.RECT = new Rectangle(100,100,200,200);           //声明矩形范围
	* --CODE: Rectangular.point(ball,true);								
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class Rectangular
	{
		
		public static var RECT:					Rectangle = new Rectangle(0, 0, 200, 200);
		
		public function Rectangular() 
		{
			throw(new Error("这是静态类无法被实例化!"));
		}
		
		/**
		* 控制目标对象在一个矩形区域内
		* @param		$target		      	  		DisplayObject		 				 * 目标对象
		* @param		$relative		      	  	Boolean		 				 		 * 是否相对于注册点计算
		*/
		public static function point($target:DisplayObject, $relative:Boolean = false ):void
		{
			if ($target.parent == null)throw(new Error("对象没有父级"));
			
			if ($relative)
			{
				var targetRect = $target.getBounds($target);
				
				//左
				if ($target.x < RECT.x - targetRect.x)
				$target.x = RECT.x - targetRect.x;
				//右 
				if ($target.x > RECT.right - targetRect.right)
				$target.x = RECT.right - targetRect.right;
				//上
				if ($target.y < RECT.y - targetRect.y)
				$target.y = RECT.y - targetRect.y;
				//下
				if ($target.y > RECT.bottom - targetRect.bottom)
				$target.y = RECT.bottom - targetRect.bottom;
			}else {
				//左
				if ($target.x < RECT.x)
				$target.x = RECT.x;
				//右 
				if ($target.x > RECT.right)
				$target.x = RECT.right;
				//上
				if ($target.y < RECT.y )
				$target.y = RECT.y;
				//下
				if ($target.y > RECT.bottom)
				$target.y = RECT.bottom;	
			}
			
		}
		
	}

}