/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.url 
{
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.system.System; 
	import flash.external.ExternalInterface;
	import tool.debug.traced;
	
	/**
	*
	* 1。设置为首页
	* 2。添加收藏夹
	* 3。获取地址栏地址并且复制到右键
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class Address 
	{
		public static function setHome():void
		{
			URL.getURL("javascript:void(document.links[0].style.behavior=’url(#default#homepage)’);void document.links[0].setHomePage(" + Address.getHTMLURL() + ");", "_self");
		}
		
		public static function favorites($name):void
		{
			ExternalInterface.call("function favorites(){if(document.all){window.external.AddFavorite('" + Address.getHTMLURL() + "','" + $name + "');}else if(window.sidebar){window.sidebar.addPanel('" + $name + "','" + Address.getHTMLURL() + "','')}}");		
		}
		
		public static function copy($txt:String = "null" ):void 
		{
			System.setClipboard($txt);  
			ExternalInterface.call("alert","您的地址已经复制成功！");	
		}
		
		public static function getSWFURL($target:DisplayObject, $bool:Boolean = false ):String
		{
			var url = LoaderInfo($target.root.loaderInfo).url;
			if ($bool) copy(url);
			return url;
		}
		
		public static function getHTMLURL($bool:Boolean = false ):String
		{
			var url = "null";
			try 
			{
				url = ExternalInterface.call("function getURL(){return window.location.href;}");	
			}catch (e:Error)
			{
				url = "null";	
			}
			
			if (!url) url = "null";
			if ($bool) copy(url);
			return url;
		}
		
	}
	
}