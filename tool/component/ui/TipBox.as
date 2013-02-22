/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.component.ui 
{
	import flash.display.*;
	import flash.utils.*;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	/**
	* 提示框TipBox(非显示类)，使用时请下载greensock最新类包
	* 
	* 导入类(包括greensock最新类包)                          				 
	* --CODE:import tool.component.ui.TipBox;
	* --CODE:com.greensock.easing.*;
	* 
	* 提示框出现方式
	* --CODE:TipBox.appear(target,{x:10 ,y:100,alpha:0},{x:20 ,y:200,alpha:1,ease:Back.easeOut},.6,this);
	* 注：第二个参数:开始的属性；	第三个参数：结束的属性；	第四个参数：过程时间；	第五个参数;要添加到的父对象
	* 
	* 相同退场
	* --CODE:TipBox.sameDisAppear(target);
	* 
	* 普通退场
	* --CODE:TipBox.disAppear(target,null,{y:70,alpha:0,ease:Back.easeIn},.3,true);
	* 注：第二个参数:开始的属性；	第三个参数：结束的属性；	第四个参数：过程时间；	第五个参数;是否从父级删除
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class TipBox 
	{
		private static var _dict:Dictionary ;
		
		public static function appear($target:*, $startProperty:Object, $endProperty:Object , $time:Number = .5, $container:DisplayObjectContainer = null ):void
		{
			if (!_dict) _dict = new Dictionary();
			
			if (_dict[$target] == null || _dict[$target] == undefined )
			{
				setProperty($target, $startProperty);
				_dict[$target] = TweenLite.to($target, $time, $endProperty);
			 
				if ($container != null)
					$container.addChild($target);
			}
		}
		
		public static function sameDisAppear($target:* ):void
		{
			if (_dict[$target])
			{
				_dict[$target].reverse();
				setTimeout(removeTarget , _dict[$target].duration * 1000 );
				function removeTarget():void
				{
					if ($target.parent)
						$target.parent.removeChild($target);
						
					delete _dict[$target];
				}
				
			}
		}
		
		public static function disAppear($target:*, $startProperty:Object, $endProperty:Object , $time:Number = .5 , $remove:Boolean = true ):void
		{
			setProperty($target, $startProperty);
			$endProperty["onComplete"] = completeFUN;
			TweenLite.to($target, $time, $endProperty);
			
			function completeFUN():void
			{
				if ($remove)
				{
					if ($target.parent)
						$target.parent.removeChild($target);
				}
				
				delete _dict[$target];
			}
		}
		
		private static function setProperty($target:*, $startProperty:Object = null ):void
		{
			if ($startProperty == null)
				return;
				
			for (var properties in $startProperty )
			{
				if ($target.hasOwnProperty(properties))
				{
					$target[properties] = $startProperty[properties];
				}
			}
		}
	}
	
}