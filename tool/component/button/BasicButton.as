/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.component.button 
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import tool.events.ButtonEvent;
	import tool.events.EventManager;
	
	/**
	* 基本的按钮MODEL(鼠标滑过正向播放，鼠标滑出反向播放)。
	* 注意:子类可以覆写mouseOutHandler，mouseOverHandler方法 , mouseDownHandler则为公共方法。
	* 继承BasicButton                                    --CODE:public class subBasicButton extends BasicButton{}
	* 要跳转到的链接,不传入就不会link                    --CODE:var btn=new subBasicButton;btn.url="http://www.a-jie.cn";
	* 新窗口的打开方式                                   --CODE:var btn.way="_blank";
	* BasicButton实例的编号                              --CODE:sub.i=1;
	* 覆写mouseDownHandler方法                           --CODE:override public function mouseDownHandler(e:MouseEvent = null):void{
																super.mouseDownHandler(e);
												                //do somethings... }
	* 覆写init方法                                       --CODE:override public function init(e:Event = null):void{
																super.init(e);
												                //do somethings... }
	*
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class BasicButton extends MovieClip
	{
		
		public var url:String = "";                  //超链接地址,不传入就不会link
		public var way:String = "_blank";            //窗口打开方式
		public var i:Number = 0;                     //可传入备用值
		public var ID:String;
		
		public function BasicButton ():void
		{
			if (stage) init();
			else addEventListener(Event.ADDED, init);
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
			EventManager.getInstance().dispatchEvent(new ButtonEvent(ButtonEvent.BUTTON_DOWN, [this]));
			if (url == "") return;
			var request = new URLRequest(url);
			navigateToURL(request, way);	
		}
			
		protected function mouseOverHandler(e:MouseEvent = null):void 
		{
			if (e != null)
			{
				e.currentTarget.removeEventListener(Event.ENTER_FRAME,prevFrameHandler);
				e.currentTarget.addEventListener(Event.ENTER_FRAME,nextFrameHandler);
			}else
			{
				this.removeEventListener(Event.ENTER_FRAME, prevFrameHandler);
				this.addEventListener(Event.ENTER_FRAME, nextFrameHandler);
			}
		}
		
		protected function mouseOutHandler(e:MouseEvent = null):void 
		{
			if (e != null)
			{
				e.currentTarget.removeEventListener(Event.ENTER_FRAME, nextFrameHandler);
				e.currentTarget.addEventListener(Event.ENTER_FRAME, prevFrameHandler);
			}else
			{
				this.removeEventListener(Event.ENTER_FRAME, nextFrameHandler);
				this.addEventListener(Event.ENTER_FRAME, prevFrameHandler);
			}
		}
		
		private function nextFrameHandler(e:Event):void 
		{
			if (e.currentTarget.currentFrame!=e.currentTarget.totalFrames) 
			e.currentTarget.nextFrame();	
			else
			e.currentTarget.removeEventListener(Event.ENTER_FRAME,nextFrameHandler);
		}
		
		private function prevFrameHandler(e:Event):void 
		{
			if (e.currentTarget.currentFrame != 1)
			e.currentTarget.prevFrame();	
			else
			e.currentTarget.removeEventListener(Event.ENTER_FRAME,prevFrameHandler);
		}
		
	}
	
}