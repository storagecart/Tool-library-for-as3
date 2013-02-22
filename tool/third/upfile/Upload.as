package tool.third.upfile
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.*;
	
	public class Upload extends MovieClip
	{
		private var _main:MovieClip;
		
		public var file:FileReference;
		public var picName="";
		
		public function Upload(fla:MovieClip,f:FileReference) 
		{
			_main=fla;
			file=f;
			addListeners(file);
			file.upload(_main.UPLOAD_URL);
		}
		
		private function addListeners(dispatcher:IEventDispatcher):void 
		{
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(Event.CANCEL, cancelHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			dispatcher.addEventListener(Event.COMPLETE,completeHandler);
			dispatcher.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,uploadCompleteDataHandler);
		}
		
		private function openHandler(event:Event):void {
			trace("OPEN HANDLER");
		}
			
		private function cancelHandler(event:Event):void {
			trace("CANCEL HANDLER");
		}
		
		private function progressHandler(event:ProgressEvent):void {
			_main.txt.text = "上传中... "
		}
		
		private function completeHandler(event:Event):void {
			trace("complete");
		}
		
		private function uploadCompleteDataHandler(event:Event):void 
		{
			_main.txt.text = "上传成功!!!";
			picName = event.data;
			file.removeEventListener(Event.OPEN,openHandler);
			file.removeEventListener(ProgressEvent.PROGRESS,progressHandler);
			file.removeEventListener(Event.COMPLETE,completeHandler);
			file.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA,uploadCompleteDataHandler);
			//_main.uploadCompleted();
		}
		
	}
}