/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.util 
{
	import flash.display.*;
	import flash.events.*;
	
	/**
	* EnterFrame类用来实现as2的onEnterFrame效果。
	* 使用                              --CODE:var _enter=new EnterFrame;
                                               _enter.onEnterFrame=function(){trace("已经开始了!");};
											   _enter.removeEnterFrame();
	*
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class EnterFrame 
	{
		private var _sprite:Sprite;
		private var _function:Function = null;
		
		public function EnterFrame() {
			_sprite = new Sprite();
		}
		
		/**
		* onEnterFrame函数  
		*
		* @param		$function		      Function		    * 要执行的函数
		*/
		public function set onEnterFrame($function:Function):*
		{
			if (_sprite == null) { _sprite = new Sprite();};
			_function = $function;
			_sprite.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_sprite.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}
		
		/**
		* removeEnterFrame函数  
		*
		* @param		$function		      Function		    * 要删除的函数
		*/
		public function removeEnterFrame():*
		{
			if (_sprite == null) return;
			_sprite.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_sprite = null;
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			_function();
		}
		
	}
	
}