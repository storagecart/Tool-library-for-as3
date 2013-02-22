/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.component.button 
{
	import flash.display.*;
	import flash.events.*;
	
	/**
	* 并联按钮MODEL.
	* 注:子类可以覆写mouseOutHandler，mouseOverHandler方法。
	* 如果子类要实现mouseDown功能，请先覆写公共方法mouseDownHandler，外部接口可以直接调用mouseDownHandler方法。
	* 继承ParallelButton                                 --CODE:public class subParallelButton extends ParallelButton{}
	* ParallelButton实例的编组类型(必须指定)             --CODE:var sub:subParallelButton=new subParallelButton; sub.group="A"
	* ParallelButton实例的编号(必须指定)                 --CODE:sub.i=1;
	* ParallelButton实例的点击状态						 --CODE:trace(sub.clicked);
	* ParallelButton实例的类型(只读)                 	 --CODE:trace(sub.type=="AssociativeButton");
	* ParallelButton实例重新初始化                       --CODE:sub.initThis();
	* 覆写mouseDownHandler方法                           --CODE:override public function mouseDownHandler(e:MouseEvent = null):void{
																super.mouseDownHandler(e);
												                //do somethings... }
	* 覆写init方法                                       --CODE:override public function init(e:Event = null):void{
																super.init();
												                //do somethings... }
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class ParallelButton extends AssociativeButton
	{
		public var group:String = "";                    //ParallelButton实例的编组类型(必须指定)
		private var _root:DisplayObject;
	
		/**
		* ParallelButton实例初始化的状态
		* 子类调用请先覆写                 --CODE:override public function init(e:Event = null):void{
												  super.init();
												  //do somethings... }
		*
		* @param		e		        Event		         * 事件实例(可不传入)
		*/
		override protected function init(e:Event = null) :void 
		{
			super.init();
		    _root = this.root;
			_root.addEventListener("associativeButtonMouseOver", associativeButtonMouseOverHandler,true);
			_root.addEventListener("associativeButtonMouseOut", associativeButtonMouseOutHandler,true);
			_root.addEventListener("associativeButtonMouseDown", associativeButtonMouseDownHandler,true);
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
			super.mouseDownHandler(e);
			dispatchEvent(new Event("associativeButtonMouseDown"));
		}
		
		override protected function mouseOverHandler(e:MouseEvent = null):void
		{
			super.mouseOverHandler(e);
			dispatchEvent(new Event("associativeButtonMouseOver"));
		}
		
		override protected function mouseOutHandler(e:MouseEvent = null):void
		{
			super.mouseOutHandler(e);
			dispatchEvent(new Event("associativeButtonMouseOut"));
		}
		
		private function associativeButtonMouseOverHandler(e:Event)
		{
			if (e.target.group != this.group && e.target.i == this.i)
			super.mouseOverHandler();
		}
		
		private function associativeButtonMouseOutHandler(e:Event)
		{
			if (e.target.group != this.group && e.target.i == this.i)
			super.mouseOutHandler();
		}
		
		private function associativeButtonMouseDownHandler(e:Event)
		{
			if (e.target.group != this.group && e.target.i == this.i)
			super.mouseDownHandler();
		}
	}
	
}