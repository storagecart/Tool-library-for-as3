/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.geom 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import tool.object.AClass;
	/**
	* RectangleUI工具条(参考了adobe)
	* --CODE: var rUI:RectangleUI=new RectangleUI('Ball',stage.stageWidth+10,stage.stageHeight+10);
	* --CODE: addChild(rUI);
	* --CODE: rUI.getCropRect();
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class RectangleUI extends Sprite
	{
		private static const INIT_WIDTH:Number = 100;
		private static const INIT_HEIGHT:Number = 100;
		private static const MIN_SIZE:Number = 30;
		private static var HALF_BUTTON_SIZE:Number;
		
		private var _tl:Sprite;
		private var _tr:Sprite;
		private var _bl:Sprite;
		private var _br:Sprite;

		private var _maxWidth:Number;
		private var _maxHeight:Number;
		private var _cropRect:Rectangle;
		private var _currentBtn:Sprite;
		private var _uiClassName:String;
		
		public function RectangleUI($uiClassName:String , maxWidth:Number, maxHeight:Number)
		{
			addEventListener(Event.ADDED, setupChildren);
			_uiClassName = $uiClassName;
			_maxWidth = maxWidth;
			_maxHeight = maxHeight;
		}
		
		//获取rect
		public function getCropRect():Rectangle
		{
			return _cropRect.clone();
		}
		
		//重置ui
		public function resetUI():void
		{
			var initX:Number = (_maxWidth - INIT_WIDTH) / 2;
			var initY:Number = (_maxHeight - INIT_HEIGHT) / 2;
			
			_cropRect.x = initX;
			_cropRect.y = initY;
			_cropRect.width = INIT_WIDTH;
			_cropRect.height = INIT_HEIGHT;
			
			updateUI();
		}
		
		private function setupChildren(event:Event):void
		{
			removeEventListener(Event.ADDED, setupChildren);
			var initX:Number = (_maxWidth - INIT_WIDTH) / 2;
			var initY:Number = (_maxHeight - INIT_HEIGHT) / 2;
			_cropRect = new Rectangle(initX, initY, INIT_WIDTH, INIT_HEIGHT);
			
			var ClassReference:Class  = AClass.getClass(_uiClassName);
			_tl = new ClassReference();
			initButton(_tl);
			_tr = new ClassReference();
			initButton(_tr);
			
			_bl = new ClassReference();
			initButton(_bl);
			
			_br = new ClassReference();
			initButton(_br);
			RectangleUI.HALF_BUTTON_SIZE = DisplayObject(_br).width / 2;
			
			updateUI();
		}
		
		
		private function mouseDownHandler(e:MouseEvent):void
		{
			_currentBtn = Sprite(e.currentTarget);
			
			addEventListener(Event.RENDER, renderHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			var tempRect:Rectangle = _cropRect.clone();
			
			switch (_currentBtn)
			{
				case _tl:
					tempRect.left = mouseX;
					tempRect.top = mouseY;
					break;
				case _tr:
					tempRect.right = mouseX;
					tempRect.top = mouseY;
					break;
				case _bl:
					tempRect.left = mouseX;
					tempRect.bottom = mouseY;
					break;
				case _br:
					tempRect.right = mouseX;
					tempRect.bottom = mouseY;
					break;
			}
			
			if (tempRect.left < 0)
			{
				tempRect.left = 0;
			}
			if (tempRect.right > _maxWidth)
			{
				tempRect.right = _maxWidth;
			}
			if (tempRect.top < 0)
			{
				tempRect.top = 0;
			}
			if (tempRect.bottom > _maxHeight)
			{
				tempRect.bottom = _maxHeight;
			}
			
			var invalid:Boolean = false;
			if (tempRect.width >= MIN_SIZE)
			{
				_cropRect.left = tempRect.left;
				_cropRect.right = tempRect.right;
				invalid = true;
			}
			
			if (tempRect.height >= MIN_SIZE)
			{
				_cropRect.top = tempRect.top;
				_cropRect.bottom = tempRect.bottom;
				invalid = true;
			}
			
			if (invalid)
			{
				stage.invalidate();
			}
		}
		
		
		private function renderHandler(event:Event):void
		{
			updateUI();
		}
		
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			_currentBtn = null;
			
			removeEventListener(Event.RENDER, renderHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		
		// ------- Private Methods -------
		private function initButton(btn:*):void
		{
			btn.buttonMode = true;
			btn.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addChild(btn);
		}
		
		
		private function updateUI():void
		{
			positionButtons();
			drawMatte();
		}
		
		
		private function positionButtons():void
		{
			_tl.x = _cropRect.left - HALF_BUTTON_SIZE;
			_tl.y = _cropRect.top - HALF_BUTTON_SIZE;
			_tr.x = _cropRect.right - HALF_BUTTON_SIZE;
			_tr.y = _cropRect.top - HALF_BUTTON_SIZE;
			_bl.x = _cropRect.left - HALF_BUTTON_SIZE;
			_bl.y = _cropRect.bottom - HALF_BUTTON_SIZE;
			_br.x = _cropRect.right - HALF_BUTTON_SIZE;
			_br.y = _cropRect.bottom - HALF_BUTTON_SIZE;
		}
		
		
		private function drawMatte():void
		{
			var fill:uint = 0x000000;
			var fillAlpha:Number = .5;
			
			var g:Graphics = graphics;
			g.clear();
			
			// draw the gray matte
			g.beginFill(fill, fillAlpha);
			g.drawRect(0, 0, _maxWidth, _cropRect.top);
			g.drawRect(0, _cropRect.top, _cropRect.left, _cropRect.height);
			g.drawRect(_cropRect.right, _cropRect.top, (_maxWidth - _cropRect.right), _cropRect.height);
			g.drawRect(0, _cropRect.bottom, _maxWidth, (_maxHeight - _cropRect.bottom));
			g.endFill();
			
			// draw a transparent rectangle over the crop area to serve as a mouse target
			g.beginFill(fill, 0);
			g.drawRect(_cropRect.x, _cropRect.y, _cropRect.width, _cropRect.height);
			g.endFill();
		}
		
	}

}