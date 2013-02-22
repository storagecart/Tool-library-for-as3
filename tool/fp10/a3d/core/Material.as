/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.fp10.a3d.core 
{
	import flash.display.*;
	import tool.fp10.a3d.A3D;
	
	/**
	* 材质(仅支持 flash player10.0 以上版本)
	* 
	* 导入类      
	* --CODE: import tool.fp10.a3d.core.Material;
	* 
	* 获取材质的数目
	* --CODE: plane.material.faceNumber;
	* 
	* 获取材质的数组
	* --CODE: plane.material.all;
	* 
	* 获取材质的宽高
	* --CODE: plane.material.width;  plane.material.height;
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 10.0/Flash 10.1
	* @tiptext
	*
	*/
	public class Material 
	{
		private var _faceNumber		:uint = 0;
		private var _all			:Array;
		private var _width			:Number;
		private var _height			:Number;
		private var _length			:Number;
		
		public function Material($material:Array , $width:Number = 100 , $height:Number = 100 , $length:Number = 0 ) 
		{
			_faceNumber = $material.length;
			_width		= $width;
			_height		= $height;
			_length     = $length;
			_all		= [];
			
			for (var i:uint = 0; i < $material.length; i++ )
			{
				var material = $material[i];
				
				if (material is DisplayObject)
				{
					material.width = _width, material.height = _height;
					_all.push(material);
				}else if(material is Number)
				{
					_all.push(colorMaterial(material));
				}	
			}
		}
		
		public function get faceNumber():uint { return _faceNumber; }
		
		public function get all():Array { return _all; }
		
		public function get width():Number { return _width; }
		
		public function get height():Number { return _height; }
		
		public function get length():Number { return _length; }
		
		
		private function colorMaterial($material:int):Sprite
		{
			var shape:Sprite = new Sprite;
			shape.graphics.beginFill($material);
			if (A3D.center)
				shape.graphics.drawRect( -_width / 2 , -_height / 2 , _width, _height);
			else
				shape.graphics.drawRect(0, 0, _width, _height);
				
			shape.graphics.endFill();
			
			return shape;
		}
		
	}
	
}