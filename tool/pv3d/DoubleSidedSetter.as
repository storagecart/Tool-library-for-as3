/*
  Copyright (c) 2009, www.a-jie.cn
  All rights reserved.
*/

package  
{
	import flash.utils.Dictionary;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	/**
	* 设置双面
	* 
	* @langversion ActionScript 3.0
	* @playerversion Flash 9.0
	* @tiptext
	*
	*/
	public class DoubleSidedSetter 
	{
		
		static public function set( obj3d:DisplayObject3D ):void
		{
			var lMaterialsList:MaterialsList = obj3d.getMaterialsList ( );
			if ( lMaterialsList )
			{
				for each ( var lMaterial:MaterialObject3D in lMaterialsList.materialsByName )
					lMaterial.doubleSided = true;
			}
				
			var lChildren:Dictionary = Dictionary (obj3d.children);
			ERProcessChildrenMaterials ( lChildren );
		}
			
		static private function ERProcessChildrenMaterials ( aChildren:Dictionary ):void
		{
			if ( aChildren )
			{
				for each ( var lChild:DisplayObject3D in aChildren )
					ERProcessChildMaterials ( lChild );
			}
				
			var lChildren:Dictionary = Dictionary (mCollada.children);
		}
		
		static private function ERProcessChildMaterials( aChild:DisplayObject3D ):void
		{
			if ( aChild )
			{
				if ( aChild.materials )
				{
					for each ( var lMaterial:MaterialObject3D in aChild.materials.materialsByName )
						lMaterial.doubleSided = true;
				}
				
				var lChildren:Dictionary = Dictionary (aChild.children);
				ERProcessChildrenMaterials ( lChildren );
			}
		}
		
	}

}