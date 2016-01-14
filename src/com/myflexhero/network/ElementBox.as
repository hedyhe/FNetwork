package com.myflexhero.network
{
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.core.IElement;
	import com.myflexhero.network.core.ILayer;
	import com.myflexhero.network.core.util.SysControl;
	import com.myflexhero.network.event.DataBoxChangeEvent;
	
	import mx.collections.ArrayCollection;
	import mx.core.mx_internal;

	use namespace mx_internal;	

	public class ElementBox extends DataBox
	{
//		private var alarmStatePropagator:AlarmStatePropagator = null;
		private var _linkBox:LinkBox = null;
		private var _styleProperties:Object = null;
		private var _alarmBox:AlarmBox = null;
		private var _layerBox:LayerBox = null;
		/**
		 * 对于Link类型的数据，如果check参数为true，则将在插入数据前先检查已有的数据，如果有重复的，则删除.<br>
		 * 例如,已存在link1对象的fromNode和toNode与插入的link2对象的toNode、fromNode是顺序相反的，则会删除link1后再执行插入.
		 */
		public var check:Boolean = true;
		public function ElementBox(id:String = "ElementBox")
		{
			super(id);
			this._alarmBox = new AlarmBox(this);
			this._linkBox = new LinkBox(this);
			this._layerBox = new LayerBox(this);
//			this.alarmStatePropagator = new AlarmStatePropagator(this);
//			this.alarmStatePropagator.enable = true;
		}
		
		override public function add(data:IData) : void
		{
			if (!(data is IElement))
				throw new Error("Only IElement can be added into ElementBox");
			
			if(data is Layer){
				this._layerBox.add(data);
			}
			else if(data is Node||data is Dummy){
				super.add(data);
			}
			else if(data is Link){
				//允许多个Link连接存在
//				if(check){
//					_linkBox.dispatchEvent(new DataBoxChangeEvent(DataBoxChangeEvent.CHECK, data));
//				}
				_linkBox.add(data);
			}
			
			//send to top
		}
		
		override public function removeData(value:IData):void{
			if(value is Node)
				super.removeData(value);
			else if(value is Link){
				_linkBox.removeData(value);
			}
		}
		
		public function getElementByID(elementID:Object) : IElement
		{
			return this.getDataByID(elementID) as IElement;
		}
		
		public function get alarmBox() : AlarmBox
		{
			return this._alarmBox;
		}
		
		public function get linkBox() : LinkBox
		{
			return this._linkBox;
		}
		
		public function get layerBox() : LayerBox
		{
			return this._layerBox;
		}
		
		protected function onStyleChanged(name:String, oldValue:Object, newValue:Object) : void
		{
			return;
		}
		
		public function get styleProperties() : ArrayCollection
		{
			var _prop:Object = null;
			var _values:* = new ArrayCollection();
			if (this._styleProperties != null)
			{
				for (_prop in this._styleProperties)
				{
					
					_values.addItem(_prop);
				}
			}
			return _values;
		}

		override public function deserializeXML(serializer:XMLSerializer, xml:XML) : void
		{
			var _loc_3:XML = null;
			var _loc_4:IData = null;
			var _loc_5:String = null;
			var _loc_6:XML = null;
			super.deserializeXML(serializer, xml);
			if (serializer.settings.layerBoxSerializable)
			{
			}
			if (xml.child("layerBox").length() == 1)
			{
				layerBox.removeAll();
				for each (_loc_3 in xml.layerBox[0].layer)
				{
					
					if (_loc_3.hasOwnProperty("@id"))
					{
						_loc_5 = serializer.settings.getPropertyType("layerID");
						if (_loc_5 == Consts.TYPE_STRING)
						{
							_loc_4 = SysControl.createInstance(Layer, _loc_3.@id.toString());
						}
						else if (_loc_5 == Consts.TYPE_NUMBER)
						{
							_loc_4 = SysControl.createInstance(Layer, Number(_loc_3.@id.toString()));
						}
						else if (_loc_5 == Consts.TYPE_INT)
						{
							_loc_4 = SysControl.createInstance(Layer, int(_loc_3.@id.toString()));
						}
						else if (_loc_5 == Consts.TYPE_UINT)
						{
							_loc_4 = SysControl.createInstance(Layer, uint(_loc_3.@id.toString()));
						}
						else
						{
							throw new Error("Unsupported layer id type \'" + _loc_5 + "\'");
						}
						layerBox.add(_loc_4);
					}
//					else
//					{
						_loc_4 = layerBox.defaultLayer;
//						layerBox.moveToBottom(_loc_4);
//					}
					if (_loc_3.hasOwnProperty("@name"))
					{
						_loc_4.name = _loc_3.@name.toString();
					}
					if (_loc_3.hasOwnProperty("@visible"))
					{
						_loc_4.visible = _loc_3.@visible.toString() == "true";
					}
//					if (_loc_3.hasOwnProperty("@editable"))
//					{
//						_loc_4.editable = _loc_3.@editable.toString() == "true";
//					}
//					if (_loc_3.hasOwnProperty("@movable"))
//					{
//						_loc_4.movable = _loc_3.@movable.toString() == "true";
//					}
				}
			}
			if (serializer.settings.styleSerializable)
			{
				for each (_loc_6 in xml.elements("s"))
				{
					
					if (_loc_6.hasOwnProperty("@n"))
					{
						deserializeStyle(serializer, _loc_6, _loc_6.@n);
					}
				}
			}
			return;
		}
		
		protected function serializeStyle(serializer:XMLSerializer, style:String, dataBox:DataBox) : void
		{
			serializer.serializeStyle(this, style, dataBox);
			return;
		}// end function
		
		protected function deserializeStyle(serializer:XMLSerializer, xml:XML, property:String) : void
		{
			serializer.deserializeStyle(this, xml, property);
			return;
		}
		
		override public function serializeXML(serializer:XMLSerializer, dataBox:DataBox) : void
		{
			var K157K:String;
			var serializer:* = serializer;
			var dataBox:* = dataBox;
			if (serializer.settings.layerBoxSerializable)
			{
				serializer.xmlString = serializer.xmlString + "\t<layerBox>\n";
				layerBox.forEach(function (layer:ILayer) : void
				{
					if (layerBox.defaultLayer == layer)
					{
						serializer.xmlString = serializer.xmlString + "\t\t<layer ";
					}
					else
					{
						serializer.xmlString = serializer.xmlString + ("\t\t<layer id=\'" + layer.id + "\' ");
					}
					if (layer.name != null)
					{
						serializer.xmlString = serializer.xmlString + ("name=\'" + layer.name + "\' ");
					}
					serializer.xmlString = serializer.xmlString + ("visible=\'" + layer.visible + "\' editable=\'" + layer.editable + "\' movable=\'" + layer.movable + "\'/>\n");
					return;
				}// end function
				);
				serializer.xmlString = serializer.xmlString + "\t</layerBox>\n";
			}
			if (serializer.settings.styleSerializable)
			{
				if (this.styleProperties != null)
				{
					var _loc_4:int = 0;
					var _loc_5:* = this.styleProperties;
					while (_loc_5 in _loc_4)
					{
						
						K157K = _loc_5[_loc_4];
						this.serializeStyle(serializer, K157K, dataBox);
					}
				}
			}
			super.serializeXML(serializer, dataBox);
			return;
		}
	}
}