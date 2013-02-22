/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
  
package tool.data 
{
	import flash.net.*;
	import flash.events.*;
	import flash.utils.Dictionary;
	
	import tool.events.LoadEvent;
	import tool.events.ListEvent;
	import tool.xml.xmlToArray;
	import tool.url.Cookies;
	
	/**
	* ListPage类，实现flash列表的相关功能
	* 
	* 导入相关类                            				 
	* --CODE: import tool.data.ListPage;
	* --CODE: import tool.events.LoadEvent;
	* --CODE: import tool.events.ListEvent;
	* 
	* 声明方法  
	* --CODE: var myListPage=new ListPage("news_xml.aspx");
	* 
	* 设置标签
	* --CODE: myListPage.setTag({"list":"news","title":"title","url":"link"});
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class ListPage extends EventDispatcher
	{
		public var length						:uint;						//列表条数
		public var list							:Array;						//列表的数组
		public var xml							:XML;						//
		
		public var voteMax						:uint = 1;					//最大的投票数
		public var timeOut						:Number = 24 * 60 * 60;		//cookie过期时间（秒--[默认一天]）
		public var input						:Boolean = true;			//是否输出trace(默认输出)
		
		private var _url						:String;
		private var _r1							:Boolean;
		private var _r2							:Boolean;
		
		private var _tagObject					:TagObject;
		private var _object						:Object;
		private var _mainDI						:DataInterface;
		private var _aidDic						:Dictionary;
		private var _cookies					:Cookies;
		
		public function get dataInterface():DataInterface
		{
			return _mainDI;
		}
		
		public function ListPage($url:String = "", $variables:URLVariables = null , $method:String = "POST", $dataFormat:String = "text", $valueMode:String = "xmls" ) 
		{
			if ($url == "") return;
			
			_tagObject 	= new TagObject();
			_url 		= $url;
			_mainDI 	= new DataInterface($url, $variables, $method, $dataFormat, $valueMode );	
			_mainDI .addEventListener(LoadEvent.LOAD_COMPLETE, loadCompleteHandler);
			_mainDI .load();
			
			dispatchEvent(new ListEvent(ListEvent.LIST_BEGIN));
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		public function setTag($tag:Object):void
		{
			_object = $tag;
			for (var property in $tag)
			{
				if (_tagObject.hasOwnProperty(property))
				{
					_tagObject[property] = $tag[property];
				}
			}
		}
		
		//添加新闻
		public function add($url:String , $variables:URLVariables = null, $refresh:Boolean = true , $method:String = "POST", $dataFormat:String = "text", $valueMode:String = "xmls" ):DataInterface
		{
			_r1				  = $refresh;
			var dataInterface = new DataInterface($url, $variables, $method, $dataFormat, $valueMode );
			dataInterface .addEventListener(LoadEvent.LOAD_COMPLETE, addLoadCompleteHandler);
			dataInterface .load();
			
			return dataInterface;
		}
		
		//删除新闻
		public function remove($url:String , id:uint = 1 , $refresh:Boolean = true ):DataInterface
		{
			_r2 			= $refresh;
			var variables 	= new URLVariables();
			variables.id 	= String(id);
			var dataInterface = new DataInterface($url, variables, "POST", URLLoaderDataFormat.TEXT, ValueMode.XMLS);
			dataInterface .valueMode=ValueMode.XMLS;
			dataInterface .addEventListener(LoadEvent.LOAD_COMPLETE, removeLoadCompleteHandler);
			dataInterface .load();
			
			return dataInterface;
		}
		
		//投票
		public function vote($url:String , id:uint = 1 ):DataInterface
		{
			if (!_aidDic)_aidDic   = new Dictionary();
			if (!_cookies)_cookies = new Cookies("$_ListPage_$", timeOut , true);
			var obj 	= new Object;trace(_cookies.getKey("vote").number)
			obj.number 	= _cookies.contains("vote") ? _cookies.getKey("vote").number : 0;
			
			if (obj.number < voteMax)
			{
				var variables 		= new URLVariables();
				variables.id 		= String(id);
				//硬挨是id
				var dataInterface 	= new DataInterface($url, variables, "POST", URLLoaderDataFormat.TEXT, ValueMode.STRING);
				dataInterface .addEventListener(LoadEvent.LOAD_COMPLETE, voteLoadCompleteHandler);
				dataInterface .load();
				_aidDic[dataInterface] = obj;
				if(input)
					trace("您已经对：id=" + id + "投了" + obj.number + "票！  " + "在" + timeOut/3600 + "小时内，最多可以投" + voteMax + "票。");
				
				return dataInterface;
			}else
			{
				if(input)
					trace("您已经对：id=" + id + "投了" + obj.number + "票！  " + "在" + timeOut/3600 + "小时内，最多可以投" + voteMax + "票。");
				return null;
			}
		}
		
		//刷新列表
		public function refresh($variables:URLVariables = null):void
		{
			_mainDI.urlVar = $variables;
			_mainDI.load(_url);
			
			dispatchEvent(new ListEvent(ListEvent.LIST_REFRESH));
		}
		
		///////////////////////////////////
		// private methods
		///////////////////////////////////
		private function addLoadCompleteHandler(e:LoadEvent):void
		{
			if (_r1) refresh();
			dispatchEvent(new ListEvent(ListEvent.LIST_ADDED));
		}
		
		private function removeLoadCompleteHandler(e:LoadEvent):void
		{
			if (_r2) refresh();
			dispatchEvent(new ListEvent(ListEvent.LIST_REMOVED));
		}
		
		private function voteLoadCompleteHandler(e:LoadEvent):void
		{
			if (!_aidDic[e.currentTarget].number && _aidDic[e.currentTarget].number != 0 )
				_aidDic[e.currentTarget].number = 0;
			else 
				_aidDic[e.currentTarget].number ++;
				
			_cookies.putKey("vote", _aidDic[e.currentTarget]);
			dispatchEvent(new ListEvent(ListEvent.LIST_VOTED));
		}
		
		private function loadCompleteHandler(e:LoadEvent):void
		{
			var result:XML		= _mainDI.value; 
			var itemArray:Array = xmlToArray(result[_tagObject.list]);
			length 				= itemArray.length ;
			list 				= new Array();	
			xml					= result;
			
			for (var i:uint = 0; i < length; i++ )
			{
				var tagObject = new TagObject();
				 
				for (var property in _object)
				{
					if (_tagObject[property])
					{
						tagObject[property] = itemArray[i][_tagObject[property]];
					}
				}
				
				list.push(tagObject);
			}
			trace(result);
			if (input)
			{
				trace("---------------------------  总共有" + length + "条列表  ---------------------------");
				for (i = 0; i < length; i++)
				{
					if (list[i].title)
						trace("标题： " + list[i].title);
				}
			}
			dispatchEvent(new ListEvent(ListEvent.LIST_COMPLETE));
		}	
	}
}

class TagObject 
{
	public var list							:String;		//列表---根目录
	
	public var id							:String;		//id
	public var title						:String;		//标题
	public var content						:String;		//内容
	public var thumb						:String;		//缩略图
	public var image						:String;		//大图
	public var url							:String;		//link
	public var email						:String;		//email
	public var score						:String;		//正得分
	public var score2						:String;		//负得分
	
	public var page							:String;		//页数
	public var current						:String;		//当前页
	public var total						:String;		//总条数
	
	public var other						:String;		//其他
}