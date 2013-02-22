/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.test 
{
	import tool.display.website.SubMovieClip;
	import tool.load.MCLoader;
	
	/**
	*
	* 测试框架
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class MainLoad extends SubMovieClip
	{
		public var mcloader:MCLoader;
		
		public function loadSWF($url:String, $p:Object = null ):void 
		{
			mcloader = new MCLoader($url, this);
		}
		
	}
	
}