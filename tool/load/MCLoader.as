/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.load
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	
	import tool.events.LoadEvent;
	import tool.display.DisplayHelper;
	
	/**
	* 方便加载的loader组件(不仅适用于MC)
	* 
	* 导入类                            				 
	* --CODE: import tool.load.MCLoader;
	* 
	* 使用
	* --CODE: var myLoader=new MCLoader("image/01.jpg",mc2,13);
	* 
	* 获取库里的某个对象实例 
	* --CODE: var mc=myLoader.getLibraryObject("MySound");
	* 
	* 属性设置
	* --CODE: myLoader.setXY(20,20);
	* --CODE: myLoader.setScale(2,1);
	* --CODE: myLoader.setProperty("alpha",.3);
	* 
	* 关闭并卸载
	* --CODE: myLoader.close();
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class MCLoader extends EventDispatcher
	{
		private var _target				:DisplayObject;
		private var _container			:DisplayObjectContainer;
		private var _depth				:int;
		private var _url				:String;
		
		private var _loader				:Loader;
		private var _loaded				:Number;
		private var _loadtotal			:Number;
		
		private var _perObject			:Object;
		
		public var loaderUI				:MovieClip;					//配套的loaderUI
		public var add					:Boolean = true  ;          //是否直接添加
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////	
		public function get target():DisplayObject
		{
			return _target;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get loader():Loader
		{
			return _loader;
		}
		
		public function get loaded():Number
		{
			return _loaded;
		}
		
		public function get loadtotal():Number
		{
			return _loadtotal;
		}
		
		///////////////////////////////////
		// Constructor
		///////////////////////////////////	
		/**
		* @param		$url		      	  	String		 			* 要加载的url
		* @param		$container		      	DisplayObjectContainer	* 容器
		* @param		$depth		      	  	int		 				* 深度
		*/  
		public function MCLoader($url:String , $container:DisplayObjectContainer, $depth:int = -1 , $context:Boolean = false ) 
		{	
			_url 		= $url;
			_container 	= $container;
			_depth 		= $depth;
			
			_loaded		= 0;
			_loadtotal	= .001;
			_perObject  = new Object();
			
			_loader 	= new Loader;
			
			try {
				var lc:LoaderContext	= new LoaderContext()
				lc.applicationDomain 	= ApplicationDomain.currentDomain;
				//lc.securityDomain 		= SecurityDomain.currentDomain;
				if(!$context)
					_loader.load(new URLRequest(_url));	
				else
					_loader.load(new URLRequest(_url), lc);	
			}catch (e)	
			{
				_loader.load(new URLRequest(_url));	
			}
			
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, 	progressHandler);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, 			completeHandler);
			dispatchEvent(new LoadEvent(LoadEvent.LOAD_BEGIN));
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		public function close():void
		{
			try {
				_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, 	progressHandler);
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, 			completeHandler);
				_loader.close();
				_loader.unload();
			}catch (e:Error) {
				try {
					_loader.unload();
				}catch(e:Error){}
			}
		}
		
		public function setXY($x:Number = 0, $y:Number = 0):void
		{
			_loader.x = $x;
			_loader.y = $y;
		}
		
		public function setScale($scalex:Number = 1, $scaley:Number = 1):void
		{
			_perObject['scaleX'] = $scalex;
			_perObject['scaleY'] = $scaley;
		}
		
		public function setProperty($property:String, $value:*):void
		{
			_perObject[$property] = $value;
		}
		
		public function getLibraryObject($linkId:String):Object
		{
			var domain:ApplicationDomain = _loader.contentLoaderInfo.applicationDomain as ApplicationDomain;
            var BallClass:Class = domain.getDefinition($linkId) as Class;
			return new BallClass;
		}
		
		///////////////////////////////////
		// private methods
		///////////////////////////////////
		private function progressHandler(e:Event):void
		{
			_loaded 	= e.target.bytesLoaded;
			_loadtotal 	= e.target.bytesTotal;
			dispatchEvent(new LoadEvent(LoadEvent.LOAD_PROGRESS));
		}
		
		private function completeHandler(e:Event):void
		{
			_target = _loader.content;
			if(add) _container.addChild(_loader); 
			
			for (var obj in _perObject)
			{
				if (_perObject[obj])
				{
					_target[obj] = _perObject[obj];
				}
			}	
				
			if (_depth != -1)
				DisplayHelper.toLayer(_loader, _depth);	
				
			dispatchEvent(new LoadEvent(LoadEvent.LOAD_COMPLETE));
		}
		
	}
	
}