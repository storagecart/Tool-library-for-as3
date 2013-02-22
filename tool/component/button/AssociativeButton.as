/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.component.button 
{
	import flash.display.*;
	import flash.events.*;
	
	/**
	* 串联按钮MODEL.
	* 注:子类可以覆写mouseOutHandler，mouseOverHandler方法。
	* 如果子类要实现mouseDown功能，请先覆写公共方法mouseDownHandler，外部接口可以直接调用mouseDownHandler方法。
	* 继承AssociativeButton                              --CODE:public class subAssociativeButton extends AssociativeButton{}
	* AssociativeButton实例的编号                        --CODE:sub.i=1;
	* AssociativeButton实例的点击状态					 --CODE:trace(sub.clicked);
	* AssociativeButton实例的类型(只读)                  --CODE:trace(sub.type=="AssociativeButton");
	* AssociativeButton实例重新初始化                    --CODE:sub.initThis();
	* 覆写mouseDownHandler方法                           --CODE:override public function mouseDownHandler(e:MouseEvent = null):void{
																super.mouseDownHandler(e);
												                //do somethings... }
	* 覆写init方法                                       --CODE:override public function init(e:Event = null):void{
																super.init();
												                //do somethings... }
	*
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class AssociativeButton extends BasicButton
	{
		public var mouseFalse:Boolean = true;
		public var clicked:Boolean = false;                             //AssociativeButton实例的点击状态；
		private var _type = "AssociativeButton";                        //AssociativeButton实例的类型(只读)；
		
		public function get type():String
		{
			return _type;
		}
		
		/**
		* mouseDown要实现的功能
		* 子类调用请先覆写                 --CODE:override public function mouseDownHandler(e:MouseEvent = null):void{
												  super.mouseDownHandler(e);
												  //do somethings... }
		*
		* @param		e		        MouseEvent		        * 事件实例(可不传入)
		*/
		override public function mouseDownHandler(e:MouseEvent = null):void
		{
			clicked = true;
			super.mouseOverHandler(e);
			super.mouseDownHandler(e);
			initTotalButton(parent);
			buttonMode = mouseFalse;
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		private function initTotalButton($target:DisplayObjectContainer) 
		{
			for (var i:uint = 0; i < $target.numChildren; i++ )
			{
				var _target = $target.getChildAt(i);
				try
				{
					if (_target.type == "AssociativeButton")
					{
						if (_target != this && _target.clicked == true)
						_target.initThis();
					}
				}catch (e:*) {}
			}
		}
		
		/**
		* 重新初始化
		* 子类调用请先覆写                 --CODE:override public function initThis():void{
												  super.initThis();
												  //do somethings... }
		*
		*/
		public function initThis()
		{
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			super.mouseOutHandler();
			buttonMode = true;
			clicked = false;
		}
		
	}
	
}