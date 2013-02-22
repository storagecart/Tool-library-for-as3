/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.fp10.a3d 
{
	import flash.geom.*;
		
	/**
	* 摄像机——3D(仅支持 flash player10.0 以上版本)
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 10.0/Flash 10.1
	* @tiptext
	*
	*/
	public class Camera3D 
	{
		public  var scene:Scene3D;
		
		public function Camera3D() 
		{
			
		}
		
		public function moveTo($point:Array, $time:Number):void
		{
			if (scene)
			{
				scene.x -= $point.x;
				scene.y -= $point.y;
				scene.z -= $point.z;
			}
		}
		
	}
	
}