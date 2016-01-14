package com.myflexhero.network.event
{
	import com.myflexhero.network.Consts;
	
	import flash.events.*;
	
	public class SelectionChangeEvent extends Event
	{
		public var datas:Array;
		public var kind:String;
		public static const ALL:String = "all";
		public static const REMOVE:String = "remove";
		public static const SET:String = "set";
		public static const APPEND:String = "append";
		public static const CLEAR:String = "clear";
		
		public function SelectionChangeEvent(kind:String, datas:Array = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(Consts.EVENT_SELECTION_CHANGE, bubbles,cancelable);
			this.kind = kind;
			this.datas = datas;
		}
		
		override public function clone() : Event
		{
			return new SelectionChangeEvent(kind, datas, bubbles, cancelable);
		}
	}
}
