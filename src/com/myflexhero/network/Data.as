package com.myflexhero.network
{
//	import com.myflexhero.network.core.IClient;
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.event.ElementPropertyChangeEvent;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.utils.UIDUtil;

	/**
	 * 所有数据的基类
	 * @author Hedy<br>
	 * 550561954#qq.com  
	 */
	public class Data extends EventDispatcher implements IData
	{
		private var _id:Object;
		private var _client:Object;
		private var _label:String;
		private var _toolTip:String;
		private var _icon:String;
		private var _parent:IData;
		protected var _children:Vector.<IData>;
		private var locked:Boolean = false;
		protected var _visible:Boolean = true;
		/**
		 * 是否处于调整状态？
		 * 当width和height的比率和原始图片的比率不同时，
		 * 如设置width(或height)属性值后，会自动更新height的值以达到和原始宽高比率相同.
		 * 在派发width事件的基础上，不会再额外派发height更改的事件
		 */
		public var adjustment:Boolean = false;
		/**
		 * 此属性用于优化显示.如果设置为true后，再更改x、y、width、height、location属性或调用setLocation()、setSize()方法，
		 * 将不会立即重绘画面(但此时值已更改)，如需手动刷新界面，请调用ElementUI的drawBody方法。<br><br>
		 * 
		 * 此外，程序内部在自动布局中的环形布局使用到该属性。<br>
		 * 当该属性为true时,环形视图将在每次timer对象调用完毕后才会更新节点视图.
		 */
		private var _isLock:Boolean = true;
		public function get isLock():Boolean
		{
			return _isLock;
		}
		
		public function set isLock(value:Boolean):void
		{
			this._isLock = value;
		}
		public function Data(id:Object)
		{
			this._id = id==null?UIDUtil.createUID():id;
			_children = new Vector.<IData>();
		}
		
		private var _name:String;
		/**
		 * 前元素的name,可以为空,Node和Link不会显示该字段
		 */
		public function set name(value:String):void{
			this._name = value;
		}
		
		public function get name():String{
			return this._name;
		}
		
		public function dispatchPropertyChangeEvent(property:String, oldValue:Object, newValue:Object) : Boolean
		{
			//to do
//			trace("dispatchPropertyChangeEvent:("+"property:"+property+",oldValue:"+oldValue+",newValue:"+newValue+")")
			if(!adjustment){
				dispatchEvent(new ElementPropertyChangeEvent(Consts.EVENT_DATA_PROPERTY_CHANGE,false,false,ElementPropertyChangeEvent.UPDATE,property,oldValue,newValue,this));
				return true;	
			}
			return false;
		}
		
		public function removePropertyChangeListener(listener:Function) : void
		{
			this.removeEventListener(Consts.EVENT_DATA_PROPERTY_CHANGE, listener);
		}
		
		public function addPropertyChangeListener(listener:Function, priority:int = 0, useCapture:Boolean = false) : void
		{
			this.addEventListener(Consts.EVENT_DATA_PROPERTY_CHANGE, listener, false, priority, useCapture);
		}
		
		public function serializeXML(xmlSerializer:XMLSerializer, data:IData) : void
		{
			var _c:String = null;
			if (xmlSerializer.settings.clientSerializable)
			{
				if (this._client != null)
				{
					for (_c in this._client)
					{
						
						this.serializeClient(xmlSerializer, _c, data);
					}
				}
			}
			this.serializeProperty(xmlSerializer, "name", data);
			this.serializeProperty(xmlSerializer, "label", data);
			this.serializeProperty(xmlSerializer, "icon", data);
			this.serializeProperty(xmlSerializer, "toolTip", data);
			this.serializeProperty(xmlSerializer, "parent", data);
			return;
		}
		
		protected function serializeClient(xmlSerializer:XMLSerializer, property:String, data:IData) : void
		{
			xmlSerializer.serializeClient(this, property, data);
			return;
		}
		
		protected function serializeProperty(xmlSerializer:XMLSerializer, property:String, data:IData) : void
		{
			xmlSerializer.serializeProperty(this, property, data);
			return;
		}
		
		public function deserializeXML(serializer:XMLSerializer, xml:XML) : void
		{
			var _loc_3:XML = null;
			var _loc_4:XML = null;
			for each (_loc_3 in xml.elements("p"))
			{
				
				if (_loc_3.hasOwnProperty("@n"))
				{
					deserializeProperty(serializer, _loc_3, _loc_3.@n);
				}
			}
			if (serializer.settings.clientSerializable)
			{
				for each (_loc_4 in xml.elements("c"))
				{
					
					if (_loc_4.hasOwnProperty("@n"))
					{
						deserializeClient(serializer, _loc_4, _loc_4.@n);
					}
				}
			}
			return;
		}
		
		protected function deserializeProperty(serializer:XMLSerializer, xml:XML, property:String) : void
		{
			serializer.deserializeProperty(this, xml, property);
			return;
		}
		
		protected function deserializeClient(serializer:XMLSerializer, xml:XML, property:String) : void
		{
			serializer.deserializeClient(this, xml, property);
			return;
		}
		/**
		 *@inheritDoc
		 */
		public function get id():Object
		{
			return _id;
		}

		public function set id(value:Object):void
		{
			_id = value;
		}

		public function get label():String
		{
			return _label;
		}
		/**
		 *@inheritDoc
		 */
		public function set label(value:String):void
		{
			var _oldValue:* = this._label;
			if(value==_oldValue)
				return;
			this._label = value;
			if(!isLock)
				this.dispatchPropertyChangeEvent("label", _oldValue, value);
		}
		/**
		 *@inheritDoc
		 */
		public function get toolTip():String
		{
			return _toolTip;
		}

		public function set toolTip(value:String):void
		{
			var _oldValue:* = this._toolTip;
			if(value==_oldValue)
				return;
			this._toolTip = value;
			if(!isLock)
				this.dispatchPropertyChangeEvent("toolTip", _oldValue, value);
		}
		/**
		 *@inheritDoc
		 */
		public function get icon():String
		{
			return _icon;
		}

		public function set icon(value:String):void
		{
			_icon = value;
		}
		/**
		 *@inheritDoc
		 */
		public function get parent() : IData
		{
			return this._parent;
		}
		/**
		 *@inheritDoc
		 */
		public function get children():Vector.<IData>{
			return this._children;
		}
		
		/**
		 * 根据索引下标返回指定的节点
		 */
		public function getChild(index:int):IData{
			if(_children)
				return _children[index];
			return null;
		}
		
		/**
		 *@inheritDoc
		 */
		public function addChild(data:IData,index:int=-1):Boolean{
			if(data==null)
				return false;
			var _i:int = children.indexOf(data);
			if(_i!=-1)
				return false;
			/*删除data原有父类的引用*/
			if(data.parent!=null)
				data.parent.removeChild(data);
			/* data为当前类的父类 */
			if(isDescendantOf(data))
				return false;
			
			if(index==-1)
				children.push(data);
			else{
				var _oldValue:IData = children[index];
				children[children.length] = _oldValue;
				children[index] = data;
			}
			data.parent = this;
			if(!isLock)
				this.dispatchPropertyChangeEvent("addChild", null, data);
			return true;
		}
		
		/**
		 *@inheritDoc
		 */
		public function removeChild(data:IData):Boolean{
			if(data==null)
				return false;
			var _index:int = children.indexOf(data);
			if(_index==-1)
				return false;
			children.splice(_index,1);
			if(!isLock)
				this.dispatchPropertyChangeEvent("removeChild", data, null);
			
//			trace("to:"+data.label+",from::::"+data.parent)
			data.parent = null;
			return true;
		}
		
		/**
		 *@inheritDoc
		 */
		public function set parent(parent:IData) : void
		{
			if (!locked)
			{
				if (this._parent != parent)
				{
					if (parent == this)
					{
						return;
					}
					if (parent != null)
					{
					
						if (parent.isDescendantOf(this))
						{
							return;
						}
					}
					var _oldValue:* = this._parent;
					this._parent = parent;
					locked = true;
					if (_oldValue != null)
					{
						//在父级元素中移除当前引用
						_oldValue.removeChild(this);
					}
					if (parent != null)
					{
						parent.addChild(this);
					}
					locked = false;
					if(!isLock)
						this.dispatchPropertyChangeEvent("parent", _oldValue, parent);
		//			this.onParentChanged(_loc_2, parent);
				}
			}
			return;
		}

		/**
		 * @inheritDoc
		 */
		public function isDescendantOf(data:IData) : Boolean
		{
			if (data == null)
			{
				return false;
			}
			if (!data.numChildren>0)
			{
				return false;
			}
			var _thisParent:* = this.parent;
			while (_thisParent != null)
			{
				
				if (data == _thisParent)
				{
					return true;
				}
				_thisParent = _thisParent.parent;
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get numChildren():int{
			if(_children==null)
				return 0;
			return _children.length;
		}

		public function get visible():Boolean
		{
			return _visible;
		}

		public function set visible(value:Boolean):void
		{
			var _oldValue:* = this._visible;
			this._visible = value;
			if(!isLock&&_oldValue!=value)
				this.dispatchPropertyChangeEvent("visible", _oldValue, value);
		}
		
		
		protected var _highLightEnable:Boolean = false;
		protected var _secondHighLightEnable:Boolean = false;

		public function get secondHighLightEnable():Boolean
		{
			return _secondHighLightEnable;
		}

		public function set secondHighLightEnable(value:Boolean):void
		{
			//这里使用^异或运算符判断时提示报错.
			if(value==_secondHighLightEnable)
				return;
			var _oldValue:* = _secondHighLightEnable;
			_secondHighLightEnable = value;
			if(!isLock)
				this.dispatchPropertyChangeEvent("secondHighLightEnable", _oldValue, value);
		}

		public function set highLightEnable(value:Boolean):void{
			//这里使用^异或运算符判断时提示报错.
			if(value==_highLightEnable)
				return;
			var _oldValue:* = _highLightEnable;
			_highLightEnable = value;
			if(!isLock)
				this.dispatchPropertyChangeEvent("highLightEnable", _oldValue, value);
		}
		
		public function get highLightEnable():Boolean{
			return _highLightEnable;
		}
		
		public function getClient(clientProp:String):*
		{
			if (this._client == null)
			{
				return null;
			}
			return this._client[clientProp];
			
		}
		
		public function setClient(clientProp:String, newValue:*) : void
		{
			if (clientProp == null)
			{
				throw new Error("client property name can not be null");
			}
			if (this._client == null)
			{
				this._client = new Object();
			}
			var _oldValue:* = this._client[clientProp];
			if(newValue==_oldValue)
				return;
			if (newValue == null)
			{
				delete this._client[clientProp];
			}
			else
			{
				this._client[clientProp] = newValue;
			}
			
			if (this.dispatchPropertyChangeEvent(Consts.PREFIX_CLIENT + clientProp, _oldValue, newValue))
			{
				this.onClientChanged(clientProp, _oldValue, newValue);
			}
//			return this;
		}
		
		protected function onClientChanged(clientProp:String, oldValue:*, newValue:*) : void
		{
			return;
		}
		
		public function get clientProperties() : Array
		{
			var _loc_2:Object = null;
			var _loc_1:* = new Array();
			if (this._client != null)
			{
				for (_loc_2 in this._client)
				{
					
					_loc_1.push(_loc_2);
				}
			}
			return _loc_1;
		}
		
		public var creationCompleted:Boolean = false;
		/**
		 * 创建并初始化UI对象后将调用该方法.
		 */
		public function creationCompleteFunction():void{
			creationCompleted = true;
			//to do
		}
	}
}