/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.fp10.a3d.core 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.*;
	import tool.fp10.a3d.A3D;
	
	import tool.fp10.a3d.move.OrderTool;
	
	/**
	* 基本3d对象(仅支持 flash player10.0 以上版本)
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 10.0/Flash 10.1
	* @tiptext
	*
	*/
	public class FP10Object3d extends Sprite implements IFP10Object3d
	{
		///////////////////////////////////
		// protected、private Properties
		///////////////////////////////////
		protected var _listenerArray 		:Array = [];
		
		private var _rotateFunctionArray 	:Array = [];
		private var _moveFunctionArray 		:Array = [];
		
		private var _bright					:* = false;
		private var _zorder					:Boolean = false;
		
		///////////////////////////////////
		// public Properties
		///////////////////////////////////
		public var material:Material;
		
		///////////////////////////////////
		// geter-seter 
		///////////////////////////////////
		public function get bright():* 
		{ 
			return _bright;
		}
		
		public function set bright(value:*):void 
		{
			if (typeof value == "boolean")
			{
				if (value)
					Light.open(this, A3D.bright );
				else
					Light.close(this);
					
				_bright = value;
			}else if (typeof value == "number")
			{
				Light.open(this, value);
				_bright = true;
			}else
			{
				throw(new Error("请传入正确的参数类型！"));
			}
		}
		
		public function get zorder():Boolean
		{ 
			return _zorder;
		}
		
		public function set zorder(value:Boolean):void 
		{
			if(value)
				OrderTool.alwaysOrder(this);
			else 
				OrderTool.stopAlwaysOrder(this);
				
			_zorder = value;
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		//LOOK AT TARGET ------------------------
		public function lookAt($target:*):void
		{
			var point:Vector3D = new Vector3D();
			if ($target is Vector3D)
			{
				point = $target;
			}
			else if ($target.hasOwnProperty("x") && $target.hasOwnProperty("y") && $target.hasOwnProperty("z"))
			{
				point.x = $target.x; point.y = $target.y; point.z = $target.z;
			}
			else
			{
				throw(new Error("对不起，您没有传入正确的参数类型！"));
			}
				
			var vector:Vector3D = new Vector3D(point.x - x, point.y - y, point.z - z);
			var radius:Number = Math.sqrt(Math.pow(point.x - x, 2) + Math.pow(point.y - y, 2) + Math.pow(point.z - z, 2));
			var verVector:Vector3D = getVector(new Vector3D(vector.x / radius, vector.y / radius, vector.z / radius));
			setAngle(this , verVector);
		}
		
		private static function setAngle($target:FP10Object3d , $vector:Vector3D ):void
		{
			var PI:Number = 180 / Math.PI;
			$target.rotationX = $vector.x*PI;
			$target.rotationY = $vector.y*PI;
			$target.rotationZ = $vector.z*PI;
		}
		
		private static function getVector( $angle:Vector3D):Vector3D
		{
			var a1:Number = $angle.x;
			var a2:Number = $angle.y;
			var a3:Number = $angle.z;
			
			var Sa1:Number = Math.sin(a1);
			var Sa2:Number = Math.sin(a2);
			var Sa3:Number = Math.sin(a3);
			var Ca1:Number = Math.cos(a1);
			var Ca2:Number = Math.cos(a2);
			var Ca3:Number = Math.cos(a3);
					
			var vx:Number = -(Ca1 * Sa2 * Ca3 + Sa1 * Sa3);
			var vy:Number = -(Ca1 * Sa2 * Sa3 - Sa1 * Ca3);
			var vz:Number = -(Ca1 * Ca2);
			return new Vector3D(vx, vy, vz);
		}
		
		//转化为2d对象 ------------------------
		public function to2D():void
		{
			this.z = 0;
			this.transform.matrix3D = null;
		}
		
		//旋转 ------------------------
		public function rotate($po:String = "x", $speed:Number = 5):void
		{
			var rotatePo    = $po;
			var totateSpeed = $speed;
			addEventListener(Event.ENTER_FRAME, rotateHandler);
			
			var listenerObject:Object 	= new Object();
			listenerObject.po 		    = $po;
			listenerObject.listener 	= rotateHandler;
			_rotateFunctionArray.push(listenerObject);
			function rotateHandler(e:Event):void 
			{
				if (rotatePo == "x")
					rotationX += totateSpeed;
				else if (rotatePo == "y")
					rotationY += totateSpeed;
				else 
					rotationZ += totateSpeed;
			}
		}
		
		//停止旋转 ------------------------
		public function stopRotate($po:String = "all" ):void
		{
			if ($po == "all")
			{
				for (var i:uint = 0; i < _rotateFunctionArray.length; i++ )
				{
					this.removeEventListener(Event.ENTER_FRAME, _rotateFunctionArray[i].listener);
				}
			}else 
			{
				for (i = 0; i < _rotateFunctionArray.length; i++ )
				{
					if ($po == _rotateFunctionArray[i].po)
						this.removeEventListener(Event.ENTER_FRAME, _rotateFunctionArray[i].listener);
				}
			}
		}
			
		//移动 ------------------------
		public function move($po:String = "x", $speed:Number = 2):void
		{
			var movePo    = $po;
			var moveSpeed = $speed;
			addEventListener(Event.ENTER_FRAME, moveHandler);
			
			var listenerObject:Object 	= new Object();
			listenerObject.po 		    = movePo;
			listenerObject.listener 	= moveHandler;
			_moveFunctionArray.push(listenerObject);
			
			function moveHandler(e:Event):void 
			{
				if (movePo == "x")
					x += moveSpeed;
				else if (movePo == "y")
					y += moveSpeed;
				else 
					z += moveSpeed;
			}
		}
		
		//停止移动 ------------------------
		public function stopMove($po:String = "all" ):void
		{
			if ($po == "all")
			{
				for (var i:uint = 0; i < _moveFunctionArray.length; i++ )
				{
					this.removeEventListener(Event.ENTER_FRAME, _moveFunctionArray[i].listener);
				}
			}else 
			{
				for (i = 0; i < _moveFunctionArray.length; i++ )
				{
					if ($po == _moveFunctionArray[i].po)
						this.removeEventListener(Event.ENTER_FRAME, _moveFunctionArray[i].listener);
				}
			}
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference); 
			var listenerObject:Object 	= new Object();
			listenerObject.type 		= type;
			listenerObject.listener 	= listener;
			listenerObject.useCapture 	= useCapture;
			_listenerArray.push(listenerObject);
		}
		
		//毁掉（清除所有侦听） ------------------------
		public function destory():void
		{
			for (var i:uint = 0; i < _listenerArray.length; i++ )
			{
				this.removeEventListener(_listenerArray[i].type, _listenerArray[i].listener, _listenerArray[i].useCapture);
			}
			
			_listenerArray = [];
			
			bright = false;
			zorder = false;
		}
	}
	
}