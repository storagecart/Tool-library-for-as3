/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.draw 
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	/**
	* Pen类用来创建一个基本的画笔
	* 
	* --CODE: import tool.draw.Pen;
	* --CODE: var pen=new Pen(this,2);
	* --CODE: pen.useTimer(35);                       //使用timer来做侦听
	* --CODE: pen.clear;               				  //清除绘制的图形
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class Pen
	{
		private var _target:						*;
		private var _thickness:						Number;
		private var _color:							uint;
		private var _alpha:							Number;
		private var _pixelHinting:					Boolean;
		private var _scaleMode:						String;
		private var _caps:							String;
		private var _joints:						String;
		private var _miterLimit:					Number;
		
		private var _graphics:						Graphics;
		private var _timer:							Timer;
		private var _useTimer:						Boolean;
		
		//=================================================================================================================================
		/**
		* 构造函数
		* @param		$target		      	  	*		 				 	 * 要绘画的位置
		* @param		$thickness		        Number		        		 * 线条的粗细
		* @param		$color		       	 	uint		     		     * 线条的十六进制颜色值
		* @param		$alpha		        	Number		      			 * 表示线条颜色的 Alpha 值的数字
		* @param		$pixelHinting		    Boolean		         		 * 用于指定是否提示笔触采用完整像素的布尔值
		* @param		$scaleMode		       	String		     		     * 用于指定要使用哪种缩放模式的 LineScaleMode 类的值
		* @param		$caps		        	String		      			 * 用于指定线条末端处端点类型的 CapsStyle 类的值。
		* @param		$joints		        	String		         		 * JointStyle 类的值，指定用于拐角的连接外观的类型。
		* @param		$miterLimit		        Number		         		 * 一个表示将在哪个限制位置切断尖角的数字
		*/  
		public function Pen($target:*, $thickness:Number = 1, $color:uint = 0, $alpha:Number = 1.0, $pixelHinting:Boolean = false, $scaleMode:String = "normal", $caps:String = null, $joints:String = null, $miterLimit:Number = 3):void 
		{
			_target				= $target;
			_thickness 			= $thickness;
			_color 				= $color;
			_alpha 				= $alpha;
			_pixelHinting 		= $pixelHinting;
			_scaleMode 			= $scaleMode;
			_caps 				= $caps;
			_joints 			= $joints;
			_miterLimit 		= $miterLimit;
			
			_graphics 			= _target.graphics;
			_useTimer 			= false;
			beginDraw();
		}
		
		/**
		* 是否使用时间检测Timer
		* @param		$time		      	  	Number		 				 * 接近帧频的时间
		*/
		public function useTimer($time:Number = 30):void
		{
			_timer				= new Timer(1000 / $time, 0 );
			_useTimer 			= true;
			_timer.				start();
		}
			
		/**
		* 清除绘制的图形
		*/
		public function clear():void
		{
			_graphics.clear();
		}
		
		private function beginDraw():void
		{
			_target.stage.addEventListener(MouseEvent.MOUSE_DOWN, 			mouseDownHandler);
			_target.stage.addEventListener(MouseEvent.MOUSE_UP, 			mouseUpHandler);
		}
		
		private function mouseDownHandler(e:MouseEvent):void
		{
			_graphics.lineStyle(_thickness, _color, _alpha, _pixelHinting, _scaleMode, _caps, _joints, _miterLimit);
			_graphics.moveTo(_target.mouseX, _target.mouseY);
			
			if (_useTimer)
			_timer.addEventListener(TimerEvent.TIMER,				 		mosueMoveHandler);
			else
			_target.stage.addEventListener(MouseEvent.MOUSE_MOVE, 			mosueMoveHandler);
		}
		
		private function mouseUpHandler(e:MouseEvent):void
		{
			if (_useTimer)
			_timer.removeEventListener(TimerEvent.TIMER, 					mosueMoveHandler);
			else
			_target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, 		mosueMoveHandler);
		}
		
		private function mosueMoveHandler(e:*):void
		{
			_graphics.lineTo(_target.mouseX, _target.mouseY);
			e.updateAfterEvent();
		}
	}

}