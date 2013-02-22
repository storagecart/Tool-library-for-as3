/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.fp10.a3d.core 
{
	
	/**
	* 3D对象接口(仅支持 flash player10.0 以上版本)
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 10.0/Flash 10.1
	* @tiptext
	*
	*/
	public interface IFP10Object3d 
	{
		function get bright():*;
		
		function set bright(value:*):void ;
		
		function get zorder():Boolean;
		
		function set zorder(value:Boolean):void ;
	
		function destory():void;
		
		function to2D():void;
	
	}
	
}