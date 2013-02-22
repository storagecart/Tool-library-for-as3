/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.display.shell 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/*
	* 控制显示对象的外壳
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class CoreShell extends EventDispatcher
	{
		public var target:DisplayObject;
		private var _listenerArray :Array = [];
		
		public function CoreShell($target:DisplayObject) 
		{
			target = $target;
			// 1 ----
			initFUN();
			
			// 2 ----
			target.addEventListener(Event.ADDED, addedHandler );

			// 3 ----
			if (target.stage) 
				addedToStageHandler();
			else
				target.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler );
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			target.addEventListener(type, listener, useCapture, priority, useWeakReference); 
			var listenerObject:Object 	= new Object();
			listenerObject.type 		= type;
			listenerObject.listener 	= listener;
			listenerObject.useCapture 	= useCapture;
			_listenerArray.push(listenerObject);
		}
		
		public function removeAllEventListener():void
		{
			for (var i:uint = 0; i < _listenerArray.length; i++ )
			{
				target.removeEventListener(_listenerArray[i].type, _listenerArray[i].listener, _listenerArray[i].useCapture);
			}
			
			_listenerArray = [];
		}
		
		public function initFUN():void
		{
			if(target is MovieClip)
				MovieClip(target).gotoAndStop(1);
			// 1 [触发步骤]
		}
		
		public function addedFUN():void
		{
			target.removeEventListener(Event.ADDED, addedHandler );
			// 2 [触发步骤]
		}
		
		public function addedStageFUN():void
		{
			target.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			// 3 [触发步骤]
		}
	
		public function destroy():void
		{
			target.removeEventListener (Event.ADDED_TO_STAGE	, addedToStageHandler );
			target.removeEventListener (Event.REMOVED_FROM_STAGE, removedHandler);
			target.removeEventListener (Event.ADDED				, addedHandler );
			removeAllEventListener();
		}
		
		//////////////////////////////////////////////------------------------------------------------------
		private function addedToStageHandler(e:Event = null ):void 
		{
			target.addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
			addedStageFUN();
		}
		
		private function removedHandler(e:Event):void 
		{
			target.removeEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
			destroy();
		}
		
		private function addedHandler(e:Event):void 
		{
			addedFUN();
		}
		
	}
	
}