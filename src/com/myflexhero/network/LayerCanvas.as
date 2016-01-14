package com.myflexhero.network
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;
	import mx.graphics.GradientEntry;
	import mx.graphics.LinearGradient;
	import mx.graphics.SolidColor;
	
	import spark.components.Group;
	import spark.primitives.Rect;

	/**
	 * 图形容器基类,扩展自Group容器，所有图形数据展示的操作通过覆盖Group的XXchild方法进行(替换***child为***data)。
	 * @author Hedy<br>
	 * 如发现Bug请报告至email: 550561954@qq.com 
	 */
	public class LayerCanvas extends BasicGroup
	{
		
		public function LayerCanvas()
		{
			useDefaultChild = false;
			super();
		}
	}
}