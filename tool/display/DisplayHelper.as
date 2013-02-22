/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.display 
{
	import flash.display.*;
	
	/**
	* DisplayObject类用于处理显示对象的一些简便操作。
	* 
	* 清空一个显示容器的所有孩子。                 
	* --CODE: DisplayHelper.clear(container_mc);
	* 
	* 将显示对象移至所在容器最顶层。               
	* --CODE: DisplayHelper.toTop(target_mc);
	* 
	* 将显示对象移至所在容器最底层。               
	* --CODE: DisplayHelper.toBottom(target_mc);
	* 
	* 将显示对象移至所在容器指定层。               
	* --CODE: DisplayHelper.toLayer(target_mc, 111);   
	* @第二个参数可以传入  DisplayHelper.TOP_LAYER|DisplayHelper.BOTTOM_LAYER|DisplayHelper.UP_LAYER|DisplayHelper.DOWN_LAYER
	* 
	* 显示对象所有孩子对齐到整数点.                
	* --CODE: DisplayHelper.autoAlgin(this);
	* 
	* 公共属性
	* DisplayHelper.TOP_LAYER            		    //最顶层
	* DisplayHelper.BOTTOM_LAYER					//最底层
	* DisplayHelper.UP_LAYER						//上一层
	* DisplayHelper.DOWN_LAYER						//下一层
	*
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class DisplayHelper 
	{
		public static const TOP_LAYER:Number = Number.MAX_VALUE;                                      //最顶层
		public static const BOTTOM_LAYER:Number = Number.MIN_VALUE;                                   //最底层
		public static const UP_LAYER:Number = Number.POSITIVE_INFINITY;                               //上一层
		public static const DOWN_LAYER:Number = Number.NEGATIVE_INFINITY;                             //下一层
		
		public function DisplayHelper()
		{
			throw(new Error("这是静态类无法被实例化!"));
		}
		
		/**
		* 清除DisplayObjectContainer的所有孩子
		*
		* @param		$target		        Object				* 要处理的对象/可以传入数组[mc1,mc2,...]
		* @return							Boolean				成功返回true,否则false
		*/
		public static function clear($target:Object = null):Boolean {
			if (!$target) { return false };
			
			var target_array:Array, bool:Boolean = false;
			if ($target is Array) 
			target_array = $target.concat();
			else
			target_array = [$target];
			
			for (var i:uint = 0; i < target_array.length; i++ ) 
			{
				var target_object:* = target_array[i];
				if (!(target_object is DisplayObjectContainer))
				continue;
				
				if (target_object.numChildren == 0)
				continue;
				for (var j:int = target_object.numChildren - 1; j >= 0; j-- )
				{
					target_object.removeChildAt(j);
				}
				bool = true;
			}
			
			if(bool)
			return true;
			else
			return false;
		}
		
		/**
		* 将diaplayObject移至所在容器的最顶层
		*
		* @param		$target		        Object				* 要处理的对象
		* @return							Boolean				成功返回true,否则false
		*/
		public static function toTop($target:Object = null):Boolean {
			if (!$target) { return false };
			if ($target.parent == null) { return false };
			
			var target_container:DisplayObjectContainer = $target.parent as DisplayObjectContainer;
			target_container.setChildIndex($target as DisplayObject, target_container.numChildren - 1);
			return true;
		}
		
		/**
		* 将diaplayObject移至所在容器的最底层
		*
		* @param		$target		        Object				* 要处理的对象
		* @return							Boolean				成功返回true,否则false
		*/
		public static function toBottom($target:Object = null):Boolean {
			if (!$target) { return false };
			if ($target.parent == null) { return false };
			
			var target_container:DisplayObjectContainer = $target.parent as DisplayObjectContainer;
			target_container.setChildIndex($target as DisplayObject, 0);
			return true;
		}
		
		/**
		* 将diaplayObject移至所在容器的指定层级
		* 注：当层级超过容器时，为顶层；负数是为底层。
		* 
		* @param		$target		        Object				* 要处理的对象
		* @param		$layer		        Number				* 指定要移动到的层级
		* @return							Boolean				成功返回true,否则false
		*/
		public static function toLayer($target:Object = null,$layer:Number = Number.MAX_VALUE):Boolean {
			if (!$target) { return false };
			if ($target.parent == null) { return false };
			
			var target_container:DisplayObjectContainer = $target.parent as DisplayObjectContainer;
			var index:Number;
			switch ($layer)
			{ 
				case Number.MAX_VALUE:
					index = target_container.numChildren - 1;
					break;
				case DisplayHelper.TOP_LAYER:
					index = target_container.numChildren - 1;
					break;
				case DisplayHelper.BOTTOM_LAYER:
					index = 0;
					break;
				case DisplayHelper.UP_LAYER:
					index = target_container.getChildIndex($target as DisplayObject) + 1;
					break;
				case DisplayHelper.DOWN_LAYER:
					index = target_container.getChildIndex($target as DisplayObject) - 1;
					break;
				default:
					index = $layer;
					break;
			}

			index = index > (target_container.numChildren - 1)?(target_container.numChildren - 1):index;
			index = index < 0?0:index;
			target_container.setChildIndex($target as DisplayObject, index);
			return true;
		}
		
		/**
		* 显示对象所有孩子对齐到整数点
		*
		* @param		$target	            DisplayObjectContainer				* 要处理的对象
		*/
		public static function autoAlgin($target:DisplayObjectContainer = null ):void
		{
			var depth:Number = $target.numChildren;
			if ($target == null) return ;
			algin($target);
			if (depth == 0) return  ;
			for (var i:uint = 0; i < depth; i++ )
			{
				var sub:DisplayObject = $target.getChildAt(i);
				algin(sub);
				if(sub is DisplayObjectContainer)
				DisplayHelper.autoAlgin(sub as DisplayObjectContainer);
			}
			
			function algin($target):void
			{
				$target.x=Math.floor($target.x);
				$target.y=Math.floor($target.y);
			}
		}
		
	}
	
}
