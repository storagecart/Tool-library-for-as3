/*

              .======.
              | INRI |
              |      |
              |      |
     .========'      '========.
     |   _      xxxx      _   |
     |  /_;-.__ / _\  _.-;_\  |
     |     `-._`'`_/'`.-'     |
     '========.`\   /`========'
              | |  / |
              |/-.(  |
              |\_._\ |
              | \ \`;|
              |  > |/|
              | / // |
              | |//  |
              | \(\  |
              |  ``  |
              |      |
              |      |
              |      |
              |      |
  \\    _  _\\| \//  |//_   _ \// _
 ^ `^`^ ^`` `^ ^` ``^^`  `^^` `^ `^
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.fp10.a3d 
{
	import flash.display.*;
	import flash.geom.Point;
	
	import tool.fp10.a3d.core.Material;
	import tool.fp10.a3d.core.FP10Object3d;
	import tool.display.addChildAndInit;
	
	/**
	* 基本面(仅支持 flash player10.0 以上版本)
	* 
	* 导入类      
	* --CODE: import tool.fp10.a3d.Plane;
	* 
	* 实例化
	* --CODE: var plane:Plane = new Plane(250,350,[new image  ,new info  ]);     //后面两个是材质
	* 
	* z排序(开、关)
	* --CODE: plane.zorder(true);
	* 
	* 旋转
	* --CODE: plane.rotate("y",2.5);
	* 
	* 获取两个面的材质
	* --CODE: plane.face1; plane.face2;  
	* --CODE: plane.material.all		//包含材质的数组;
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 10.0/Flash 10.1
	* @tiptext
	*
	*/
	public class Plane extends FP10Object3d
	{
		private var _face1:*;
		private var _face2:*;
		
		public function Plane($width:Number , $height:Number, $material:Array ) 
		{
			material = new Material($material, $width, $height );
			
			var point:Point = A3D.center ? new Point( 0, 0) : new Point( -$width / 2, -$height / 2 );
			
			if(material.faceNumber>1)
			{
				_face1 = material.all[0];
				_face2 = material.all[1];
				
				var sprite1:Sprite = new Sprite;
				var sprite2:Sprite = new Sprite;
				
				addChildAndInit(sprite2, _face2 , { x:point.x, y: point.y } );
				addChildAndInit(sprite1, _face1 , { x:point.x, y:point.y } );
				sprite2.rotationY = 180;
				
				addChildAndInit(this, sprite2, {  z: 0.01 } );
				addChildAndInit(this, sprite1, {  z: -0.01 } );
			}else if (material.faceNumber == 1)
			{
				_face1 = material.all[0];
				_face2 = material.all[0];
				
				var sprite0:Sprite = new Sprite;
				
				addChildAndInit(sprite0, _face1 , { x:point.x, y:point.y , z:0 } );
				
				addChildAndInit(this, sprite0);
			}
			
			zorder = true;
		}
		
		public function get face1():* { return _face1; }
		
		public function get face2():* { return _face2; }
		
	}
	
}