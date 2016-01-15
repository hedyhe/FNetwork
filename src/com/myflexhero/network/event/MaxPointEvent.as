package com.myflexhero.network.event
{
	import com.myflexhero.network.Node;
	
	import flash.events.Event;

	/**
	 * 界面最值节点事件类
	 * @author Hedy<br>
	 * 550561954#qq.com 
	 */
	public class MaxPointEvent extends Event
	{
		/**
		 * 更改的节点值类型,true为x值，否则为y值。
		 */
		private var _isX:Boolean = false;
		/**
		 * 容器所有坐标中最大的x或y值改变时分派
		 */
		public static const INCREASE:String = "increase";
		/**
		 * 超出容器宽高的节点集合发生更改时分派
		 */
		public static const DECREASE:String = "decrease";
		/**
		 * 删除超出容器宽高的节点时分派
		 */
		public static const DELETE:String = "delete";
		
		public function MaxPointEvent(type:String,isX:Boolean = true,bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles,cancelable);
			this._isX = isX;
		}
		
		override public function clone() : Event
		{
			return new MaxPointEvent(type,this._isX,bubbles, cancelable);
		}
		
	}
}