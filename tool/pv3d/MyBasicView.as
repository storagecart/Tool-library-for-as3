/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.pv3d 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.view.BasicView;
	
	/**
	* 3D场景
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class MyBasicView extends BasicView
	{
		public function MyBasicView(viewportWidth:Number = 640, viewportHeight:Number = 480, scaleToStage:Boolean = true, interactive:Boolean = false, cameraType:String = "Target")
		{
			super(viewportWidth, viewportHeight, scaleToStage, interactive, cameraType);
		}
		
		public function init3D($z:Number, $zoom:Number, $focus:Number ):void
		{
			camera.focus = $focus;
			camera.zoom = $zoom;
			camera.z = $z;
			startRendering();addChild()
		}
		
		public function show100():Number
		{
			return  camera.zoom * camera.focus + camera.z;
		}
		
		override public function addChild (child:DisplayObject3D) : DisplayObject3D;
		{
			scene.addChild(child);
		}
		
		override protected function onRenderTick (e:Event=null):void
		{
			super.onRenderTick();
		}
		
		public function destory()
		{
			stopRendering();
		}
		
	}

}