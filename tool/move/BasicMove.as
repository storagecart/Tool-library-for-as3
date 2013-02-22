/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.move 
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	/**
	* 简单的运动方式
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class BasicMove 
	{	
		public static var minSpace:					Number = .5;
		private static var v:						Number = 0;
		
		/**
		* 缓动公式
		* 
		* @param		$object		      	  		Object		 				 * 要处理的对象
		* @param		$property		        	String		        		 * 对象的属性
		* @param		$targetValue		       	Number		     		     * 目标数值
		* @param		$easing		       		 	Number		      			 * 缓动系数
		* @return						        	Boolean		         		 * 是否到达目标
		*/  
		public static function easingMove($object:Object, $property:String, $targetValue:Number, $easing:Number = 5 ):Boolean
		{
			$easing = __formatEasing($easing);
			
			if (Math.abs($targetValue-$object[$property]) <= minSpace)
			{
				$object[$property] = $targetValue;
				return true;
			}else {
				$object[$property] += ($targetValue-$object[$property]) / $easing;
				return false;
			}
		}
		
		/**
		* 弹性公式
		* 
		* @param		$object		      	  		Object		 				 * 要处理的对象
		* @param		$property		        	String		        		 * 对象的属性
		* @param		$targetValue		       	Number		     		     * 目标数值
		* @param		$elastic		       		Number		      			 * 弹性系数
		* @param		$obstacle		       		Number		      			 * 摩擦系数（速度衰减快慢）
		* @return						        	Boolean		         		 * 是否到达目标
		*/  
		public static function elasticMove ($object:Object, $property:String, $targetValue:Number, $elastic:Number = 5, $obstacle:Number = .9 ):Boolean
		{
			$elastic = __formatEasing($elastic);
			
			if (Math.abs($targetValue-$object[$property]) <= minSpace)
			{
				$object[$property] = $targetValue;
				return true;
			}else {
				v += ($targetValue-$object[$property]) / $elastic;
				v *= $obstacle;
				$object[$property] += v;
				return false;
			}
		}
		
		//格式化数字
		private static function __formatEasing($eas:Number ):Number
		{
			var num:Number;
			if ($eas < 1)
			{
				num = 1;
			}else if ($eas > 50) {
				num = 50;
			}else {
				num = $eas;
			}
				
			return num;
		}
		
	}
	
}