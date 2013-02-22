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
	* 在指定的延迟（以桢数为单位）后运行指定的函数。
	* 
	* 用法
	* --CODE: import tool.util.setFrameout;
	* --CODE: var id=setFrameout(this,this_fun,this.totalFrames,2,"go");
	* --CODE: function this_fun(a:Number,b:String){ trace(a,b);  }
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/

	//======================================================================================================
	/**
	* @param		$functionTarget		      		MovieClip		 				 * 参考所在的影片剪辑
	* @param		$function		       			Function	        			 * 要执行的函数的名称
	* @param		$delay		        			Number		     		     	 * 间隔（以毫秒为单位） 
	* @param		... rest		        		*		     		   			 * 传递给函数的可选参数列表
	* @return							     		int						  		 超时进程的唯一数字标识符。 
	*/  
	public function setFrameout($functionTarget:MovieClip, $function:Function, $delay:Number, ... rest ) :int
	{
		if ($delay > $functionTarget.totalFrames) return -1;
		
		$functionTarget.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		AbstractNumberClass.array.push(enterFrameHandler);
		return ++AbstractNumberClass.number;
		
		function enterFrameHandler(e:Event):void
		{
			if ($functionTarget.currentFrame == $delay)
			{
				if (rest.length == 0)
				$function();
				else
				$function.apply(null, rest);
				
				$functionTarget.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
	}
	
}