/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.fp10.a3d.move 
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import tool.fp10.a3d.A3D;
	import tool.fp10.a3d.core.FP10Object3d;
	
	/**
	* Z轴排序器(仅支持 flash player10.0 以上版本)
	* 
	* 导入类
	* --CODE: import tool.fp10.a3d.move.OrderTool;
	* 
	* 一直z排序
	* --CODE: OrderTool.alwaysOrder(box);
	* 
	* 停止z排序
	* --CODE: OrderTool.stopAlwaysOrder(box);
	* 
	* 智能z排序（当对象某属性大于【>,<,==】某一数值时候停止z排序）
	* --CODE: OrderTool.order(box, "rotationX", 130, OrderTool.THAN);
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 10.0/Flash 10.1
	* @tiptext
	*
	*/
	public class OrderTool 
	{
		
		public static const THAN :int = 1;
		public static const LESS :int = -1;
		public static const EQUAL:int = 0;
		
		private static var _dic			:Dictionary;
		
		public static function order($target:FP10Object3d, $properties:String , $overValue:*, $than:int = 1 ):void 
		{
			var _timer:Timer = new Timer(1000 / 40, 0);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			_timer.start();
			
			function timerHandler(e:TimerEvent):void
			{
				if ($than == THAN)
				{
					if ($target[$properties] >= $overValue)
					{
						zOrder($target);
						_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
						_timer.stop();
					}
				}else if ($than == LESS)
				{
					if ($target[$properties] <= $overValue)
					{
						zOrder($target);
						_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
						_timer.stop();
					}
				}else
				{
					if ($target[$properties] == $overValue)
					{
						zOrder($target);
						_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
						_timer.stop();
					}
				}
				
			}
		}
		
		public static function alwaysOrder($target:FP10Object3d):void 
		{
			if (!_dic)_dic = new Dictionary;

			var timerHandler:Function = function (e:TimerEvent):void
			{
				zOrder($target);
			}
			var timer:Timer = new Timer(1000 / A3D.zorderFrame, 0);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.start();
			
			var brightObject:Object = new Object;
			brightObject.target = $target;
			brightObject.timer = timer;
			brightObject.timerHandler = timerHandler;
			_dic[$target] = brightObject;
		}
		
		public static function stopAlwaysOrder($target:FP10Object3d):void 
		{
			if (_dic)
			{
				if (_dic[$target])
				{
					_dic[$target].timer.removeEventListener(TimerEvent.TIMER, _dic[$target].timerHandler);
					_dic[$target].timer.stop();
					delete _dic[$target];
				}
			}
		}
		
	}
	
}