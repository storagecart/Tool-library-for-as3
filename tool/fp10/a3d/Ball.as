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
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;
	
	import tool.fp10.a3d.core.Material;
	import tool.fp10.a3d.core.FP10Object3d;
	import tool.display.addChildAndInit;
	
	/**
	* 球(仅支持 flash player10.0 以上版本)
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 10.0/Flash 10.1
	* @tiptext
	*
	*/
	public class Ball extends FP10Object3d
	{
		private var _projectedVertices:Vector.<Number>;
		private var _vertices:Vector.<Number>;
		private var _matrix3d:Matrix3D;
		private var _paraVector:Vector3D;
		private var _uvtData:Vector.<Number>;
		private var _indices:Vector.<int>;
		private var _texture:*;
		
		public var rows:int = 32;
		public var cols:int = 16;

		public function Ball($radius:Number = 100, $texture:* = 0xff0000)
		{		
			_texture = $texture;
			_matrix3d = new Matrix3D();
			_paraVector = new Vector3D();
			_vertices = new Vector.<Number>();
			_projectedVertices = new Vector.<Number>();
			_indices = new Vector.<int>();
			_uvtData = new Vector.<Number>();
			
			for(var i:int = 0; i<rows; i++)
			{
				var ix = i/(rows-1)*Math.PI*2.0;
				
				for(var j:int = 0; j<cols; j++)
				{
					var iy = (j/(cols-1) - 0.5)*Math.PI;
					
					_paraVector = new Vector3D(Math.cos(iy)*Math.cos(ix), Math.sin(iy), Math.cos(iy)*Math.sin(ix));
					_paraVector.scaleBy($radius);
					_vertices.push(_paraVector.x,_paraVector.y,_paraVector.z);
					_uvtData.push( i/(rows-1),j/(cols-1), 0.0);
				}
			}
			
			var ii:int =0;
			for (var ik:int=0 ; ik!=rows-1; ik++) 
			{
				for (var jk:int=0 ; jk!=cols-1; jk++) 
				{
					_indices.push( ii, ii + cols + 1, ii + 1, ii + cols, ii + cols + 1, ii++);
				}
				ii++;
			}
			
			render();
		}
		
		private function render():void
		{
			Utils3D.projectVectors(_matrix3d, _vertices, _projectedVertices, _uvtData);
			
			graphics.clear();
			if(_texture is BitmapData)
			{
				graphics.beginBitmapFill(_texture,null,false,false);
				graphics.drawTriangles(_projectedVertices, _indices, _uvtData, TriangleCulling.NEGATIVE);
			}else
			{
				graphics.beginFill(_texture);
				graphics.lineStyle(1,_texture);
				graphics.drawTriangles(_projectedVertices,_indices);
			}
			graphics.endFill();			
		}
		
	}

}