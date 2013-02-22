/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.events 
{
	import flash.events.Event;
	
	/**
	* list相关的事件
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class ListEvent extends Event 
	{
		public static const LIST_ADDED:			String = "listAdded";					//添加新闻
		
		public static const LIST_REMOVED:		String = "listRemoved";					//删除新闻
		
		public static const LIST_VOTED:		 	String = "listVoted";					//投票完毕
		
		public static const LIST_BEGIN:			String = "listBegin";           		//开始加载
		
		public static const LIST_REFRESH:		String = "listRefresh";           		//开始刷新
		
		public static const LIST_COMPLETE:		String = "listComplete";   				//加载完毕
		
		public function ListEvent($type:String, $bubbles:Boolean = false, $cancelable:Boolean = false)
		{
			super($type, $bubbles, $cancelable);
		}
		
	}
	
}