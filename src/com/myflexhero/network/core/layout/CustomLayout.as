package com.myflexhero.network.core.layout
{
	import com.myflexhero.network.Link;
	import com.myflexhero.network.Network;
	import com.myflexhero.network.Node;
	import com.myflexhero.network.core.ICustomLayout;
	import com.myflexhero.network.core.IElementUI;
	
	import flash.geom.Point;
	
	import mx.core.mx_internal;

 	use namespace mx_internal;
	
	/**
	 * 自定义布局的基类,提供了部分通用的方法。
	 * @author Hedy
	 */
	public class CustomLayout extends BasicLayout implements ICustomLayout
	{
		protected var _topNodes:Vector.<Node>;

		/**
		 * 舞台宽度
		 */
		public var stageWidth:Number;
		
		/**
		 * 舞台高度
		 */
		public var stageHeight:Number;

		/**
		 * 临时变量,作为参考的当前界面显示的顶级节点及子节点(根据对应的层数)
		 */
		protected var _displayingNodes:Vector.<Node>;
		/**
		 * 当前节点的连接
		 */
		protected var _displayingLinks:Vector.<Link>;
		
		/**
		 *  是否清除全部
		 */
		protected var _clearAll:Boolean = false;
		
		public function CustomLayout(network:Network)
		{
			super(network);
			_topNodes = Network.createVectorNodes();
			stageWidth = network.width;
			stageHeight = network.height;
		}
		
		public function doLayout():void{
		}
		

		//***************************************************************************************
		//
		//    设置需要显示的节点
		//
		//***************************************************************************************
		/**
		 * 初始化节点以根据节点层数显示对应的节点。<br>
		 * 如果设置了depthLimit属性，则每一次只显示对应的层数，而此时的currentNode作为点击的节点，开始计算层数。
		 * @param currentNode 当前的顶级节点(不包括额外显示的上级节点)，根据该参数和layerLimit参数来更新需要显示的节点数量.
		 */
		protected function setSelectedNode(currentNode:Node=null):void{
			//			var startTime:int = getTimer();
			//			currentCompareNode = currentNode==null?null:currentNode;
			/* 显示全部 */
			if(limit==0||isNaN(limit)||isAppendMode){
				/**
				 * 直接引用会在下一次被删除，所以传递
				 */
				if(nodes)
					_displayingNodes = nodes.slice(0);
				else
					_displayingNodes =  Network.createVectorNodes();
				if(links)
					_displayingLinks = links.slice(0);
				else
					_displayingLinks = Network.createVectorLinks();
				return;
			}
			/* 显示自定义的节点层数 */
			if(_displayingNodes==null)
				_displayingNodes = Network.createVectorNodes();
			else
				_displayingNodes.splice(0,_displayingNodes.length);
			
			if(_displayingLinks==null)
				_displayingLinks = Network.createVectorLinks();
			else
				_displayingLinks.splice(0,_displayingLinks.length);
			
			/* currentNode=当前的顶级节点(不包括额外显示的上级节点) 
			设置当前可见的顶级节点及外观特效 */
			if(currentNode){
				if(!currentNode.parent){
					/*当前为顶级节点,显示全部顶级节点*/
					_displayingNodes = _topNodes.slice(0);
				}else
					_displayingNodes.push(currentNode);
			}else{
				//初次进入
				_displayingNodes = _topNodes.slice(0);
			}
			
			var _len:int = _displayingNodes.length;
			/* 设置需要显示的节点 */
			for(var i:int=0;i< _len;i++){
				setNodesForLayer(_displayingNodes[i]);
			}
			
			/** 
			 *  设置节点对应的连接.
			 *  如果不设置该参数,仅单单设置_displayingNodes，则界面上的界面位置会很靠近。因为坐标使用了全部节点来计算。
			 */
			for each(var j:Node in _displayingNodes){
				if(j.parent){
					var _links:Vector.<Link> = _network.getLinkReference(j.parent,j);
					if(_links!=null){
						for each(var li:Link in _links)
						_displayingLinks.push(li);
					}
				}
			}
			
			/* 额外添加的上级节点 */
			if(currentNode&&currentNode.parent!=null){
				(currentNode.parent as Node).visible = true;
				_displayingNodes.push(currentNode.parent);
				/* 也高亮 */
				var _ui:IElementUI = _network.getElementUI(currentNode.parent);
				/* 为空则可能是已经删除 */
				if(_ui!=null)
					_ui.setHighLightLevel(2);
			}
		}

		/**
		 * 迭代设置需要显示的节点。
		 * @param nodeCollection 返回供显示的节点集合
		 * @param currentNode 针对的当前节点
		 * @param currentDepth 当前所处的节点层数
		 */
		protected function setNodesForLayer(currentNode:Node,currentDepth:int=0):void{
			/* 超出限制层数 */
			if(currentDepth>=limit)
				return;
			if(currentDepth<limit&&currentNode.numChildren>0){
				var d:int = currentDepth+1;
				for(var i:int=0;i<currentNode.numChildren;i++)
					setNodesForLayer(currentNode.children[i] as Node,d);
			}
			currentNode.visible = true;
			var ui:IElementUI = _network.getElementUI(Node(currentNode));
			
			/*最后一层节点(currentDepth+1>limit)不设置高亮*/
			/* 如果当前显示的最低级节点拥有子节点 */
			if(ui&&_topNodes)
				ui.setHighLightLevel(currentNode.numChildren>0&&(currentDepth+1>limit)?
						3:0);
			
			/*排除已有*/
			if(_displayingNodes.indexOf(currentNode)==-1)
				_displayingNodes.push(currentNode);
		}
		
		public function clear(): void {
			if(_displayingNodes)
				_displayingNodes.splice(0,_displayingNodes.length);
			if(_topNodes)
				_topNodes.splice(0,_topNodes.length);
			if(_displayingLinks)
				_displayingLinks.splice(0,_displayingLinks.length);
			if(nodes) 
				nodes.splice(0,nodes.length);
			if(links)
				links.splice(0,links.length);
		}
		
		public function initNodeCoordinate():void{
			//subclass to do
		}
		
		public function setTopElementsLocation(node:Node,width:Number,Height:Number,fromPoint:Point):void{
			
		}
		
		public function initChildrensCoordinate():void{
			
		}
		 
		public function set clearAll(value:Boolean):void{
			_clearAll = value;
		}
		
		public function refreshLayout():void{
			if(!nodes)
				return;
			//重置最大、最小节点坐标。
			_network.reset();
			
			/* 先清空 */
			_topNodes.splice(0,_topNodes.length);
			/* 获取所有一级节点 */
			for each(var n:Node in nodes){
				/* 便于优化，默认设置isLock=true */
				if(!n.parent)
					_topNodes.push(n);
				
				n.visible = (limit==0||isAppendMode);
				if(n.context)
					n.context = null;
				/* 先设置isLock=true，再更改x、y */
				n.isLock = true;
				
				/* 小于1则需要设置节点到屏幕中央 */
				if(isNaN(n.x)||n.x<1)
					n.x = stageWidth/2;
				if(isNaN(n.y)||n.y<1)
					n.y = stageHeight/2;
				n.isLock = false;
			}
			/* 初始化界面需要显示的节点 */
			setSelectedNode(currentCompareNode);
		}
		
		public function get displayingNodes():Vector.<Node>
		{
			return _displayingNodes;
		}
		
		public function set displayingNodes(value:Vector.<Node>):void
		{
			_displayingNodes = value;
		}
		
		public function get displayingLinks():Vector.<Link>
		{
			return _displayingLinks;
		}
		
		public function set displayingLinks(value:Vector.<Link>):void
		{
			_displayingLinks = value;
		}
	}
}