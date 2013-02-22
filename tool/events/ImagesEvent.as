/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.events 
{
	/**
	* JPGLoader相关的事件
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class ImagesEvent  extends BasicEvent
	{
		static public const IMAGES_SELECT:String = 'imagesSelect';
		static public const IMAGES_LOADED:String = 'imagesLoaded';
		static public const IMAGES_BEGIN_SAVE:String = 'imagesBeginSave';
		static public const IMAGES_SAVED:String = 'imagesSaved';
		
		public function ImagesEvent($type:String, $para_array:Array = null,$bubbles:Boolean = false, $cancelable:Boolean = false ) 
		{
			super($type,$para_array ,$bubbles, $cancelable);
		}
		
	}

}