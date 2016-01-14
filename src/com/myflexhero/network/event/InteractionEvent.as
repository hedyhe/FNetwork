package com.myflexhero.network.event
{
    import com.myflexhero.network.Consts;
    import com.myflexhero.network.Network;
    import com.myflexhero.network.core.IElement;
    
    import flash.events.*;

    public class InteractionEvent extends Event
    {
        public var pointIndex:int = -1;
        public var resizeDirection:String = null;
        public var network:Network = null;
        public var kind:String = null;
        public var mouseEvent:MouseEvent = null;
        public var element:IElement = null;
		
        public static const UP_SUBNETWORK:String = "upSubNetwork";
        public static const ENTER_SUBNETWORK:String = "enterSubNetwork";
		
        public static const CLICK_BACKGROUND:String = "clickBackground";
		/**
		 * 双击背景，当前不是Subnetwork的子集，仅为双击空白背景操作。该事件event.element属性值为空。
		 */
        public static const DOUBLE_CLICK_BACKGROUND:String = "doubleClickBackground";
		/**
		 * 双击背景，且当前显示的集合为Subnetwork的子集，操作目的为返回Subnetwork的上一级。该事件event.element属性值为操作时的SubNetwork元素。
		 */
		public static const DOUBLE_CLICK_SUBNETWORK_BACKGROUND:String = "doubleClickSubnetworkBackground";
        public static const DOUBLE_CLICK_ELEMENT:String = "doubleClickElement";
		
		public static const LAYTOUT_UPDATED:String = "layoutUpdated";
		
        public static const BUNDLE_LINK:String = "bundleLink";
		
		public static const CLICK_ELEMENT:String = "clickElement";
        public static const CREATE_ELEMENT:String = "createElement";
        public static const REMOVE_ELEMENT:String = "removeElement";
		
        public static const SELECT_BETWEEN:String = "selectBetween";
		
        public static const SELECT_ALL:String = "selectAll";
		/**
		 * 相当于MouseDown，当UI对象被选中时派发(注意，此时鼠标未释放)
		 */
        public static const SELECTED_START:String = "selected_start";
		/**
		 * 相当于MouseUp，当UI对象被选中时派发(注意，此时鼠标已经释放掉焦点)
		 */
		public static const SELECTED_END:String = "selected_end";
		/**
		 * 鼠标进行多选操作结束时派发，派发的是MouseEvent.MOUSE_UP事件。请使用network.selectedElements对选中的对象进行操作。
		 */
		public static const MULTIL_SELECTED:String = "multi_selected";
		/**
		 * 相当于MouseMove，当UI对象获得焦点时(鼠标处于UI上方)派发
		 */
		public static const ELEMENT_FOCUS:String = "element_focus";
//		/**
//		 * 当前鼠标未处于UI对象上方时派发。
//		 */
//		public static const ELEMENT_NOT_FOCUS:String = "element_not_focus";
		/**
		 * 相当于MouseOut，当UI对象失去焦点时派发
		 */
		public static const OUT:String = "out";
		
        public static const EXPAND_GROUP:String = "expandGroup";

		public function InteractionEvent(kind:String, network:Network, mouseEvent:MouseEvent, element:IElement, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(Consts.EVENT_INTERACTION,bubbles, cancelable);
            this.kind = kind;
            this.network = network;
            this.mouseEvent = mouseEvent;
            this.element = element;
            return;
        }

        override public function clone() : Event
        {
            var _loc_1:* = new InteractionEvent(this.kind, this.network, this.mouseEvent, this.element, this.bubbles, this.cancelable);
            _loc_1.resizeDirection = this.resizeDirection;
            _loc_1.pointIndex = this.pointIndex;
            return _loc_1;
        }
    }
}
