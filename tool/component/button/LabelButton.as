/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.component.button 
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	/**
	* LabelButton(加标签的按钮类型)
	* 
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class LabelButton extends MovieClip
	{
		private var _over:String, _out:String, _down:String;
		
		public function LabelButton ($over:String = null, $out:String = null, $down:String = null ):void
		{
			_over 	= $over;
			_out 	= $out;
			_down	= $down;
			
			if (stage) init();
			else addEventListener(Event.ADDED, init);
		}
		
		public function setStatus($over:String = null , $out:String = null , $down:String = null ):void
		{
			_over 	= $over;
			_out 	= $out;
			_down	= $down;
		}
		
		/**
		* LabelButton实例初始化的状态
		* 子类调用请先覆写                 --CODE:override public function init(e:Event = null):void{
												  super.init(e);
												  //do somethings... }
		*
		* @param		e		        Event		         * 事件实例(可不传入)
		*/
		protected function init(e:Event = null) :void 
		{
			removeEventListener(Event.ADDED, init);
			
			stop();
			buttonMode=true;
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		/**
		* mouseDown要实现的功能
		* 子类调用请先覆写                 --CODE:override public function mouseDownHandler(e:MouseEvent = null):void{
												  super.mouseDownHandler(e);
												  //do somethings... }
		*
		* @param		e		        MouseEvent		        * 事件实例(可不传入)
		*/
		public function mouseDownHandler(e:MouseEvent = null) :void 
		{
			if(_down)
				gotoAndStop(_down);
		}
			
		protected function mouseOverHandler(e:MouseEvent = null):void 
		{
			if(_over)
				gotoAndPlay(_over);
		}
		
		protected function mouseOutHandler(e:MouseEvent = null):void 
		{
			if(_out)
				gotoAndPlay(_out);
		}
		
	}
	
}