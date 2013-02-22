package tool.url 
{
	import flash.external.ExternalInterface;
	
	public class HtmCookies 
	{
        private static const FUNCTION_SETCOOKIE:String =
        "document.insertScript = function ()" +
        "{ " +
          "if (document.snw_setCookie==null)" +
          "{" +
            "snw_setCookie = function (name, value, days)" +
            "{" +
              "if (days) {"+
                              "var date = new Date();"+
                              "date.setTime(date.getTime()+(days*24*60*60*1000));"+
                              "var expires = '; expires='+date.toGMTString();"+
                          "}" +
                          "else var expires = '';"+
                          "document.cookie = name+'='+value+expires+'; path=/';" +
                "}" +
          "}" +
        "}";
			
        private static const FUNCTION_GETCOOKIE:String =
        "document.insertScript = function ()" +
        "{ " +
          "if (document.snw_getCookie==null)" +
          "{" +
            "snw_getCookie = function (name)" +
            "{" +
              "var nameEQ = name + '=';"+
                          "var ca = document.cookie.split(';');"+
                          "for(var i=0;i < ca.length;i++) {"+
                              "var c = ca[i];"+
                              "while (c.charAt(0)==' ') c = c.substring(1,c.length);"+
                              "if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);"+
                          "}"+
                          "return null;" +
                "}" +
          "}" +
        "}";
		
		private static var INITIALIZED:Boolean = false;
		
		public static function init():void
		{
			ExternalInterface.call(FUNCTION_GETCOOKIE);
			ExternalInterface.call(FUNCTION_SETCOOKIE);
			INITIALIZED = true;
		}
		
		public static function setCookie(name:String, value:Object, days:int = .5):void
		{
			if(!INITIALIZED)init();
			ExternalInterface.call("snw_setCookie", name, value, days);
		}
		
		public static function getCookie(name:String):Object
		{
			if(!INITIALIZED)init();
			return ExternalInterface.call("snw_getCookie", name);
		}
		
		public static function deleteCookie(name:String):void
		{
			if(!INITIALIZED)init();
			ExternalInterface.call("snw_setCookie", name, "", -1);
		}
	}

}