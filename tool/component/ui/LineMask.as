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
	
	public class LineMask extends Shape
	{
		private var _bmd:BitmapData;
		private var _sp:Sprite
		public function LineMask($w:Number, $h:Number,$line:Number = 1 ,  $color:uint = 0x000000, $alpha:Number = .5) 
		{
			_bmd = new BitmapData($line, 2*$line, true, 0x00000000);
			_sp = new Sprite;
			_sp.graphics.beginFill($color, 1);
			_sp.graphics.drawRect(0, 0, $line, $line);
			_sp.graphics.beginFill($color, 0);
			_sp.graphics.drawRect(0, $line, $line, $line);
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