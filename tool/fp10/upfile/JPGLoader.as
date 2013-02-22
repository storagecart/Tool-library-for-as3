/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.fp10.upfile 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import tool.display.DisplayHelper;
	
	import tool.events.EventManager;
	import tool.events.ImagesEvent;
	
	/**
	* 本地图片上传预览
	* --CODE: var jloader:JPGLoader=new JPGLoader();
	* --CODE: imageMC.addChild(jloader.target);
	* --CODE: jloader.LOG=true;
	* --CODE: jloader.addEventListener(ImagesEvent.IMAGES_LOADED,imagesLoadedHandler);
	* --CODE: jloader.browse(false);
	* --CODE: jloader.save('jpg',_ab,100);
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class JPGLoader extends EventDispatcher
	{
		static public const JPG:String = 'jpg';
		static public const PNG:String = 'png';
		
		private var _fileReference:FileReference;
		private var _loader:Loader;
		private var _byteArray:ByteArray;
		private var _bmd:BitmapData;
		private var _container:Sprite;
		private var _cropBD:BitmapData;
		private var _containerArr:Array;
		
		public var LOG:Boolean = false;
		public function get croped():BitmapData
		{
			return _cropBD;
		}
		public function get target():Sprite
		{
			return _container;
		}
		public function get targetArr():Array
		{
			return _containerArr;
		}
		
		public function JPGLoader() 
		{
			_container = new Sprite;
			_containerArr = [];
			_fileReference = new FileReference();
			_fileReference.addEventListener(Event.COMPLETE, frfCompleteHandler);
			_fileReference.addEventListener(Event.SELECT, frfSelectedFileHandle);
		}
		
		public function browse($clear:Boolean = true ):void
		{
			if ($clear)
			{
				DisplayHelper.clear(_container);
				_containerArr = [_container];
			}
			else
			{
				_container = new Sprite;
				_containerArr.push(_container);
			}
			var fileFilter:FileFilter = new FileFilter("Images: (*.jpeg, *.jpg, *.gif, *.png)", "*.jpeg; *.jpg; *.gif; *.png");
			_fileReference.browse([fileFilter]);
		}
		
		//剪裁
		public function crop($cropRect:Rectangle):BitmapData
		{
			_cropBD = new BitmapData($cropRect.width, $cropRect.height);
			var shiftOrigin:Matrix = new Matrix();
			shiftOrigin.translate(-$cropRect.x, -$cropRect.y);
			_cropBD.draw(_container, shiftOrigin);
			return _cropBD;
		}
		
		//保存
		public function save($type = 'jpg', $endStr:String = '_img', $quality:int = 85 ):void
		{
			if (_containerArr.length < 1) return;
			var encodedImage:ByteArray;
			var fileNameRegExp:RegExp = /^(?P<fileName>.*)\..*$/;
			var outputFileName:String = fileNameRegExp.exec(_fileReference.name).fileName + $endStr;	
			if (!_cropBD)
			{
				_cropBD = new BitmapData(_container.width, _container.height);
				_cropBD.draw(_container);
			}
			
			if ($type == JPGLoader.JPG)
			{
				var jpgEncoder:JPGEncoder = new JPGEncoder($quality);
				encodedImage = jpgEncoder.encode(_cropBD);
				outputFileName += ".jpg";
			}
			else
			{
				encodedImage = PNGEncoder.encode(_cropBD);
				outputFileName += ".png";
			}
			
			var saveFile:FileReference = new FileReference();
			saveFile.addEventListener(Event.OPEN		, saveBeginHandler);
			saveFile.addEventListener(Event.COMPLETE	, saveCompleteHandler);
			saveFile.save(encodedImage	, outputFileName);
		}
		
		//上传
		public function upload($url:String):void
		{
			_fileReference.upload(new URLRequest($url));
		}
		
		private function saveCompleteHandler(e:Event):void 
		{
			e.target.removeEventListener(Event.OPEN		, saveBeginHandler);
			e.target.removeEventListener(Event.COMPLETE , saveCompleteHandler);
			EventManager.getInstance().dispatchEvent(new ImagesEvent(ImagesEvent.IMAGES_SAVED));
			dispatchEvent(new ImagesEvent(ImagesEvent.IMAGES_SAVED));
		}
		
		private function saveBeginHandler(event:Event):void
		{
			EventManager.getInstance().dispatchEvent(new ImagesEvent(ImagesEvent.IMAGES_BEGIN_SAVE));
			dispatchEvent(new ImagesEvent(ImagesEvent.IMAGES_BEGIN_SAVE));
		}
		
		private function frfSelectedFileHandle(e:Event):void 
		{
			var fileReference:FileReference = e.currentTarget as FileReference;
			var result:int = 0;
			if (fileReference.type == ".jpg" || fileReference.type == ".png" || fileReference.type == ".gif")
			{
				if (LOG) trace('文件格式正确！');
				result = 1;
				fileReference.load();
			} else {
				if (LOG) trace('文件格式错误！');
				result = 0;
			}
			
			EventManager.getInstance().dispatchEvent(new ImagesEvent(ImagesEvent.IMAGES_SELECT, [result]));
			dispatchEvent(new ImagesEvent(ImagesEvent.IMAGES_SELECT, [result]));
		}
			
		private function frfCompleteHandler(e:Event):void
		{
			_byteArray = e.currentTarget.data as ByteArray;
			_loader=new Loader ;
			_loader.loadBytes(_byteArray);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
		}
		
		private function loaderCompleteHandler(e:Event):void 
		{
			_cropBD = null;
			var bitmap:Bitmap = Bitmap(_loader.content);
			_bmd = bitmap.bitmapData;
			_container.addChild(bitmap);
			if (LOG) trace("图片的宽和高: ", bitmap.width, bitmap.height);
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			EventManager.getInstance().dispatchEvent(new ImagesEvent(ImagesEvent.IMAGES_LOADED));
			dispatchEvent(new ImagesEvent(ImagesEvent.IMAGES_LOADED));
		}
	}

}