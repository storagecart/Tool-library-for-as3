/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.mouse 
{
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	
	/*
	* 右键菜单
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class Menu 
	{
		private var _target			:DisplayObjectContainer;
		private var _myContextMenu	:ContextMenu;
		
		public function Menu($target:DisplayObjectContainer) 
		{
			_myContextMenu = new ContextMenu();
			_myContextMenu.hideBuiltInItems();
			_target = $target;
			$target.contextMenu = _myContextMenu;
		}
		
		
		public function addItem($item:String, $fun:Function = null ):void
		{
			var item:ContextMenuItem = new ContextMenuItem($item);
			_myContextMenu.customItems.push(item);
			
			if($fun!=null)
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function() { $fun() } );
			_target.contextMenu = _myContextMenu;
		}
		
	}
	
}