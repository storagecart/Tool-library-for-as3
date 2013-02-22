/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.draw 
{
	import flash.display.*;
	
	/**
	* 生成光滑曲线
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class SmoothCurve extends Shape
	{
		private var _shape:				Shape;
		private var _gra:				Graphics;
		
		public function SmoothCurve ():void
		{
			_gra = graphics;
		}
		
		public function lineStyle(thickness:Number, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void
		{
			_gra.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
		}
		
		public function moveTo($x:Number, $y:Number ):void
		{
			_gra.moveTo($x, $y );
		}
		
		public function curveTo($pointArray:Array):void
		{
			var numPoints = $pointArray.length;
			if (numPoints == 0)
				return;
			
			_gra.moveTo($pointArray[0].x, $pointArray[0].y);
			if (numPoints < 3)
			{
				try {
					graphics.lineTo($pointArray[1].x, $pointArray[1].y);
					return;
				}catch (e) {
					return;
				}
			}
			
			for (var i = 1; i < numPoints - 2; i ++) {
				var xc:Number = ($pointArray[i].x + $pointArray[i + 1].x) / 2;
				var yc:Number = ($pointArray[i].y + $pointArray[i + 1].y) / 2;
				graphics.curveTo($pointArray[i].x, $pointArray[i].y, xc, yc);
			}

			graphics.curveTo($pointArray[i].x, $pointArray[i].y, $pointArray[i+1].x,$pointArray[i+1].y);
		}
		
		public function clear():void
		{
			_gra.clear();
		}
	}
	
}