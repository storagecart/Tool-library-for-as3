/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.display 
{
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.*;
	
	/**
	* 一个显示对象群组（可以通过控制群组控制所有对象）
	* 
	* 导入类
	* --CODE: import tool.display.DisplayGrpup;
	*
	*  声明对象
	* --CODE: var displayGroup:DisplayGrpup=new DisplayGrpup();
	*
	* 设置对象数组
	* --CODE: displayGroup.subArray=[a1,a2,a3,a4.ball];
	*
	* 删除元素
	* --CODE: displayGroup.remove(a3);
	*
	* 使用
	* --CODE: displayGroup.alpha=.1;
	*
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0, Flash 10.0
	* @tiptext
	*
	*/
	
	public class DisplayGroup extends Shape
	{
		
		public function DisplayGroup()
		{
			addEventListener(Event.ADDED  , addedHandler);
			addEventListener(Event.REMOVED, removedHandler);
		}
		
		private function removedHandler(e:Event):void 
		{
			for (var i:uint = 0; i < subArray.length; i++ )
			{
				parent.removeChild(subArray[i]);
			}
		}
		
		private function addedHandler(e:Event):void 
		{
			for (var i:uint = 0; i < subArray.length; i++ )
			{
				parent.addChild(subArray[i]);
			}
		}
		
		public var subArray:Array = [];

		public function add($display:DisplayObject):void 
		{
			subArray.push($display);
		}
		
		public function remove($display:DisplayObject):void 
		{
			for (var i:uint = 0; i < subArray.length; i++ )
			{
				if ($display == subArray[i])
					subArray[i] = null;
			}
		}
		
		private function setGroup($property:String, $value:*):void
		{
			for (var i:uint = 0; i < subArray.length; i++ )
			{
				if(subArray[i])
				{
					if (DisplayObject(subArray[i]).hasOwnProperty($property) )
						DisplayObject(subArray[i])[$property] = $value;
				}
			}
		}

		override public function set alpha (value:Number) : void
		{
			super.alpha = value;
			setGroup("alpha", value );
		}

		override public function set blendMode (value:String) : void 
		{
			super.blendMode = value;
			setGroup("blendMode", value );
		}

		override public function set cacheAsBitmap (value:Boolean) : void 
		{
			super.cacheAsBitmap = value;
			setGroup("blendMode", value );
		}

		override public function set filters (value:Array) : void
		{
			super.filters = value;
			setGroup("filters", value );
		}

		override public function set mask (value:DisplayObject) : void
		{
			super.mask = value;
			setGroup("mask", value );
		}

		override public function set opaqueBackground (value:Object) : void
		{
			super.opaqueBackground = value;
			setGroup("opaqueBackground", value );
		}

		override public function set rotation (value:Number) : void
		{
			super.rotation = value;
			setGroup("rotation", value );
		}

		override public function set scale9Grid (innerRectangle:Rectangle) : void
		{
			super.scale9Grid = innerRectangle;
			setGroup("scale9Grid", innerRectangle );
		}

		override public function set scaleX (value:Number) : void
		{
			super.scaleX = value;
			setGroup("scaleX", value )
		}

		override public function set scaleY (value:Number) : void
		{
			super.scaleY = value;
			setGroup("scaleY", value );
		}

		override public function set scrollRect (value:Rectangle) : void
		{
			super.scrollRect = value;
			setGroup("scrollRect", value );
		}

		override public function set transform (value:Transform) : void
		{
			super.transform = value;
			setGroup("transform", value );
		}

		override public function set width (value:Number) : void
		{
			super.width = value;
			setGroup("width", value );
		}
		
		override public function set height (value:Number) : void
		{
			super.height = value;
			setGroup("height", value );
		}

		override public function set visible (value:Boolean) : void
		{
			super.visible = value;
			setGroup("visible", value );
		}

		override public function set x (value:Number) : void
		{
			super.x = value;
			setGroup("x", value );
		}

		override public function set y (value:Number) : void
		{
			super.y = value;
			setGroup("y", value );
		}
	}
	
}