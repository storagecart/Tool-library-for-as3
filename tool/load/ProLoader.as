/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.load 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	/**
	* 预加载
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class ProLoader 
	{
		private var _url		:Array = [];
		private var _loadID		:uint = 0;
		private var _endID		:uint = 0;
		private var _loader		:Loader;
		
		public function ProLoader(...rest ) 
		{
			for (var i:uint = 0; i < rest.length; i++ )
			{
				var url:* = rest[i];
				
				if (url is String)
					_url.push(url);
				else 
					_url = _url.concat(url);	
			}
		}
		
		public function start($url:String = "" ):void
		{
			if (_loadID >= _url.length)
			{
				return;
			}
			
			if (!_loader)_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE			, completeHandler);
			_loader.load(new URLRequest(_url[_loadID++]));
		}
		
		public function pause():void
		{
			
		}
		
		public function resume($url:String = "" ):void
		{
			
		}
		
		public function close():void
		{
			
		}
		
		///////////////////////////////////////////////////////////////////////////////
		private function completeHandler(e:Event):void
		{			
			singleLoad();
		}
	}
	
}