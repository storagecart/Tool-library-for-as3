/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.display.bitmap 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	/**
	* 新的bitmap
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0, Flash 10.0
	* @tiptext
	*
	*/
	public class GoodBmp extends MovieClip
	{
		
		public function GoodBmp($target:DisplayObject, $useTargetWidth:Boolean = true, $w:Number = 300, $h:Number = 300 ) 
		{
			var w, h;
			if ($useTargetWidth)
			{
				w = $target.width;
				h = $target.height;
			}else 
			{
				w = $w;
				h = $h;
			}
			
			var bpd:BitmapData = new BitmapData(w, h);
			bpd.draw($target);
			
			var bitmap:Bitmap = new Bitmap(bpd, "auto", true);
			addChild(bitmap);
		}
		
	}

}