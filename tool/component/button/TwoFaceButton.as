/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.component.button 
{
	import flash.display.*;
	import flash.events.*;
	
	/**
	* 两帧型按钮(按钮有两个状态)
	* 注意:子类可以覆写init， mouseDownHandler方法。
	* 
	* 导入类                            				 
	* --CODE: import tool.component.button.TwoFaceButton;
	* 继承父类
	* --CODE: public class SubTwoFaceButton extends TwoFaceButton{}
	* 重写mouseDownHandler方法
	* --CODE: override public function mouseDownHandler(e:MouseEvent = null) :void {
	*         super.mouseDownHandler(e);
	*         ////do somethings...}
	* 或者直接添加侦听
	* addEventListener(MouseEvent.MOUSE_DOWN, otherMouseDownHandler);
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class TwoFaceButton extends MovieClip
	{
		private var _value:String = "1";
		
		public function get value():String
		{
			_value = currentFrame == 1? "1":"2";
			return _value;
		}
		
		public function TwoFaceButton() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		* BasicButton实例初始化的状态
		* 子类调用请先覆写                 --CODE:override public function init(e:Event = null):void{
												  super.init(e);
												  //do somethings... }
		*
		* @param		e		        Event		         * 事件实例(可不传入)
		*/
		protected function init(e:Event = null) :void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stop();
			buttonMode=true;
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 9999, true);
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
			var n = currentFrame + 1 > totalFrames? 1: currentFrame + 1;
			gotoAndStop(n);
		}
	}
	
}