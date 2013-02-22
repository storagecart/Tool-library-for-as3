/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.data 
{
	import flash.net.*;
	import flash.events.*;
	
	import tool.events.LoadEvent;
	
	/**
	* DataInterface类简化了flash和后台数据之间的交互。在下载文本文件、XML 或其它用于动态数据驱动应用程序的信息时，它很有用。 
	* 
	* 导入类                            				 
	* --CODE: import tool.data.*;
	* 
	* 两种声明方法  
	* --CODE: var myData:DataInterface=new DataInterface("book.txt");
	* --CODE: var myData:DataInterface=new DataInterface("metro.xml",myVariables,"POST",URLLoaderDataFormat.VARIABLES,ValueMode.XMLS);
	* 
	* 加载并重新修改变量
	* --CODE: myData.url="metro.xml";                          			//要访问的URL地址
	* --CODE: myData.urlVar=myVariables;        		    			//随URL请求一起传输的数据
	* --CODE: myData.method=URLRequestMethod.POST;        		    	//控制 HTTP 窗体提交方法是 GET 还是 POST 操作
	* --CODE: myData.dataFormat=URLLoaderDataFormat.VARIABLES;          //以文本、原始二进制数据还是URL编码变量接收下载的数据
	* --CODE: myData.valueMode=ValueMode.XMLS;        					//返回数据的类型
	* --CODE: myData.load();                          					//加载
	* 
	* 关闭加载
	* --CODE: myData.close();
	* 
	* 返回的数据
	* --CODE: var myValue=myData.value;                                 //返回的数据(很重要)
	* 
	* 加载的数据(用于loading)
	* --CODE: var loaded:Number=myData.bytesLoaded;						//已加载的字节数
	* --CODE: var total:Number=myData.bytesTotal;						//总的的字节数
	* --CODE: var progress:Number=myData.progress;						//加载的进度比例 (0-1)
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class DataInterface extends EventDispatcher
	{
		
		private var _loader:					URLLoader;
		private var _urlRequest:				URLRequest;
		
		private var _bytesLoaded:				Number = 0;
		private var _bytesTotal:				Number = -1;
		private var _progress:					Number = 0;
		
		private var _url:                       String;
		private var _urlVar:              		URLVariables 
		private var _method:					String
		private var _dataFormat:				String;
		private var _valueMode:                 String;
		private var _value:						*;
		
		public function set url($url):void
		{
			_url = $url;
			urlRequest(_url);
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get bytesLoaded():Number
		{
			return _bytesLoaded;
		}

		public function get bytesTotal():Number
		{
			return _bytesTotal;
		}
		
		public function get progress():Number
		{
			return _progress;
		}
		
		public function set urlVar($urlVar:URLVariables):void
		{
			_urlVar = $urlVar;
			_urlRequest.data = _urlVar;
		}
		
		public function get urlVar():URLVariables
		{
			return _urlVar;
		}
		
		public function set method($method:String):void
		{
			_method = $method;
			_urlRequest.method = _method;
		}
		
		public function get method():String
		{
			return _method;
		}
		
		public function set dataFormat($dataFormat:String):void
		{
			_dataFormat = $dataFormat;
			_loader.dataFormat = _dataFormat;
		}
		
		public function get dataFormat():String
		{
			return _dataFormat;
		}
		
		public function set valueMode($valueMode:String):void
		{
			_valueMode = $valueMode;
		}
		
		public function get valueMode():String
		{
			return _valueMode;
		}
		
		public function get value():*
		{
			return _value;
		}
		
		public static function  sendToURL($url:String, $urlVar:URLVariables = null , $method:String = "POST" ):void
		{
			var urlRequest:URLRequest = new URLRequest($url);
			if ($urlVar != null)
			{
				var urlVar = $urlVar;
				urlRequest.data = urlVar;
			}
			urlRequest.method = $method;
			
			flash.net.sendToURL(urlRequest);
		}
		
		//===========================================================================================================================
		/**
		* 构造函数
		* @param		$url		      	  	String		 				 * 要访问的URL地址
		* @param		$urlVar		       		URLVariables		         * 随URL请求一起传输的数据
		* @param		$method		        	String		     		     * 控制 HTTP 窗体提交方法是 GET 还是 POST 操作
		* @param		$dataFormat		        String		      			 * 以文本 (URLLoaderDataFormat.TEXT)、原始二进制数据 (URLLoaderDataFormat.BINARY) 还是 URL 编码变量 (URLLoaderDataFormat.VARIABLES) 接收下载的数据
		* @param		$valueMode		        String		         		 * 返回数据的类型
		*/  
		public function DataInterface($url:String = null , $urlVar:URLVariables = null , $method:String = "POST", $dataFormat:String = "text", $valueMode:String = "string" ) 
		{	
			_url 		= $url;
			_urlVar 	= $urlVar;
			_method 	= $method;
			_dataFormat = $dataFormat;
			urlRequest(_url);
			
			_valueMode 	= $valueMode;
			_loader 	= new URLLoader();
			_loader.dataFormat = _dataFormat;
			configureListeners(_loader);
		}
		 
		/**
		* 从指定的 URL 发送和加载数据。
		* @param		$url		      	  	String		 				 * 要访问的URL地址(默认值为声明实例时的URL)
		*/  
		public function load($url:String = "-1" ):void
		{
			if ($url != "-1")
			{
				_url = $url;
				urlRequest(_url);
			}
			
			try 
			{ 
				_loader.load(_urlRequest);
				dispatchEvent(new LoadEvent(LoadEvent.LOAD_BEGIN));
			} catch (e:Error) 
			{
				throw(new Error("无法连接到资源")); 
			}
		}
		
		/**
		* 关闭进行中的加载操作
		*/  
		public function close():void 
		{
			_loader.close();
		}
		
		private function urlRequest($url:String):void
		{
			_urlRequest = new URLRequest($url);
			_urlRequest.method = _method;
			_urlRequest.data = _urlVar;
		}
		
		//侦听
		private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler, false, 0, true );
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true );
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true );
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true );
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true );
        }
		
		//加载成功
		private function completeHandler(event:Event):void
		{
			_loader.removeEventListener(Event.COMPLETE, completeHandler);
			switch (_valueMode)
			{
				case "xmls":
					_value = new XML(_loader.data);
					break;
				
				case "variables":
					_value = new URLVariables(_loader.data);
					break;
					
				case "string":
					_value = String(_loader.data);
					break;
			}
			
			dispatchEvent(new LoadEvent(LoadEvent.LOAD_COMPLETE) );
		}

        private function progressHandler(event:ProgressEvent):void 
		{
            _bytesLoaded = event.bytesLoaded;
			_bytesTotal = event.bytesTotal;
			_progress = _bytesLoaded / _bytesTotal;
			dispatchEvent(new LoadEvent(LoadEvent.LOAD_PROGRESS ));
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void 
		{
            trace("跨域安全错误");
			dispatchEvent(new LoadEvent(LoadEvent.LOAD_ERROR ));
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void 
		{
            switch(event.status)
			{
				case 403:
					trace("没有权限访问文件");
					dispatchEvent(new LoadEvent(LoadEvent.LOAD_ERROR ));
					break;
					
				case 404:
					trace("找不到文件");
					dispatchEvent(new LoadEvent(LoadEvent.LOAD_ERROR ));
					break;
					
				case 500:
					trace("服务器内部错误");
					dispatchEvent(new LoadEvent(LoadEvent.LOAD_ERROR ));
					break;
					
				default:
					break;
			}
        }

        private function ioErrorHandler(event:IOErrorEvent):void
		{
            trace("加载操作错误");
			dispatchEvent(new LoadEvent(LoadEvent.LOAD_ERROR ));
        }
		
	}
	
}