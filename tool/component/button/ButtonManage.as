/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.component.button 
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.Dictionary;
	
	/**
	*
	* 按钮统一管理器
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class ButtonManage 
	{
		static private var _dic:Dictionary;
		static private var _iddic:Dictionary;
		static private var __id:*;
		
		public function ButtonManage() 
		{
			throw(new Error("这是静态类无法被实例化!"));
		}
		
		/*
		* 设置按钮操作
		* 
		* @param		$type		        String		        	* btn对象
		* @param		$btn		        *		        		* url超链接地址
		* @param		$group		        String		        	* 打开方式
		*/
		static public function make($btn:*, $id:* = 0 ):void
		{
			if (!(($btn is Array) || ($btn is MovieClip)))
				throw(new Error("请传入正确类型!"));
				
			__id = $id;
			if (!_dic)_dic = new Dictionary;
			if (!_iddic)_iddic = new Dictionary;
			
			var array:Array;
			array = $btn is Array? $btn:[$btn];
			for (var i:uint = 0; i < array.length; i++ ) 
			{
				makeing(array[i]);
			}
		}
		
		static public function addListener($btn:*, $type:String, $listen:Function, $id:*  = 0 ):void
		{
			$btn.addEventListener($type, $listen);
			var obj = new Object;
			obj.target = $btn;
			obj.type = $type;
			obj.listen = $listen;
			if (!_dic[$btn])_dic[$btn] = [];
			_dic[$btn].push(obj);
			
			if (!_iddic[$id])_iddic[$id] = [];
			if (_iddic[$id].indexOf($btn) < 0) _iddic[$id].push($btn);
		}
		
		static public function removeListenerByListen($btn:*, $type:String, $listen:Function):void
		{
			$btn.removeEventListener($type, $listen);
		}
		
		
		static public function removeListener($btn:*):void
		{
			if (_dic[$btn])
			{
				for (var i = 0; i < _dic[$btn].length; i++ )
				{
					_dic[$btn][i].target.removeEventListener(_dic[$btn][i].type, _dic[$btn][i].listen);
				}
				delete _dic[$btn];
			}
		}
		
		static public function removeListenerByID($id:*= 0):void
		{
			for (var i = 0; i < _iddic[$id].length; i++ )
			{
				removeListener(_iddic[$id][i]);
			}
		}
		
		/*
		* btn的url超链接操作
		* 
		* @param		$btn		        MovieClip		        * btn对象
		* @param		$url		        String		        	* url超链接地址
		* @param		$way		        String		        	* 打开方式
		*/
		static public function link($btn:MovieClip, $url:String, $way:String = "_blank"):void
		{
			addListener($btn, MouseEvent.CLICK, clickHandler, __id);
			
			function clickHandler(e:MouseEvent):void
			{
				var request = new URLRequest($url);
				navigateToURL(request,$way);
			}
		}
		
		//-----------------------------------------------------------------
		static private function makeing($btn:*):void
		{
			makeBaseBtn($btn);
		}
		
		//基本按钮-初始化
		static private function makeBaseBtn($btn:MovieClip):void
		{
			$btn.stop();
			$btn.buttonMode = true;
			addListener($btn, MouseEvent.MOUSE_OUT, mouseOutHandler, __id);
			addListener($btn, MouseEvent.MOUSE_OVER, mouseOverHandler, __id);
		}
		
		//----------------------------------------------------------
		static private function mouseOverHandler(e:MouseEvent ):void 
		{
			removeListenerByListen(e.currentTarget, Event.ENTER_FRAME, prevFrameHandler);
			addListener(e.currentTarget, Event.ENTER_FRAME, nextFrameHandler, __id);
		}
		
		static private function mouseOutHandler(e:MouseEvent ):void 
		{
			removeListenerByListen(e.currentTarget, Event.ENTER_FRAME, nextFrameHandler);
			addListener(e.currentTarget, Event.ENTER_FRAME, prevFrameHandler, __id);
		}
		
		static private function nextFrameHandler(e:Event):void 
		{
			if (e.currentTarget.currentFrame!=e.currentTarget.totalFrames) 
			e.currentTarget.nextFrame();	
			else
			removeListenerByListen(e.currentTarget, Event.ENTER_FRAME, nextFrameHandler);
		}
		
		static private function prevFrameHandler(e:Event):void 
		{
			if (e.currentTarget.currentFrame != 1)
			e.currentTarget.prevFrame();	
			else
			removeListenerByListen(e.currentTarget, Event.ENTER_FRAME, prevFrameHandler);
		}
		
	}
	
}