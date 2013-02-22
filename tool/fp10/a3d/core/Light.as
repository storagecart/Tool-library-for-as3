/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.fp10.a3d.core 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.*;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import tool.fp10.a3d.A3D;
	
	/**
	* 灯光(仅支持 flash player10.0 以上版本)
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 10.0/Flash 10.1
	* @tiptext
	*
	*/
	public class Light 
	{
		private static var _dic			:Dictionary;
			
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		public static function open($container:FP10Object3d, $brightness:Number = .45 ):void 
		{
			if (!_dic)_dic = new Dictionary;
			
			var timerHandler:Function = function (e:TimerEvent):void
			{
				line($container);
			}
			
			var timer:Timer = new Timer(1000 / A3D.brightFrame , 0);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.start();
			
			var brightObject:Object = new Object;
			brightObject.target = $container;
			brightObject.timer = timer;
			brightObject.timerHandler = timerHandler;
			brightObject.brightness = $brightness;
			_dic[$container] = brightObject;
		}
		
		public static function close($container:FP10Object3d = null ):void 
		{
			if (_dic)
			{
				if (_dic[$container])
				{
					_dic[$container].timer.removeEventListener(TimerEvent.TIMER, _dic[$container].timerHandler);
					_dic[$container].timer.stop();
					delete _dic[$container];
				}
			}
		}
		
		///////////////////////////////////
		// private methods
		///////////////////////////////////
		private static function line($container:FP10Object3d):void 
		{
			for (var i:uint = 0; i < $container.numChildren; i++) 
			{ 
				var target:Sprite = $container.getChildAt(i) as Sprite;
				var angle:Vector3D = new Vector3D();
				
				if (!target.transform.matrix3D) continue;
				
				if ($container.root)
					angle = target.transform.getRelativeMatrix3D($container.root).decompose("eulerAngles")[1];
				else
					angle = target.transform.getRelativeMatrix3D($container).decompose("eulerAngles")[1];
					
				var verVector:Vector3D = getVector(angle);
				var jAngle:Number = verVector.dotProduct(new Vector3D(0, 0, -1));
				setBright($container ,target, jAngle);
			} 
		}
		
		private static function getVector( $angle:Vector3D):Vector3D
		{
			var a1:Number = $angle.x;
			var a2:Number = $angle.y;
			var a3:Number = $angle.z;
			
			var Sa1:Number = Math.sin(a1);
			var Sa2:Number = Math.sin(a2);
			var Sa3:Number = Math.sin(a3);
			var Ca1:Number = Math.cos(a1);
			var Ca2:Number = Math.cos(a2);
			var Ca3:Number = Math.cos(a3);
					
			var vx:Number = -(Ca1 * Sa2 * Ca3 + Sa1 * Sa3);
			var vy:Number = -(Ca1 * Sa2 * Sa3 - Sa1 * Ca3);
			var vz:Number = -(Ca1 * Ca2);
			return new Vector3D(vx, vy, vz);
		}
		
		private static function setBright($container:FP10Object3d, $display:DisplayObject , $num:Number ):void
		{
			var c:Number 			= Math.cos(A3D.angle);
			var bn:Number			= (c / (1 - c * c)) * $num * $num + $num - (c / (1 - c * c));
			var brightness:Number 	= Math.min(_dic[$container].brightness, 1);
			brightness			  	= Math.max(brightness, -1);
			var bright:Number 		= bn * 255 * brightness;
			
			var matrix:Array = new Array();
			matrix = matrix.concat([1, 0, 0, 0, bright]); 		// red
			matrix = matrix.concat([0, 1, 0, 0, bright]); 		// green
			matrix = matrix.concat([0, 0, 1, 0, bright]); 		// blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); 		    // alpha
			
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			$display.filters = [filter];
		}
      
	}
	
}