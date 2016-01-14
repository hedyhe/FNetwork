package com.myflexhero.network.core
{
	import com.myflexhero.network.Link;
	import com.myflexhero.network.Node;

	/**
	 * 节点数量控制接口
	 */
	public interface IQuantityController
	{
		function get displayingNodes():Vector.<Node>;
		
		function set displayingNodes(value:Vector.<Node>):void;
		function get displayingLinks():Vector.<Link>;
		
		function set displayingLinks(value:Vector.<Link>):void;
	}
}