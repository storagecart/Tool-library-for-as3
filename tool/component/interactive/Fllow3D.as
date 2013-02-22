package tool.component.interactive 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import tool.util.EnterFrame;
	import tool.util.tryRun;
	
	
	public class Fllow3D 
	{
		private var _ef:EnterFrame;
		private var _dic:Dictionary;
		private var _container:DisplayObjectContainer;
		private var _center:String;
		private var __centerPoint:Point;
		
		public var distance:int = 5000;
		
		public function Fllow3D($container:DisplayObjectContainer, $center:* = 'C') 
		{
			_dic = new Dictionary;
			_ef = new EnterFrame
			_container = $container;
			_center = $center;
			if (_center == 'C')__centerPoint = new Point(_container.stage.stageWidth / 2, _container.stage.stageHeight / 2 );
			else if (_center == 'TL')__centerPoint = new Point(0, 0);
			else if (_center is Array)__centerPoint = new Point(_center[0], _center[1] );
			
			_ef.onEnterFrame = enterFrameHandler;
			
			//_container.stage.addEventListener(Event.RESIZE, bgResize);
			bgResize();
		}
		
		private function enterFrameHandler():void
		{
			for (var mc in _dic)
			{
				var mcZpoint = _dic[mc].zPoint;
				var oldX = _dic[mc].oldX;
				var mcTargetX = (_container.mouseX -  __centerPoint.x ) * mcZpoint / distance + oldX;
				mc.x += (mcTargetX - mc.x) / 30;
			}
		}
		
		private function bgResize(e:Event = null ):void
		{
			stop();
			for (var mc in _dic)
			{
				var obj = _dic[mc];
				obj.oldX = mc.x;
			}
			reset();
		}
		
		public function add3D($target:DisplayObject, $ZPoint:Number)
		{
			var obj = new Object;
			obj.target = $target;
			obj.zPoint = $ZPoint;
			obj.oldX = $target.x;
			_dic[$target] = obj;
			
		}
		
		public function remove3D($target:DisplayObject):void
		{
			delete _dic[$target];
		}
		
		public function stop()
		{
			_ef.removeEnterFrame();
		}
		
		public function reset():void
		{
			_ef.removeEnterFrame();
			_ef.onEnterFrame = enterFrameHandler;
		}
		
		public function destory():void
		{
			tryRun(function() {
					_container.stage.removeEventListener(Event.RESIZE, bgResize);
					_ef.removeEnterFrame();
					for (var mc in _dic)
					{
						delete _dic[mc];
					}
			})
		}
		
	}

}