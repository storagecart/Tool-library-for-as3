/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.stage 
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Dictionary;
	
	import com.greensock.easing.*;
	import com.greensock.TweenMax;
	//import fl.transitions.*;
	//import fl.transitions.easing.*;                                   	//可换第三方类 
	
	/**
	* AutoSize类用来现实元件自适应屏幕尺寸.
	* (⊙ 注：使用时候的坐标是相对于元件原来坐标的【所以确保元件最初添加到场景】)
	* 
	* 设置发布尺寸（必须的）
	* --CODE:AutoSize.publicSize = [550,400]
	* 
	* 自适应函数调用。                        
	* --CODE:AutoSize.auto(mc,"L","B",1);
	* 
	* 自适应的最小宽度。                      
	* --CODE:AutoSize.minWidth;
	* 
	* 自适应的最小高度。                      
	* --CODE:AutoSize.minHeight;
	* 
	* 水平左对齐。                            
	* --CODE:AutoSize.LEFT;
	* 
	* 水平中对齐。                            
	* --CODE:AutoSize.CENTER;
	* 
	* 水平右对齐。                            
	* --CODE:AutoSize.RIGHT;
	* 
	* 垂直上对齐。                            
	* --CODE:AutoSize.UPPER;
	* 
	* 垂直中对齐。                            
	* --CODE:AutoSize.CENTER;
	* 
	* 垂直下对齐。                            
	* --CODE:AutoSize.BOTTOM;
	*
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class AutoSize 
	{
		/**
		* 对齐方式
		*/
		public static const LEFT		:String = "L";
		public static const CENTER		:String = "C";
		public static const RIGHT		:String = "R";
		public static const UPPER		:String = "U";
		public static const BOTTOM		:String = "B";

		/**
		* 小于该尺寸自适应将失效
		* 默认最小分辨率(1024x768)下的页面尺寸(1003*550)
		*/
		public static var minWidth		:Number = 1003;
		public static var minHeight	    :Number = 550;
		public static var LOG			:Boolean = false;
		public static var CURRENT_WIDTH :Number;
		public static var CURRENT_HEIGHT:Number;
		
		private static var _str			:String = "~~o(>_<)o ~~   ";
		private static var instantiation:AutoSize = null;
		private static var _publicSize	:Array = [0, 0];
		
		private var _stage				:DisplayObject;
		private var _dic				:Dictionary;
		private var _sObj				:Object;
		private var _funObj				:Object;	
		
		/**
		* 影片的发布尺寸,在初始化后调用
		*/
		public static function  get publicSize():Array
		{
			return _publicSize;
		}
		
		public static function  set publicSize($wh:Array):void
		{
			_publicSize = $wh;
		}
		
		public static function instantiate($target:DisplayObject):void
		{
			new AutoSize(new SingletonEnforcer, $target);	
		}
		
		public function AutoSize(singletonEnforcer:SingletonEnforcer, $target:DisplayObject = null)           
		{
			AutoSize.instantiation  = this;
			_stage 					= $target.stage;
			_dic 					= new Dictionary();
			_sObj 					= new Object;
			_funObj 				= new Object;
			CURRENT_WIDTH 			= Stage(_stage).stageWidth  > minWidth?Stage(_stage).stageWidth:minWidth;
			CURRENT_HEIGHT			= Stage(_stage).stageHeight > minHeight?Stage(_stage).stageHeight:minHeight;
			Stage(_stage).addEventListener(Event.RESIZE, resizeHandler);
		}
		
		/**
		* 自适应函数  
		*
		* @param		$target		      DisplayObject		    * 要处理的对象
		* @param		$horizontal		  String				* 对象的水平坐标
		* @param		$vertical   	  String				* 对象的垂直坐标
		* @param		$time		      Number				* 是否缓动处理，默认为(0)不缓动
		*/
		public static function auto($target:DisplayObject , $horizontal:String = AutoSize.CENTER, $vertical:String = AutoSize.CENTER, $time:Number = 0, $public:Array = null ):void
		{
			if (AutoSize.instantiation == null)new AutoSize(new SingletonEnforcer, $target);	
			AutoSize.instantiation.beginAuto($target, $horizontal, $vertical, $time, $public );
		}
		
		/**
		* 按比例适应函数  
		*
		* @param		$target		      DisplayObject		    * 要处理的对象
		*/
		public static function autoScale($target:DisplayObject , $speed:Number = 1, $max:Number = 0, $min:Number = 0):void
		{
			if (AutoSize.instantiation == null) new AutoSize(new SingletonEnforcer, $target);
			AutoSize.instantiation.beginAutoScale($target, $speed, $max, $min);
		}
		
		public static function onResize($fun:Function, $runNow:Boolean = false ):void
		{
			if(AutoSize.instantiation)
			{
				Stage(AutoSize.instantiation._stage).addEventListener(Event.RESIZE, $fun );
				if ($runNow)$fun(new Event("resize"));
			}
		}
		
		public static function removeOnResize($fun):void
		{
			if(AutoSize.instantiation)
			{
				Stage(AutoSize.instantiation._stage).removeEventListener(Event.RESIZE, $fun );
			}
		}
		
		public static function remove($target:DisplayObject):void
		{
			if (AutoSize.instantiation._dic[$target]) delete AutoSize.instantiation._dic[$target];
			if (AutoSize.LOG) trace("^^^^^^^^^^删除了     ", $target, AutoSize.instantiation._dic[$target]);
		}
		
		public static function stopAuto($target:DisplayObject):void
		{
			AutoSize.instantiation._dic[$target].breturn = true;
		}
		
		/**
		* 立刻执行一次
		*/
		public static function runNow():void
		{
			AutoSize.instantiation.resizeHandler();
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function beginAuto($target, $horizontal, $vertical, $time,$public):void
		{
			if (!_dic[$target])
			{
				var targetObject:ProperObject = new ProperObject();
				targetObject.auto		= true;
				targetObject.horizontal = $horizontal;
				targetObject.vertical 	= $vertical;
				targetObject.time 		= $time;
				targetObject.oldX 		= $target.x;
				targetObject.oldY 		= $target.y;
				targetObject.target     = $target;
				targetObject.publics 	= $public;
				_dic[$target] 			= targetObject;
			}else
			{
				_dic[$target].auto		= true;
				_dic[$target].horizontal= $horizontal;
				_dic[$target].vertical 	= $vertical;
				_dic[$target].time 		= $time;
				_dic[$target].oldX		= $target.x;
				_dic[$target].oldY		= $target.y;
				_dic[$target].target    = $target;
				_dic[$target].publics 	= $public;
			}
			
			if (!_stage) getPublicSize($target) ;
		}
		
		private function beginAutoScale($target:DisplayObject,$speed:Number = 1, $max:Number = 0, $min:Number = 0):void
		{
			if (!_dic[$target])
			{
				var targetObject:ProperObject = new ProperObject();
				targetObject.scale		 = true; 
				targetObject.target      = $target;
				targetObject.speed       = $speed;
				targetObject.max         = $max;
				targetObject.min         = $min;
				_dic[$target] 			 = targetObject;
			}else
			{
				_dic[$target].scale	     = true;
				_dic[$target].speed  	 = $speed;
				_dic[$target].max		 = $max;
				_dic[$target].min  		 = $min;
				_dic[$target].target 	 = $target;
			}
			
			if (!_stage) getPublicSize($target) ;
		}
		
		private function getPublicSize($target:DisplayObject):void
		{
			var W:Number, H:Number;
			if (_publicSize[0] == 0 && _publicSize[1] == 0)
			{
				try
				{ 
					W = $target.root.loaderInfo.width;
					H = $target.root.loaderInfo.height;
				}
				catch (e:*)
				{
					throw(new Error("对不起，您应该输入flash的发布尺寸！"))
				}
				
				_publicSize = [W, H];
			}
		}
		
		//-----------------设置尺寸-------------------
		private function resizeHandler(e:Event = null):void
		{
			if (AutoSize.LOG) trace("(=^ ^=)★☆★☆★☆★☆★☆★☆★☆★---正在自适应操作---★☆★☆★☆★☆★☆★☆★☆★(=^ ^=)" );
			
			for (var target in _dic) 
			{
				var targetObject:ProperObject = _dic[target];
				if(targetObject.auto)
					setSize(targetObject.target, targetObject.horizontal, targetObject.vertical, targetObject.time, targetObject.oldX, targetObject.oldY );
				if (targetObject.scale)
					setScale(targetObject.target, targetObject.speed, targetObject.max, targetObject.min);
			}
		}
		
		private function setScale($target:DisplayObject, $speed:Number, $max:Number, $min:Number ):void
		{
			var scale:Number;
			var targetObject:ProperObject = _dic[$target];
			CURRENT_WIDTH = Stage(_stage).stageWidth  > minWidth?Stage(_stage).stageWidth:minWidth;
			CURRENT_HEIGHT= Stage(_stage).stageHeight > minHeight?Stage(_stage).stageHeight:minHeight;	
			if (targetObject.max != 0) 
				scale = Math.min(CURRENT_WIDTH / _publicSize[0], CURRENT_HEIGHT / _publicSize[1]);	
			else	
				scale = Math.max(CURRENT_WIDTH / _publicSize[0], CURRENT_HEIGHT / _publicSize[1]);
				
			if (targetObject.max != 0) scale = scale > targetObject.max?  targetObject.max:scale;
			if (targetObject.min != 0) scale = scale < targetObject.min?  targetObject.min:scale;
			scale = Math.pow(scale, targetObject.speed);
			$target.scaleX = $target.scaleY = scale;
			
			if (AutoSize.LOG) trace(AutoSize._str, $target, "在自适应尺寸");
		}
		
		private function setSize($target, $horizontal, $vertical, $time, $oldX, $oldY):void
		{
			var targetObject:ProperObject = _dic[$target];
			if (targetObject.breturn) return;
			CURRENT_WIDTH = Stage(_stage).stageWidth  > minWidth?Stage(_stage).stageWidth:minWidth;
			CURRENT_HEIGHT = Stage(_stage).stageHeight > minHeight?Stage(_stage).stageHeight:minHeight;
			var publiccsize:Array = targetObject.publics?targetObject.publics:_publicSize;
			
			switch ($horizontal)
			{ 
				case AutoSize.LEFT:
					targetObject.targetX = $oldX;
					break;
				case AutoSize.CENTER:
					targetObject.targetX = CURRENT_WIDTH / 2 - (publiccsize[0] / 2 - $oldX);
					break;
				case AutoSize.RIGHT:
					targetObject.targetX = CURRENT_WIDTH - (publiccsize[0] - $oldX);
					break;
			}
			
			switch ($vertical)
			{ 
				case AutoSize.UPPER:
					targetObject.targetY = $oldY;
					break;
				case AutoSize.CENTER:
					targetObject.targetY = CURRENT_HEIGHT / 2 - (publiccsize[1] / 2 - $oldY);
					break;
				case AutoSize.BOTTOM:
					targetObject.targetY = CURRENT_HEIGHT - (publiccsize[1] - $oldY);
					break;
			}
			
			if ($time != 0)
			{
				TweenMax.to($target, $time, { x:targetObject.targetX, y:targetObject.targetY, ease:Quart.easeOut } );
				//new Tween($target, "x", Strong.easeOut, $target.x, _targetX[i], $time, true);
				//new Tween($target, "y", Strong.easeOut, $target.y, _targetY[i], $time, true);
			}else 
			{
				$target.x = targetObject.targetX;
				$target.y = targetObject.targetY;
			}
			
			if (AutoSize.LOG) trace(AutoSize._str, $target, $horizontal, $vertical,"适应位置" );
		}

	}
	
}

/////////////////////////////////
import flash.display.DisplayObject;
class ProperObject extends Object {
	var target:DisplayObject;
	var auto:Boolean;
	var scale:Boolean;
	var horizontal:String;
	var vertical:String;
	var time:Number;
	var oldX:Number;
	var oldY:Number;
	var targetX:Number;
	var targetY:Number;
	var speed:Number;
	var max:Number;
	var min:Number;
	var breturn:Boolean = false;
	var publics:Array = [];
}
class SingletonEnforcer { };