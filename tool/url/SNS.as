/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.url 
{
	/**
	* SNS code
	* SNS.toSNS("sina","你好","你好你好你真好！")
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class SNS 
	{
		
		static private var _title:String;
		static private var _message:String;
		static private var _url:String;
		static private var _web:String;
		
		static public function get sina	()	:String
		{
			return "http://v.t.sina.com.cn/share/share.php?title=" + encodeURIComponent(title) + "&url=" + encodeURIComponent(url) +"&source=bookmark";
		}
		
		static public function get kaixin	()	:String
		{
			return "http://www.kaixin001.com/repaste/share.php?rtitle=" + encodeURIComponent(title) + "&rurl=" + encodeURIComponent(url) + "&rcontent=" +  _message;
		}
		
		static public function get renren	()	:String
		{
			return "http://share.renren.com/share/buttonshare.do?link=" + encodeURIComponent(url) + "&title=" + encodeURIComponent(title);
		}
		
		static public function get msn	()	:String
		{
			return "http://profile.live.com/badge?url=" + encodeURIComponent(url) + "&title=" + encodeURIComponent(title);
		}
		
		
		static public function get sohu	()	:String
		{
			return "http://t.sohu.com/third/post.jsp?url=" + encodeURIComponent(url) +"&title=" + title + "&content=" + _message;
		}
		
		static public function get w163	()	:String
		{          
			return "http://t.163.com/article/user/checkLogin.do?source=" + encodeURIComponent(_web) + "&info=" + _message;
		}
		
		static public function get qqblog	()	:String
		{
			return "http://v.t.qq.com/share/share.php?title="+encodeURIComponent(title)+"&url="+encodeURIComponent(url)+"&appkey=118cd1d635c44eab9a4840b2fbf8b0fb&site=www.ogilvy.com.cn&pic=";
		}
		
		static public function get qqzone	()	:String
		{
			return "http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?url=" + encodeURIComponent(url);
		}
		
		static public function get douban	()	:String
		{
			return "http://www.douban.com/recommend/?url=" + url + "&title=" + encodeURIComponent(title) + "&v=1";
		}
		
		///////////////////////////////////////////////////
		static public function  get title():String
		{
			return _title;
		}
		
		static public function  set title($t):void
		{
			_title = $t;
		}
		
		static public function get url():String
		{
			return _url;
		}
		
		static public function get message():String
		{
			return _message;
		}
		
		static public function toSNS($type:String, $title:String = "" , $message:String = "" ,$web:String = ""):void
		{
			_url = Address.getHTMLURL();
			_title = $title;
			_message = encodeURIComponent($message);
			_web = $web;
			
			if ($type == "kaixin")
				URL.getURL(kaixin);
			else if ($type == "sina")
				URL.getURL(sina);
			else if ($type == "renren")
				URL.getURL(renren);
			else if ($type == "msn")
				URL.getURL(msn);
			else if ($type == "sohu")
				URL.getURL(sohu);
			else if ($type == "w163")
				URL.getURL(w163);
			else if ($type == "qqblog")
				URL.getURL(qqblog);
			else if ($type == "qqzone")
				URL.getURL(qqzone);
			else if ($type == "copy")
				Address.getHTMLURL(true);
			else if ($type == "favorites")
				Address.favorites(title);
		}
		
		public static const KAIXIN:String = 'kaixin';
		public static const SINA:String = 'sina';
		public static const RENREN:String = 'renren';
		public static const MSN:String = 'msn';
		public static const SOHU:String = 'sohu';
		public static const W163:String = 'w163';
		public static const QQBLOG:String = 'qqblog';
		public static const QQZONE:String = 'qqzone';
		public static const COPY:String = 'copy';	
		public static const DOUBAN:String = 'douban';	
		public static const FAVORITES:String = 'favorites';
		
	}

}