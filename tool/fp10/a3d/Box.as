/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.fp10.a3d 
{
	import tool.display.addChildAndInit;
	
	import tool.fp10.a3d.core.FP10Object3d;
	import tool.fp10.a3d.core.Material;
	import tool.fp10.a3d.move.zOrder;
	
	/**
	* 盒子/六面体(仅支持 flash player10.0 以上版本)
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 10.0/Flash 10.1
	* @tiptext
	*
	*/
	public class Box extends FP10Object3d
	{
		private var _face1:*; 		//前
		private var _face2:*; 		//后
		private var _face3:*; 		//上
		private var _face4:*; 		//下
		private var _face5:*; 		//左
		private var _face6:*; 		//右
		
		public function Box($width:Number , $height:Number, $length:Number, $material:Array ) 
		{
			var thisMaterial:Array = $material.concat([]);
			
			if ($material.length < 6)
			{
				for (var i:uint = $material.length ; i < 6; i++ )
				{
					thisMaterial.push($material[0]);
				}
			}
			
			material  = new Material(thisMaterial, $width , $height, $length);
			
			_face1 = material.all[0];
			_face2 = material.all[1];
			_face3 = material.all[2];
			_face4 = material.all[3];
			_face5 = material.all[4];
			_face6 = material.all[5];
			
			var plane1:Plane = new Plane($width, $height, [_face1]);
			var plane2:Plane = new Plane($width, $height, [_face2]);
			var plane3:Plane = new Plane($width, $length, [_face3]);
			var plane4:Plane = new Plane($width, $length, [_face4]);
			var plane5:Plane = new Plane($length, $height, [_face5]);
			var plane6:Plane = new Plane($length, $height, [_face6]);
			
			addChildAndInit(this, plane1, { zorder:false, z: -$length / 2 } );
			addChildAndInit(this, plane2, { zorder:false, z:  $length / 2 , rotationY:180 } );
			
			addChildAndInit(this, plane3, { zorder:false, y:  -$height / 2 , rotationX:-90 } );
			addChildAndInit(this, plane4, { zorder:false, y:  $height / 2 , rotationX: 90 } );
			
			addChildAndInit(this, plane5, { zorder:false, x:  -$width / 2 , rotationY:90 } );
			addChildAndInit(this, plane6, { zorder:false, x:  $width / 2 , rotationY: -90 } );
			
			zOrder(this);
		}
		
		
		public function get face1():* { return _face1; }
		
		public function get face2():* { return _face2; }
		
		public function get face3():* { return _face3; }
		
		public function get face4():* { return _face4; }
		
		public function get face5():* { return _face5; }
		
		public function get face6():* { return _face6; }
		
	}
	
}