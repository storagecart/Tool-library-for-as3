/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.display.quick 
{
	import flash.utils.Dictionary;
	/**
	* 保存 QuickMovieClip 对象的数组
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class QuickMovieClipArray 
	{
		public static var movieClipArray:Dictionary ;
		
		public function QuickMovieClipArray()
		{
			throw(new Error("这是抽象类，无法被实例化！"));
		}
	}
	
}