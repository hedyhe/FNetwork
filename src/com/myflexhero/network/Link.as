package com.myflexhero.network
{
	import com.myflexhero.network.core.IData;
	
	import flash.display.Sprite;
	
	import mx.core.mx_internal;

	use namespace mx_internal;	
	/**
	 * 节点连接类，是基本视图的显示单位，主要用于网元等图形的连接显示。 <br>
	 * 该类为图形的显示提供了更多的支持，如支持动态设置节点间的连接，动态更改连接位置。  <br>
	 * 如果不设置任何值，将使用默认样式(Style). 关于节点内嵌的全部图片，请查看ImageLoader类。 <br>
	 *  如果当前Link的fromNode或者toNode其中一个属于SubNetwork类型组件， <br>
	 * 请确保: 该var link:Link = new Link()构造代码在network.elementBox.add(fromNode)和network.elementBox.add(toNode)添加之后。  <br>
	 * 否则不属于SubNetwork的那个节点将默认作为SubNetwork的子类不被默认显示(需点击后才会显示)。 <br>
	 * <br><br>数据元素的继承结构如下所示:
	 * <pre>
	 * Data(数据基类)
	 * 	|Element(元素基类)
	 *		|Node(节点类)
	 * 			|<b>Follower</b>(具有跟随功能的类)
	 *				|SubNetwork(具有显示多层次子类关系的类)
	 *				|AbstractPipe(具有内部显示不同形状的抽象类)
	 *					|RoundPipe(圆管,内部可显示父子关系的圆孔)
	 *					|SquarePipe(矩形管道,内部可显示不同大小的矩形)
	 *				|Group(内部作为一个整体，具有统一的边界外观)
	 *				|Grid(网格，可设置任意行、列)
	 *					|KPICard(可表示KPI的网格)
	 *		|Link(链接类，表示节点之类的关系)
	 * </pre>
	 * @see com.myflexhero.network.Node
	 * @see com.myflexhero.network.Styles
	 * @see com.myflexhero.network.core.image.ImageLoader
	 * @date  02/15/2011
	 * @author Hedy<br>
	 * 如发现Bug请报告至email: 550561954@qq.com 
	 */
	public class Link extends Element
	{
		private var _fromNode:Node=null;

		private var _toNode:Node=null;

		/**
		 * 默认构造函数。如果参数id为Node类型，则将被设置为fromNode，此时参数fromNode将被设置为toNode，如果设置失败，会尝试将参数toNode将被设置为toNode。
		 */
		public function Link(id: Object = null, fromNode: Node = null, toNode: Node = null)
		{
			super(id is Node?fromNode is Node?toNode:fromNode:id);
			if(id is Node){
				this.fromNode = id as Node;
				if(fromNode is Node){
					this.toNode = fromNode;
				}else if(toNode is Node){
					this.toNode = toNode;
					
				}
					
			}else{
				if(fromNode is Node){
					this.fromNode = fromNode;
				}
				if(toNode is Node){
					this.toNode = toNode;
				}
			}
			refreshNodeRelation();
			this.isLock = false;
		}
		
		/**
		 * 单独设置开始节点，在设置完成后，请手动调用refreshNodeRelation方法刷新节点关系。
		 */
		public function set fromNode(node: Node): void{
			if(_fromNode ==node)
				return;
//			if(node is Node){
				var _oldValue:* = this._fromNode;
				this._fromNode = node;
				if(!isLock)
					this.dispatchPropertyChangeEvent("fromNode", _oldValue, node);
				refreshNodeRelation();
//			}
		}
		
		public function get fromNode():Node
		{
			return _fromNode;
		}
		
		/**
		 * 单独设置结束节点，在设置完成后，请手动调用refreshNodeRelation方法刷新节点关系。
		 */
		public function set toNode(node: Node): void{
			if(_toNode ==node)
				return;
//			if(node is Node){
				var _oldValue:* = this._toNode;
				this._toNode = node;
				if(!isLock)
					this.dispatchPropertyChangeEvent("toNode", _oldValue, node);
				refreshNodeRelation(_oldValue);
//			}
		}
		
		public function get toNode():Node
		{
			return _toNode;
		}
		
		/**
		 * 重设父子关系
		 */
		private function refreshNodeRelation(oldToNode:Node=null):void{
			/* 删除fromNode原有关系 */
			if(oldToNode&&_fromNode)
				_fromNode.removeChild(oldToNode);
			/* 重设现有关系 */
			if(_toNode&&_fromNode){
				_fromNode.addChild(_toNode);
				if(_toNode.parent!=_fromNode)
					_toNode.parent = _fromNode;
			}
		}
//		
//		public function drawLine(displayContainer:Sprite):void{
//			
//		}
		
		
		/* ******************************* */
		
		public var length: int;
		public function getLength(): int {
//			return length;
			var result: int = (_toNode.imageWidth + _toNode.imageHeight +
				_fromNode.imageWidth + _fromNode.imageHeight) / 4;
			if(result > 0)
				return result;
			else
				return 50; // !!@
		}
		
		override public function serializeXML(serializer:XMLSerializer, data:IData) : void
		{
			super.serializeXML(serializer, data);
			this.serializeProperty(serializer, "fromNode", data);
			this.serializeProperty(serializer, "toNode", data);
		}
	}
}