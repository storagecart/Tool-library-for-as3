/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.display 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import tool.object.some;
	import tool.display.DisplayHelper;
	
	/**
	* 添加显示对象并且初始化
	* 
	* --CODE: import tool.display.addChildAndInit;
	* --CODE: addChildAndInit(this, new LogoMC,{x:100,y:100},20);
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0, Flash 10.0
	* @tiptext
	*
	*/
	
	public function addChildAndInit($container:DisplayObjectContainer, $target:DisplayObject, $object:Object = null , $depth:int = -1 ):* 
	{
		$container.addChild($target);
		some($target, $object);
			
		if ($depth != -1)
			DisplayHelper.toLayer($target, $depth);
			
		return $target;
	}
	
}