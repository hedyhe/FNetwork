package com.myflexhero.network.event
{
	import com.myflexhero.network.Consts;
	import com.myflexhero.network.core.IElement;
	
	import flash.events.*;
	
	public class IndexChangeEvent extends Event
	{
		public var newIndex:int;
		public var oldIndex:int;
		public var element:IElement;
		
		public function IndexChangeEvent(element:IElement = null, oldIndex:int = -1, newIndex:int = -1, K77K:Boolean = false, K78K:Boolean = false)
		{
			super(Consts.EVENT_INDEX_CHANGE, K77K, K78K);
			this.element = element;
			this.oldIndex = oldIndex;
			this.newIndex = newIndex;
			return;
		}
		
		override public function clone() : Event
		{
			return new IndexChangeEvent(element, oldIndex, newIndex, bubbles, cancelable);
		}
		
	}
}
