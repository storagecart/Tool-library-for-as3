/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.display 
{
	import flash.display.*;
	import flash.events.*;
	
	import tool.timeline.prevPlay;
	
	/**
	* 快速MovieClip
	* 注：该类中的部分属性要用到cs4以上版本
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0 , Flash 10.0
	* @tiptext
	*
	*/
	
	public class QMC 
	{
		private var _target:			*;
		private var _angleSpeed:		Number;
		private var _listenerArray		:Array;
		
		public function set onClick($onClick:Function):void
		{
			_target.addEventListener(MouseEvent.CLICK, $onClick);
			addListener(MouseEvent.CLICK, $onClick);
		}
		
		public function set onEnterFrame($onEnterFrame:Function):void
		{
			_target.addEventListener(Event.ENTER_FRAME , $onEnterFrame);
			addListener(Event.ENTER_FRAME, $onEnterFrame);
		}
		
		public function set removeEnterFrame($onEnterFrame:Function):void
		{
			_target.removeEventListener(Event.ENTER_FRAME , $onEnterFrame);
		}

		public function set onMouseOver($onMouseOver:Function):void
		{
			_target.addEventListener(MouseEvent.MOUSE_OVER , $onMouseOver);
			addListener(MouseEvent.MOUSE_OVER, $onMouseOver);
		}

		public function set onMouseOut($onMouseOut:Function):void
		{
			_target.addEventListener(MouseEvent.MOUSE_OUT , $onMouseOut);
			addListener(MouseEvent.MOUSE_OUT, $onMouseOut);
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/**
		* 构造函数
		* @param		$target		      	  	MovieClip		 * 对象
		*/  
		public function QMC($target:* ):void
		{
			_target = $target;
			_target.addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
		}
		
		private function removedHandler(e:DataEvent):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
			removeAllEventListener();
		}
		
		public function removeAllEventListener():void
		{
			for (var i:uint = 0; i < _listenerArray.length; i++ )
			{
				_target.removeEventListener(_listenerArray[i].type, _listenerArray[i].listener, _listenerArray[i].useCapture);
			}
			
			_listenerArray = [];
		}
		
		private function addListener($type, $listener, $useCapture:Boolean = false ):void
		{
			var listenerObject:Object 	= new Object();
			listenerObject.type 		= $type;
			listenerObject.listener 	= $listener;
			listenerObject.useCapture 	= $useCapture;
			if (!_listenerArray)_listenerArray = [];
			_listenerArray.push(listenerObject);
		}
		
		public function rotate($angleSpeed:Number = 1):void
		{
			_angleSpeed = $angleSpeed;
			_target.addEventListener(Event.ENTER_FRAME, rotateEnterFrameHandler);
		}
		
		public function stopRotate():void
		{
			_target.removeEventListener(Event.ENTER_FRAME, rotateEnterFrameHandler);
		}
		
		public function next($speed:Number = 1):void
		{
			prevPlay(_target, _target.currentFrame, _target.totalFrames, $speed);
		}
		
		public function prev($speed:Number = 1):void
		{
			prevPlay(_target, _target.currentFrame, 1, $speed);
		}
			
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function rotateEnterFrameHandler(e:Event):void
		{
			_target.rotation += _angleSpeed;
		}
		
	}
	
}