package com.myflexhero.network.core.layout.forcelayout {

/**
 * @author Hedy
 */
public interface IDataProvider {
	function forAllNodes(fen: IForEachNode): void;
	function forAllEdges(fee: IForEachEdge): void;
	function forAllNodePairs(fenp: IForEachNodePair): void;
}
}