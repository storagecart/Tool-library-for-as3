/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.component.text 
{
	import flash.text.*;
	import flash.events.*;
	import flash.utils.Dictionary;
	
	/**
	* InputText类是一个用来设置输入文本的静态类
	* --CODE: import tool.component.text.InputText;
	* --CODE: InputText.add(t1,t2,t3,t4);
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class InputText 
	{	
		public function InputText() 
		{
			throw(new Error("这是静态类无法被实例化!"));
		}
		
		/**
		* 设置输入文本
		*
		* @param		... rest	        *    				* 要添加的TextField对象
		*/
		public static function add(...rest):void
		{
			var length:Number = rest.length;
			if (length == 0) throw(new Error("请传入参数"));
			var _dict = new Dictionary(); 
			for (var i:uint = 0; i < length; i++ )
			{
				var _txt = rest[i];
				if (!(_txt is TextField)) continue;
				_txt.addEventListener(FocusEvent.FOCUS_IN, focusInHandler, false, 0, true);
				_txt.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler, false, 0, true);
				_txt.tabIndex = i;
				_txt.tabEnabled = true;
			}
			
			function focusInHandler(e:FocusEvent):void
			{
				_dict[e.currentTarget] = e.currentTarget.text;
				e.currentTarget.text = "";
			}
			
			function focusOutHandler(e:FocusEvent):void
			{
				if (e.currentTarget.text == "")
				e.currentTarget.text = _dict[e.currentTarget];
			}
		}
		
	}
	
}