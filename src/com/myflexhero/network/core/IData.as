package com.myflexhero.network.core
{
	import com.myflexhero.network.XMLSerializer;
	
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;

	public interface IData  extends IClient,IEventDispatcher
	{
		public function IData();
		
		function dispatchPropertyChangeEvent(property: String, oldValue: Object, newValue: Object): Boolean;
		/**
		 *当前元素的显示Name
		 */
		function set label(value:String):void;
		
		function get label():String;
		/**
		 * 前元素的name,可以为空,Node和Link不会显示该字段
		 */
		function set name(value:String):void;
		
		function get name():String;
		
		/**
		 *当前元素的toolTip提示字符
		 */
		function set toolTip(toolTip:String):void;
		
		function get toolTip():String;
		/**
		 *当前元素的icon图标
		 */
		function set icon(icon:String):void;
		
		function get icon():String;
		/**
		 *当前元素的唯一标识符
		 */
		function get id() : Object;
		/**
		 * 设置当前元素的父元素，会自动过滤父元素为当前元素本身或已是传入参数的父元素.
		 */
		function set parent(parent:IData) : void;
		/**
		 * 返回当前元素的上一级(父)元素
		 */
		function get parent() : IData;
		/**
		 * 判断是否为传入参数的子元素
		 */
		function isDescendantOf(data:IData) : Boolean;
		/**
		 * 返回当前元素的所有子元素
		 */
		function get children():Vector.<IData>;
		/**
		 * 根据索引下标返回指定的节点
		 */
		function getChild(index:int):IData;
		/**
		 * 删除对应的子节点,该操作会自动删除子元素原来的引用
		 */
		function removeChild(data:IData):Boolean;
		/**
		 * 新增子元素,该操作会自动删除子元素原来的引用，新增现有引用
		 */
		function addChild(data:IData,index:int=-1):Boolean;
		/**
		 * 返回子元素的数量。0 表示不包含子元素，而 -1 表示长度未知。
		 */
		function get numChildren():int;
		/**
		 * 是否可见
		 */
		function get visible():Boolean;
		
		function set visible(value:Boolean):void;
		/**
		 * 此属性用于优化显示.如果设置为true后，再更改x、y、width、height、location属性或调用setLocation()、setSize()方法，
		 * 将不会立即重绘画面(但此时值已更改)，如需手动刷新界面，请调用ElementUI的drawBody方法。<br><br>
		 * 
		 * 此外，程序内部在自动布局中的环形布局使用到该属性。<br>
		 * 当该属性为true时,环形视图将在每次timer对象调用完毕后才会更新节点视图.
		 */
		function get isLock():Boolean;
		
		function set isLock(value:Boolean):void;
		/**
		 * 是否启用元素高亮(闪烁效果)。高亮的颜色由Styles.HIGH_LIGHT_COLOR决定。
		 */
		function set highLightEnable(value:Boolean):void;
		
		function get highLightEnable():Boolean;
		/**
		 * 是否启用二次高亮，即在一个元素上同时显示2种类型的高亮，一种为Inner，一种为Outer.
		 */
		function get secondHighLightEnable():Boolean;
		
		function set secondHighLightEnable(value:Boolean):void;
		
		function serializeXML(serializer:XMLSerializer, newInstance:IData) : void;
		
		function deserializeXML(serializer:XMLSerializer, dataXML:XML) : void;

	}
}