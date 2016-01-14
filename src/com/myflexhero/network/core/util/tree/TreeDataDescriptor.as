package com.myflexhero.network.core.util.tree
{
	import com.myflexhero.network.Node;
	import com.myflexhero.network.core.IData;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.controls.treeClasses.ITreeDataDescriptor;

	public class TreeDataDescriptor implements ITreeDataDescriptor
	{
		public function TreeDataDescriptor()
		{
			
		}
		public function getChildren(node:Object, model:Object = null):ICollectionView{
			var arr:ArrayCollection = new ArrayCollection();
			for each(var e:IData in Node(node).children){
				arr.addItem(e);
			}
			return  arr;
		}
		public function hasChildren(node:Object, model:Object = null):Boolean{
			return Node(node).children.length>0;
		}
		
		public function isBranch(node:Object, model:Object = null):Boolean{
			return Node(node).children.length>0;
		}
		
		public function getData(node:Object, model:Object = null):Object{
			return node;
		}
		
		public function addChildAt(parent:Object, newChild:Object,
							index:int, model:Object = null):Boolean{
			return Node(parent).addChild(newChild as IData,index);
		}
		public function removeChildAt(parent:Object, child:Object,
							   index:int, model:Object = null):Boolean{
			return Node(parent).removeChild(child as IData); 
		}
	}
}