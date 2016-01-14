package com.myflexhero.network
{
	import flash.geom.Rectangle;

	/**
	 * 圆管接口类，定义了一些公用的方法。
	 */
	public interface IPipe
	{
		/**
		 * 根据圆孔下标获取其内部坐标
		 */
		function getPipeHoleBoundsByHoleIndex(holeIndex:int):Rectangle;
		/**
		 * 根据自身对象获取其坐标
		 */
		function getPipeHoleBoundsByHole(hole:IPipe):Rectangle;
		/**
		 * 根据圆孔下标获取自身对象引用
		 */
		function getPipeHoleByHoleIndex(holeIndex:int):IPipe;
		
		function get innerWidth():Number;
		function set innerWidth(innerWidth:Number):void;
		/**
		 * 圆孔的固定圆形边框虚线颜色，值为uint类型，默认为绿色(0x00B200)。
		 */
		function get innerColor():uint;
		/**
		 * 圆孔的固定圆形边框虚线颜色，值为uint类型，默认为绿色(0x00B200)。
		 */
		function set innerColor(innerColor:uint):void;
		/**
		 * 圆孔的固定圆形边框虚线Alpha 透明度值。有效值为 0（完全透明）到 1（完全不透明）。默认值为 1。
		 */
		function get innerAlpha():Number;
		/**
		 * 圆孔的固定圆形边框虚线Alpha 透明度值。有效值为 0（完全透明）到 1（完全不透明）。默认值为 1。
		 */
		function set innerAlpha(innerColor:Number):void;
		/**
		 * 圆孔的固定圆形边框虚线(拖动圆孔后，该虚线位置不变，作为对比显示用)。<br>
		 * 值为array类型，且长度只能为2.如传入[2,3]。其中2意味着固定虚线的长度，3意味着固定虚线之间的间隔像素。<br>
		 * 默认值为[3,3].
		 */
		function get innerPattern():Array;
		/**
		 * 圆孔的固定圆形边框虚线(拖动圆孔后，该虚线位置不变，作为对比显示用)。<br>
		 * 值为array类型，且长度只能为2.如传入[2,3]。其中2意味着固定虚线的长度，3意味着固定虚线之间的间隔像素。<br>
		 * 默认值为[3,3].
		 */
		function set innerPattern(innerPattern:Array):void;
		/**
		 * 内部圆孔的索引下标。默认从0开始，如果未设置内部圆孔数量，则返回-1.
		 */
		function get holeIndex():int;
		/**
		 * 内部圆孔的索引下标。默认从0开始，如果未设置内部圆孔数量，则返回-1.
		 */
		function set holeIndex(holeIndex:int):void;
	}
}