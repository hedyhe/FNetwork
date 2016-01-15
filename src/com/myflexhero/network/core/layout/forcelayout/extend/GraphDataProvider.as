package com.myflexhero.network.core.layout.forcelayout.extend
{
import com.myflexhero.network.Link;
import com.myflexhero.network.Node;
import com.myflexhero.network.core.layout.SpringLayout;
import com.myflexhero.network.core.layout.forcelayout.IDataProvider;
import com.myflexhero.network.core.layout.forcelayout.IForEachEdge;
import com.myflexhero.network.core.layout.forcelayout.IForEachNode;
import com.myflexhero.network.core.layout.forcelayout.IForEachNodePair;

import flash.geom.Rectangle;

import mx.core.UIComponent;

 /** 
  * 对布局中的数据进行管理
  * @author Hedy<br>
  * 550561954#QQ.com 
  */
public class GraphDataProvider implements IDataProvider {
//	private var nodeStore: Object/*{id: GraphNode}*/ = new Object();
	private var _nodes: Vector.<Node>; /*{id: GraphNode}*/
	private var _edges: Vector.<Link>;
	private var host: SpringLayout;	
	private var _layoutChanged: Boolean = false;
	private var _distance: int;
//	public var boundary: Rectangle;
//
//	private function makeGraphNode(item: Item): GraphNode {
//		var result: GraphNode;
//		if(nodeStore.hasOwnProperty(item.id)) {
//			result = nodeStore[item.id];
//			if(result.view.parent == null)
//				host.addComponent(result.view);	
//		} else {
//			result = new GraphNode(host.newComponent(item), this, item);
//			nodeStore[item.id] = result;
//		}
//		return result;
//	}
//
	public function GraphDataProvider(host: SpringLayout) {
		this.host = host;
//		for (var i: int = 0; i < _nodes.length; i++) {
//			var itemView: Node = _nodes[i];
//			itemView.context = this;
//			itemView.isLock = true;
//			itemView.x = host.stageWidth/2;
//			itemView.y = host.stageHeight/2;
//		}
	}

	public function forAllNodes(fen: IForEachNode): void {
		if(_nodes)
			for each(var n:Node in _nodes) {
				/* 设置引用 */
				fen.forEachNode(n);
			}
	}
	
	public function forAllEdges(fee: IForEachEdge): void {
		if(_edges)
		for each(var link:Link in _edges) {
			fee.forEachEdge(link);
		}
	}
	
	public function forAllNodePairs(fenp: IForEachNodePair): void {
		if(_nodes)
		for each(var k:Node in _nodes) {
			for each(var j:Node in _nodes) {
				if(k != j) {
					fenp.forEachNodePair(k,j);
				}
			}
		}
	}

//	public function set graph(g: Graph): void {
//		var newItems: Object = g.nodes;
//		var newEdges: Object = g.edges;
//		
//		// re-create the list of nodes
//		var oldNodes: Array = nodes;
//		nodes = new Array();
//		for each (var item: Item in newItems) {
//			nodes.push(makeGraphNode(item));
//		}
//		if(oldNodes != null) {
//			for each (var oldNode: GraphNode in oldNodes) {
//				if(!g.hasNode(oldNode.item.id)) {
//					// this node is not in the currently displayed set
//					if(oldNode.view.parent != null)
//						host.removeComponent(oldNode.view);
//						delete nodeStore[oldNode.item.id];
//						// !!@ how does it get re-added
//				}
//			}
//		}
//
//		// re-create the list of edges
//		edges = new Array();
//		for each (var edge: Array in newEdges) {
//			edges.push(new GraphEdge(GraphNode(nodeStore[Item(edge[0]).id]), GraphNode(nodeStore[Item(edge[1]).id]), _distance));
//		}
//	}

//	public function set distance(d: int): void {
//		_distance = d;
//	}
//	
//	public function get distance(): int {
//		return _distance;
//	}
//
//	public function getEdges(): Array {
//		return edges;
//	}
//	
//	public function findNode(component: UIComponent): GraphNode {
//		for (var i: int = 0; i < nodes.length; i++) {
//			var node: GraphNode = GraphNode(nodes[i]);
//			if(node.view == component)
//				return node;
//		}
//		return null;
//	}
//
	public function get layoutChanged(): Boolean {
		return _layoutChanged;
	}
	
	public function set layoutChanged(b: Boolean): void{
		_layoutChanged = b;
	}
//	
	public function get repulsionFactor(): Number {
		return host.repulsionFactor;
	}
	
	public function get defaultRepulsion(): Number {
		return host.defaultRepulsion;
	}
//	
	public function get hasNodes(): Boolean {
		return (_nodes != null) && (_nodes.length > 0);
	}

	public function set nodes(value:Vector.<Node>):void
	{
		_nodes = value;
	}

	public function set edges(value:Vector.<Link>):void
	{
		_edges = value;
	}

	public function clear():void{
		if(_nodes)
			_nodes.splice(0,_nodes.length);
		if(_edges)
			_edges.splice(0,_edges.length);
		_nodes = null;
		_edges = null;
		host = null;
	}

}
}
