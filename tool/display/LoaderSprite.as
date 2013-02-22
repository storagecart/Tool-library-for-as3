/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.display 
{
	import flash.display.*;
	import flash.events.*;
	
	import tool.events.LoadEvent;
	
	/**
	* LoaderSprite类,是用来处理Loader相关的Sprite
	* 
	* 导入类                            				 
	* --CODE: import tool.display.LoaderSprite;
	* 
	* 继承父类
	* --CODE: public class Loading extends LoaderSprite{}
	* 
	* 覆写父类的相关方法
	* 	//初始化
	    override protected function init():void
		{
			alpha=0;
		}
		
		//出现
		override protected function appear():void
		{
			addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		
		//加载过程中要处理的
		override protected function loading():void
		{
			num_txt.text=String(Math.floor(loadProgress*100)+"%");
		}
		
		//消失
		override protected function disAppear():void
		{
			MovieClip(target).play();
			if(this.parent!=null)
			parent.removeChild(this);
		}
	* 
	* 声明实例
	* --CODE: var loading=new Loading(this.loaderInfo);
	* 
	* 公共属性
	* --CODE: loading.bytesLoaded                    //媒体已加载的字节数。
	* --CODE: loading.bytesTotal                     //整个媒体文件中压缩的字节数。
	* --CODE: loading.loadProgress                   //加载进度的数字比。
	* --CODE: loading.target                  		 //与此对象关联的已加载对象。
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class LoaderSprite extends Sprite
	{
		private var _bytesLoaded:					uint = 0;            		//媒体已加载的字节数。
		private var _bytesTotal:					uint = 0;					//整个媒体文件中压缩的字节数。
		private var _loadProgress:					Number = 0;					//加载进度的数字比。(0-1)
		private var _target:						DisplayObject;				//与此对象关联的已加载对象。
		
		private var _appeared:                		Boolean = false;
		
		public function get bytesLoaded():uint
		{
			return _bytesLoaded;
		}
		
		public function get bytesTotal():uint
		{
			return _bytesTotal;
		}

		public function get loadProgress():Number
		{
			if (_bytesTotal == 0) return 0;
			return _bytesLoaded / _bytesTotal;
		}
		
		public function get target():DisplayObject
		{
			return _target;
		}
		
		//========================================================
		public function LoaderSprite($loaderInfo :LoaderInfo):void
		{
			if (stage) initFUN();
			else addEventListener(Event.ADDED_TO_STAGE, initFUN);
			configureListeners($loaderInfo);
		}
		
		protected function init():void { }
		
		protected function appear():void { }
		
		protected function error():void { }
		
		protected function loading():void { }
		
		protected function disAppear():void { }

		//----------------------------------------------------
		private function initFUN(e:Event = null ):void
		{
			init();
			addEventListener(LoadEvent.LOAD_BEGIN, loadBeginHandler );
			addEventListener(LoadEvent.LOAD_ERROR, loadErrorHandler);
			addEventListener(LoadEvent.LOAD_PROGRESS, loadProgressHandler);
			addEventListener(LoadEvent.LOAD_COMPLETE, loadCompleteHandler);
		}

		private function loadBeginHandler(e:LoadEvent):void
		{
			appear();
		}
		
		private function loadErrorHandler(e:LoadEvent):void
		{
			error();
			disAppear();
		}
		
		private function loadProgressHandler(e:LoadEvent):void
		{
			loading();
		}
		
		private function loadCompleteHandler(e:LoadEvent):void
		{
			disAppear();
		}
		
		private function configureListeners(dispatcher:LoaderInfo):void 
		{
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);	
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(Event.INIT, initHandler);
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
        }
		
		private function completeHandler(event:Event):void {
			dispatchEvent(new LoadEvent(LoadEvent.LOAD_COMPLETE));
        }

        private function initHandler(event:Event):void {
            dispatchEvent(new LoadEvent(LoadEvent.LOAD_INIT));
			_target = event.currentTarget.content;
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
           dispatchEvent(new LoadEvent(LoadEvent.LOAD_ERROR));
        }

        private function openHandler(event:Event = null ):void {
			_appeared = true;
            dispatchEvent(new LoadEvent(LoadEvent.LOAD_BEGIN));
        }

        private function progressHandler(event:ProgressEvent):void {
			if (!_appeared) openHandler();
			
            dispatchEvent(new LoadEvent(LoadEvent.LOAD_PROGRESS));
			_bytesLoaded = event.currentTarget.bytesLoaded;
			_bytesTotal = event.currentTarget.bytesTotal;
        }

	}
	
}