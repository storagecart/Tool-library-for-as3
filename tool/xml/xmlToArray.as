/*

              .======.
              | INRI |
              |      |
              |      |
     .========'      '========.
     |   _      xxxx      _   |
     |  /_;-.__ / _\  _.-;_\  |
     |     `-._`'`_/'`.-'     |
     '========.`\   /`========'
              | |  / |
              |/-.(  |
              |\_._\ |
              | \ \`;|
              |  > |/|
              | / // |
              | |//  |
              | \(\  |
              |  ``  |
              |      |
              |      |
              |      |
              |      |
  \\    _  _\\| \//  |//_   _ \// _
 ^ `^`^ ^`` `^ ^` ``^^`  `^^` `^ `^
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.xml 
{
	
	/**
	* 将xml或者xmlList转换为数组
	* 
	* --CODE: var array = xmlToArray(myXML);
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public function  xmlToArray ($xml:*):Array
	{
		if (!($xml is XML ||$xml is XMLList)) throw(new Error("请传入XML或者XMLList类型！"));;
		
		var array = new Array();
		
		for (var i:uint = 0; i < $xml.length(); i++ ) 
		{
			array.push($xml[i]);
		}
			
		return array;
	}
	
}