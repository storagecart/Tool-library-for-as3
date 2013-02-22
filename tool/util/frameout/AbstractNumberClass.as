/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.util.frameout
{

	/**
	* AbstractNumberClass类用来辅助setFrameout类，不能实例化。
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class AbstractNumberClass 
	{
		
		public static var number:Number = -1;
		
		public static var array:Array = [];

		public function AbstractNumberClass() 
		{
			throw(new Error("这是静态类无法被实例化!"));
		}
		
	}
	
}