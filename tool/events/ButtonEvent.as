package tool.events 
{
	
	public class ButtonEvent extends BasicEvent
	{
		static public const BUTTON_OVER:String = "buttonOver";
		static public const BUTTON_OUT:String = "buttonOut";
		static public const BUTTON_DOWN:String = "buttonDown";
		
		public function ButtonEvent($type:String, $para_array:Array = null,$bubbles:Boolean = false, $cancelable:Boolean = false ) 
		{
			super($type,$para_array ,$bubbles, $cancelable);
		}
		
	}

}