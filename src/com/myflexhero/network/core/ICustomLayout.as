package com.myflexhero.network.core
{
	import com.myflexhero.network.Node;
	
	import flash.geom.Point;

	public interface ICustomLayout extends ILayoutData,IQuantityController
	{
		/**
		 * 开始调用界面自定义布局
		 */
		function doLayout():void;
		
		/**
		 * 初始化布局范围,包括x、y坐标
		 */
		function initNodeCoordinate():void;
		/**
		 * 清除当前布局器
		 */
		function clear():void;
		/**
		 * 设置是否清除当前布局器,设置该值并不会自动执行清除操作，请调用clear()方法(推荐)或refreshLayout()方法。
		 */
		function set clearAll(value:Boolean):void;
		/**
		 * 设置顶级元素的位置
		 * @param node 当前的顶级节点
		 * @param width 顶级节点允许的宽度
		 * @param height 顶级节点允许的高度
		 * @param fromPoint 作为判断依据的起点坐标
		 */
		function setTopElementsLocation(node:Node,width:Number,Height:Number,fromPoint:Point):void;
		
		function initChildrensCoordinate():void;
		
		/**
		 * 当布局中的数据发生变化时，刷新数据,并开始计算布局.
		 */
		function refreshLayout():void;
	}
}