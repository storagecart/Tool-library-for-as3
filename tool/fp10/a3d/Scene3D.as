/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.fp10.a3d
{	
	import tool.fp10.a3d.Container3D;
	
	/**
	* 主场景(仅支持 flash player10.0 以上版本)
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 10.0/Flash 10.1
	* @tiptext
	*
	*/
	public class Scene3D extends Container3D
	{
		private var _camera:Camera3D;
		
		public function Scene3D() 
		{
			
		}
		
		public function get camera():Camera3D { return _camera; }
		
		public function set camera(value:Camera3D):void 
		{
			_camera = value;
			_camera.scene = this;
		}
		
	}
	
}