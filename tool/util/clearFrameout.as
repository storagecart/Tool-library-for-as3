/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.util 
{
	import flash.display.*;
	import flash.events.*;
	import tool.util.frameout.AbstractNumberClass;
	
	/**
	* 取消指定的 setFrameout() 调用。
	* 
	* 用法
	* --CODE: import tool.util.setFrameout;
	* --CODE: clearFrameout(id,this);
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	//======================================================================================================
	/**
	* @param		$id		      				int		 					 * 超时进程的唯一数字标识符。 
	* @param		$functionTarget		       	MovieClip	        		 * 参考所在的影片剪辑
	* 
	*/
	
	public function clearFrameout($id:int, $functionTarget:MovieClip ):void 
	{
		if ($id == -1) return;
		$functionTarget.removeEventListener(Event.ENTER_FRAME, AbstractNumberClass.array[$id] );
	}
	
}