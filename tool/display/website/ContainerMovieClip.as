/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/
 
package tool.display.website
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import tool.object.AClass;
	import tool.load.MCLoader;
	
	/*
	* movieClip容器，一般用来存放加载的 swf（供父类继承）
	* 
	* ================================SUB_MC_SWF里的函数disAppear=======================================
	* 	public function disAppear($disAppearCompleted:Function):void
		{
			prevPlay(this, this, 1, 3 );
			TweenMax.delayedCall(.8, $disAppearCompleted);
		}
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	
	public class ContainerMovieClip extends SubMovieClip
	{
		///////////////////////////////////
		// public property
		///////////////////////////////////
		static public const AABB:String = 'AABB';				//一个退场结束后另一个进场
		static public const ABAB:String = 'ABAB';				//一个退场紧接着另一个进场
		
		static public var MOVE_MODE:String = AABB;
		
		//当前的swf id
		public var CURRENT_ID:int = -1;
		//子swf的地址数组
		public var SWF_URL:Array;
		
		//loader对象
		public var loader:MCLoader;
		
		public var LOACTION:String = "outSide";
		
		static public const OUTSIDE:String = "outSide";
		static public const INSIDE:String = "inSide";
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		//开始加载
		public function loadSWF($id:uint ):void
		{
			if (CURRENT_ID != $id)
			{	
				CURRENT_ID = $id;
				
				if (MOVE_MODE == AABB)
				{
					if (this.numChildren <= 0)appear();
					else disAppear();
				} else if (MOVE_MODE == ABAB)
				{
					disAppear();
					appear();
				}
			}
		}
		
		//加载新swf并出场
		public function appear():void
		{
			if (LOACTION == "outSide")
				outLoader();
			else  if(LOACTION == "inSide")
				inLoader();
		}
		
		protected function inLoader():void
		{
			var ClassReference:Class  = AClass.getClass(SWF_URL[CURRENT_ID]);
			var oMC:*= new ClassReference();
			addChildAndInit(this, oMC);
		}
		
		protected function outLoader():void
		{
			if (loader)
			{
				loader.close();
				loader = null;
			}
			
			loader = new MCLoader(SWF_URL[CURRENT_ID], this);
		}
		
		//swf退场
		public function disAppear():void
		{
			/////////////////// 调用disAppearCompleted
			/////////////////// MC.disAppear();------------------disAppearCompleted();
			
			
			/////////////////////////以下代码仅为一种参考的解决方案//////////////////////////////
			if (MOVE_MODE == AABB) 
			{
				/////////////////////////AABBAABBAABBAABB//////////////////////////////
				if (numChildren > 0)
				{
					if(LOACTION == ContainerMovieClip.INSIDE)
					{
						if (getChildAt(0).hasOwnProperty('disAppear')) getChildAt(0)['disAppear'](disAppearCompleted);
					}else
					{
						if(getChildAt(0) is Loader)
						{
							if (Loader(getChildAt(0)).getChildAt(0).hasOwnProperty('disAppear')) Loader(getChildAt(0)).getChildAt(0)['disAppear'](disAppearCompleted);
						}else 
						{
							if (getChildAt(0).hasOwnProperty('disAppear')) getChildAt(0)['disAppear'](disAppearCompleted);
						}
					}
				}
			}else if (MOVE_MODE == ABAB)
			{
				/////////////////////////ABABABABABABAB//////////////////////////////
				for (var i:uint = 0; i < numChildren;i++ )
				{
					if(LOACTION == ContainerMovieClip.INSIDE)
					{
						if (getChildAt(i).hasOwnProperty('disAppear')) getChildAt(i)['disAppear']();
					}else
					{
						if(getChildAt(0) is Loader)
						{
							if (Loader(getChildAt(i)).getChildAt(0).hasOwnProperty('disAppear')) Loader(getChildAt(i)).getChildAt(0)['disAppear']();
						}else 
						{
							if (getChildAt(i).hasOwnProperty('disAppear')) getChildAt(i)['disAppear']();
						}
					}
				}
			}
		}
		
		//退场完成新的加载
		public function disAppearCompleted():void
		{
			DisplayHelper.clear(this);
			appear();
		}
		
	}
	
}