package com.myflexhero.network
{
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.core.IElement;
	
	import mx.collections.ArrayCollection;

	/**
	 * 元素基类,提供了风格样式支持。
	 * @author Hedy<br>
	 * 550561954#qq.com 
	 */
	public class Element extends Data implements IElement
	{
//		private var _alarmState:AlarmState = null;
		private var _styleProperties:Object = null;
		private var _layerID:Object;
		/**
		 * 可供开发人员自定义传入的字段，程序将不做处理。
		 */
		public var customField:Object;
		
		public function Element(id:Object = null)
		{
//			_layerID = "default";
			super(id);
//			_alarmState = new AlarmState(this);
			return;
		}
		
//		public function get alarmState() : AlarmState
//		{
//			return this._alarmState;
//		}
		
		protected function onStyleChanged(property:String, oldValue:Object, newValue:Object): void{
			//to do
			return;
		}
		
		public function set layerID(layerID:Object) : void
		{
			var _loc_2:* = this._layerID;
			this._layerID = layerID;
			if(!isLock)
				this.dispatchPropertyChangeEvent("layerID", _loc_2, layerID);
		}
		
		public function get layerID() : Object
		{
			return this._layerID;
		}
		
		public function getStyle(styleProp:String, returnDefaultIfNull:Boolean = true):*{
			var _styleValue:Object = null;
			if (this._styleProperties != null)
			{
				_styleValue = this._styleProperties[styleProp];
//				trace("get styleProp："+styleProp+","+_styleValue)
			}
			if (_styleValue == null)
			{
				if (returnDefaultIfNull)
				{
					return Styles.getStyle(styleProp);
				}
			}
			return _styleValue;
		}
		
		public function setStyle(property:String, newValue:*) : void
		{
			if (property == null)
			{
				throw new Error("style 属性名不能为空");
			}
			if (this._styleProperties == null)
			{
				this._styleProperties = new Object();
			}
			var _oldValue:* = this._styleProperties[property];
			if(newValue==_oldValue)
				return;
			
			if (newValue == null)
			{
				delete this._styleProperties[property];
			}
			else
			{
				this._styleProperties[property] = newValue;
//				trace("set styleProp："+property+","+newValue)
			}
			if (!isLock&&this.dispatchPropertyChangeEvent("S:" + property, _oldValue, newValue))
			{
				this.onStyleChanged(property, _oldValue, newValue);
			}
//			return this;
		}
		
		public function get styleProperties() : ArrayCollection
		{
			var _loc_2:Object = null;
			var _loc_1:* = new ArrayCollection();
			if (this._styleProperties != null)
			{
				for (_loc_2 in this._styleProperties)
				{
					
					_loc_1.addItem(_loc_2);
				}
			}
			return _loc_1;
		}
		
		public function get elementUIClass() : Class
		{
			return null;
		}
		
		
		override public function serializeXML(serializer:XMLSerializer, newInstance:IData) : void
		{
			var _loc_3:String = null;
			var _loc_5:int = 0;
			var _loc_7:int = 0;
			if (serializer.settings.styleSerializable)
			{
				if (this._styleProperties != null)
				{
					for (_loc_3 in this._styleProperties)
					{
						
						this.serializeStyle(serializer, _loc_3, newInstance);
					}
				}
			}
			super.serializeXML(serializer, newInstance);
			this.serializeProperty(serializer, "layerID", newInstance);
		}
		
		protected function serializeStyle(serializer:XMLSerializer, style:String, data:IData) : void
		{
			serializer.serializeStyle(this, style, data);
			return;
		}
		
		override public function deserializeXML(serializer:XMLSerializer, xml:XML) : void
		{
			var _loc_3:XML = null;
			super.deserializeXML(serializer, xml);
			if (serializer.settings.styleSerializable)
			{
				for each (_loc_3 in xml.elements("s"))
				{
					
					if (_loc_3.hasOwnProperty("@n"))
					{
						deserializeStyle(serializer, _loc_3, _loc_3.@n);
					}
				}
			}
			return;
		}
		
		protected function deserializeStyle(serializer:XMLSerializer, xml:XML, property:String) : void
		{
			serializer.deserializeStyle(this, xml, property);
			return;
		}
	}
	
}