package com.myflexhero.network.event
{
	import com.myflexhero.network.core.IData;
	
	import flash.events.*;
	
	import mx.core.mx_internal;
	/**
	 * 数据操作事件类,将统一派发type="dataBoxChange"类型的事件。
	 * <p>
	 * 请通过监听DataBox(子类有ElementBox、LinkBox、AlarmBox等)类来截获该事件的派发，并通过DataBoxChangeEvent的kind属性判别操作类型。
	 * </p>
	 * <p>
	 * 	已有的kind属性有如下所示值：
	 * <ul>
	 * 		<li><p><b>DataBoxChangeEvent.ADD</b>    新增指定的数据元素。调用<code>DataBox.add()</code>方法和<code>DataBox.setDatas()</code>方法(每一个数据元素将派发一次)将派发该事件，并设置DataBoxChangeEvent的data属性为新增的数据元素。</p></li>
	 *  	<li><p><b>DataBoxChangeEvent.REMOVE</b> 删除指定的数据元素。调用<code>DataBox.removeData()</code>方法将派发该事件，并设置DataBoxChangeEvent的data属性为删除的数据元素。</p></li>
	 * 		<li><p><b>DataBoxChangeEvent.CLEAR</b>  清空当前所属的数据容器所有的数据元素。调用<code>DataBox.removeAll()</code>方法将派发该事件，并设置DataBoxChangeEvent的datas属性为已删除的数据集合。</p></li>
	 * 		<li><p><b>DataBoxChangeEvent.CHECK</b>  内部使用，目前无需自行处理。可参阅ElementBox.check属性。</p></li>
	 * </ul>
	 * </p>
	 * @author Hedy<br>
	 * 如发现Bug请报告至email: 550561954@qq.com 
	 */
	public class DataBoxChangeEvent extends Event
	{
		public var datas:Vector.<IData>;
		public var data:IData;
		public var kind:String;
		/**
		 * 新增一个
		 */
		public static const ADD:String = "add";
		/**
		 * 移除一个
		 */
		public static const REMOVE:String = "remove";
		/**
		 * 清除全部
		 */
		public static const CLEAR:String = "clear";
		
		/**
		 * 刷新布局器
		 */
		public static const LAYOUT_REFRESH:String = "layout.refresh";
		
		/**
		 * 执行数据检查
		 */
		mx_internal static const CHECK:String = "check";
		
		public function DataBoxChangeEvent(kind:String, data:IData = null, datas:Vector.<IData> = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super("dataBoxChange", bubbles,cancelable);
			this.kind = kind;
			this.data = data;
			this.datas = datas;
		}
		
		override public function clone() : Event
		{
			return new DataBoxChangeEvent(kind, data, datas, bubbles, cancelable);
		}
		
	}
}