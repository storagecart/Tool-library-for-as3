/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.stage 
{
	import flash.display.*;
	/**
	* StageInit用于初始化场景
	* 
	* 导入类                            				
	* --CODE: import tool.stage.StageInit;
	* --CODE: StageInit.init(this);     
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*/
	
	public class StageInit 
	{
		
		public static function init($container:DisplayObjectContainer, $stageAlign:String = "TL", $scaleMode:String = "noScale" , $dcm:Boolean = false  ):void
		{
			if($container.stage)
			{
				$container.stage.showDefaultContextMenu	= $dcm;
				$container.stage.align 					= $stageAlign;
				$container.stage.scaleMode 				= $scaleMode;
			}
		}
		
	}
	
}