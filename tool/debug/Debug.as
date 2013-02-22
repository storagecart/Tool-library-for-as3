/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.debug 
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.*;
	import flash.text.*;
	import flash.utils.*;
	import tool.util.EnterFrame;
	
	/**
	* Debug类，简单实用的调试工具。
	* UI功能:
	* 1.移动缩放.(右下角为拉动块)
	* 2.字体样式.
	* 3.控制输出.
	* 4.隐藏显示.(显示快捷键shift+enter)
	* 
	* 导入类                                          
	* --CODE:import tool.debug.*;
	* 
	* 创建Debug面板                                   
	* --CODE:Debug.creat(this,10,10,300,300);
	* 
	* 清除Debug面板  								  
	* --CODE:Debug.clear();
	* 
	* 使用traced                                      
	* --CODE:traced(1,200,"好");
	* 
	* 输出动态对象的所有动态属性                      
	* --CODE:Debug.traceDynamic(arr);
	* 
	* 输出对象的所有孩子							  -
	* -CODE:Debug.traceChild(ball);
	* 
	* ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
	* 替换全部的trace语句并且显示到调试面板        注意(重要，慎重使用)
	* 在文档类、或者主时间轴的第一帧加上如下代码
	* -CODE: include '../../tool/debug/trace.as';                 //注：'../../tool/debug/trace.as' 相对于fla的相对目录
	* 
	* ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
	* 升级备注：
	* 2010.07.1
	* 加入 Debug.traceDynamic/traceChild 功能
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class Debug
	{
		public static var array:Array = [];                            //trace存储数组
		public static var line:Number = 0;                             //当前输出行数
		
		private static var instantiation:Debug = null;
		private var minWidth = 270;                                    //Debug面板的最小宽度
		private var minHeight = 120;                                   //Debug面板的最小高度
		private var _width:Number;                                     //Debug面板宽度
		private var _height:Number;                                    //Debug面板高度
		private var _enter:EnterFrame;                                 //EnterFrame实例
		private var _timer:Timer;                                      //Timer实例
		private var _root:DisplayObjectContainer;                      //root
		private var _sprite:Sprite;									   //Debug  container
		private var _backgroud:Sprite ;                                //背景
		private var _blod:Sprite;                             		   //加粗按钮
		private var _close:Sprite ;                                    //关闭按钮
		private var _clear:Sprite;                           		   //清除按钮
		private var _control:Sprite;                           		   //控制块
		private var _playbutton:Sprite;                        		   //播放按钮
		private var _parsebutton:Sprite;         					   //暂停按钮
		private var _twoSharp:Sprite;                           	   //双头箭头
		private var _textArea:TextField ;                       	   //显示文本框
		private var _size:TextField ;                       		   //字体
		private var _input:TextField ;                         	       //字体输入框
		
		private var _textFormat:TextFormat                            
		private var _controlTimerHandler:Function;
		private var _controlClick:Boolean = false;
		private var _blodClick:Boolean = false;
		private var _state:Boolean = true;
		private var _parseArray:Array = [];
		
		public function Debug(singletonEnforcer:SingletonEnforcer,$width, $height,$root:DisplayObjectContainer):void
		{
			_sprite = new Sprite;
			_enter = new EnterFrame;
			_timer = new Timer(1000 / 30, 0);                                      //30帧/秒
			_textFormat = new TextFormat;
			_width = $width; _height = $height;
			_root = $root;
			_twoSharp = createTwoSharp(15, 6, 3.5);
			createUI(_sprite);
			Debug.instantiation = this;
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		/**
		* 创建Debug面板 
		*
		* @param		$target		      DisplayObject		    * 要添加面板的对象
		* @param		$x		          Number		        * Debug面板的x坐标
		* @param		$y		          Number		  		* Debug面板的y坐标
		* @param		$width		      Number		  	    * Debug面板的宽度
		* @param		$height		      Number		  	    * Debug面板的高度
		*/
		public static function creat($target:DisplayObject, $x:Number = 0, $y:Number = 0,$width:Number=350, $height:Number=240  ):void
		{
			var _root = $target.root;
			if (_root == null) return;
			
			$width = $width < 270?270:$width;                                     //Debug面板的最小宽度
			$height = $height < 120?120:$height;								  //Debug面板的最小高度
			if (Debug.instantiation == null)
			new Debug(new SingletonEnforcer, $width, $height,_root);
			var this_sprite = Debug.instantiation._sprite;
			this_sprite.x = $x;
			this_sprite.y = $y;
			_root.addChild(this_sprite);
			Debug.instantiation._enter.onEnterFrame = function() 
			{
				if (_root.getChildIndex(this_sprite) != _root.numChildren - 1)
				_root.addChild(this_sprite);
			}
			_root.stage.addEventListener(KeyboardEvent.KEY_DOWN, Debug.instantiation.keyDownHandler, false, 0, true);
		}
		
		/**
		* 清除Debug面板 
		*
		* @return							Boolean				成功返回true,否则false
		*/
		public static function clear():Boolean
		{
			if (Debug.instantiation == null) return false;
			Debug.instantiation.clearDisplayObjectContainer(Debug.instantiation._sprite);
			Debug.instantiation._root.removeChild(Debug.instantiation._sprite);
			Debug.instantiation._timer.stop();
			Debug.instantiation._enter.removeEnterFrame();
			Debug.instantiation._root.stage.removeEventListener(KeyboardEvent.KEY_DOWN, Debug.instantiation.keyDownHandler);
			Debug.instantiation = null;
			return true;
		}
		
		/**
		* 输出动态对象的所有动态属性 
		*
		* @param		$obj		      *		    			* 要输出的对象
		*/
		public static function traceDynamic($obj:*):void
		{
			var arr:Array = [];
			var types:String = $obj is Array ? "array":typeof $obj;
			arr.unshift("<font color='#cccccc'>" + (++Debug.line ) +"</font>" + "  <i>trace</i>::  ");             //前缀
			arr.push("type --> " + (types));
			arr.push("<br>"); 
			for (var property in $obj)
			{
				var str:String = " ";
				for (var i:uint = 0; i < String(Debug.line).length + 14; i++)
				{
					str = str.concat(" ");
				}
				arr.push(str + property + "  ->  " + ($obj[property]));
				arr.push("<br>"); 
			}
			
			Debug.array = Debug.array.concat(arr);
			Debug.write();
		}
		
		/**
		* 输出对象的所有孩子
		*
		* @param		$obj		      DisplayObject		    	* 要输出的对象
		*/
		public static function traceChild($obj:DisplayObject):void
		{
			var arr:Array = [];
			arr.unshift("<font color='#cccccc'>" + (++Debug.line ) +"</font>" + "  <i>trace</i>::  ");             //前缀
			
			if ($obj is DisplayObjectContainer)
			{
				arr.push($obj.name + "'childs -->");
				arr.push("<br>");
				for (var j:uint = 0; j < DisplayObjectContainer($obj).numChildren; j++ )
				{
					var str:String = " ";
					for (var i:uint = 0; i < String(Debug.line).length + 14; i++)
					{
						str = str.concat(" ");
					}
					arr.push(str + j + "  ->  " + (DisplayObjectContainer($obj).getChildAt(j).name) + "   __type__  " + (DisplayObjectContainer($obj).getChildAt(j)));
					arr.push("<br>"); 
				}
			}else {
				arr.push($obj.name + "no child ");
				arr.push("<br>");
			}
			
			Debug.array = Debug.array.concat(arr);
			Debug.write();
		}
		
		///////////////////////////////////
		// private methods
		///////////////////////////////////
		private function keyDownHandler(e:KeyboardEvent):void
		{
			if (!(e.keyCode == Keyboard.ENTER && e.shiftKey)) return;
			if (_root.contains(_sprite)) return ;
			_root.addChild(_sprite);
			_enter.onEnterFrame = function() 
			{
				if (_root.getChildIndex(_sprite) != _root.numChildren - 1)
				_root.addChild(_sprite);
			}
		}
		
		public static function write():void
		{
			if (!Debug.instantiation) return ;
			if (Debug.instantiation._state)
			Debug.instantiation.traceDebug(Debug.instantiation._sprite);
		}
		
		private function traceDebug($target:DisplayObjectContainer) :void
		{
			var _string = _state?String(Debug.array):String(_parseArray);
			_string = replaceTxt(_string, "::  ,", "::  ");
			_string = replaceTxt(_string, ",<br>,", "<br>");
			_string = replaceTxt(_string, ",<br>", "<br>");
			_textArea.htmlText = _string;
			_textArea.scrollV = _textArea.maxScrollV;
			_textArea.setTextFormat(_textFormat);
		}
		
		private function createUI($target:DisplayObjectContainer) {
			var distance = 5;                                                      //底部按钮距文本框的距离
			var _width = 60;                                                       //方型按钮的宽     
			var _height = 20;                                                      //方型按钮的高
			var _radius = 10;                                                      //圆形按钮的半径
			_backgroud = createBackgroud(this._width + 20, this._height + 40);     //背景
			_control = createBackgroud( 20,  20, 0xff0000);                        //右下角的控制块
			_playbutton = createPreaseButton(1.2 * _radius / 3, 1.2 * _radius );   //开始按钮
			_parsebutton = createPlayButton(1.2 * _radius );                       //暂停按钮
			_textArea = new TextField;                                             //显示文本框
			_size = new TextField;                                                 //字号
			_input = new TextField;                                                //字号输入框
			var b_txt:String = _textFormat.bold?"N":"B";                           //是否加粗
			_blod = createCircleButton(b_txt, _radius);                            //加粗按钮
			_close = createRectButton("关  闭", _width, _height);                  //关闭按钮
			_clear = createRectButton("清  屏",_width,_height);                    //清除按钮
			_textArea.width = this._width;
			_textArea.height = this._height;
			_textArea.border = true;
			_textArea.multiline = true;
			_textArea.wordWrap  = true;
			_size.text = "字号"
			_size.selectable = false;
			_input.text = _textFormat.size?String(_textFormat.size):"12";
			_input.type = TextFieldType.INPUT;
			_input.maxChars = 2;
			_input.border = true;
			_input.restrict = "0-9";
			_input.width = 20;
			_input.height = 18;
			_control.alpha = 0;
			_playbutton.visible = _state;
			_parsebutton.visible = !_state;
			
			_backgroud.x = _backgroud.y = -10;
			_size.y = _textArea.y + _textArea.height + distance;
			_close.y = _size.y ;
			_close.x = _textArea.x + _textArea.width - _width;
			_clear.y = _size.y ;
			_clear.x = _close.x - _width - 10;
			_input.y = _size.y ;
			_input.x = _size.x + _size.textWidth + 10;
			_blod.y = _size.y ;
			_blod.x = _input.x + _input.width + 20;
			_playbutton.y = _size.y +_height / 2 - _playbutton.height / 2;
			_playbutton.x = _blod.x + _blod.width + 20;
			_parsebutton.y = _playbutton.y;
			_parsebutton.x = _playbutton.x;
			_control.x = _backgroud.x + _backgroud.width - _control.width;
			_control.y = _backgroud.y + _backgroud.height - _control.height;
			
			$target.addChild(_backgroud);
			$target.addChild(_control);
			$target.addChild(_textArea);
			$target.addChild(_size);
			$target.addChild(_input);
			$target.addChild(_close);
			$target.addChild(_clear);
			$target.addChild(_blod);
			$target.addChild(_parsebutton);
			$target.addChild(_playbutton);
			_input.addEventListener(FocusEvent.FOCUS_IN, focusInHandler, false, 0, true);
			_input.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler, false, 0, true);
			_blod.addEventListener(MouseEvent.MOUSE_DOWN, blodMouseDownHandler, false, 0, true);
			_clear.addEventListener(MouseEvent.MOUSE_DOWN, clearMouseDownHandler, false, 0, true);
			_close.addEventListener(MouseEvent.MOUSE_DOWN, closeMouseDownHandler, false, 0, true);
			_backgroud.addEventListener(MouseEvent.MOUSE_DOWN, bgMouseDownHandler, false, 0, true);
			_backgroud.addEventListener(MouseEvent.MOUSE_UP, bgMouseUpHandler, false, 0, true);
			_playbutton.addEventListener(MouseEvent.MOUSE_DOWN, playMouseDownHandler, false, 0, true);
			_parsebutton.addEventListener(MouseEvent.MOUSE_DOWN, parseMouseDownHandler, false, 0, true);
			_control.addEventListener(MouseEvent.MOUSE_OVER, controlMouseOverHandler, false, 0, true);
			_control.addEventListener(MouseEvent.MOUSE_OUT, controlMouseOutHandler, false, 0, true);
			_control.addEventListener(MouseEvent.MOUSE_DOWN, controlMouseDownHandler, false, 0, true);
			_control.addEventListener(MouseEvent.MOUSE_UP, controlMouseUpHandler, false, 0, true);
		}
		
		private function playMouseDownHandler(e:MouseEvent):void
		{
			_playbutton.visible = !_state;
			_parsebutton.visible = _state;
			_parseArray = Debug.array;
			_state = false;
		}
		
		private function parseMouseDownHandler(e:MouseEvent):void
		{
			_playbutton.visible = !_state;
			_parsebutton.visible = _state;
			_state = true;
		}
		
		private function controlMouseOverHandler(e:MouseEvent):void
		{
			_sprite.addChild(_twoSharp);
			_sprite.addChild(_control);
			_twoSharp.x = _control.x + _control.width / 2;
			_twoSharp.y = _control.y + _control.height / 2;
			Mouse.hide();
		}
		
		private function controlMouseOutHandler(e:MouseEvent):void
		{
			if (!_controlClick) 
			{
				if (_sprite.contains(_twoSharp))
				_sprite.removeChild(_twoSharp);
				_sprite.addChildAt(_control, 1);
				Mouse.show();
			}
		}
		
		private function controlMouseUpHandler(e:MouseEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER, _controlTimerHandler);
			_root.stage.removeEventListener(MouseEvent.MOUSE_UP, controlMouseUpHandler);
			if (_sprite.contains(_twoSharp))
			_sprite.removeChild(_twoSharp);
			_sprite.addChildAt(_control, 1);
			Mouse.show();
			_controlClick = false;
		}
		
		private function controlMouseDownHandler(e:MouseEvent):void
		{
			var dx = _control.x - _sprite.mouseX;
			var dy = _control.y - _sprite.mouseY;
			_controlTimerHandler=function (e:Event):void
			{
				_control.x = _sprite.mouseX + dx;
				_control.y = _sprite.mouseY + dy;
				if (_control.x + _control.width - 10 < minWidth)
				_control.x = minWidth + 10 - _control.width;
				if (_control.y + _control.height - 30 < minHeight)
				_control.y = minHeight + 30 - _control.height;
				_twoSharp.x = _control.x + _control.width / 2 ;
				_twoSharp.y = _control.y + _control.height / 2 ;
				RefreshUI();
				_sprite.addChildAt(_twoSharp , _sprite.numChildren - 2);
			}
			_timer.addEventListener(TimerEvent.TIMER, _controlTimerHandler, false, 0, true);
			_timer.start();
			_root.stage.addEventListener(MouseEvent.MOUSE_UP, controlMouseUpHandler, false, 0, true);
			_controlClick = true;
		}
		
		private function RefreshUI():void
		{
			_width = _control.x + _control.width - 10;
			_height = _control.y + _control.height - 30;
			clearDisplayObjectContainer(_sprite);
			createUI(_sprite);
			traceDebug(_sprite);
		}
		
		private function bgMouseUpHandler(e:MouseEvent):void
		{
			_sprite.stopDrag();
		}
		
		private function bgMouseDownHandler(e:MouseEvent):void
		{
			_sprite.startDrag();
		}
		
		private function blodMouseDownHandler(e:MouseEvent):void
		{
			if (!_blodClick)
			{
				e.currentTarget.getChildAt(0).text="N"
				_textFormat.bold = true;
				
			}else {
				e.currentTarget.getChildAt(0).text="B"
				_textFormat.bold = false;
			}
			_textArea.setTextFormat(_textFormat);
			_blodClick = !_blodClick;
		}
		
		private function closeMouseDownHandler(e:MouseEvent = null ):void
		{
			_root.removeChild(_sprite);
			_enter.removeEnterFrame();
			_root.stage.focus = _root.stage ;
		}
		
		private function clearMouseDownHandler(e:MouseEvent):void
		{
			_textArea.htmlText = "";
			Debug.array = [];
			_parseArray = [];
			Debug.line = 0;
		}
		
		private function focusInHandler(e:Event) {
			e.currentTarget.text=""
		}
		
		private function focusOutHandler(e:Event) {
			if (Number(e.currentTarget.text) == 0) e.currentTarget.text ="12";
			if (Number(e.currentTarget.text) < 8) e.currentTarget.text ="8";
			if (Number(e.currentTarget.text) > 24 ) e.currentTarget.text = "24";
			_textFormat.size = Number(e.currentTarget.text);
			_textArea.setTextFormat(_textFormat);
		}
		
		//--------------------创建背景-----------------------------
		private function createBackgroud($width:Number, $height:Number, $color:uint = 0xffffff):Sprite 
		{
			var _sprite:Sprite = new Sprite;
			_sprite.graphics.beginFill($color);
			_sprite.graphics.drawRect(0, 0, $width, $height);
			_sprite.graphics.endFill();
			return _sprite;
		}
		
		//--------------------创建方形按钮---------------------------
		private function createRectButton($text:String, $width:Number, $height:Number, $color:uint = 0x000000 ):Sprite
		{
			var _sprite:Sprite = new Sprite;
			var _txt:TextField = new TextField;
			_sprite.graphics.beginFill($color);
			_sprite.graphics.drawRect(0, 0, $width, $height);
			_sprite.graphics.endFill();
			_txt.text = $text;
			_txt.selectable = false;
			_txt.textColor = 0xffffff;
			_txt.width = _txt.textWidth + 3;
			_txt.height = _txt.textHeight + 3;
			_txt.x = $width / 2 - _txt.textWidth / 2;
			_txt.y = $height / 2 - _txt.textHeight / 2;
			_sprite.addChild(_txt);
			_sprite.buttonMode = true;
			_sprite.mouseChildren = false;
			return _sprite;
		}
		
		//--------------------创建圆形按钮---------------------------
		private function createCircleButton($text:String, $radius:Number, $color:uint = 0xff0000 ):Sprite
		{
			var _sprite:Sprite = new Sprite;
			var _txt:TextField = new TextField;
			_sprite.graphics.beginFill($color);
			_sprite.graphics.drawCircle($radius , $radius, $radius);
			_sprite.graphics.endFill();
			_txt.text = $text;
			_txt.selectable = false;
			_txt.textColor = 0xffffff;
			_txt.width = _txt.textWidth + 5;
			_txt.height = _txt.textHeight + 5;
			_txt.x = $radius  - _txt.textWidth / 2-2;
			_txt.y = $radius  - _txt.textHeight / 2-2;
			_sprite.addChild(_txt);
			_sprite.mouseChildren = false;
			_sprite.buttonMode = true;
			return _sprite;
		}
		
		//--------------------创建播放按钮-----------------------------
		private function createPlayButton($width:Number, $color:uint = 0x000000):Sprite 
		{
			var _sprite:Sprite = new Sprite;
			var bg = createBackgroud($width, $width, $color);
			bg.alpha = 0;
			_sprite.graphics.beginFill($color);
			_sprite.graphics.moveTo(0, 0);
			_sprite.graphics.lineTo($width, $width / 2);
			_sprite.graphics.lineTo(0, $width);
			_sprite.graphics.lineTo(0, 0);
			_sprite.graphics.endFill();
			_sprite.addChild(bg);
			_sprite.buttonMode = true;
			return _sprite;
		}
		
		//--------------------创建暂停按钮-----------------------------
		private function createPreaseButton($width:Number, $height:Number,$color:uint = 0x000000):Sprite 
		{
			var _sprite:Sprite = new Sprite;
			var s1 = createBackgroud($width, $height, $color);
			var s2 = createBackgroud($width, $height, $color);
			var bg = createBackgroud($height, $height, $color);
			s2.x = $height -  $width;
			bg.alpha = 0;
			_sprite.addChild(s1);
			_sprite.addChild(s2);
			_sprite.addChild(bg);
			_sprite.buttonMode = true;
			return _sprite;
		}
		
		//--------------------创建双向箭头---------------------------
		private function createTwoSharp($R:Number, $r:Number, $d:Number, $thickness:Number = .1, $color:uint = 0x000000):Sprite 
		{
			var _sprite:Sprite = new Sprite;
			var _sin, _cos;
			_sin = _cos = Math.sin(Math.PI / 4);
			_sprite.graphics.lineStyle($thickness, $color);
			_sprite.graphics.beginFill(0xffffff);
			_sprite.graphics.moveTo(0, 0);
			_sprite.graphics.lineTo($r, 0);
			_sprite.graphics.lineTo($r - $d * _sin  , $d * _sin);
			_sprite.graphics.lineTo($R - $d * _sin  , $R - $r + $d * _sin);
			_sprite.graphics.lineTo($R , $R - $r);
			_sprite.graphics.lineTo($R , $R );
			_sprite.graphics.lineTo($R - $r , $R );
			_sprite.graphics.lineTo( $R - $r + $d * _sin , $R - $d * _sin  );
			_sprite.graphics.lineTo($d * _sin , $r - $d * _sin );
			_sprite.graphics.lineTo(0, $r);
			_sprite.graphics.lineTo(0, 0);
			_sprite.graphics.endFill();
			return _sprite;
		}
		
		//--------------------replace递归---------------------------
		private function replaceTxt($string:String, $a:String, $b:String):*
		{
			var _string = $string.replace($a, $b);
			if (_string.indexOf($a) > -1)
			return replaceTxt(_string, $a, $b);
			else
			return _string;
		}
		
		//--------------------清除显示对象---------------------------
		private function clearDisplayObjectContainer($target:DisplayObjectContainer):void
		{	
			if ($target.numChildren == 0)
			return;
			for (var j:int = $target.numChildren - 1; j >= 0; j-- )
			{
				$target.removeChildAt(j);
			}
		}
		
	}
	
}
class SingletonEnforcer{};