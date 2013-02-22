/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.component.interactive 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.Dictionary;
	
	/**
	* MouseFollow类用来实现一组对象的鼠标跟随
	* 
	* 导入类
	* --CODE: import tool.component.interactive.MouseFollow;
	* 
	* 声明对象
	* --CODE: var mf=new MouseFollow([ball],false,"t",.2);    			//单个对象
	* --CODE: var mf=new MouseFollow([a1,a2,a3,a4],false,"t",.2);     	//多个对象
	* 
	* 开始和停止跟随
	* --CODE: mf.start(); /mf.stop();
	* 
	* 是否转动方向和运动模式
	* --CODE: mf.rotate = true ;
	* --CODE: mf.moveMode= "h";
	* 
	* 弹性（缓动）系数/阻力系数
	* --CODE: mf.easing=.5;        					//弹性（缓动）系数
	* --CODE: mf.obstacle=.5;        				//阻力系数
	* 
	* 设置最小检测距离（用于判断旋转）
	* --CODE: mf.min = .5;
	* 
	* 是否启用时间侦听
	* --CODE: mf.useTimer = false;
	* 
	* 常量
	* --CODE: MouseFollow.H;   //缓动方式
	* --CODE: MouseFollow.H;   //弹性方式
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	final public class MouseFollow 
	{
		public static const H:							String = "h";				//缓动运动方式
		public static const T:							String = "t";				//弹性运动方式
		
		private var _displayArray:						Array;                      //运动对象数组
		private var _rotate:							Boolean;                   	//是否旋转
		private var _moveMode:                          String;						//运动方式
		private var _easing:                            Number;						//缓动系数
		private var _obstacle:							Number;						//阻力系数
		private var _useTimer:							Boolean;					//启用时间侦听
		private var _min:								Number = .8;                //判断旋转的最小距离
		
		private var _dict:                              Dictionary;
		private var _timer:                             Timer;
		private var _this:								DisplayObjectContainer;
		
		//
		public function get displayArray():Array
		{
			return _displayArray;
		}
		
		public function set displayArray($array:Array):void
		{
			_displayArray = $array;
		}
		
		public function get rotate():Boolean
		{
			return _rotate;
		}
		
		public function set rotate($value:Boolean):void
		{
			_rotate = $value;
		}
		
		public function get moveMode():String
		{
			return _moveMode;
		}
		
		public function set moveMode($value:String):void
		{
			if ($value != "t")
				$value = "h";
			_moveMode = $value;
		}
		
		public function get easing():Number
		{
			return _easing;
		}
		
		public function set easing($value:Number):void
		{
			if ($value <= 0 )
				$value = 1;
			_easing = $value;
		}
		
		public function get obstacle():Number
		{
			return _obstacle;
		}
		
		public function set obstacle($value:Number):void
		{
			if ($value <= 0 )
				$value = 1;
			_obstacle = $value;
		}
		
		public function get useTimer():Boolean
		{
			return _useTimer;
		}
		
		public function set useTimer($value:Boolean):void
		{
			_useTimer = $value;
			start();
		}
		
		public function get min():Number
		{
			return _min;
		}
		
		public function set min($value:Number):void
		{
			_min = $value;
		}
		
		//======================================================================================================
		/**
		* 构造函数
		* @param		$array		      			Array		 				 * 显示对象组成的数组
		* @param		$rotate		       			Boolean	        			 * 是否转动方向
		* @param		$moveMode		        	String		     		     * 弹性/缓动方式
		* @param		$easing		        		Number		     		     * 弹性或缓动系数
		* @param		$obstacle		        	Number		     		     * 阻力缓动
		*/  
		public function MouseFollow($array:Array,$rotate:Boolean = false , $moveMode:String = "h" ,$easing:Number = 1,$obstacle:Number = .7 ) :void
		{
			if ($array.length == 0) throw(new Error("没有传入正确的参数！"));
			
			_displayArray 	= $array;
			_rotate 		= $rotate;
			_moveMode 		= $moveMode;
			_easing 		= $easing > 1 ? 1 : $easing;
			_easing 		= _easing <= 0 ? 1 : _easing;
			_obstacle 		= $obstacle > 1 ? 1 : $obstacle;
			_obstacle 		= _obstacle <= 0 ? 1 : _obstacle;
		}
		
		/**
		* 启动跟随
		* 
		* @param		$bool		      			Boolean		 				 * 是否使用时间侦听器
		*/ 
		public function start($bool:Boolean=true ):void
		{
			setTargetPoint();
			stop();
			if ($bool)
			{
				_timer = new Timer(1000 / 33, 0);                                   //33帧/秒
				_timer.addEventListener(TimerEvent.TIMER, beginFollow);
				_timer.start();
				_useTimer = true;
			}else
			{    
				_this.addEventListener(Event.ENTER_FRAME, beginFollow);
				_useTimer = false;
			}
		}
		
		/**
		* 停止跟随
		*/
		public function stop():void
		{
			if (_useTimer == false)
			{
				_this.removeEventListener(Event.ENTER_FRAME, beginFollow);
			}else if (_useTimer == true) {
				_timer.removeEventListener(TimerEvent.TIMER, beginFollow);
				_timer.stop();
				_timer = null;
			}
		}
		
		//设置目标点
		private function setTargetPoint():void
		{
			var length = _displayArray.length;
			var target_0 = _displayArray[0];
			_this = _displayArray[0].parent;
			_dict = new Dictionary(); 
			//--头--
			_dict[target_0] = new Object();
			_dict[target_0].speedX = 0;
			_dict[target_0].speedY = 0;
			
			for (var i:uint = 1; i < length; i++ )
			{
				var target_2:DisplayObject = _displayArray[i];
				var target_1:DisplayObject = _displayArray[i - 1];
				//--尾--
				_dict[target_2] = new Object();
				_dict[target_2].distance = Math.sqrt(Math.pow(target_2.x - target_1.x, 2 ) + Math.pow(target_2.y - target_1.y, 2 ));
				_dict[target_2].rotation = Math.atan2(target_2.y - target_1.y, target_2.x - target_1.x);
				_dict[target_2].speedX = 0;
				_dict[target_2].speedY = 0;
			}
		}
		
		//开始跟随
		private function beginFollow(e:*):void
		{
			var length = _displayArray.length;
			var target_0 = _displayArray[0];
			
			if (length == 1 ) {
				moveToTarget(target_0, _this.mouseX, _this.mouseY);	
			}else {
				topMoveToTarget(target_0, _this.mouseX, _this.mouseY);
			}
			
			if(_rotate)
				rotationToTarget(target_0, new Point(_this.mouseX, _this.mouseY));
			
			for (var i:uint = 1; i < length; i++ )
			{
				var target_2:DisplayObject = _displayArray[i];
				var target_1:DisplayObject = _displayArray[i - 1];
				var distance = _dict[target_2].distance;
				var rotation = _dict[target_2].rotation;
				moveToTarget(target_2, target_1.x - distance * Math.cos(rotation) , target_1.y - distance * Math.sin(rotation));
				if(_rotate)
					rotationToTargetOther(target_2, target_1);
			}
			try{e.updateAfterEvent();}catch(e:Error){}
		}
		
		//头跟随
		private function topMoveToTarget($taraget:DisplayObject , $targetX:Number , $targetY:Number ):void
		{
			$taraget.x += ($targetX - $taraget.x) * _easing;
			$taraget.y += ($targetY - $taraget.y) * _easing;
		}
		
		//尾跟随方式(弹性/缓动)
		private function moveToTarget($taraget:DisplayObject , $targetX:Number , $targetY:Number ):void
		{
			if (_moveMode == "t")
			{
				_dict[$taraget].speedX += ($targetX - $taraget.x) * _easing;
				_dict[$taraget].speedY += ($targetY - $taraget.y) * _easing;
				_dict[$taraget].speedX *= _obstacle;
				_dict[$taraget].speedY *= _obstacle;
				$taraget.x += _dict[$taraget].speedX;
				$taraget.y += _dict[$taraget].speedY;
			}else
			{
				$taraget.x += ($targetX - $taraget.x) * _easing;
				$taraget.y += ($targetY - $taraget.y) * _easing;
			}
		}
		
		//头旋转
		private function rotationToTarget($target:DisplayObject, $rotationTarget:*)
		{
			var dx:Number = $rotationTarget.x - $target.x;
			var dy:Number = $rotationTarget.y - $target.y;
			if ((Math.abs(dx) > _min || Math.abs(dy) > _min) && Math.abs(dx) * Math.abs(dy) > 0 )
			{
				var radians:Number = Math.atan2(dy, dx);
				var targetRadians:Number = radians * 180 / Math.PI;
				if (Math.abs(targetRadians - $target.rotation) < 180 )
				$target.rotation += (targetRadians - $target.rotation) * _easing;
				else if (targetRadians - $target.rotation >= 180 )
				$target.rotation += (targetRadians - 360 - $target.rotation) * _easing;
				else if ($target.rotation - targetRadians >= 180 )
				$target.rotation += (targetRadians + 360 - $target.rotation) * _easing;
			}
		}
		
		//尾旋转
		private function rotationToTargetOther($target:DisplayObject, $rotationTarget:*)
		{
			if (Math.abs($rotationTarget.rotation - $target.rotation) < 180 )
		    $target.rotation += ($rotationTarget.rotation -$target.rotation) * _easing;
			else if ($rotationTarget.rotation - $target.rotation >= 180 )
			$target.rotation += ($rotationTarget.rotation - 360 - $target.rotation) * _easing;
			else if ($target.rotation - $rotationTarget.rotation >= 180 )
			$target.rotation += ($rotationTarget.rotation + 360 - $target.rotation) * _easing;
			
			 _dict[$target].rotation = $target.rotation / ( 180 / Math.PI);
		}
	}
	
}