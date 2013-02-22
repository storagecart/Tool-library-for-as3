/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.display.color
{
	import flash.display.*;
	import flash.geom.ColorTransform;

	/**
	* 颜色工具   #####（基于 fl.motion.Color）######
	* Color 类扩展了 Flash Player 的 ColorTransform 类，增加了控制亮度和色调的功能。 它还包含静态方法，可以在两个 ColorTransform 对象之间或两个颜色数字之间进行插值。 
	*
	* --公共属性
	* brightness 			: Number 亮度的百分比（-1 到 1 之间的小数）。
	* color 				: uint ColorTransform 对象的 RGB 颜色值。 
    * tintColor 			: uint 0xRRGGBB 格式的着色颜色值。 Color 
    * tintMultiplier 		: Number 应用着色颜色的百分比（0 到 1 之间的小数值）。
	* 
	* --公共方法 
	* Color(redMultiplier:Number = 1.0, greenMultiplier:Number = 1.0, blueMultiplier:Number = 1.0, alphaMultiplier:Number = 1.0, redOffset:Number = 0, greenOffset:Number = 0, blueOffset:Number = 0, alphaOffset:Number = 0)
	* fromXML(xml:XML)		:Color [static] 从 XML 创建 Color 实例。
	* interpolateColor(fromColor:uint, toColor:uint, progress:Number ):uint [static] 从一个颜色值平滑地混合到另一个颜色值。
	* interpolateTransform(fromColor:ColorTransform, toColor:ColorTransform, progress:Number):ColorTransform [static] 平滑地从一个 ColorTransform 对象混合到另一个 ColorTransform 对象。
	* setTint(tintColor:uint, tintMultiplier:Number):void  同时设置着色颜色和色量。
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class Color extends ColorTransform
	{
		function Color (redMultiplier:Number=1.0, 
						greenMultiplier:Number=1.0, 
						blueMultiplier:Number=1.0, 
						alphaMultiplier:Number=1.0, 
						redOffset:Number=0, 
						greenOffset:Number=0, 
						blueOffset:Number=0, 
						alphaOffset:Number=0)
		{
			super(redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier, redOffset, greenOffset, blueOffset, alphaOffset);
		}

		public function get brightness():Number
		{
			return this.redOffset ? (1-this.redMultiplier) : (this.redMultiplier-1);
		}
		
		public function set brightness(value:Number):void
		{
			if (value > 1) value = 1;
			else if (value < -1) value = -1;
			
			var percent:Number = 1 - Math.abs(value);
			var offset:Number = 0;
			if (value > 0) offset = value * 255;
			this.redMultiplier = this.greenMultiplier = this.blueMultiplier = percent;
			this.redOffset     = this.greenOffset     = this.blueOffset     = offset;
		}

		public function setTint(tintColor:uint, tintMultiplier:Number):void
		{
			this._tintColor = tintColor;
			this._tintMultiplier = tintMultiplier;
			this.redMultiplier = this.greenMultiplier = this.blueMultiplier = 1 - tintMultiplier;
			var r:uint = (tintColor >> 16) & 0xFF;
			var g:uint = (tintColor >>  8) & 0xFF;
			var b:uint =  tintColor        & 0xFF;
			this.redOffset   = Math.round(r * tintMultiplier);
			this.greenOffset = Math.round(g * tintMultiplier);
			this.blueOffset  = Math.round(b * tintMultiplier);
		}	
		
		private var _tintColor:Number = 0x000000;
 
		public function get tintColor():uint
		{
			return this._tintColor;
		}

		public function set tintColor(value:uint):void
		{
			this.setTint(value, this.tintMultiplier);
		}

		private function deriveTintColor():uint
		{
			var ratio:Number = 1 / (this.tintMultiplier); 
			var r:uint = Math.round(this.redOffset * ratio);
			var g:uint = Math.round(this.greenOffset * ratio);
			var b:uint = Math.round(this.blueOffset * ratio);
			var colorNum:uint = r<<16 | g<<8 | b;
			return colorNum; 
		}

		private var _tintMultiplier:Number = 0;

		public function get tintMultiplier():Number
		{
			return this._tintMultiplier;
		}
		
		public function set tintMultiplier(value:Number):void
		{
			this.setTint(this.tintColor, value);
		}

		public static function fromXML(xml:XML):Color
		{
			return Color((new Color()).parseXML(xml));
		}

		private function parseXML(xml:XML=null):Color
		{
			if (!xml) return this;
         
			var firstChild:XML = xml.elements()[0];
			if (!firstChild) return this;
		 
			for each (var att:XML in firstChild.attributes())
			{
				var name:String = att.localName();
				if (name == 'tintColor')
				{
					var tintColorNumber:uint = Number(att.toString()) as uint;
					this.tintColor = tintColorNumber;
				}
				else
				{
					this[name] = Number(att.toString());
				}
			}
			return this;
		}
		
		///////////////
		public static function setColor($target:DisplayObject, $color:*):void
		{
			if($color is ColorTransform)
			{
				$target.transform.colorTransform = $color;
			}
			else 
			{
				var color:Color=new Color();
                color.color = $color;
                $target.transform.colorTransform=color;
			}
		}

		public static function interpolateTransform(fromColor:ColorTransform, toColor:ColorTransform, progress:Number):ColorTransform
		{
			var q:Number = 1-progress;
			var resultColor:ColorTransform = new ColorTransform
			(
			  fromColor.redMultiplier*q   + toColor.redMultiplier*progress
			, fromColor.greenMultiplier*q + toColor.greenMultiplier*progress
			, fromColor.blueMultiplier*q  + toColor.blueMultiplier*progress
			, fromColor.alphaMultiplier*q + toColor.alphaMultiplier*progress
			, fromColor.redOffset*q       + toColor.redOffset*progress
			, fromColor.greenOffset*q     + toColor.greenOffset*progress
			, fromColor.blueOffset*q      + toColor.blueOffset*progress
			, fromColor.alphaOffset*q     + toColor.alphaOffset*progress
			)
			return resultColor;		
		}
	
		public static function interpolateColor(fromColor:uint, toColor:uint, progress:Number):uint
		{
			var q:Number = 1-progress;
			var fromA:uint = (fromColor >> 24) & 0xFF;
			var fromR:uint = (fromColor >> 16) & 0xFF;
			var fromG:uint = (fromColor >>  8) & 0xFF;
			var fromB:uint =  fromColor        & 0xFF;

			var toA:uint = (toColor >> 24) & 0xFF;
			var toR:uint = (toColor >> 16) & 0xFF;
			var toG:uint = (toColor >>  8) & 0xFF;
			var toB:uint =  toColor        & 0xFF;
			
			var resultA:uint = fromA*q + toA*progress;
			var resultR:uint = fromR*q + toR*progress;
			var resultG:uint = fromG*q + toG*progress;
			var resultB:uint = fromB*q + toB*progress;
			var resultColor:uint = resultA << 24 | resultR << 16 | resultG << 8 | resultB;
			return resultColor;		
		}
	}
}
