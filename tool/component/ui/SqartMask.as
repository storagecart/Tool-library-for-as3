/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.component.ui 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	* 全屏遮罩，能遮挡全屏的按钮
	* 
	* 使用方法
	* --CODE: import tool.component.ui.LineMask;
	* --CODE: var myLineMask=new LineMask(1024,768,0xffcccc,.2);
	* --CODE: addChild(myLineMask);
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class SqartMask extends Shape
	{
		private var _bmd:BitmapData;
		private var _sp:Sprite
		public function SqartMask($w:Number, $h:Number, $sp:Number = 10 ,  $color:uint = 0x000000, $alpha:Number = .5)
		{
			_bmd = new BitmapData($sp, $sp, true, 0x00000000);
			_sp = new Sprite;
			_sp.graphics.lineStyle(1, $color, 1);
			_sp.graphics.beginFill(0, 0);
			_sp.graphics.drawRect(0, 0, $sp, $sp);
			_sp.graphics.endFill();
			_bmd.draw(_sp, new Matrix);
			
			graphics.beginBitmapFill(_bmd, null, true);
            graphics.drawRect(0, 0, $w, $h);
            graphics.endFill();
			alpha = $alpha;
		}
		
		public function reset($w:Number, $h:Number)
		{
			graphics.clear();
			graphics.beginBitmapFill(_bmd, null, true);
            graphics.drawRect(0, 0, $w, $h);
            graphics.endFill();
		}
		
		public function destory():void
		{
			_bmd.dispose();
		}
		
	}

}