/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.fp10.a3d.move 
{
	import flash.geom.Matrix3D;
	import tool.fp10.a3d.core.FP10Object3d;
	
	/**
	* Z轴排序函数(仅支持 flash player10.0 以上版本)
	* 
	* --CODE: zOrder(box);
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 10.0/Flash 10.1
	* @tiptext
	*
	*/
	public function zOrder($container:FP10Object3d):void 
	{
		var targetArray:Array = [];
		
		for (var i:uint = 0; i < $container.numChildren; i++) 
		{ 
			var target:* = $container.getChildAt(i);
			var zPoint:Number ;
			
			if (!target.transform.matrix3D) continue;
			
			if ($container.root)
				zPoint = target.transform.getRelativeMatrix3D($container.root).position.z;
			else
				zPoint = target.transform.getRelativeMatrix3D($container).position.z;
			
			targetArray.push({
							"t3d": target,
							"z"  : zPoint
				});
			
		} 
		
		targetArray.sortOn("z", Array.NUMERIC | Array.DESCENDING); 
		
		for (i = 0; i < targetArray.length; i++) 
		{ 
			$container.setChildIndex(targetArray[i].t3d, i); 
		} 
	
	}
	
}