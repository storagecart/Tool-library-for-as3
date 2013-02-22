/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.component.interactive 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	* 拖动功能元件。
	* 注意:子类可以覆写mouseDownHandler，mouseUpHandler,init方法 。
	* 
	* 导入类                            				 
	* --CODE: import tool.component.interactive.DragComponent;
	* 
	* 继承DragComponent                                  
	* --CODE: public class subDragComponent extends DragComponent{}
	* 
	* 选择拖动的方式                                     
	* --CODE: var btn=new subDragComponent;
	* --CODE: btn.way="enterFrame";
	* 
	* 是否带有缓动                                       
	* --CODE: btn.easing=3;
	* 
	* 可拖动的区域                                       
	* --CODE:btn.rectangle=new Rectangle(0,0,100,100);
	* 
	* 
	* 公共静态属性:(拖动方式)
	* DragComponent.DRAG                       			 //startDrag方式(无法实现缓动)
	* DragComponent.TIMER						 		 //timer侦听方式(不受帧频限制)
	* DragComponent.ENTER_FRAME							 //enterFrame侦听方式(比较不消耗资源的方式)
	* DragComponent.MOUSE_MOVE							 //mouseMove侦听方式(在某些浏览器内会有停顿的问题)
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class DragComponentContrl
	{
		public static const DRAG:                       String = "drag";
		public static const TIMER:                      String = "timer";
		public static const ENTER_FRAME:                String = "enterFrame";
		public static const MOUSE_MOVE:				    String = "mouseMove";
		
		static public var rectangle:							Rectangle = null;			//可拖动的区域     
		
		static private var _way:								String; 					//选择拖动的方式  
		static private var _easing:							Number = 1;					//是否带有缓动  
		static private var _timer:                             Timer = new Timer(1000 / 40, 0);
		static private var distanceX:							Number;
		static private var distanceY:							Number;
		
		static private var _over:							Boolean = true;
		
		static public var target:Sprite;
		
		static public function get way():String
		{
			return _way;
		}
		
		static public function set way($value):void
		{
			if (!($value != "drag" && $value != "timer" && $value != "enterFrame" && $value != "mouseMove"))
			_way = $value;
		}
		
		static public function get easing():Number
		{
			return _easing;
		}
		
		static public function set easing($value):void
		{
			_easing = $value<1||$value>20?1:$value;
		}
		
		static public function make($target:Sprite, $way:String ='enterFrame', $easing:Number =5):void 
		{
			target = $target;
			way = $way;
			easing = $easing;
			if (target.stage) init();
			else target.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		static public function stopd():void
		{
			_over = false;
			stopDragTarget();
		}
		
		static public function continued():void
		{
			_over = true;
		}
		
		
		/**
		* DragComponent实例初始化的状态
		* 子类调用请先覆写                 --CODE:override public function init(e:Event = null):void{
												  super.init();
												  //do somethings... }
		*
		* @param		e		        Event		         * 事件实例(可不传入)
		*/
		static protected function init(e:Event = null) :void 
		{
			target.removeEventListener(Event.ADDED_TO_STAGE, init);
			target.mouseChildren = false;
			target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true );
			target.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
			target.parent.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
			target.parent..stage.addEventListener(MouseEvent.ROLL_OUT, mouseUpHandler, false, 0, true);
			target.root.stage.addEventListener(Event.MOUSE_LEAVE, mouseUpHandler, false, 0, true);
		}
		
		/**
		* mouseDown要实现的功能
		* 子类调用请先覆写                 --CODE:override public function mouseDownHandler(e:MouseEvent = null):void{
												  super.mouseDownHandler(e);
												  //do somethings... }
		*
		* @param		e		        MouseEvent		        * 事件实例(可不传入)
		*/
		static protected function mouseDownHandler(e:MouseEvent) :void 
		{
			startDragTarget();
		}
		
		/**
		* mouseUp要实现的功能
		* 子类调用请先覆写                 --CODE:override public function mouseUpHandler(e:MouseEvent = null):void{
												  super.mouseUpHandler(e);
												  //do somethings... }
		*
		* @param		e		        MouseEvent		        * 事件实例(可不传入)
		*/
		static protected function mouseUpHandler(e:*):void 
		{
			stopDragTarget();
		}
		
		static private function startDragTarget():void
		{
			switch(_way)
			{
				case "drag":
				target.startDrag(false, rectangle );
				break ;
				
				case "enterFrame":
				distanceX = target.x - target.parent.mouseX;
				distanceY = target.y - target.parent.mouseY;
				target.addEventListener(Event.ENTER_FRAME, DragFUN);
				break ;
				
				case "mouseMove":
				distanceX = target.x - target.parent.mouseX;
				distanceY = target.y - target.parent.mouseY;
				target.parent.stage.addEventListener(MouseEvent.MOUSE_MOVE, DragFUN, false, 0, true);
				break ;
				
				case "timer":
				distanceX = target.x - target.parent.mouseX;
				distanceY = target.y - target.parent.mouseY;
				_timer.addEventListener(TimerEvent.TIMER, DragFUN, false, 0, true);
				_timer.start();
				break ;
			}
		}
		
		static private function stopDragTarget():void
		{
			switch(_way)
			{
				case "drag":
				target.stopDrag();
				break ;
				
				case "enterFrame":
				target.removeEventListener(Event.ENTER_FRAME, DragFUN);
				break ;
				
				case "mouseMove":
				target.parent.stage.removeEventListener(MouseEvent.MOUSE_MOVE, DragFUN);
				break ;
				
				case "timer":
				_timer.removeEventListener(TimerEvent.TIMER, DragFUN);
				_timer.stop();
				break;
			}
		}
		
		static private function DragFUN(e:*):void
		{
			if(!_over)return;
			target.x += (target.parent.mouseX + distanceX - target.x) / _easing;
			target.y += (target.parent.mouseY + distanceY - target.y) / _easing;
			if (rectangle != null) judgeBoundary();
			if (e is MouseEvent || e is TimerEvent ) e.updateAfterEvent();
		}
		
		static private function judgeBoundary():void
		{
			//左
			if (target.x < rectangle.x)
				target.x = rectangle.x;
			//右 
			if (target.x > rectangle.right)
				target.x = rectangle.right;
			//上
			if (target.y < rectangle.y )
				target.y = rectangle.y;
			//下
			if (target.y > rectangle.bottom)
				target.y = rectangle.bottom;
		}
	}
	
}