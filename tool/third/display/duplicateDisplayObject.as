package tool.third.display{
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * duplicateDisplayObject
	 * creates a duplicate of the DisplayObject passed.
	 * similar to duplicateMovieClip in AVM1
	 * @param target the display object to duplicate
	 * @param autoAdd if true, adds the duplicate to the display list
	 * in which target was located
	 * @return a duplicate instance of target
	 */
	public function duplicateDisplayObject(target:DisplayObject, autoAdd:Boolean = false):DisplayObject {
		// create duplicate
		var targetClass:Class = Object(target).constructor;
		var duplicate:DisplayObject = new targetClass();trace(targetClass)
		
		// duplicate properties
		duplicate.transform = target.transform;
		duplicate.filters = target.filters;
		duplicate.cacheAsBitmap = target.cacheAsBitmap;
		duplicate.opaqueBackground = target.opaqueBackground;
		if (target.scale9Grid) {
			var rect:Rectangle = target.scale9Grid;
			// WAS Flash 9 bug where returned scale9Grid is 20x larger than assigned
			// rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
			duplicate.scale9Grid = rect;
		}
		
		// add to target parent's display list
		// if autoAdd was provided as true
		if (autoAdd && target.parent) {
			target.parent.addChild(duplicate);
		}
		return duplicate;
	}
}