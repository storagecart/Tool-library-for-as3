package tool.display.bitmap 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;	
	
	
	public class DistortHelper extends EventDispatcher
	{
		//- PRIVATE & PROTECTED VARIABLES -------------------------------------------------------------------------

		private var _holder:*;
		private var _mc:MovieClip;
		private var _mcWidth:Number;
		private var _mcHeight:Number;
		private var _bmd:BitmapData;
		private var _bmp:Bitmap;
		private var _container:Shape;
		private var _tl:Point;
		private var _tr:Point;
		private var _br:Point;
		private var _bl:Point;
		private var _distortion:DistortImage;
		private var _tweenFunc:Function;
		private var _tweenTime:Number;
		private var _precision:uint;
		
		// tweens
		private var _tlXTween:Tween;
		private var _tlYTween:Tween;
		private var _trXTween:Tween;
		private var _trYTween:Tween;
		private var _brXTween:Tween;
		private var _brYTween:Tween;
		private var _blXTween:Tween;
		private var _blYTween:Tween;
		
		//- PUBLIC & INTERNAL VARIABLES ---------------------------------------------------------------------------
		
		public static const DEFAULT_NAME:String = "DistortHelper 1.0";
		
		//- CONSTRUCTOR	-------------------------------------------------------------------------------------------
	
		/**
		 * Creates a new instance of the DistortionTweener class.  The point values are relative to the holder clip, NOT the stage.
		 * 
		 * @param $holder The DisplayObject that will be used to hold your distorted bitmap
		 * @param $mc The source movie clip that will be used to copy into the bitmap that will be distorted
		 * @param $tl The top left point to use in the distortion
		 * @param $tr The top right point to use in the distortion
		 * @param $br The bottom right point to use in the distortion
		 * @param $bl The bottom left point to use in the distortion
		 * @param $precision A uint representing the value to use as the precision in the DistortImage class
		 * 
		 * @return void
		 */
		public function DistortHelper($holder:*, $mc:MovieClip, $tl:Point, $tr:Point, $br:Point, $bl:Point, $precision:uint):void
		{
			this._holder 	= $holder;
			this._mc 		= $mc;
			this._mcWidth 	= this._mc.width;
			this._mcHeight 	= this._mc.height;
			this._tl 		= $tl;
			this._tr 		= $tr;
			this._br 		= $br;
			this._bl 		= $bl;
			this._precision = $precision;
			
			this.init();
		}
		
		//- PRIVATE & PROTECTED METHODS ---------------------------------------------------------------------------
		
		private function init():void
		{
			this._mc.visible= false;
			
			this._bmd 		= new BitmapData(this._mcWidth, this._mcHeight, true, 0x00FFFFFF);
			this._bmd.draw(this._mc);
			
			this._bmp 		= new Bitmap(this._bmd);
			this._container = new Shape();
			
			this._holder.addChild(this._container);
			
			this._distortion = new DistortImage(this._mcWidth, this._mcHeight, this._precision, this._precision);
			this._distortion.setTransform(this._container.graphics, this._bmp.bitmapData, this._tl, this._tr, this._br, this._bl);
		}

		//- PUBLIC & INTERNAL METHODS -----------------------------------------------------------------------------
	
		/**
		 * Tweens the distortion. As with the constructor, the point values are relative to the holder clip, NOT the stage.
		 * 
		 * <p>
		 * The tweenTo method dispatches two events:
		 * <ul>
		 * <li>Event.INIT: Dispatched when the tweening begins</li>
		 * <li>Event.COMPLETE: Dispatched when the tweening ends</li>
		 * </ul>
		 * </p>
		 * 
		 * @param $tl The top left point to end the tween at
		 * @param $tr The top right point to end the tween at
		 * @param $br The bottom right point to end the tween at
		 * @param $bl The bottom left point to end the tween at
		 * @param $tweenFunc The easing function to use in the tween
		 * @param $time The duration, in seconds, of the tween
		 * 
		 * @return void
		 */
		public function tweenTo($tl:Point, $tr:Point, $br:Point, $bl:Point, $tweenFunc:Function, $time:Number):void
		{
			this.dispatchEvent(new Event(Event.INIT));
			
			this._tweenFunc = $tweenFunc;
			this._tweenTime = $time;
			
			// top left tweens
			this._tlXTween = new Tween(this._tl, "x", this._tweenFunc, this._tl.x, $tl.x, this._tweenTime, true);
			this._tlYTween = new Tween(this._tl, "y", this._tweenFunc, this._tl.y, $tl.y, this._tweenTime, true);
			
			// top right tweens
			this._trXTween = new Tween(this._tr, "x", this._tweenFunc, this._tr.x, $tr.x, this._tweenTime, true);
			this._trYTween = new Tween(this._tr, "y", this._tweenFunc, this._tr.y, $tr.y, this._tweenTime, true);
			
			// bottom right tweens
			this._brXTween = new Tween(this._br, "x", this._tweenFunc, this._br.x, $br.x, this._tweenTime, true);
			this._brYTween = new Tween(this._br, "y", this._tweenFunc, this._br.y, $br.y, this._tweenTime, true);
			
			// bottom left tweens
			this._blXTween = new Tween(this._bl, "x", this._tweenFunc, this._bl.x, $bl.x, this._tweenTime, true);
			this._blYTween = new Tween(this._bl, "y", this._tweenFunc, this._bl.y, $bl.y, this._tweenTime, true);
			
			this._blYTween.addEventListener(TweenEvent.MOTION_CHANGE, render);
			this._blYTween.addEventListener(TweenEvent.MOTION_FINISH, onFinished);
		}
		
		/**
		 * Resets the bitmap to the specified points.
		 * 
		 * @param $tl The top left point to use in the distortion
		 * @param $tr The top right point to use in the distortion
		 * @param $br The bottom right point to use in the distortion
		 * @param $bl The bottom left point to use in the distortion
		 * 
		 * @return void
		 */
		public function reset($tl:Point, $tr:Point, $br:Point, $bl:Point):void
		{
			this._tl = $tl;
			this._tr = $tr;
			this._br = $br;
			this._bl = $bl;
			
			this._container.graphics.clear();
			this._holder.removeChild(this._container);
			
			this._container = null;
			this._container = new Shape();
			
			this._holder.addChild(this._container);
		}
		
		/**
		 * Cleans up the DistortionTweener for garbage collection.
		 * 
		 * @return Nothing
		 */
		public function destroy():void
		{
			this._bmd.dispose();
			
			this._container.graphics.clear();
			this._holder.removeChild(this._container);
			
			this._bmd = null;
			this._bmp = null;
			this._container = null;
			this._holder = null;
			this._distortion = null;
		}
	
		//- EVENT HANDLERS ----------------------------------------------------------------------------------------
	
		// Dispatched during the MOTION_CHANGE event to update the distorted graphics.
		private function render($evt:TweenEvent):void
		{
			this._container.graphics.clear();
			this._distortion.setTransform(this._container.graphics, this._bmp.bitmapData, this._tl, this._tr, this._br, this._bl);
		}
		
		// Dispatches a COMPLETE event when the distortion is finished.
		private function onFinished($evt:TweenEvent):void
		{
			this._blYTween.removeEventListener(TweenEvent.MOTION_CHANGE, render);
			this._blYTween.removeEventListener(TweenEvent.MOTION_FINISH, onFinished);
			
			this._tlXTween = null;
			this._tlYTween = null;
			this._trXTween = null;
			this._trYTween = null;
			this._brXTween = null;
			this._brYTween = null;
			this._blXTween = null;
			this._blYTween = null;
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	
		//- GETTERS & SETTERS -------------------------------------------------------------------------------------
	
		
	
		//- HELPERS -----------------------------------------------------------------------------------------------
	
		public override function toString():String
		{
			return "tool.display.bitmap.DistortHelper";
		}
	
		//- END CLASS ---------------------------------------------------------------------------------------------
	}
}