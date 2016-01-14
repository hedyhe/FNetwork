package com.myflexhero.network.event
{
	import flash.events.Event;
	/**
	 * 元素属性更改后将派出的事件。事件的priority优先级被默认设置为10，这意味着如果开发人员设置的监听函数的priority如果为默认的0，则会优先执行ElementUI内的onPropertyChange()方法。
	 * @author Hedy
	 */
	public class ElementPropertyChangeEvent extends Event
	{
		
		public static const UPDATE:String = "update";
		/**
		 * 图片加载完成时派发.data.dispatchPropertyChangeEvent(ElementPropertyChangeEvent.IMAGE_LOADED, null, event.imageAsset);
		 * dispatchEvent(new ElementPropertyChangeEvent(Consts.EVENT_DATA_PROPERTY_CHANGE,false,false,ElementPropertyChangeEvent.UPDATE,property,oldValue,newValue,this));
		 */
		public static const IMAGE_LOADED:String = "image.loaded";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function ElementPropertyChangeEvent(type:String, bubbles:Boolean = false,
											cancelable:Boolean = false,
											kind:String = null,
											property:String = null, 
											oldValue:Object = null,
											newValue:Object = null,
											source:Object = null)
		{
			super(type, bubbles, cancelable);
			
			this.kind = kind;
			this.property = property;
			this.oldValue = oldValue;
			this.newValue = newValue;
			this.source = source;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  kind
		//----------------------------------
		
		public var kind:String;
		
		//----------------------------------
		//  newValue
		//----------------------------------
		
		public var newValue:Object;
		
		public var oldValue:Object;
		
		
		public var property:String;
		
		//----------------------------------
		//  source
		//----------------------------------
		
		public var source:Object;
		
//		/**
//		 *  如果需要在实践处理函数中继续派发该事件，则需要重载clone方法.
//		 *  @private
//		 */
//		override public function clone():Event
//		{
//			return new ElementPropertyChangeEvent(type, bubbles, cancelable, kind,
//				property, oldValue, newValue, source);
//		}
	}
	
}
