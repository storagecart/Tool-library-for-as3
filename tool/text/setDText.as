/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.text 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	*
	* 快速设置动态文本
	* 
	* --CODE: import tool.text.BitmapText
	* --CODE: var bt=new BitmapText(name_txt);
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public function setDText($textField:TextField, $color:int = -1, $size:int = -1, $selectable:Boolean = false , $mouseEnabled:Boolean = false )
	{
		var format:TextFormat = new TextFormat();
		
		if($color!=-1) format.color = $color;
		if ($size != -1) format.size = $size;
		
		$textField.selectable = $selectable;
		$textField.mouseEnabled = $mouseEnabled;
		$textField.setTextFormat(format);
	}

}