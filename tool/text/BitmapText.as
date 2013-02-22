/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.text 
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	/**
	*
	* 创建bitmap的文本副本
	* 
	* --CODE: import tool.text.BitmapText
	* --CODE: var bt=new BitmapText(name_txt);
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class BitmapText extends Bitmap 
	{
		private var _bmd:				BitmapData;
		private var _targetTxt:			TextField;
		private var _parent:			DisplayObjectContainer;
		
		public function BitmapText($txt:TextField):void 
		{
			_targetTxt 		= $txt;
			var width 		= $txt.textWidth + 1;
			var height 		= $txt.textHeight + 1;
				
			_bmd 			= new BitmapData(width, height);
			_bmd.draw($txt);
			super(_bmd, "auto", true);
			x = _targetTxt.x;
			y = _targetTxt.y;
			
			addEventListener(Event.ADDED  , addedHandler);
			addEventListener(Event.REMOVED, removeedHandler);
		}
		
		private function addedHandler(e:Event):void
		{
			_targetTxt.visible = false;
		}
		
		private function removeedHandler(e:Event):void
		{
			_targetTxt.visible = true;
		}
		
	}
	
}