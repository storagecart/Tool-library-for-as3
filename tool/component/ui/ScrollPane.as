/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.component.ui
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	* ScrollPane类是一个滚动窗口组件
	* 
	* 导入类                            				 
	* --CODE:import tool.component.ui.ScrollPane;
	* 
	* 两种声明方法  
	* --CODE:（1）var scroll:ScrollPane = new ScrollPane(target_mc,mask_mc,scroll_bar,scroll_line);
	* --CODE:（2）var scroll:ScrollPane = new ScrollPane(target_mc,mask_mc,scroll_bar,scroll_line,5,true,false,false,"H");
	* 
	* 遮罩参数可传入Rectangle值
	* --CODE: var rect=new Rectangle(0,0,200,200);     
	* --CODE: new ScrollPane(target_mc,rect,scroll_bar,scroll_line);
	* 
	* 还可以重新设置以下属性
	* --CODE: scroll.tween=5;       		 	 			//缓动系数( <1就不缓动 )
	* --CODE: scroll.elastic=true;  			 			//滑块是否可伸缩
	* --CODE: scroll.lineAbleClick=true;		 			//背景条是否可点击
	* --CODE: scroll.mouseWheel=true;			    		//鼠标滚轮
	* --CODE: scroll.direction="L";                  		//方向(横向还是纵向)
	* --CODE: scroll.speed=20;                  	 		//鼠标滚轮的滚动速度
	* --CODE: scroll.scale9Grid=new Rectangle(0,0,10,10);   //滑块的9切片
	* 
	* 添加上下按钮
	* --CODE: scroll.UP=up_btn;								//上按钮
	* --CODE: scroll.DOWN=down_btn;							//下按钮
	* 
	* 当遮罩或者被遮罩对象尺寸变化时，重新刷新UI(重要)
	* --CODE: scroll.refresh();
	* 
	* 
	* 公共属性
	* ScrollPane.H                       				 	//横向
	* ScrollPane.L						 					//纵向
	* scroll.name                                           //组件名称
	*
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class ScrollPane 
	{
		public static const H = "H";
		public static const L = "L";
		
		public const name = "滚动条窗口";
		
		private var _speed:Number = 15;
		private var _upBtn:Sprite;
		private var _downBtn:Sprite;
		
		private var _tween:Number;
		private var _elastic:Boolean;
		private var _lineAbleClick:Boolean;
		private var _mouseWheel:Boolean;
		private var _direction:String;
		private var _scale9Grid:Rectangle;

		private var _target:DisplayObject;
		private var _maskTarget:DisplayObject;
		private var _scrollBar:Sprite;
		private var _scrollLine:Sprite;
		
		private var _timer:Timer = null;
		private var _scrollBarOriginalPoint:Point;
		private var _parentMC:DisplayObjectContainer;
		private var _rectangle:Rectangle;
		private var _distanceX:Number;
		private var _distanceY:Number;
		private var _targetPoint:Number = NaN;
		
		private var _coor:String;
		private var _length:String;
		private var _mouse:String;
		private var _oldLength:Point;
		private var _abled = true;
		
		public function set tween($value:Number):void
		{
			_tween = $value < 1||$value > 20?1:$value;
		}
		
		public function set elastic($value:Boolean):void
		{
			_elastic = $value ;
			if (_abled)
			makeScrollBar();    
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
			if (_mouseWheel && _abled)
			_parentMC.stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler, false, 0, true );
			else if(_abled)
			_parentMC.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		}
			
		public function set direction($value:String):void
		{
			_direction 	= $value ;
			_coor 		= _direction == "H"?"x":"y";
			_length 	= _coor == "x"?"width":"height";
			_mouse 		= _coor == "x"?"mouseX":"mouseY";
			
			if (_abled)
			makeScrollBar();  
		}
		
		public function set scale9Grid($value:Rectangle):void
		{
			_scale9Grid = $value ;
			try { _scrollBar.scale9Grid =  _scale9Grid } catch (e) { _scrollBar.scale9Grid = null }
		}
		
		public function set speed($value:Number):void
		{
			_speed = $value<5||$value>35?15:$value;
		}
		
		public function set UP($target:Sprite):void
		{
			_upBtn = $target;
			if (!_abled)
			{
				_upBtn.visible = false;
				_upBtn.removeEventListener(MouseEvent.MOUSE_DOWN, upDownBtnMouseDownHandler );
				return;
			}
			_upBtn.addEventListener(MouseEvent.MOUSE_DOWN, upDownBtnMouseDownHandler, false, 0, true );
		}
		
		public function set DOWN($target:Sprite):void
		{
			_downBtn = $target;
			if (!_abled)
			{
				_downBtn.visible = false;
				_downBtn.removeEventListener(MouseEvent.MOUSE_DOWN, upDownBtnMouseDownHandler );
				return;
			}
			_downBtn.addEventListener(MouseEvent.MOUSE_DOWN, upDownBtnMouseDownHandler, false, 0, true );
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/**
		* 构造函数
		* @param		$target		      	  	DisplayObjectContainer		 * 被遮罩对象
		* @param		$maskTarget		        *		        			 * 遮罩对象(可传入Rectangle类型)
		* @param		$scrollBar		        Sprite		     		     * 滚动滑块
		* @param		$scrollLine		        Sprite		      			 * 滚动条
		* @param		$tween		            Number		         		 * 缓动系数
		* @param		$elastic		        Boolean		       			 * 滑块可否拉伸
		* @param		$lineAbleClick		    Boolean		      	         * 滚动条可否点击
		* @param		$mouseWheel		   		Boolean		      	         * 滚轮可用
		* @param		$direction		    	String		      	         * 方向(默认纵向)
		*/  
		public function ScrollPane($target:DisplayObjectContainer, $maskTarget:*, $scrollBar:Sprite, $scrollLine:Sprite, $tween:Number = 0, $elastic:Boolean = true, $lineAbleClick:Boolean = false, $mouseWheel:Boolean = true, $direction:String = "L") 
		{
			if (!(($maskTarget is DisplayObject) || ($maskTarget is Rectangle))) throw(new Error("没有传入遮罩对象"));
			
			_target = $target;
			_maskTarget = $maskTarget is Rectangle?drawMaskTarget($maskTarget):$maskTarget;
			_scrollBar = $scrollBar;
			_scrollLine = $scrollLine;
			_tween = $tween < 1||$tween > 20?1:$tween;
			_elastic = $elastic;
			_lineAbleClick = $lineAbleClick;
			_mouseWheel = $mouseWheel;
			_direction = $direction;
			_parentMC = _scrollBar.parent;
			_coor = $direction == "H"?"x":"y";
			_length = _coor == "x"?"width":"height";
			_mouse = _coor == "x"?"mouseX":"mouseY";
			_oldLength = new Point(_scrollBar.width, _scrollBar.height);			
			_scale9Grid = new Rectangle(_scrollBar.width / 3, _scrollBar.height / 3, _scrollBar.width / 3, _scrollBar.height / 3);
			
			makeScrollPane();
		}
		
		/**
		* 刷新UI
		*/  
		public function refresh():void
		{
			checkAbled();
		}
		
		private function makeScrollPane():void
		{
			initAllThing();
			_scrollBarOriginalPoint = new Point(_scrollBar.x, _scrollBar.y);
			makeMask();
			checkAbled();	
		}
		
		//检查可用性
		private function checkAbled():void
		{
			if (_maskTarget[_length] >= _target[_length])
			{
				_scrollBar.visible = false;
				_scrollLine.visible = false;
				if (_downBtn)_downBtn.visible = false;
				if (_upBtn)_upBtn.visible = false;
				_abled = false;
				
				if (_upBtn&&_downBtn) {
					_upBtn.removeEventListener(MouseEvent.MOUSE_DOWN, upDownBtnMouseDownHandler );
					_downBtn.removeEventListener(MouseEvent.MOUSE_DOWN, upDownBtnMouseDownHandler );
				}
				if (_mouseWheel) makeMouseWheel("stop");
			}else
			{
				_scrollBar.visible = true;
				_scrollLine.visible = true;
				if (_downBtn)_downBtn.visible = true;
				if (_upBtn)_upBtn.visible = true;
				_abled = true;
				
				makeScrollBar(); 
				if (_upBtn&&_downBtn) {
					_upBtn.addEventListener(MouseEvent.MOUSE_DOWN, upDownBtnMouseDownHandler, false, 0, true );
					_downBtn.addEventListener(MouseEvent.MOUSE_DOWN, upDownBtnMouseDownHandler, false, 0, true );
				}
				if (_lineAbleClick) makeScrollLine();
				if (_mouseWheel) makeMouseWheel();
				timeListener();	
			}
		}
		
		//timer检测器
		private function timeListener():void
		{
			if (_timer != null) return;
			_timer = new Timer(1000 / 30, 0);
			_timer.addEventListener(TimerEvent.TIMER, timeHandler );
			_timer.start();
		}
		
		//注册点
		private function initAllThing():void
		{
			setRegistration(_maskTarget as DisplayObjectContainer);
			setRegistration(_target as DisplayObjectContainer);
			setRegistration(_scrollLine);
			setRegistration(_scrollBar);
		}
		
		//初始化遮罩
		private function makeMask():void
		{
			_target.x = Math.floor(_target.x);                                //防止文字模糊
			_target.y = Math.floor(_target.y);
			_maskTarget.x = _target.x;
			_maskTarget.y = _target.y;
			if (_maskTarget.parent == null)_parentMC.addChild(_maskTarget);
			_target.mask = _maskTarget;
		}
		
		//背景条
		private function makeScrollLine():void
		{
			_scrollLine.buttonMode = false;
			_scrollLine.addEventListener(MouseEvent.MOUSE_DOWN,              scrollLineMouseDownHandler, false, 0, true );	
		}
		
		//滚轮
		private function makeMouseWheel(state:String = "start" ):void
		{
			if(state=="start")
			_parentMC.stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler, false, 0, true );
			else if (state == "stop")
			_parentMC.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		}
		
		//滑块
		private function makeScrollBar():void 
		{
			_scrollBar.buttonMode = true;
			_scrollBar.mouseChildren = false;
			scrollBarLength();                                                  	 //计算滑块长度
			if (_coor == "y")
			_rectangle = new Rectangle(_scrollBarOriginalPoint.x, _scrollBarOriginalPoint.y, 0, _scrollLine.getRect(_parentMC)[_length] - _scrollBar.getRect(_parentMC)[_length]);
			else 
			_rectangle = new Rectangle(_scrollBarOriginalPoint.x, _scrollBarOriginalPoint.y, _scrollLine.getRect(_parentMC)[_length] - _scrollBar.getRect(_parentMC)[_length], 0);
			
			_scrollBar.addEventListener(MouseEvent.MOUSE_DOWN,              scrollBarMouseDownHandler, false, 0, true );
			_scrollBar.addEventListener(MouseEvent.MOUSE_UP,                scrollBarMouseUpHandler, false, 0, true );
			_scrollBar.parent.stage.addEventListener(MouseEvent.MOUSE_UP,   scrollBarMouseUpHandler, false, 0, true );
			_scrollBar.root.stage.addEventListener(Event.MOUSE_LEAVE,       scrollBarMouseUpHandler, false, 0, true );
		}
		
		//计算滑块长度
		private function scrollBarLength():void
		{
			if (_elastic)
			try { _scrollBar.scale9Grid =  _scale9Grid } catch (e) {  _scrollBar.scale9Grid = null }
			else
			_scrollBar.scale9Grid = null;
			
			_scrollBar.width = _oldLength.x;
			_scrollBar.height = _oldLength.y;
			_scrollBar[_length] = _elastic ? _scrollLine[_length] * _maskTarget[_length] / _target[_length] : _oldLength[_coor];
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
		
		private function timeHandler(e:TimerEvent):void
		{
			scrollMachine();
		}
		
		//滚动条点击
		private function scrollLineMouseDownHandler(e:MouseEvent):void
		{
			if (_parentMC[_mouse] > _scrollBar[_coor])
			_scrollBar[_coor] += 3*_speed;
			else
			_scrollBar[_coor] -= 3*_speed;
			judgeBoundary();
		}
		
		//上下按钮点击
		private function upDownBtnMouseDownHandler(e:MouseEvent):void
		{
			if (e.currentTarget == _downBtn)
			_scrollBar[_coor] += 3*_speed;
			else
			_scrollBar[_coor] -= 3 * _speed;
			judgeBoundary();
		}
		
		//鼠标滚轮
		private function mouseWheelHandler(e:MouseEvent):void
		{
			if (e.delta < 0)
			_scrollBar[_coor] += _speed;
			else
			_scrollBar[_coor] -= _speed;
			judgeBoundary();
		}
		
		//拖动滑块
		private function makeDragBar():void
		{
			_scrollBar.x = _parentMC.mouseX + _distanceX;
			_scrollBar.y = _parentMC.mouseY + _distanceY;
			judgeBoundary();	
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
		
		//滚动计算公式
		private function scrollMachine():void
		{
			_targetPoint = _maskTarget[_coor] - (_scrollBar[_coor] - _scrollBarOriginalPoint[_coor]) * (_target[_length] - _maskTarget[_length]) / (_scrollLine[_length] - _scrollBar[_length]);
			if (Math.abs(_target[_coor] - _targetPoint) < .3)
			{
				if (_target[_coor] != _targetPoint) _target[_coor] = _targetPoint;
				return;
			}
			
			if (_tween != 0)
			_target[_coor] += (_targetPoint - _target[_coor]) / _tween; 
			else
			_target[_coor] = _targetPoint;
		}
		
		//绘制遮罩
		private function drawMaskTarget($rect:Rectangle):Sprite
		{
			var maskTarget:Sprite = new Sprite();
			maskTarget.graphics.beginFill(0xffffff);
			maskTarget.graphics.drawRect($rect.x, $rect.y, $rect.width, $rect.height);
			maskTarget.graphics.endFill();
			return maskTarget;
		}
		
		//注册点移到左上角
		private function setRegistration($target:DisplayObjectContainer):void
		{
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