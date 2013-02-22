/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.fp10.a3d.move 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.*;
	import tool.fp10.a3d.core.FP10Object3d;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	/**
	* 3d工具制造器(仅支持 flash player10.0 以上版本/请预先导入greensock类)
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 10.0/Flash 10.1
	* @tiptext
	*
	*/
	public class ToolMaker 
	{
		private static var funObject:Object;
		
		public static function flipBoard($target:FP10Object3d, $rotation:String = "rotationY" , $time:Number = .5, $ease:Function = null ):void
		{
			$target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			if (!funObject) funObject = new Object;
			funObject["flipBoard"] = mouseDownHandler;
			
			var face:Boolean = true;
			var easeFUN:Function = $ease == null?Quart.easeOut:$ease;
			
			function mouseDownHandler(e:MouseEvent):void
			{
				if (!face)
				{
					if($rotation=="rotationY")
						TweenMax.to($target, $time, { rotationY:360, ease: easeFUN } );
					if($rotation=="rotationX")
						TweenMax.to($target, $time, { rotationX:360, ease: easeFUN } );
					if($rotation=="rotationZ")
						TweenMax.to($target, $time, { rotationZ:360, ease: easeFUN } );
						
					OrderTool.order($target, $rotation, 270);
				}else
				{
					$target[$rotation] = 0;
					if($rotation=="rotationY")
						TweenMax.to($target, $time, { rotationY:180, ease: easeFUN } );
					if($rotation=="rotationX")
						TweenMax.to($target, $time, { rotationX:180, ease: easeFUN } );
					if($rotation=="rotationZ")
						TweenMax.to($target, $time, { rotationZ:180, ease: easeFUN } );
						
					OrderTool.order($target, $rotation, 90);
				}
				
				face = ! face;
			}
		}
		
		public static function flipAlphaBoard($target:FP10Object3d, $rotation:String = "rotationY" , $time:Number = .5, $ease:Function = null ):void
		{
			$target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			if (!funObject) funObject = new Object;
			funObject["flipAlphaBoard"] = mouseDownHandler;
			
			var face:Boolean = true;
			var easeFUN:Function = $ease == null?Quart.easeOut:$ease;
			
			function mouseDownHandler(e:MouseEvent):void
			{
				if (!face)
				{
					if($rotation=="rotationY")
						TweenMax.to($target, $time, { rotationY:360, ease: easeFUN } );
					if($rotation=="rotationX")
						TweenMax.to($target, $time, { rotationX:360, ease: easeFUN } );
					if($rotation=="rotationZ")
						TweenMax.to($target, $time, { rotationZ:360, ease: easeFUN } );
				}else
				{
					$target[$rotation] = 0;
					if($rotation=="rotationY")
						TweenMax.to($target, $time, { rotationY:180, ease: easeFUN } );
					if($rotation=="rotationX")
						TweenMax.to($target, $time, { rotationX:180, ease: easeFUN } );
					if($rotation=="rotationZ")
						TweenMax.to($target, $time, { rotationZ:180, ease: easeFUN } );
				}
				
				DisplayObjectContainer($target).getChildAt(0).alpha = 0;
				TweenMax.to(DisplayObjectContainer($target).getChildAt(0), $time, { alpha:1, ease:easeFUN } );
				DisplayObjectContainer($target).addChild(DisplayObjectContainer($target).getChildAt(0));
				
				face = ! face;
			}
		}
		
		public static function followBoard($target:FP10Object3d , $margin:Number = 6, $ease:int = 5 ):void
		{
			$target.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			if (!funObject) funObject = new Object;
			funObject["followBoard"] = enterFrameHandler;
			
			
			function enterFrameHandler(e:Event):void
			{
				if($target.parent)
				{
					$target.rotationY += (($target.parent.stage.stageWidth / 2 - $target.parent.mouseX) / $margin - $target.rotationY) / $ease;
					$target.rotationX += ( -($target.parent.stage.stageHeight / 2 - $target.parent.mouseY) / $margin - $target.rotationX) / $ease;
				}
			}
		}
		
		public static function stopFilpBoard($target:FP10Object3d):void
		{
			if (funObject)
				$target.removeEventListener(Event.ENTER_FRAME, funObject["flipBoard"]);
		}
		
		public static function stopFlipAlphaBoard($target:FP10Object3d):void
		{
			if (funObject)
				$target.removeEventListener(Event.ENTER_FRAME, funObject["flipAlphaBoard"]);
		}
		
		public static function stopFollowBoard($target:FP10Object3d):void
		{
			if (funObject)
				$target.removeEventListener(Event.ENTER_FRAME, funObject["followBoard"]);
		}
		
	}
	
}