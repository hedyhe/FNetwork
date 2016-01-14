package com.myflexhero.network.core
{
	public interface ILayoutManager
	{
		/**
		 * 设置自动布局器类型,设置该参数并不会自动执行自动布局。如需执行自动布局，请调用返回参数的refreshLayout()方法。<br>
		 * 参数值请参见:Consts.LAYOUT前缀.
		 */
		function setLayout(layoutType:String=""):void;
		/**
		 * 返回当前使用的布局器
		 */
		function getCurrentLayout():ICustomLayout;
		/**
		 *  当布局中的数据发生变化时，刷新数据,并开始计算布局.<br>
		 *  当clearAll属性被设置为true时，调用该方法将清除当前布局器的及其内部所有状态。
		 */
		function refreshLayout():void;
		/**
		 * 设置是否清除当前布局器,设置该值并不会自动执行清除操作，请调用clear()方法(推荐)或refreshLayout()方法。
		 */
		function set clearAll(value:Boolean):void;
	}
}