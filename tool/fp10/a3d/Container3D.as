/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.fp10.a3d 
{
	import flash.display.*;
	
	import tool.fp10.a3d.core.FP10Object3d;
	import tool.display.DisplayHelper;
	
	/**
	* 3d容器方便控制属性(仅支持 flash player10.0 以上版本)
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 10.0/Flash 10.1
	* @tiptext
	*
	*/
	public class Container3D  extends FP10Object3d
	{
		
		override public function addChild ($child:DisplayObject) : DisplayObject
		{	
			if (!$child.transform.matrix3D)
				$child.z = 0;
				
			var display:DisplayObject = super.addChild($child);
			return display;
		}
		
		public function removeAllChild():void
		{
			DisplayHelper.clear(this);
		}
		
		override public function destory():void
		{
			for (var i:uint = 0; i < numChildren; i++ )
			{
				var obj:FP10Object3d = getChildAt(i) as FP10Object3d;
				obj.destory();
			}
			
			this.removeEventListener(_listenerArray[i].type, _listenerArray[i].listener, _listenerArray[i].useCapture);
			_listenerArray = [];
			
			bright = false;
			zorder = false;
		}
	}
	
}