/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.object 
{
	import flash.utils.*;
	
	/**
	* 获取对象所属的类
	* 
	* --CODE: var ClassReference:Class  = AClass.getClass("MovieClip");
	* --CODE: var obj=new ClassReference();
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class AClass 
	{
		public static function newObject($name):Object
		{
			var ClassReference:Class  = AClass.getClass($name);
			var obj:Object = new ClassReference();
			return obj;
		}
		
		/**
		* 返回 name 参数指定的类的类对象引用。
		* 
		*/
		public static function getClass($name:String ) :*
		{
			return getDefinitionByName($name);
		}
		
		/**
		* 返回 value 参数指定的对象的基类的完全限定类名。
		* 
		*/
		public static function getClassName($value:* , $super:Boolean = false ) :String
		{
			if ($super)
				return getQualifiedSuperclassName($value);
			else
				return getQualifiedClassName($value);
		}
		
	}
	
}