/*

              .======.
              | INRI |
              |      |
              |      |
     .========'      '========.
     |   _      xxxx      _   |
     |  /_;-.__ / _\  _.-;_\  |
     |     `-._`'`_/'`.-'     |
     '========.`\   /`========'
              | |  / |
              |/-.(  |
              |\_._\ |
              | \ \`;|
              |  > |/|
              | / // |
              | |//  |
              | \(\  |
              |  ``  |
              |      |
              |      |
              |      |
              |      |
  \\    _  _\\| \//  |//_   _ \// _
 ^ `^`^ ^`` `^ ^` ``^^`  `^^` `^ `^
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.events 
{
	import flash.events.*;
	
	/**
	* 单例--事件管理器
	* 自己发送自己接收（缺点：不利于事件管理）
	* 
	* 导入类                            				 
	* --CODE:import tool.events.EventManager;
	* 
	* ------------发送事件------------
	* --CODE: EventManager.getInstance().dispatchEvent(new Event("gameOver"));	
	* 
	* 中止发送某一事件
	* --CODE: EventManager.getInstance().stopDispatchByType("gameOver");
	* 移除[中止发送某一事件]
	* --CODE: EventManager.getInstance().removeStopDispatchByType("gameOver");	
	* 
	* 中止发送所有事件
	* --CODE: EventManager.getInstance().stopAllDispatch();
	* 移除[中止发送所有事件]
	* --CODE: EventManager.getInstance().removeStopAllDispatch();	
	* 
	* ------------注册事件侦听------------
	* 普通注册事件侦听
	* --CODE: EventManager.getInstance().addEventListener("gameOver" ,gameOverHandler);
	* 
	* 特殊注册事件侦听（可以传入ID），第三个参数是注册的ID（可以是mc01 /"number01"/12等）;
	* --CODE: EventManager.getInstance().addEventListeners("gameOver" ,gameOverHandler,this);
	* 
	* 移除事件侦听
	* --CODE: EventManager.getInstance().removeEventListener("gameOver" ,gameOverHandler);
	* 
	* 移除某类特定事件的侦听[以事件类型为标准]
	* --CODE: EventManager.getInstance().removeListenerByType("gameOver");
	* 
	* 移除某类特定事件的侦听[以ID(id可以是任何类型)为标准]
	* --CODE: EventManager.getInstance().removeListenerByID(this);
	* 
	* 移除所有事件的侦听
	* --CODE: EventManager.getInstance().removeAllEventListener();
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class EventManager extends EventDispatcher
	{
		///////////////////////////////////
		// static public property
		///////////////////////////////////
		public static var LOG:Boolean = false;
		
		///////////////////////////////////
		// static private property
		///////////////////////////////////
		private static var _instance	:EventManager;
		
		///////////////////////////////////
		// private property
		///////////////////////////////////
		private var _dispatchEventArray	:Array = [];
		private var _addedEventArray	:Array = [];
		private var _stopedDispatch		:Boolean = false;
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		public function EventManager($singleton:SingletonClass) 
		{}
		
		public static function getInstance():EventManager
		{
			if (_instance == null)
				_instance = new EventManager(new SingletonClass());
				
			return _instance as EventManager;	
		}
		
		override public function addEventListener ($type:String, $listener:Function, $useCapture:Boolean = false , $priority:int = 0, $useWeakReference:Boolean = false) : void
		{
			super.addEventListener($type, $listener, false , $priority, $useWeakReference);
				
			var eventObject:Object 			= new EventObject();
			eventObject.id					= null;
			eventObject.type 				= $type;
			eventObject.listener 			= $listener;
			eventObject.priority 			= $priority;
			eventObject.useWeakReference 	= $useWeakReference;
			_addedEventArray.push(eventObject);
			
			if (EventManager.LOG) trace("当前注册了：[" + $type + "]类型的侦听。");
		}
		
		public function addEventListeners ($type:String, $listener:Function, $id:* = null , $priority:int = 0, $useWeakReference:Boolean = false) : void
		{
			super.addEventListener($type, $listener, false , $priority, $useWeakReference);
				
			var eventObject:Object 			= new EventObject();
			eventObject.id					= $id;
			eventObject.type 				= $type;
			eventObject.listener 			= $listener;
			eventObject.priority 			= $priority;
			eventObject.useWeakReference 	= $useWeakReference;
			_addedEventArray.push(eventObject);
			
			if (EventManager.LOG) trace("当前注册了：[" + $type + "]类型的侦听,注册ID为：[" + $id + "]。");
		}
		
		override public function removeEventListener ($type:String, $listener:Function , $useCapture:Boolean = false ) : void
		{
			var proxyArray:Array = [];
			for (var i:uint = 0; i < _addedEventArray.length; i++ )
			{
				var eventObject:EventObject = _addedEventArray[i] as EventObject;
				if (eventObject.type == $type && eventObject.listener == $listener )
					super.removeEventListener($type, $listener);
				else
					proxyArray.push(eventObject);
			}
			
			_addedEventArray = proxyArray;
			
			if (EventManager.LOG) trace("移除了：[" + $type + "]类型的侦听");
		}
		
		public function removeListenerByType ($type:String ) : void
		{
			var proxyArray:Array = [];
			for (var i:uint = 0; i < _addedEventArray.length; i++ )
			{
				var eventObject:EventObject = _addedEventArray[i] as EventObject;
				if (eventObject.type == $type )
					super.removeEventListener($type, eventObject.listener );
				else
					proxyArray.push(eventObject);
			}
			
			_addedEventArray = proxyArray;
			
			if (EventManager.LOG) trace("移除了：[" + $type + "]类型的所有侦听事件。");
		}
		
		public function removeListenerByID ($id:* ) : void
		{
			var proxyArray:Array = [];
			for (var i:uint = 0; i < _addedEventArray.length; i++ )
			{
				var eventObject:EventObject = _addedEventArray[i] as EventObject;
				if (eventObject.id == $id )
					super.removeEventListener(eventObject.type, eventObject.listener );
				else
					proxyArray.push(eventObject);
			}
			
			_addedEventArray = proxyArray;
			
			if (EventManager.LOG) trace("移除了ID为：[" + $id + "]的所有侦听事件。");
		}
		
		public function removeAllEventListener () : void
		{
			for (var i:uint = 0; i < _addedEventArray.length; i++ )
			{
				var eventObject:EventObject = _addedEventArray[i] as EventObject;
				super.removeEventListener(eventObject.type, eventObject.listener );
			}
			
			_addedEventArray = [];
			
			if (EventManager.LOG) trace("移除了所有侦听事件。");
		}
		
		//////////////////////////////////////////////////////////////////////
		override public function dispatchEvent ($event:Event) : Boolean
		{
			var result:Boolean = false;
			if (_stopedDispatch) return result;
			
			if (_dispatchEventArray.indexOf($event.type) > -1)
				result = false;
			else
				result = super.dispatchEvent($event);
				
			if (EventManager.LOG) trace("当前正在发送：[" + $event.type + "]类型的[" + $event + "]事件。");
			return result;	
		}
		
		public function stopDispatchByType ($eventType:String ):void
		{
			_dispatchEventArray.push($eventType);
			if (EventManager.LOG) trace("中止发送：[" + $eventType + "]类型的事件");
		}
		
		public function removeStopDispatchByType($eventType:String):void
		{
			var proxyArray:Array = [];
			for (var i:uint = 0; i < _dispatchEventArray.length; i++ )
			{
				var type:String = _addedEventArray[i] as String;
				if (type != $eventType ) proxyArray.push(type);	
			}
			
			_dispatchEventArray = proxyArray;
			
			if (EventManager.LOG) trace("移除，中止发送：[" + $eventType + "]类型的事件");
		}
		
		public function stopAllDispatch ():void
		{
			_stopedDispatch = true;
			if (EventManager.LOG) trace("中止发送所有事件");
		}
		
		public function removeStopAllDispatch ():void
		{
			_stopedDispatch = false;
			if (EventManager.LOG) trace("移除[中止发送所有事件]");
		}
		
	}
	
}

///////////////////////////////////
// class 
///////////////////////////////////
class EventObject 
{
	var id:*;
	var type:String;
	var listener:Function;
	var priority:int;
	var useWeakReference:Boolean;
}
class SingletonClass
{ }