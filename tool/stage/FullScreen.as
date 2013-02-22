/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.stage 
{
	import flash.display.*;
	import flash.events.*;
	
	/**
	* FullScreen类用于控制全屏
	* 
	* 全屏函数。                      
	* --CODE:FullScreen.SetFullScreen(this);
	* 
	* 场景当前状态。                   
	* --CODE:FullScreen.state(this);
	* 
	* 全屏状态                         
	* --CODE:FullScreen.F;
	* 
	* 正常状态                         
	* --CODE:FullScreen.N;
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class FullScreen 
	{
		public static const F:String = "fullScreen";
		public static const N:String = "normal";
		private static var _state:String = "normal";
		
		public function FullScreen():void {
			throw(new Error("这是静态类无法被实例化!"));
		}
		
		public static function SetFullScreen($target:DisplayObject ):void
		{
			switch($target.stage.displayState) {
                case "normal":
					FullScreen._state = StageDisplayState.FULL_SCREEN;
                    $target.stage.displayState = StageDisplayState.FULL_SCREEN;    
                    break;
                case "fullScreen":
                default:
				    FullScreen._state = StageDisplayState.NORMAL;
                    $target.stage.displayState = StageDisplayState.NORMAL;    
                    break;
            }
			
		}
		
		public static function state($target):String
		{
			return $target.stage.displayState;
		}
		
	}
	
}