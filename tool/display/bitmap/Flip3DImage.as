/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package   tool.display.bitmap 
{
	import com.greensock.*;
    import com.greensock.easing.*;
    import flash.display.*;
    import flash.geom.*;
	
	/**
	* 3d扭曲图片出现效果
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0, Flash 10.0
	* @tiptext
	*
	*/

    public class Flip3DImage extends Sprite
    {
        private var _btmArr:Array;
        private var _fxContent:DistortImage;
        private var _topArr:Array;
        private var _completeHandler:Function;
        private var _content:Bitmap;
        private var _timeFactor:Number;

        public function Flip3DImage($targetBitmap:Bitmap, $comFUN:Function, $seg:int = 3, $time:Number = 1)
        {
            _content = $targetBitmap;
            _completeHandler = $comFUN;
            _timeFactor = $time;
            init($seg);
        }
		
		//初始化  $seg段数
		private function init($seg:int) : void
        {
            _fxContent = new DistortImage(_content.width, _content.height, $seg, $seg);
            _topArr = [_content.x, _content.y, _content.x + _content.width, _content.y];
            _btmArr = [_content.x + _content.width, _content.y + _content.height, _content.x, _content.y + _content.height];
        }

        public function start() : void
        {
            TweenMax.from(_topArr, .35 * _timeFactor, {endArray:[_content.width * 0.7, _content.height * 0.2 + 50, _content.width * 0.3, _content.height * -0.2 + 50], ease:Back.easeOut, onUpdate:transitonFunction});
            TweenMax.from(_btmArr, .45 * _timeFactor, {endArray:[_content.width >> 1, _content.height * 0.8, _content.width >> 1, _content.height * 1.2], onUpdate:transitonFunction, ease:Back.easeOut, onComplete:transitonCompleteHandler, delay:0.15});
            TweenMax.from(this, 0.4, {alpha:0});
        }
		
        public function dispose() : void
        {
            TweenMax.killTweensOf(_topArr);
            TweenMax.killTweensOf(_btmArr);
            this.graphics.clear();
            _content.bitmapData.dispose();
            _content = null;
            _fxContent = null;
        }

        private function transitonFunction() : void
        {
            this.graphics.clear();
            _fxContent.setTransform(this.graphics, _content.bitmapData, new Point(_topArr[0], _topArr[1]), new Point(_topArr[2], _topArr[3]), new Point(_btmArr[0], _btmArr[1]), new Point(_btmArr[2], _btmArr[3]));
        }

        private function transitonCompleteHandler() : void
        {
            _completeHandler();
        }

    }

}