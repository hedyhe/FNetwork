package com.myflexhero.network.core
{
	import com.myflexhero.network.Link;
	import com.myflexhero.network.Node;

	public interface ILayoutData
	{
		/**
		 * 设置所有供操作的link 
		 */
		function set links(value:Vector.<Link>):void;
		
		function get links():Vector.<Link>;
		/**
		 * 设置所有供操作的nodes 
		 */
		function set nodes(value:Vector.<Node>):void;
		
		/**
		 * 每个布局中的任何Node，只要其有子节点，则该属性为最低级的节点与父节点的半径.<br>
		 * 对于RoundLayout，该属性为最低级节点与父节点的半径。<br>
		 * 对于RoundLayout，该属性为最低级节点与父节点的半径。<br>
		 * 
		 */
		function set radius(value:Number):void;
		
		/**
		 * 最左侧的节点离左侧屏幕的X轴偏移量
		 */
		function set offsetX(value:Number):void;
		
		/**
		 *  最左侧的节点离左侧屏幕的Y轴偏移量
		 */
		function set offsetY(value:Number):void;
		/**
		 * 当使用Layoutlimit时，作为每一层获取节点时的判断依据。
		 */
		function get currentCompareNode():Node;
		function set currentCompareNode(value:Node):void;
		/**
		 * 限制节点显示的层数,赋值范围为0~n(层)，如果为0，则显示所有层数，如果为大于1，则额外添加直接父节点作为返回上一级的入口节点。<br>
		 * 如果Layout的appendMode设置为true，则该参数将被忽略。
		 */
		function get limit():int;
		
		function set limit(value:int):void;
		/**
		 * 布局器双击节点后的节点显示模式。<br>
		 * 默认点击的节点和其直接父节点作为顶级节点，隐藏其他和父节点关联的节点，并只显示自身子节点。<br>
		 * 如果设置为true,则不会隐藏当前已经展示的节点，而是将点击的节点的子节点作为附加的节点添加进来。
		 * @param value 是否为添加模式。默认为false，即点击一次节点只显示节点的子节点。
		 * 
		 */
		function set isAppendMode(value:Boolean):void;
		/**
		 * 布局器双击节点后的节点显示模式。<br>
		 * 默认点击的节点和其直接父节点作为顶级节点，隐藏其他和父节点关联的节点，并只显示自身子节点。<br>
		 * 如果设置为true,则不会隐藏当前已经展示的节点，而是将点击的节点的子节点作为附加的节点添加进来。
		 * @param value 是否为添加模式。默认为false，即点击一次节点只显示节点的子节点。
		 * 
		 */
		function get isAppendMode():Boolean;
	}
}