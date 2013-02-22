/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.url 
{
	import flash.net.SharedObject;
	
	/**
	* shareObject类似于cookies的功能
	* 
	* 导入类
	* --CODE: import tool.url.Cookies;
	* 
	* 声明并清除超时内容（超时时间单位为秒）
	* --CODE: var var cookies=new Cookies("a-jie",5,true);
	* 
	* 设置和获取key值
	* --CODE: var obj = new Object;
	* --CODE: var obj.number = cookies.getKey("click") ? cookies.getKey("click").number : 0;
	* 
	* --CODE: var cookies.putKey("click",obj);
	* --CODE: var cookies.getKey("click").number;
	* 
	* 删除key值
	* --CODE: cookies.remove("a-jie");
	* 
	* key值是否存在;  
	* --CODE: cookies.contains("a-jie");
	* 
	* 清除cookies
	* --CODE: cookies.clear();
	*
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class Cookies
	{
		private var _timeOut:				uint;
		private var _name:					String;
		private var _sharedObject:			SharedObject;
		
		public function get name():String
		{
			return _name;  
		}
		
		public function get timeOut():uint
		{
			return _timeOut;  
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/**
		* 构造函数
		* @param		$name		        	String		     		     * cookies名字
		* @param		$timeOut		        uint		      			 * 过期时间（秒）
		* @param		$clear		       	 	Boolean		      			 * 是否清除缓存
		*/  
		public function Cookies($name:String = "@#$%myCookies", $timeOut:uint = 3600 , $clear:Boolean = false ):void 
		{
			_name 			= $name;
			_timeOut 		= $timeOut;
			_sharedObject 	= SharedObject.getLocal(_name, "/");
			if ($clear) clearTimeOut();
		}
		 
		//清除超时内容;  
        public function clearTimeOut():void 
		{  
            var obj:* = _sharedObject.data.cookie;  
            if(obj == undefined) return;  
			
            for (var key in obj)
			{  
                if (obj[key] == undefined || obj[key].time == undefined || isTimeOut(obj[key].time))
				{  
                    delete obj[key];  
                }  
            }  
            _sharedObject.data.cookie = obj;  
            _sharedObject.flush();  
        }   
          
        //清除Cookie;  
        public function clear():void
		{  
            _sharedObject.clear();  
        }  
          
        //添加key值  
        public function putKey(key:String, value:*):void 
		{  
            var today:Date 	= new Date();  
            key 			= "$key_" + key;
			
            if (_sharedObject.data.cookie == undefined || _sharedObject.data.cookie == null ) {  
                var obj:Object 	= new Object();  
                obj[key] 		= value;  
				obj[key].time	= today.getTime();  
                _sharedObject.data.cookie = obj;  
            }else{  
                _sharedObject.data.cookie[key] = value;  
				_sharedObject.data.cookie[key].time	= today.getTime(); 
            }  
            _sharedObject.flush();  
        } 
		
		//获取key值;  
        public function getKey(key:String):Object
		{       
            return contains(key)?_sharedObject.data.cookie["$key_" + key]:null; 
        }  
           
        //删除key值;  
        public function remove(key:String):void 
		{  
            if (contains(key)) 
			{  
                delete _sharedObject.data.cookie["$key_" + key];  
                _sharedObject.flush();  
            }  
        }  
     
        //key值是否存在;  
        public function contains(key:String):Boolean
		{  
            key = "$key_" + key;  
            return _sharedObject.data.cookie != undefined && _sharedObject.data.cookie[key] != undefined;
        } 
		 
		private function isTimeOut(time:Number):Boolean 
		{  
            var today:Date = new Date();  
            return (time + _timeOut * 1000) < today.getTime();  
			
        }
	}

}