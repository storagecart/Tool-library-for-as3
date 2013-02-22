/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.component.text 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	/**
	* 打字效果动态文本
	* 
	* 导入类       
	* --CODE: import tool.component.text.Typewriter;
	* 
	* 使用
	* --CODE: var time=100;                                          	 //打字的间隔时间
	* --CODE: var txtgroup="6#8#10#13#14#16#17";                         //控制节奏,模拟逐个词汇的输入(格式:a#b#c ,[其中a,b,c表示第几个字停顿])
	* --CODE: timeInterval=3;                                            //节奏间隔时间
	* --CODE: Typewriter.print(my_txt,time,txtgroup,timeInterval);
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class Typewriter
	{
		private var _time:          	Number;
		private var _timeInterval:  	Number;
		private var _group:             String;
		
		private var _textField:			TextField;
		private var _otherTextField:    TextField;
		private var _textFormat:        TextFormat;
		private var _text:              String;
		private var _cursor:			Sprite;
		private var i:					uint = 0;
		private var _groupArray:		Array;
		private var _this:				DisplayObjectContainer;
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/**
		* 构造函数
		* @param		$textFiled		      	TextField		 			 * 要设置的TextField对象
		* @param		$time		       		Number	        			 * 打字的间隔时间
		* @param		$group		        	String		     		     * 打字的节奏
		* @param		$timeInterval		    Number		      			 * 节奏间隔时间
		*/  
		public function Typewriter($textFiled:TextField , $time:Number = 500 , $group:String = "" , $timeInterval:Number = 3 ) 
		{
			_textField = $textFiled;
			_otherTextField = new TextField();
			_textFormat = _textField.getTextFormat();
			var height :Number = _textField.textHeight;
			_text = _textField.text;
			_textField.text = "";
			_textField.selectable = false;
			_time = $time;
			_this = $textFiled.parent;
			_timeInterval = $timeInterval;
			_otherTextField.setTextFormat(_textFormat);
			
			_cursor = createCursor(Number(_textFormat.size), 1,Number(_textFormat.color));
			_cursor.x = _textField.x;
			_cursor.y = _textField.y + height;
			_this.addChild(_cursor);
			
			_group = $group;
			_groupArray = _group.split("#");
			
			typing();
		}
		
		/**
		* 打字执行函数
		* @param		$textFiled		      	TextField		 			 * 要设置的TextField对象
		* @param		$time		       		Number	        			 * 打字的间隔时间
		* @param		$group		        	String		     		     * 打字的节奏
		* @param		$timeInterval		    Number		      			 * 节奏间隔时间
		*/  
		public static function print($textFiled:TextField , $time:Number = 500 , $group:String = "", $timeInterval:Number = 3 ):Typewriter
		{
			return new Typewriter($textFiled , $time , $group );
		}
		
		//打字
		private function typing() :void
		{
			var time:Number = _time;
			_textField.appendText( _text.substr(i++, 1));
			_otherTextField.text = _textField.getLineText(_textField.bottomScrollV - 1);
			_otherTextField.setTextFormat(_textFormat);
			_cursor.x = _textField.x + _otherTextField.textWidth + 5;
			_cursor.y = _textField.y + _textField.textHeight;
			
			if (i == _text.length) {
				_this.removeChild(_cursor);
				_otherTextField = null;
				return;
			}
			
			for (var j = 0; j<_groupArray.length; j++) {
				if (i == _groupArray[j]) {
					time = _time * _timeInterval;
				}
			}
			setTimeout(typing, time);
		}
		
		//创建光标
		private function createCursor($width:Number, $heght:Number ,$color:uint=0x000000):Sprite
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill($color, 1);
			sprite.graphics.drawRect(0, 0, $width, $heght);
			sprite.graphics.endFill();
			return sprite;
		}
	}
	
}