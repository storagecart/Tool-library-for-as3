/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.draw 
{
	import flash.display.*;
	
	/**
	* Painter是一个绘图类,其中包括画正多边形，星形，还有圆弧等...
	*
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class Painter 
	{
		
		public function Painter() 
		{
			throw(new Error("这是静态类无法被实例化!"));
		}
		
		/**
		* 绘制圆的内切正多边形
		*
		* @param		$edge		        Number				* 要绘制多边形的边数
		* @param		$radius		        Number				* 要绘制多边形的内切圆的半径
		* @param		$color		        Number				* 要绘制多边形的颜色
		* @param		$lineThickness		Number				* 要绘制多边形的边的粗细（默认没有）
		* @param		$lineColor   		Number				* 要绘制多边形的边的颜色
		* @return							Sprite				返回绘制的Sprite多边形
		*/
		
		public static function drawPoly($edge:Number = 3, $radius:Number = 50, $color:Number = 0x000000, $lineThickness:Number = 1, $lineColor:Number = 0x000000) :Sprite 
		{
			if ($edge < 2) { return new Sprite()};
			
			var sprite:Sprite = new Sprite();
			sprite.graphics.clear();
			sprite.graphics.beginFill($color);
			if ($lineThickness != 0)
            sprite.graphics.lineStyle($lineThickness, $lineColor);
			
			var angle:Number,i:uint;
			i=0;
			angle = Math.PI / 2 - (Math.PI / $edge + (2 * Math.PI / $edge) * i);
			sprite.graphics.moveTo($radius * Math.cos(angle), $radius * Math.sin(angle));
			
			for (i = 1; i < $edge; i++ ) {
				angle = Math.PI / 2 - (Math.PI / $edge + (2 * Math.PI / $edge) * i);
				sprite.graphics.lineTo($radius * Math.cos(angle), $radius * Math.sin(angle));
			}
			
			i=0;
			angle = Math.PI / 2 - (Math.PI / $edge + (2 * Math.PI / $edge) * i);
			sprite.graphics.lineTo($radius * Math.cos(angle), $radius * Math.sin(angle));
            sprite.graphics.endFill();

			return sprite;
		}
		
		/**
		* 绘制圆的内切星形
		*
		* @param		$edge		        Number				* 要绘制星形的边数
		* @param		$radius		        Number				* 要绘制星形的内切圆的半径
		* @param		$color		        Number				* 要绘制星形的颜色
		* @param		$lineThickness		Number				* 要绘制星形的边的粗细（默认没有）
		* @param		$lineColor   		Number				* 要绘制星形的边的颜色
		* @return							Sprite				返回绘制的Sprite星形
		*/
		
		public static function drawStar($edge:Number = 3, $radius:Number = 50, $color:Number = 0x000000, $lineThickness:Number = 1, $lineColor:Number = 0x000000) :Sprite 
		{
			if ($edge < 4) { return new Sprite()};
			
			var sprite:Sprite = new Sprite();
			sprite.graphics.clear();
			sprite.graphics.beginFill($color);
			if ($lineThickness != 0)
            sprite.graphics.lineStyle($lineThickness, $lineColor);
			
			var angle:Number,small_angle:Number,small_radius:Number,i:uint;
			i=0;
			angle = Math.PI / 2 - (Math.PI / $edge + (2 * Math.PI / $edge) * i);
			small_angle = angle-Math.PI / $edge;
			small_radius = $radius * Math.cos(2 * Math.PI / $edge) / Math.cos(Math.PI / $edge);
			sprite.graphics.moveTo($radius * Math.cos(angle), $radius * Math.sin(angle));
			sprite.graphics.lineTo(small_radius * Math.cos(small_angle), small_radius * Math.sin(small_angle));
			for (i = 1; i < $edge; i++ ) {
				angle = Math.PI / 2 - (Math.PI / $edge + (2 * Math.PI / $edge) * i);
				small_angle = angle-Math.PI / $edge;
				sprite.graphics.lineTo($radius * Math.cos(angle), $radius * Math.sin(angle));
				sprite.graphics.lineTo(small_radius * Math.cos(small_angle), small_radius * Math.sin(small_angle));
				
			}
			
			i=0;
			angle = Math.PI / 2 - (Math.PI / $edge + (2 * Math.PI / $edge) * i);
			small_angle = angle-Math.PI / $edge;
			sprite.graphics.lineTo($radius * Math.cos(angle), $radius * Math.sin(angle));
			sprite.graphics.lineTo(small_radius * Math.cos(small_angle), small_radius * Math.sin(small_angle));
            sprite.graphics.endFill();

			return sprite;
		}
		
		/**
		* 绘制圆弧   
		* (45度内圆弧近似于二次贝塞尔曲线)
		*
		* @param		$radius		        Number				* 要绘制圆弧的半径
		* @param		$beginRadian		Number				* 要绘制圆弧的开始角度
		* @param		$endRadian   		Number				* 要绘制圆弧的结束角度
		* @param		$lineThickness		Number				* 要绘制圆弧线条的粗细
		* @param		$lineColor   		Number				* 要绘制圆弧线条的颜色
		* @return							Sprite				返回绘制的Sprite圆弧
		*/
		
		public static function drawArc($radius:Number = 50,$beginRadian:Number=0,$endRadian:Number=Math.PI/2 ,$lineThickness:Number = 1, $lineColor:Number = 0x000000) :Sprite 
		{
			if ($beginRadian == $endRadian) { return new Sprite()};
			
			var sprite:Sprite = new Sprite();
			sprite.graphics.clear();
            sprite.graphics.lineStyle($lineThickness, $lineColor);
			
			if (Math.abs($beginRadian - $endRadian) >= Math.PI * 2)
			{
				$beginRadian = $endRadian + Math.PI * 2;
			}
			
			sprite.graphics.moveTo($radius * Math.cos($beginRadian), $radius * Math.sin($beginRadian));
			var long_radius = $radius / Math.cos((($endRadian - $beginRadian) / 2) / 8);
			var angleDelta = ($endRadian - $beginRadian) / 8;
			var angle = $beginRadian;
			
			for (var i:uint = 0; i < 8; i++ )
			{
				angle += angleDelta;
				var anchorX = $radius * Math.cos(angle);
				var anchorY = $radius * Math.sin(angle);
				var contrlX = long_radius * Math.cos((angle + angle-angleDelta) / 2);
				var contrlY = long_radius * Math.sin((angle + angle-angleDelta) / 2);
				sprite.graphics.curveTo(contrlX, contrlY, anchorX, anchorY);
			}
			
			return sprite;
		}
		
	}
	
}