/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.display.website
{
	import flash.display.*;
	import flash.events.*;
	
	/*
	* movieClip基类（供父类继承）
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class SubMovieClip extends MovieClip
	{
		private var _listenerArray :Array = [];
		
		public function SubMovieClip() 
		{
			// 1 ----
			initFUN();
			
			// 2 ----
			addEventListener(Event.ADDED, addedHandler );
			
			// 3 ----
			if (stage) 
				addedToStageHandler();
			else
				addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler );
		}
		
		private function addedToStageHandler(e:Event = null ):void 
		{
			addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
			addedStageFUN();
		}
		
		private function addedHandler(e:Event = null):void
		{
			addedFUN();
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////
		protected function initFUN():void
		{
			// 1 [触发步骤]
		}
		
		protected function addedFUN():void
		{
			removeEventListener(Event.ADDED, addedHandler );
			// 2 [触发步骤]
		}
		
		protected function addedStageFUN():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			// 3 [触发步骤]
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		public function destroy($removeEvent:Boolean = true ):void
		{
			if ($removeEvent)
				removeAllEventListener();
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference); 
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
				this.removeEventListener(_listenerArray[i].type, _listenerArray[i].listener, _listenerArray[i].useCapture);
			}
			
			_listenerArray = [];
		}
		
		override public function removeChild($target:DisplayObject ):DisplayObject
		{
			var value:DisplayObject = null;
			if($target)
			{
				if (contains($target))
					value = super.removeChild($target);
			}
			
			return value;
		}
		
		/////////////////////////////////////////////////////////////////
		private function removedHandler(e:Event):void
		{
			destroy();
			removeEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
		}
		
	}
	
}