package tool.third.upfile
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.net.*;
	import flash.utils.*;
	public class UpFile extends MovieClip
	{
		public const SERVER_URL:String = "";

		
		public const IMG_URL:String="/upload/";
		
		private const MAX_SIZE_PHOTO_ALLOWED:Number=1024*60; // max size allowed for one image ( bytes )
		public var UPLOAD_URL:URLRequest;
		public var file:FileReference;
		public var photos_array:Array=new Array();
		private var timer:Timer;
		private var imgName:String;
		private var loader:Loader;
		
		public var upload:Upload;
		private var imgload:imgLoader;
		public function UpFile()
		{
			addEventListener(Event.ADDED_TO_STAGE,init);
		
		}
		
		private function init(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);

			browse_btn.addEventListener(MouseEvent.CLICK, browseWin);
			upload_btn.addEventListener(MouseEvent.CLICK, uploadImage);
			browse_btn.mouseChildren=upload_btn.mouseChildren=false;
			browse_btn.buttonMode=upload_btn.buttonMode=true;
		}
		
		//选择
		private function browseWin(evt:Event):void
		{
			file=new FileReference();
			file.addEventListener(Event.SELECT,selectHandler);
			file.browse([new FileFilter('Images(*.jpg,*.jpeg,*.gif,*.png)','*.jpg;*.jpeg;*.gif;*.png')]);
		}

		private function selectHandler(evt:Event):void
		{
			var file:FileReference=FileReference(evt.target);
			if(file.size>MAX_SIZE_PHOTO_ALLOWED)
			{
				displayError("图片太大!");
			}
			else
			{
				imgName=file.name;
				txt.text = file.name;
				photos_array.push(file);
			}
		}
		
		//上传
		private function uploadImage(evt:Event):void	
		{
			if(txt.text=="")
			{
				displayError("请选择图片!");
			}
			else
			{
				UPLOAD_URL=new URLRequest(SERVER_URL);
				upload=new Upload(this,file);
			}
		}
		
		//错误提示
		private function displayError(str:String):void
		{
			txt.text=str;
			removeError();
		}
		private function removeError():void
		{
			timer=new Timer(1500,1);
			timer.addEventListener(TimerEvent.TIMER,goTimer);
			timer.start();
		}
		
		private function goTimer(evt:TimerEvent):void
		{
			txt.text="";
		}
		
		//加载图片
		/*public function uploadCompleted():void
		{
			var path:String ="http://ask.yaolee.net.cn/in/"+upload.picName;
			imgload = new imgLoader(this,path);
		}*/
	} 
}