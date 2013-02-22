/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.fp10.a3d 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	/**
	* 参数配置(仅支持 flash player10.0 以上版本)
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 10.0/Flash 10.1
	* @tiptext
	*
	*/
	public class A3D 
	{
		public static const VERSION		:String = "1.0.0";			//版本
		
		public static var zorderFrame	:uint = 25;					//z排序的帧频
		
		public static var brightFrame	:uint = 40;					//灯光的刷新帧频
		
		public static var center		:Boolean = true;			//材质中心点是否为中心
		
		public static var bright		:Number = .45;				//默认的亮度
		
		public static var angle			:Number = 45;				//正常亮度的角度
		
		public static function setCenterPoint($target:DisplayObject, $x:Number, $y:Number )
		{
			$target.root.transform.perspectiveProjection.projectionCenter = new Point($x, $y);
		}
		
	}
	
}