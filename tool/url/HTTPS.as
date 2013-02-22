/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.url 
{
	/**
	* url随机数
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class HTTPS 
	{
		
		public static function get RAN():String
		{
			return "?" + Math.random();
		}
		
		public static function get RAN2():String
		{
			return "&abcdefg=" + String(Math.random());
		}
		
	}

}