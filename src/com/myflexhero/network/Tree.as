package com.myflexhero.network
{
	import com.myflexhero.network.core.IElement;
	import com.myflexhero.network.core.util.tree.TreeDataDescriptor;
	import com.myflexhero.network.core.util.tree.TreeItemLinesRenderer;
	
	import mx.controls.Tree;
	import mx.core.ClassFactory;
	import mx.events.ListEvent;
	/**
	 * 通过对Tree的简单包装，实现节点导航树的展示。<br>
	 * 点击树中节点，拓扑界面中节点将被选中.<br>
	 * 需为该组件设置network属性
	 * @author Hedy
	 */
	public class Tree extends mx.controls.Tree
	{
		/**
		 * network引用
		 */
		private var _network:Network;

		public function set network(value:Network):void
		{
			_network = value;
		}

		/**
		 * 当点击树中节点时，默认会调用network中的选中函数(network.setSelectedElements()及network.ensureElementIsVisible())对节点进行选中。<p>
		 * 如果需要进行自定义处理，请设置该属性为false，该组件将跳过选中处理。请通过类似于<b>addEventListener(ListEvent.ITEM_CLICK,itemClickHandler)</b>的方式进行自定义监听并处理。
		 */
		private var _useDefaultItemClickHandler:Boolean;

		public function set useDefaultItemClickHandler(value:Boolean):void
		{
			_useDefaultItemClickHandler = value;
		}

		public function Tree(network:Network=null,useDefaultItemClickHandler:Boolean = true)
		{
			super();
			if(network)
				this.network = network;
			itemRenderer = new ClassFactory(TreeItemLinesRenderer);
			dataDescriptor = new TreeDataDescriptor();
			addEventListener(ListEvent.ITEM_CLICK,itemClickHandler);
		}
		
		/**
 		 * Item Click函数,对界面中的节点进行选中.
 		 */
		protected function itemClickHandler(event:ListEvent):void
		{
			if(_useDefaultItemClickHandler&&this.selectedIndex!=-1&&this.selectedItem){
				var node:Node = this.selectedItem as Node;
				var eID:Object = node.id;
				_network.elementBox.forEach(function(element:IElement):void{
					if(element is Node){
						var n:Node = element as Node;
						if(n.id ==eID){
							//额外添加高亮
							//node.isLock = true;
							//node.highLightEnable = true;
							//node.isLock = false;
							//设置为选中
							_network.setSelectedElements(n,false);
							_network.ensureElementIsVisible(n);
						}else if(_network.selectedElements.indexOf(element)!=-1)
							_network.setSelectedElements(null,false);
						
					}
				});
			}
		}
	}
}