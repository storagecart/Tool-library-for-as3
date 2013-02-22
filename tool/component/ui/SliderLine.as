/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.component.ui 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import tool.move.*;
	
	/**
	*
	*	SliderLine类是一个滚动条组件
	* 
	* 导入类                            				 
	* --CODE:import tool.component.ui.SliderLine;
	* 
	* 两种声明方法  
	* --CODE:（1）var scroll:ScrollPane = new SliderLine(scroll_bar,scroll_line);
	* --CODE:（2）var scroll:ScrollPane = new SliderLine(scroll_bar,scroll_line,true,true,"L");
	* 
	* 还可以重新设置以下属性
	* --CODE: scroll.lineAbleClick=true;		 			//背景条是否可点击
	* --CODE: scroll.mouseWheel=true;			    		//鼠标滚轮
	* --CODE: scroll.direction="L";                  		//方向(横向还是纵向)
	* --CODE: scroll.speed=20;                  	 		//鼠标滚轮的滚动速度
	* 
	* 添加上下按钮
	* --CODE: scroll.UP=up_btn;								//上按钮
	* --CODE: scroll.DOWN=down_btn;							//下按钮
	* 
	* 获取和设置比例值
	* --CODE: scroll.scaleValue=35;							//注:范围(0-1)
	* --CODE: trace(scroll.scaleValue)						//注:范围(0-1)
	* 
	* 公共属性
	* ScrollPane.H                       				 	//横向
	* ScrollPane.L						 					//纵向
	* 
	* 销毁
	* --CODE: scroll.destroy();
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class SliderLine     
	{
		
		public static const H = "H";
		public static const L = "L";
		
		public var ab:String = 'A-B';
		
		private var _scaleValue:Number;
		private var _speed:Number = 20;
		private var _upBtn:Sprite;
		private var _downBtn:Sprite;
		
		private var _lineAbleClick:Boolean;
		private var _mouseWheel:Boolean;
		private var _direction:String;

		private var _scrollBar:Sprite;
		private var _scrollLine:Sprite;
		
		private var _coor:String;
		private var _length:String;
		private var _mouse:String;
		private var _parentMC:DisplayObjectContainer;
		private var _rectangle:Rectangle;
		private var _scrollBarOriginalPoint:Point;
		private var _distanceX:Number;
		private var _distanceY:Number;
	
		public function get scaleValue():Number
		{
			return getScaleValue();
		}
		
		public function set scaleValue($value:Number) :void
		{
			$value = $value < 0  ? 0:$value;
			$value = $value > 100  ? 100:$value;
			setScaleValue($value / 100 );
		}
		
		public function set lineAbleClick($value:Boolean):void
		{
			_lineAbleClick = $value ;
			if (_lineAbleClick)
				_scrollLine.addEventListener(MouseEvent.MOUSE_DOWN,              scrollLineMouseDownHandler, false, 0, true );	
			else 
				_scrollLine.removeEventListener(MouseEvent.MOUSE_DOWN,              scrollLineMouseDownHandler);	
		}
		
		public function set mouseWheel($value:Boolean):void
		{
			_mouseWheel = $value ;
			if (_mouseWheel)
				_parentMC.stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler, false, 0, true );
			else
				_parentMC.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		}
			
		public function set direction($value:String):void
		{
			_direction 	= $value ;
			_coor 		= _direction == "H"?"x":"y";
			_length 	= _coor == "x"?"width":"height";
			_mouse 		= _coor == "x"?"mouseX":"mouseY";
			setRect();
			
			//makeScrollPane(); 
		}
		
		public function set speed($value:Number):void
		{
			_speed = $value<5||$value>35?10:$value;
		}
		
		public function set UP($target:Sprite):void
		{
			_upBtn = $target;
			_upBtn.addEventListener(MouseEvent.MOUSE_DOWN, upDownBtnMouseDownHandler, false, 0, true );
		}
		
		public function set DOWN($target:Sprite):void
		{
			_downBtn = $target;
			_downBtn.addEventListener(MouseEvent.MOUSE_DOWN, upDownBtnMouseDownHandler, false, 0, true );
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/**
		* 构造函数
		* @param		$scrollBar		        Sprite		     		     * 滚动滑块
		* @param		$scrollLine		        Sprite		      			 * 滚动条
		* @param		$lineAbleClick		    Boolean		      	         * 滚动条可否点击
		* @param		$mouseWheel		   		Boolean		      	         * 滚轮可用
		* @param		$direction		    	String		      	         * 方向(默认横向)
		*/  
		public function SliderLine($scrollBar:Sprite, $scrollLine:Sprite,$lineAbleClick:Boolean = false, $mouseWheel:Boolean = false, $direction:String = "H") 
		{
			_scrollBar 				= $scrollBar;
			_scrollLine 			= $scrollLine;
			_lineAbleClick 			= $lineAbleClick;
			_mouseWheel 			= $mouseWheel;
			_direction 				= $direction;
			_parentMC 				= _scrollBar.parent;
			_coor 					= $direction == "H"?"x":"y";
			_length 				= _coor == "x"?"width":"height";
			_mouse 					= _coor == "x"?"mouseX":"mouseY";
			_scrollBarOriginalPoint = new Point(_scrollBar.x, _scrollBar.y);
			
			makeScrollPane();
		}
		
		public function destroy():void
		{
			if (_scrollLine)_scrollLine.removeEventListener(MouseEvent.MOUSE_DOWN, scrollLineMouseDownHandler );	
			if (_parentMC&&_mouseWheel)_parentMC.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			if (_scrollBar)
			{
				SimpleTween.kill(_scrollBar);
				_scrollBar.removeEventListener(Event.ENTER_FRAME,scrolBarEnterFrameHandler);
				_scrollBar.removeEventListener(MouseEvent.MOUSE_DOWN,scrollBarMouseDownHandler);
				_scrollBar.removeEventListener(MouseEvent.MOUSE_UP,scrollBarMouseUpHandler);
			}
			
			if(_scrollBar.parent)_scrollBar.parent.stage.removeEventListener(MouseEvent.MOUSE_UP,   scrollBarMouseUpHandler);	
			if (_scrollBar.root)_scrollBar.root.stage.removeEventListener(Event.MOUSE_LEAVE,       scrollBarMouseUpHandler);
			if (_upBtn)_upBtn.removeEventListener(MouseEvent.MOUSE_DOWN, upDownBtnMouseDownHandler);
			if (_downBtn)_downBtn.removeEventListener(MouseEvent.MOUSE_DOWN, upDownBtnMouseDownHandler);
				
			_scrollBar = null;
			_scrollLine = null;
			_parentMC = null;
			_upBtn = null;
			_downBtn = null;
		}
		
		private function makeScrollPane():void
		{
			setRegistration(_scrollLine);
			setRegistration(_scrollBar);
			makeScrollBar();  
		}
		
		//背景条
		private function makeScrollLine():void
		{
			_scrollLine.buttonMode = false;
			_scrollLine.addEventListener(MouseEvent.MOUSE_DOWN,              scrollLineMouseDownHandler, false, 0, true );	
		}
		
		//滚轮
		private function makeMouseWheel():void
		{
			_parentMC.stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler, false, 0, true );
		}
		
		//滚动条点击
		private function scrollLineMouseDownHandler(e:MouseEvent):void
		{	
			var target = judgeBoundaryTwo(_parentMC[_mouse]);
			SimpleTween.go(_scrollBar, 200, _coor, target, Quart.easeOut);
		}
		
		//上下按钮点击
		private function upDownBtnMouseDownHandler(e:MouseEvent):void
		{
			var target = _scrollBar[_coor];
			if (e.currentTarget == _downBtn)
			target += 3*_speed;
			else
			target -= 3 * _speed;
			
			target = judgeBoundaryTwo(target);
			SimpleTween.go(_scrollBar, 200, _coor, target, Quart.easeOut);
		}
		
		//鼠标滚轮
		private function mouseWheelHandler(e:MouseEvent):void
		{
			var target = _scrollBar[_coor];
			if (e.delta < 0)
				target += _speed;
			else
				target -= _speed; 
			
			target = judgeBoundaryTwo(target);
			SimpleTween.kill(_scrollBar);
			SimpleTween.go(_scrollBar, 50, _coor, target,Linear.easeOut);
		}
		
		//滑块
		private function makeScrollBar():void
		{
			_scrollBar.buttonMode = true;
			_scrollBar.mouseChildren = false;
			setRect();
			_scrollBar.addEventListener(MouseEvent.MOUSE_DOWN,              scrollBarMouseDownHandler, false, 0, true );
			_scrollBar.addEventListener(MouseEvent.MOUSE_UP,                scrollBarMouseUpHandler, false, 0, true );
			
			if(_scrollBar.parent)
				_scrollBar.parent.stage.addEventListener(MouseEvent.MOUSE_UP,   scrollBarMouseUpHandler, false, 0, true );
				
			if (_scrollBar.root)
				_scrollBar.root.stage.addEventListener(Event.MOUSE_LEAVE,       scrollBarMouseUpHandler, false, 0, true );
		}
		
		private function setRect():void 
		{
			if (_coor == "y")
				_rectangle = new Rectangle(_scrollBarOriginalPoint.x, _scrollBarOriginalPoint.y, 0, _scrollLine.getRect(_parentMC)[_length] - _scrollBar.getRect(_parentMC)[_length]);
			else 
				_rectangle = new Rectangle(_scrollBarOriginalPoint.x, _scrollBarOriginalPoint.y, _scrollLine.getRect(_parentMC)[_length] - _scrollBar.getRect(_parentMC)[_length], 0);
			_scrollBar[_coor] = _scrollLine[_coor];
		}
		
		private function scrollBarMouseDownHandler(e:MouseEvent):void
		{
			_distanceX = _scrollBar.x - _parentMC.mouseX;
			_distanceY = _scrollBar.y - _parentMC.mouseY;
			_scrollBar.addEventListener(Event.ENTER_FRAME, scrolBarEnterFrameHandler, false, 0, true );
		}
		
		private function scrollBarMouseUpHandler(e:*):void
		{
			_scrollBar.removeEventListener(Event.ENTER_FRAME, scrolBarEnterFrameHandler);
		}
		
		private function scrolBarEnterFrameHandler(e:Event):void
		{
			makeDragBar();
		}
		
		//拖动滑块
		private function makeDragBar():void
		{
			_scrollBar.x = _parentMC.mouseX + _distanceX;
			_scrollBar.y = _parentMC.mouseY + _distanceY;
			judgeBoundary();	
		}
		
		//判断边界2
		private function judgeBoundaryTwo($target:Number) :Number
		{
			if ($target < _rectangle[_coor])
				$target = _rectangle[_coor];
			if ($target > _rectangle[_coor]+_rectangle[_length])
				$target = _rectangle[_coor] + _rectangle[_length];
				
			return $target;
		}
		
		//判断边界 
		private function judgeBoundary() :void
		{
			if (_scrollBar.x < _rectangle.x)
				_scrollBar.x = _rectangle.x;
			if (_scrollBar.x > _rectangle.right)
				_scrollBar.x = _rectangle.right;
			if (_scrollBar.y < _rectangle.y )
				_scrollBar.y = _rectangle.y;
			if (_scrollBar.y > _rectangle.bottom)
				_scrollBar.y = _rectangle.bottom;
		}
		
		//获取_scaleValue值
		private function getScaleValue():Number
		{
			_scaleValue = (_scrollBar[_coor] - _scrollBarOriginalPoint[_coor]) / (_scrollLine[_length] - _scrollBar[_length]);
			_scaleValue = Math.min(Math.ceil(_scaleValue * 100), 100);
			return _scaleValue;
		}
		
		//设置_scaleValue值
		private function setScaleValue($value:Number):void
		{
			_scaleValue = $value ;	
			_scrollBar[_coor] = _scaleValue * (_scrollLine[_length] - _scrollBar[_length]) + _scrollBarOriginalPoint[_coor];
		}
		
		//注册点移到左上角
		private function setRegistration($target:DisplayObjectContainer):void
		{
			return;  //这个功能有待考虑
			var rect = $target.getRect($target);
			var _x = rect.x;
			var _y = rect.y;
			var depth:Number = $target.numChildren;
			if (depth == 0) return;	
			for (var i:uint = 0; i < depth; i++ )
			{
				var target:DisplayObject = $target.getChildAt(i);
				target.x -= _x;
				target.y -= _y;
			}
			if ($target.parent != null)
			{
				$target.x += _x;
				$target.y += _y;
			}
		}
	}
	
}