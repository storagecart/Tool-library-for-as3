package tool.events 
{
	
	public class Mp3Event extends BasicEvent
	{
		static public const SOUND_COMPLETE:String = "mp3Complete";
		
		public function Mp3Event($type:String, $para_array:Array = null,$bubbles:Boolean = false, $cancelable:Boolean = false ) 
		{
			super($type,$para_array ,$bubbles, $cancelable);
		}
		
	}

}