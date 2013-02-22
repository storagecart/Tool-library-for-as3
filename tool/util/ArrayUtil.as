/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.util 
{
	/**
	* 数组辅助功能
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class ArrayUtil 
	{
		
		//合并数组
		public static function merge(...rest):Array 
		{
			var length      :int = rest.length;
			var restArray   :Array = [];
			var array:		Array = [];
			
			for (var i:uint = 0; i < length; i++ )
			{
				if (rest[i] is Array)
				{
					restArray.push(rest[i]);
				}
			}

			if (restArray.length == 0)
			{
				throw(new Error("请传入正确参数！"));
				return array;
			}
			
			array=restArray[0].concat();
			for (i = 1; i < restArray.length ; i++)
			{
				for (var j:uint = 0; j < restArray[i].length; j++) 
				{
					array.push(restArray[i][j]);
				}
			}
			
			return array;
		}
		
		//打乱数组
		public static function upset($arr:Array):Array
		{
			var my_array:Array = $arr.concat([]);
				
			for (var i = 0; i < $arr.length; i++)
			{
				var a1:int = Math.random() * $arr.length;
				var a2:* = my_array[i];
				my_array[i] = my_array[a1];
				my_array[a1] = a2;
			}
			
			return my_array;
		}
		
	}
	
}