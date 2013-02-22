/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.timeline 
{
	import flash.display.MovieClip;
	import flash.events.*;
	
	/*
	* 反向/正向播放mc（加速）
	* 
	* --CODE:prevPlay(mc);
	* --CODE:prevPlay(mc,13,5);				//从第13帧播放到第5帧。
	* --CODE:prevPlay(mc,13,5,2,func); 		//以两倍帧速播放，结束执行一个函数。
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public function prevPlay ($mc:MovieClip, $fromFrame:uint = 0, $toFrame:uint = 1 , $speed:uint = 1, $fun:Function = null ):void
	{
		$mc.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		
		if ($fromFrame != 0)
		{
			$mc.gotoAndStop($fromFrame);
		}
		
		function enterFrameHandler(e:Event):void
		{
			if (Math.abs($mc.currentFrame - $toFrame) < $speed)
			{
				if ($fun != null)$fun();
				$mc.gotoAndStop($toFrame);
				$mc.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
				
			if ($fromFrame != 0)
			{
				if ($fromFrame < $toFrame)
				{
					$mc.gotoAndStop($mc.currentFrame + $speed);
				}
				else if ($fromFrame == $toFrame)
				{
					if ($fun != null)$fun();
					$mc.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				}
				else
				{
					$mc.gotoAndStop($mc.currentFrame - $speed);
				}
			}else
			{	
				$mc.gotoAndStop($mc.currentFrame - $speed );
			}
		}
		
	}
	
}