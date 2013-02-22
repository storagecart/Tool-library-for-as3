/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
import tool.debug.*;

function trace(...arguments):void 
{
	arguments.unshift("<font color='#cccccc'>" + (++Debug.line ) +"</font>" + "  <i>trace</i>::  ");             //前缀
	arguments.push("<br>");                                                                                      //后缀
	Debug.array = Debug.array.concat(arguments);
	Debug.write();
}
