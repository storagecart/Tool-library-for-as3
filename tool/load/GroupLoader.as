/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.load 
{
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	
	import tool.events.LoadEvent;
	
	/**
	* 列队加载一组元素
	* 
	* 导入类                            				 
	* --CODE: import tool.load.GroupLoader;
	* --CODE: import tool.events.LoadEvent;;
	* 
	* 声明实例并添加侦听
	* --CODE: var gl:GroupLoader=new GroupLoader();
	* --CODE: gl.addEventListener(LoadEvent.GROUP_LOAD_COMPLETE,groupLoadCompleteHandler);
	* --CODE: gl.addEventListener(LoadEvent.GROUP_LOAD_PROGRESS,groupLoadProgressHandl);
	* 
	* 设置文件大小（非必填，如果不设置那么就按照平均比例加载）
	* --CODE: gl.fileSize=[148,49,64,66,106,298];
	* 
	* 开始加载操作（两种方式传入参数）
	* 传入数组：
	* --CODE: gl.load(["img/01.jpg","img/02.jpg","img/03.jpg","img/04.jpg","img/05.jpg","swf/swf01.swf"]);
	* 传入数字符串：
	* --CODE: gl.load("img/01.jpg","img/02.jpg","img/03.jpg","img/04.jpg","img/05.jpg","swf/swf01.swf");
	* 
	* 
	* 关闭并卸载
	* --CODE: gl.close();
	* --CODE: gl.unload();
	* 
	* ::属性::
	* 
	* 加载对象的数组（只读）
	* --CODE: gl.targetList;
	* 
	* loader对象的数组（只读）
	* --CODE: gl.loaderList;
	* 
	* 正在加载的对象的id（只读）
	* --CODE: gl.loadID;
	* 
	* 加载的进度（只读）
	* --CODE: gl.loadScale;
	* 
	* 文件的尺寸（只写）
	* --CODE: gl.fileSize;
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class GroupLoader extends EventDispatcher
	{
		private var _loaderList	:Array = [];
		private var _targetList	:Array = [];
		private var _loadScale	:Number = 0;
		
		private var _fileSize	:Array = [];
		private var _totalSize	:Number = 0;
		private var _oldScale	:Number = 0;
		
		private var _url		:Array = [];
		private var _num		:int = 0;
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////	
		public function get loaderList():Array
		{
			return _loaderList;
		}
		
		public function get targetList():Array
		{
			return _targetList;
		}
		
		public function get loadID():Number
		{
			return _num;
		}
		
		public function get loadScale():Number
		{
			return _loadScale;
		}
		
		public function set fileSize($size:Array):void 
		{
			_fileSize = $size;
			
			_totalSize = 0;
			for (var i:int = 0; i < _fileSize.length; i++ )
			{
				_totalSize += _fileSize[i];
			}
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		/**
		* @param		...rest		      	  	String/Array		 			* 要加载的url
		*/  
		public function load(...rest):void
		{
			for (var i:uint = 0; i < rest.length; i++ )
			{
				var url:* = rest[i];
				
				if (url is String)
					_url.push(url);
				else 
					_url = _url.concat(url);	
			}
			
			singleLoad();
		}
		
		public function close():void
		{
			for (var i:uint = 0; i < _loaderList.length; i++ )
			{
				Loader(_loaderList[i]).close();
				Loader(_loaderList[i]).contentLoaderInfo.removeEventListener(Event.COMPLETE				, completeHandler);
				Loader(_loaderList[i]).contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR		, ioErrorHandler);
				Loader(_loaderList[i]).contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS		, progressHandler);
			}
		}
		
		public function unload():void
		{
			for (var i:uint = 0; i < _loaderList.length; i++ )
			{
				Loader(_loaderList[i]).unload();
			}
		}
		
		///////////////////////////////////
		// private methods
		///////////////////////////////////
		private function singleLoad():void
		{
			if (_num >= _url.length)
			{
				_loadScale = 1;
				dispatchEvent(new LoadEvent(LoadEvent.GROUP_LOAD_COMPLETE) );
				return;
			}
			
			var url:String = String(_url[_num]);
			if (url.indexOf(".swf") > -1 || url.indexOf(".jpg") > -1 || url.indexOf(".png") > -1 || url.indexOf(".gif") > -1)
			{	
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE			, completeHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR		, ioErrorHandler);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS	, progressHandler);
				loader.load(new URLRequest(url));
				_loaderList.push(loader);
			}else
			{
				var urlloader:URLLoader = new URLLoader();
				urlloader.addEventListener(Event.COMPLETE				, completeHandler);
				urlloader.addEventListener(IOErrorEvent.IO_ERROR		, ioErrorHandler);
				urlloader.addEventListener(ProgressEvent.PROGRESS		, progressHandler);
				urlloader.load(new URLRequest(url));
				_loaderList.push(urlloader);
			}
			
			_num++;
		}
		
		private function completeHandler(e:Event):void
		{			
			scaleFUN(1);
			if (_totalSize == 0)
				_oldScale += 1 / _url.length;
			else
				_oldScale += (_fileSize[_num - 1] / _totalSize);
			
			if(e.currentTarget is URLLoader)
				_targetList.push(URLLoader(_loaderList[_num - 1]).data);
			else
				_targetList.push(Loader(_loaderList[_num - 1]).content);
				
			singleLoad();
			dispatchEvent(new LoadEvent(LoadEvent.LOAD_COMPLETE) );
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void
		{	
			resetSize(0);
			_targetList.push(null);
			singleLoad();
			dispatchEvent(new LoadEvent(LoadEvent.LOAD_ERROR) );
		}
		
		private function progressHandler(e:ProgressEvent):void
		{
			//resetSize(e.bytesTotal / 1024 );
			scaleFUN(e.bytesLoaded / e.bytesTotal);
			dispatchEvent(new LoadEvent(LoadEvent.GROUP_LOAD_PROGRESS) );
		}
		
		//修正文件尺寸，暂时不添加这个功能-------------------------------
		private function resetSize($size:Number):void
		{
			if (_fileSize.length > _num)
			{
				if (_fileSize[_num - 1] != $size) 
				{
					_fileSize[_num - 1] = $size;
					fileSize = _fileSize.concat([]);
					
					_oldScale = 0;
					for (var i:uint = 0; i < _num; i++ )
					{
						_oldScale += (_fileSize[i] / _totalSize);
					}
				}
			}
		}
		
		private function scaleFUN($scale:Number ):void
		{
			if (_totalSize == 0)
				_loadScale = _oldScale + ($scale) / _url.length;
			else
				_loadScale = _oldScale + ($scale) * (_fileSize[_num - 1] / _totalSize);
				
		}
		
	}
	
}