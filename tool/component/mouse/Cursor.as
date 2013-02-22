/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.component.mouse
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.geom.Rectangle;
	import flash.utils.*;
	
	/**
	* 自定义鼠标指针
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class Cursor extends MovieClip
	{
		public static const DRAG:                       String = "drag";
		public static const TIMER:                      String = "timer";
		public static const ENTER_FRAME:                String = "enterFrame";
		public static const MOUSE_MOVE:				    String = "mouseMove";
		
		private var _rectangle:							Rectangle = null;			//可拖动的区域     
		private var _way:								String; 					//选择拖动的方式  
		private var _easing:							Number = 1;					//是否带有缓动  
		private var _timer:                             Timer = new Timer(1000 / 40, 0);
		private var _id:								Number;
		private var _over:                              Boolean = false;             //是否开始
		
		public function get rectangle():Rectangle
		{
			return _rectangle;
		}
		
		public function set rectangle($value:Rectangle):void
		{
			_rectangle = $value;
			resert();
		}
		
		public function get way():String
		{
			return _way;
		}
		
		public function set way($value:String):void
		{
			if (_over) { stoped(); _over = true; }
			if (!($value != "drag" && $value != "timer" && $value != "enterFrame" && $value != "mouseMove"))
			_way = $value;
			if(_over) start();
		}
		
		public function get easing():Number
		{
			return _easing;
		}
		
		public function set easing($value:Number):void
		{
			_easing = $value<1||$value>20?1:$value;
			resert();
		}

		public function Cursor() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		/**
		* DragComponent实例初始化的状态
		* 子类调用请先覆写                 --CODE:override public function init(e:Event = null):void{
												  super.init();
												  //do somethings... }
		*
		* @param		e		        Event		         * 事件实例(可不传入)
		*/
		protected function init(e:Event = null) :void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			mouseEnabled  = false;
			mouseChildren = false;
			way = Cursor.TIMER;
		}
		
		private function resert():void
		{
			if (_over)
			{
				stoped();
				start();
			}
		}
		
		public function start():void
		{
			Mouse.hide();
			var obj = this;
			_id = setInterval(function() {
										  if (parent.getChildIndex(obj) != parent.numChildren - 1)
										  parent.addChild(obj);
										  },1000/30);
			switch(_way)
			{
				case "drag":
				startDrag(false, _rectangle );
				break ;
				
				case "enterFrame":
				addEventListener(Event.ENTER_FRAME, DragFUN);
				break ;
				
				case "mouseMove":
				parent.stage.addEventListener(MouseEvent.MOUSE_MOVE, DragFUN, false, 0, true);
				break ;
				
				case "timer":
				_timer.addEventListener(TimerEvent.TIMER, DragFUN, false, 0, true);
				_timer.start();
				break ;
			}
			_over = true;
		}
		
		public function stoped():void
		{
			clearInterval(_id);
			Mouse.show();
			switch(_way)
			{
				case "drag":
				stopDrag();
				break ;
				
				case "enterFrame":
				removeEventListener(Event.ENTER_FRAME, DragFUN);
				break ;
				
				case "mouseMove":
				parent.stage.removeEventListener(MouseEvent.MOUSE_MOVE, DragFUN);
				break ;
				
				case "timer":
				_timer.removeEventListener(TimerEvent.TIMER, DragFUN);
				_timer.stop();
				break;
			}
			_over = false;
		}
		
		private function DragFUN(e:*):void
		{
			x += (parent.mouseX - x) / _easing;
			y += (parent.mouseY - y) / _easing;
			if (_rectangle != null) judgeBoundary();
			if (e is MouseEvent || e is TimerEvent ) e.updateAfterEvent();
		}
		
		private function judgeBoundary():void
		{
			//左
			if (x < _rectangle.x)
			x = _rectangle.x;
			//右 
			if (x > _rectangle.right)
			x = _rectangle.right;
			//上
			if (y < _rectangle.y )
			y = _rectangle.y;
			//下
			if (y > _rectangle.bottom)
			y = _rectangle.bottom;
		}
		
	}
	
}