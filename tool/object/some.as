/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.object 
{
	
	/**
	* 简单遍历并调用对象集属性
	* 简化代码步骤
	* 
	* --CODE: import tool.object.some;
	* --CODE: some(mc1, {alpha:0, scaleX:.5 ,buttoMode:true});
	* --CODE: some(mc1, {gotoAndStop:2, startDrag:null});
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public function some($target:Object,$proper:Object):void 
	{
		for (var properties in $proper )
		{
			if ($target.hasOwnProperty(properties))
			{
				try {
					$target[properties] = $proper[properties];
				}catch (e:Error)
				{
					if ($proper[properties] != null)
					{
						if ($proper[properties] is Array)
						{
							try {
								$target[properties].apply(null, $proper[properties]);
							}catch (e:Error){}
						}else
						{
							$target[properties]($proper[properties]);
						}
					}else {
						$target[properties]();
					}
				}
			}
		}
	}
	
}