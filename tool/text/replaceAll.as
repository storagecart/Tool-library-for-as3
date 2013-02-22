/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.text 
{
	
	/**
	*
	* 替换字符串中出现的所有特定字符
	* 
	* --CODE: import tool.text.replaceAll
	* --CODE: replaceAll("12abdr34sfger#sdfsdf","s","0");
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	/**
	* replaceAll
	* @param		$string		      	  	String		 				 * 要处理的字符串
	* @param		$a		        		String		        		 * 被替换的字符
	* @param		$b		       	 		String		     		     * 替换的字符
	*/  
	public function replaceAll ($string:String, $a:String, $b:String):String
	{
		var _string = $string.replace($a, $b);
		
		if (_string.indexOf($a) > -1)
		return replaceAll(_string, $a, $b);
		else
		return _string;
	}
	
}