/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.component.ui 
{
	import flash.display.Sprite;
	
	/**
	* 全屏遮罩，能遮挡全屏的按钮
	* 
	* 使用方法
	* --CODE: import tool.component.ui.BlackMask;
	* --CODE: var myBlackMask=new BlackMask(1024,768,0xffcccc,.2);
	* --CODE: addChild(myBlackMask);
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class BlackMask extends Sprite
	{
		
		public function BlackMask($w:Number, $h:Number, $color:uint = 0x000000, $alpha:Number = .5 ) 
		{
			graphics.beginFill($color, $alpha);
			graphics.drawRect(0, 0, $w, $h);
			graphics.endFill();
		}
		
	}
	
}