/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.url 
{
	import flash.display.DisplayObject;
	import flash.external.ExternalInterface;
	import flash.net.*;
	
	/**
	* URL类处理和URL相关操作
	* 
	* 跳转html的便捷方式。                 
	* --CODE: URL.getURL("http://www.a-jie.cn","_blank");
	* 
	* 获取文件的服务器端地址。               
	* --CODE: trace(unescape(URL.url(this)));
	*
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class URL 
	{
		public function URL():void
		{
			throw(new Error("这是静态类无法被实例化!"));
		}
		
		/**
		* 将来自特定 URL 的文档加载到窗口中
		*
		* @param		$url		        String				* 指定要导航到哪个 URL
		* @param		$window		        String				* "_self" 指定当前窗口中的当前帧。
																  "_blank" 指定一个新窗口。
                                                                  "_parent" 指定当前帧的父级。
                                                                  "_top" 指定当前窗口中的顶级帧。
		*/
		public static function getURL($url:String, $window:String = "_blank") :void 
		{
			navigateToURL(new URLRequest($url), $window);
		}
		
		/**
		* 文件的服务器端地址
		*
		* @param		$root		        DisplayObject		* swf主场景
		* @return							*   				返回服务器端地址
		*/
		public static function url($root:DisplayObject):String
		{
			var _url:String;
			var _str:String=$root.loaderInfo.url;
			var num1:int=_str.lastIndexOf("\\");
			var num2:int=_str.lastIndexOf("/");			
			if (num1 > num2) 
			_url = _str.substr(0, num1 + 1);
			else
			_url = _str.substr(0, num2 + 1);
			return _url;
		}
		
		public  static function getUrlParamString(param:String):String
        {
            var returnValue:String;
            switch (param)
            {
                case "PathAndName" :
                    returnValue = ExternalInterface.call("function getUrlParams(){return window.location.pathname;}");
                    break;
                case "query" :
                    returnValue = ExternalInterface.call("function getUrlParams(){return window.location.search;}");
                    break;
                case "url" :
                    returnValue = ExternalInterface.call("function getUrlParams(){return window.location.href;}");
                    break;
                default :
                    returnValue = ExternalInterface.call("function getUrlParams(){return window.location." + param + ";}");
                    break;
            }
			
            return returnValue ;
        }
		
		public  static function getUrlParam(urlStr:String):Object
		{  
			var pattern:RegExp= /.*\?/;  
			urlStr=urlStr.replace(pattern, "");  
			if (urlStr.indexOf("=") == -1)  return null;   
			var params:Array=urlStr.split("&");  
			if (params == null || params.length == 0)   return null;  
			var paramObj:Object={};  
			for(var i:int=0;i<params.length;i++){  
				var keyValue:Array=params[i].split("=");  
				paramObj[keyValue[0]]=keyValue[1];  
			}  
			return paramObj;  
		}  
	}
	
}