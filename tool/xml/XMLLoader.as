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
  
package tool.xml 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import tool.events.LoadEvent;
	/**
	* --CODE: xml
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class XMLLoader extends EventDispatcher
	{
		private var xml:XML;
		
		public function load($url:String)
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest($url));
			urlLoader.addEventListener(Event.COMPLETE, completeHandler);
		}
		
		private function completeHandler(e:Event):void 
		{
			xml = XML(URLLoader(e.currentTarget).data);
			dispatchEvent(new LoadEvent(LoadEvent.LOAD_COMPLETE, [xml]));
		}
	}

}