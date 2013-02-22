/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package tool.object
{	
	/**
	* 全体对象调整
	* 简化代码步骤
	* 
	* --CODE: import tool.object.all;
	* --CODE: all(mc1,mc2,mc3,mc4,mc5,mc6,"stop");
	* --CODE: all(mc1,mc2,mc3,mc4,mc5,mc6,"gotoAndStop",1);
	* --CODE: all(mc1,mc2,mc3,mc4,mc5,mc6,"buttonMode",true);
	* --CODE: all(mc1,mc2,mc3,mc4,mc5,mc6,"addEventListener",MouseEvent.MOUSE_OVER,mouseOverHandler);
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public function all(...arguments):*
	{
		var target_array:Array;
		var property_array:Array;
		var property:String;
	 
		var length:Number = arguments.length;
		if (length < 2) throw(new Error("参数不完整"));
		
		var num:Number = -1;
		for (var i:uint = 0; i < length; i++)
		{
			var target = arguments[i];
			if (target is String)
			{
				num = i;
				property = target;
				break;
			}
		}
		if (num == -1) throw(new Error("没有传入公共方法或属性"));
		target_array = arguments.slice(0, num);
		if (num < length - 1) property_array = arguments.slice(num + 1, length);
		else property_array = [];
		propertyFUN();
		
		//----------------------------------------
		function propertyFUN():void
		{
		for (var i:uint = 0; i < target_array.length; i++)
		{
			var target = target_array[i];
			switch(property_array.length)
			{
				case 0:
					try {
						target[property]();
					}catch (e:Error){
					}
					break;
				
				case 1:
					try {
						target[property] = property_array[0];
					}catch (e:Error){
						target[property](property_array[0]);
					}
					break;
				
				default:
					try {
						target[property].apply(null, property_array);
					}catch (e:Error){
					}
					break;
			}
		}
		}
	}
	
}