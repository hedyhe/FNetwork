package com.myflexhero.network
{
    import com.myflexhero.network.core.IData;
    import com.myflexhero.network.core.util.SerializationSettings;
    import com.myflexhero.network.core.util.SysControl;
    
    import flash.geom.*;
    import flash.utils.*;
    
	/**
	 * 序列化及反序列化当前的数据对象，并保存其外观样式就属性值。
	 * 
	 */
    public class XMLSerializer extends Object
    {
        public var elementBox:ElementBox;
        public var xmlString:String = "";
        public var refMap:Dictionary;
        private var ref:int = 0;
        public var idMap:Dictionary;
        public var settings:SerializationSettings;
        public var filterFunction:Function = null;

        public function XMLSerializer(elementBox:ElementBox, settings:SerializationSettings = null)
        {
            refMap = new Dictionary();
            idMap = new Dictionary();
            this.elementBox = elementBox;
            this.settings = settings == null ? (new SerializationSettings()) : (settings);
            return;
        }

        public function deserializeValue(xml:XML, type:String) : Object
        {
            var _loc_3:String = null;
            var _loc_4:IData = null;
            var _loc_5:Array = null;
            var _loc_6:Array = null;
            var _loc_7:int = 0;
            var _loc_8:Array = null;
            var _loc_9:XML = null;
            var _loc_10:Array = null;
            var _loc_11:XML = null;
            if (xml.hasOwnProperty("@none"))
            {
                return null;
            }
            if (type == Consts.TYPE_STRING)
            {
                return xml.toString();
            }
            if (type == Consts.TYPE_NUMBER)
            {
                return Number(xml.toString());
            }
            if (type == Consts.TYPE_BOOLEAN)
            {
                return xml.toString() == "true";
            }
            if (type == Consts.TYPE_INT)
            {
                return int(xml.toString());
            }
            if (type == Consts.TYPE_UINT)
            {
                return uint(xml.toString());
            }
            if (type == Consts.TYPE_POINT)
            {
                return new Point(xml.@x, xml.@y);
            }
            if (type == Consts.TYPE_RECTANGLE)
            {
                return new Rectangle(xml.@x, xml.@y, xml.@w, xml.@h);
            }
            if (type == Consts.TYPE_DATA)
            {
                _loc_3 = xml.@ref;
                _loc_4 = this.refMap[_loc_3];
                if (_loc_4 == null)
                {
                    return this.idMap[_loc_3];
                }
                return _loc_4;
            }
            if (type == Consts.TYPE_ARRAY_NUMBER)
            {
                _loc_5 = xml.toString().split(",");
                _loc_6 = [];
                _loc_7 = 0;
                while (_loc_7 < _loc_5.length)
                {
                    
                    _loc_6.push(Number(_loc_5[_loc_7]));
                    _loc_7 = _loc_7 + 1;
                }
                return _loc_6;
            }
            if (type == Consts.TYPE_ARRAY_STRING)
            {
                return xml.toString().split(",");
            }
            if (type == Consts.TYPE_COLLECTION_POINT)
            {
                _loc_8 = [];
                for each (_loc_9 in xml.elements("p"))
                {
                    
                    _loc_8.push(new Point(_loc_9.@x, _loc_9.@y));
                }
                return _loc_8;
            }
            if (type == Consts.TYPE_COLLECTION_STRING)
            {
                _loc_10 = [];
                for each (_loc_11 in xml.elements("s"))
                {
                    
                    _loc_10.push(_loc_11.toString());
                }
                return _loc_10;
            }
            return xml.toString();
        }

        public function serializeClient(obj:Object, client:String, data:Object) : void
        {
            var _loc_5:Object = null;
            var _loc_6:Object = null;
            var _loc_4:* = settings.getClientType(client);
            if (_loc_4 != null)
            {
                _loc_5 = obj.getClient(client);
                _loc_6 = data.getClient(client);
                if (_loc_5 != _loc_6)
                {
                    this.serializeValue("c", client, _loc_5, _loc_6, _loc_4, settings.isClientCdata(client));
                }
            }
            return;
        }

        public function serializeProperty(obj:Object, property:String, data:Object) : void
        {
            var _loc_5:Object = null;
            var _loc_6:Object = null;
            var _loc_4:* = settings.getPropertyType(property);
            if (_loc_4 != null)
            {
                _loc_5 = obj[property];
                _loc_6 = data[property];
                if (_loc_5 != _loc_6)
                {
                    this.serializeValue("p", property, _loc_5, _loc_6, _loc_4, settings.isPropertyCdata(property));
                }
            }
            return;
        }

		/**
		 * 是否可序列化
		 */
        protected function isSerializable(data:IData) : Boolean
        {
            if (!elementBox.contains(data)&&!elementBox.linkBox.contains(data))
            {
                return false;
            }
            if (filterFunction != null)
            {
	            if (!filterFunction(data))
	            {
	                return false;
	            }
			}
            return true;
        }

        protected function serializeBody() : void
        {
            var _loc_4:Class = null;
            var _loc_5:IData = null;
            this.ref = 0;
            var _loc_1:Vector.<IData> = elementBox.getDatas();
            _loc_1.forEach(this.setRef);
            if (settings.dataBoxSerializable)
            {
                xmlString = xmlString + ("<dataBox type=\'" + Utils.getQualifiedClassNameForObject(elementBox) + "\'>\n");
                _loc_4 = Utils.getClass(elementBox);
//                elementBox.serializeXML(this, new _loc_4);
                xmlString = xmlString + "</dataBox>\n";
            }
            var _loc_2:* = _loc_1.length;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_5 = _loc_1[_loc_3];
                this.serializeData(_loc_5);
                _loc_3 = _loc_3 + 1;
            }
			_loc_1 = elementBox.linkBox.getDatas();
			_loc_1.forEach(this.setRef);
			_loc_2= _loc_1.length;
			_loc_3 = 0;
			while (_loc_3 < _loc_2)
			{
				
				_loc_5 = _loc_1[_loc_3];
				this.serializeData(_loc_5);
				_loc_3 = _loc_3 + 1;
			}
			
        }

        public function serialize() : String
        {
            xmlString = "<teacher v=\'" + Utils.VERSION + "\'>\n";
            this.serializeBody();
            xmlString = xmlString + "</teacher>\n";
            return xmlString;
        }

		/**
		 * 序列化具体数据对象
		 */
        protected function serializeData(data:IData, index:int=-1, array:Vector.<IData>=null) : void
        {
            var _loc_2:Class = null;
            var _loc_3:IData = null;
            var _loc_4:String = null;
            if (isSerializable(data))
            {
                _loc_2 = Utils.getClass(data);
                _loc_3 = new _loc_2;
                _loc_4 = this.refMap[data];
                xmlString = xmlString + ("<data type=\'" + Utils.getQualifiedClassNameForObject(data) + "\' ref=\'" + _loc_4 + "\'");
                if (settings.getPropertyType("id") != null)
                {
                    xmlString = xmlString + (" id=\'" + data.id + "\'");
                }
                xmlString = xmlString + ">\n";
                data.serializeXML(this, _loc_3);
                xmlString = xmlString + "</data>\n";
            }
//			if(data.children)
//            	data.children.forEach(this.serializeData);
        }

        public function serializeValue(c:String, property:String, value:Object, point:Object, type:String, K447K:Boolean) : void
        {
            var _loc_7:Object = null;
            var _loc_8:Array = null;
            var _loc_9:int = 0;
            var _loc_10:Point = null;
            var _loc_11:Array = null;
            var _loc_12:Rectangle = null;
            if (value == null)
            {
                xmlString = xmlString + ("\t<" + c + " n=\'" + property + "\' none=\'\'/>\n");
            }
            else if (K447K)
            {
                xmlString = xmlString + ("\t<" + c + " n=\'" + property + "\'><![CDATA[" + value + "]]></" + c + ">\n");
            }
            else if (type == Consts.TYPE_DATA)
            {
                _loc_7 = this.refMap[value];
                if (_loc_7 != null)
                {
                    xmlString = xmlString + ("\t<" + c + " n=\'" + property + "\' ref=\'" + _loc_7 + "\'/>\n");
                }
            }
            else if (type == Consts.TYPE_POINT)
            {
                if (point is Point)
                {
                    if (value.x == point.x)
                    {
                    }
                }
                if (value.y != point.y)
                {
                    xmlString = xmlString + ("\t<" + c + " n=\'" + property + "\' x=\'" + value.x + "\' y=\'" + value.y + "\'/>\n");
                }
            }
            else if (type == Consts.TYPE_COLLECTION_POINT)
            {
                _loc_8 = value as Array;
                xmlString = xmlString + ("\t<" + c + " n=\'" + property + "\'>\n");
                _loc_9 = 0;
                while (_loc_9 < _loc_8.count)
                {
                    
                    _loc_10 = _loc_8.getItemAt(_loc_9);
                    xmlString = xmlString + ("\t\t<p x=\'" + _loc_10.x + "\' y=\'" + _loc_10.y + "\'/>\n");
                    _loc_9 = _loc_9 + 1;
                }
                xmlString = xmlString + ("\t</" + c + ">\n");
            }
            else if (type == Consts.TYPE_COLLECTION_STRING)
            {
                _loc_11 = value as Array;
                xmlString = xmlString + ("\t<" + c + " n=\'" + property + "\'>\n");
                _loc_9 = 0;
                while (_loc_9 < _loc_11.count)
                {
                    
                    xmlString = xmlString + ("\t\t<s>" + _loc_11.getItemAt(_loc_9) + "</s>\n");
                    _loc_9 = _loc_9 + 1;
                }
                xmlString = xmlString + ("\t</" + c + ">\n");
            }
            else if (type == Consts.TYPE_RECTANGLE)
            {
                _loc_12 = Rectangle(value);
                xmlString = xmlString + ("\t<" + c + " n=\'" + property + "\' x=\'" + _loc_12.x + "\' y=\'" + _loc_12.y + "\' w=\'" + _loc_12.width + "\' h=\'" + _loc_12.height + "\'/>\n");
            }
            else
            {
                xmlString = xmlString + ("\t<" + c + " n=\'" + property + "\'>" + value + "</" + c + ">\n");
            }
            return;
        }

        public function deserializeStyle(obj:Object, xml:XML, property:String) : void
        {
            var _loc_4:* = settings.getStyleType(property);
            if (_loc_4 != null)
            {
                obj.setStyle(property, deserializeValue(xml, _loc_4));
            }
            return;
        }

        public function deserializeProperty(obj:Object, xml:XML, property:String) : void
        {
            var _loc_4:* = settings.getPropertyType(property);
            if (_loc_4 != null)
            {
                obj[property] = deserializeValue(xml, _loc_4);
            }
            return;
        }

        public function serializeStyle(obj:Object, style:String, data:Object) : void
        {
            var _loc_5:Object = null;
            var _loc_6:Object = null;
            var _loc_4:* = settings.getStyleType(style);
            if (_loc_4 != null)
            {
                _loc_5 = obj.getStyle(style);
                _loc_6 = data.getStyle(style);
                if (_loc_5 != _loc_6)
                {
                    this.serializeValue("s", style, _loc_5, _loc_6, _loc_4, settings.isStyleCdata(style));
                }
            }
            return;
        }

        public function deserializeClient(obj:Object,xml:XML, property:String) : void
        {
            var _loc_4:* = settings.getClientType(property);
            if (_loc_4 != null)
            {
                obj.setClient(property, deserializeValue(xml, _loc_4));
            }
            return;
        }

        private function setRef(data:IData, index:int, array:Vector.<IData>) : void
        {
            var _loc_2:Object = this;
            _loc_2.ref = this.ref + 1;
            this.refMap[data] = (this.ref++).toString();
			if(data.children)
            	data.children.forEach(this.setRef);
        }

		/**
		 * 反序列化数据对象。<br>
		 * 如果反序列化的对象已存在，则会自动进行属性更新。如果未存在，则新建该对象并添加至ElementBox中。
		 */
        public function deserialize(xmlString:String, data:IData = null) : void
        {
            var _dataObject:IData = null;
            var _dataObjectXml:XML = null;
            var _count:int = 0;
            var _loc_9:String = null;
            var _dataIdType:String = null;
            var _dataId:Object = null;
            var _dataIdRef:String = null;
            SysControl.isDeserializingXML = true;
            this.xmlString = xmlString;
            var _xml:* = new XML(xmlString);
            SysControl.clear(this.refMap);
            SysControl.clear(this.idMap);
            var _dataObjectArray:Array = [];
            var _dataObjectXmlArray:Array = [];
            for each (_dataObjectXml in _xml.data)
            {
                
                _loc_9 = _dataObjectXml.@type;
                _dataIdType = settings.getPropertyType("id");
                if (_dataIdType != null)
                {
	                if (_dataObjectXml.hasOwnProperty("@id"))
	                {
	                    _dataId = null;
	                    if (_dataIdType == Consts.TYPE_STRING)
	                    {
	                        _dataId = _dataObjectXml.@id.toString();
	                    }
	                    else if (_dataIdType == Consts.TYPE_NUMBER)
	                    {
	                        _dataId = Number(_dataObjectXml.@id.toString());
	                    }
	                    else if (_dataIdType == Consts.TYPE_INT)
	                    {
	                        _dataId = int(_dataObjectXml.@id.toString());
	                    }
	                    else if (_dataIdType == Consts.TYPE_UINT)
	                    {
	                        _dataId = uint(_dataObjectXml.@id.toString());
	                    }
	                    else
	                    {
	                        throw new Error("Unsupported id type \'" + _dataIdType + "\'");
	                    }
						
						//允许通过设置action属性删除当前已存在的数据对象
	                    if (_dataObjectXml.@action == "remove")
	                    {
							if(this.elementBox.getDataByID(_dataId))
	                        	this.elementBox.removeData(this.elementBox.getDataByID(_dataId));
							else
								this.elementBox.linkBox.removeData(this.elementBox.linkBox.getDataByID(_dataId));
	                        continue;
	                    }
	                    _dataObject = this.elementBox.getDataByID(_dataId);
						
						if(_dataObject==null)
							_dataObject = this.elementBox.linkBox.getDataByID(_dataId);
						
	                    if (_dataObject == null)
	                    {
	                        _dataObject = SysControl.createInstance(_loc_9, _dataId);
	                    }
	                }
				}
                else
                {
                    _dataObject = SysControl.createInstance(_loc_9);
                }
                if (_dataObjectXml.hasOwnProperty("@ref"))
                {
                    _dataIdRef = _dataObjectXml.@ref;
                    this.refMap[_dataIdRef] = _dataObject;
                }
                _dataObjectArray.push(_dataObject);
                _dataObjectXmlArray.push(_dataObjectXml);
                idMap[_dataObject.id] = _dataObject;
            }
            _count = 0;
            while (_count < this.elementBox.length)
            {
                
                _dataObject = this.elementBox.getDatas()[_count];
                idMap[_dataObject.id] = _dataObject;
                _count = _count + 1;
            }
			_count = 0;
			while (_count < this.elementBox.linkBox.length)
			{
				
				_dataObject = this.elementBox.linkBox.getDatas()[_count];
				idMap[_dataObject.id] = _dataObject;
				_count = _count + 1;
			}
			
            _count = 0;
            while (_count < _dataObjectArray.length)
            {
                
                _dataObject = _dataObjectArray[_count];
                _dataObjectXml = _dataObjectXmlArray[_count];
                _dataObject.deserializeXML(this, _dataObjectXml);
                _count = _count + 1;
            }
            _count = 0;
            while (_count < _dataObjectArray.length)
            {
                
                _dataObject = _dataObjectArray[_count];
                if (this.elementBox.getDataByID(_dataObject.id)!=null||this.elementBox.linkBox.getDataByID(_dataObject.id)!=null)
                {
					//to do
                }
                else
                {
                    if (data != null)
                    {
	                    if (_dataObject.parent == null)
	                    {
	                        _dataObject.parent = data;
	                    }
					}
                    elementBox.add(_dataObject);
                }
                _count = _count + 1;
            }
            if (settings.dataBoxSerializable)
            {
	            if (_xml.child("dataBox").length() == 1)
	            {
	                elementBox.deserializeXML(this, _xml.dataBox[0]);
	            }
			}
            SysControl.isDeserializingXML = false;
        }

    }
}
