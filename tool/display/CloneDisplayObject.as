/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package  tool.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	* 克隆显示对象返回不同的种类的对象
	*
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0, Flash 10.0
	* @tiptext
	*
	*/
	public class CloneDisplayObject 
	{
		
		 public static function cloneBitmap($taraget:DisplayObject, $w:int = -1, $h:int = -1, $newW:int = 0, $newH:int = 0) : Bitmap
        {
            $w = $w < 0 ? ($taraget.width) : ($w);
            $h = $h < 0 ? ($taraget.height) : ($h);
            if (!$taraget)
            {
                throw new Error("对象为空");
            }
            if ($w <= 0 || $h <= 0)
            {
                throw new Error("宽度或者高度小于0");
            }
            if ($w + $newW > $taraget.width || $h + $newH > $taraget.height)
            {
                throw new Error("宽高溢出！");
            }
            if ($w >= 2880 || $h >= 2880)
            {
                throw new Error("宽度或者高度超出渲染范围");
            }
            var bitmap:Bitmap = new Bitmap(new BitmapData($w, $h, true, 0));
            var matrix:Matrix = new Matrix();
            matrix.translate(-$newW, -$newH);
            bitmap.bitmapData.draw($taraget, matrix);
			
            return bitmap;
        }
		
		public static function duplicateDisplayObject($target:DisplayObject) : DisplayObject
        {
            var rect:Rectangle = null;
            var classs:* = Class(Object($target).constructor);
            var obj:* = new classs as DisplayObject;
            obj.transform = $target.transform;
            obj.filters = $target.filters;
            obj.cacheAsBitmap = $target.cacheAsBitmap;
            obj.opaqueBackground = $target.opaqueBackground;
			
            if ($target.scale9Grid)
            {
                rect = $target.scale9Grid;
                $target.scale9Grid.x = rect.x / 20;
                rect.y = rect.y / 20;
                rect.width = rect.width / 20;
                rect.height = rect.height / 20;
                obj.scale9Grid = rect;
            }
            return obj;
        }
		
	}

}