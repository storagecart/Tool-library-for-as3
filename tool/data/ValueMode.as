/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.data 
{
	
	/**
	* ValueMode
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class ValueMode 
	{
		public static const XMLS:String = "xmls";
		public static const VARIABLES:String = "variables";
		public static const STRING:String = "string";
		
		public function ValueMode() 
		{
			throw(new Error("这是静态类无法被实例化!"));
		}

	}
	
}