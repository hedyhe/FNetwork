package com.myflexhero.network
{
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.core.image.ImageLoader;
	import com.myflexhero.network.event.DataBoxChangeEvent;
	import com.myflexhero.network.event.ElementPropertyChangeEvent;
	import com.myflexhero.network.event.ImageLoadEvent;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.core.mx_internal;

	use namespace mx_internal;
	
	public class DataBox extends EventDispatcher
	{
		private var dataElements:Vector.<IData>;
		private var _dataElements:Dictionary;
		private var dataParents:Vector.<IData>;
		private var _name:String;
		private var _dataParents:Dictionary;
		public function DataBox(name:String = "DataBox")
		{
			dataElements = new Vector.<IData>();
			_dataElements = new Dictionary();
			dataParents = new Vector.<IData>();
			_dataParents = new Dictionary();
			_name = name; 
		}
		
		public function handleImageLoaded(event:ImageLoadEvent) : void
		{
			for each(var data:* in dataElements){
				if(data.image==event.name){
					data.dispatchPropertyChangeEvent(ElementPropertyChangeEvent.IMAGE_LOADED, null, event.imageAsset);
				}
			}
			//通知界面刷新自动布局器
			dispatchEvent(new DataBoxChangeEvent(DataBoxChangeEvent.LAYOUT_REFRESH, null));
		}
		
		public function addDataBoxChangeListener(listener:Function, priority:int = 0, useWeakReference:Boolean = false) : void
		{
			this.addEventListener(Consts.EVENT_DATABOX_CHANGE, listener, false, priority, useWeakReference);
		}
		
		public function removeDataBoxChangeListener(listener:Function) : void
		{
			this.removeEventListener(Consts.EVENT_DATABOX_CHANGE, listener);
		}
		
		public function getDataByID(id:Object) : IData
		{
			return this._dataElements[id];
		}
		
		/**
		 * 根据传入的name参数，返回等于该字符串的元素。
		 */
		public function getDataByName(name:String) : IData
		{
			for(var i:int = 0;i<dataElements.length;i++){
				if(dataElements[i].name==name)
					return dataElements[i];
			}
			return null;
		}
		
		public function add(data:IData):void{
			if (data == null)
			{
				return;
			}
			if (_dataElements[data.id] != null||dataElements.indexOf(data)!=-1)
			{
				//去掉报错
//				throw new Error("已经存在相同ID的Data,id=\'" + data.id + "\'");
				return;
			}
			
			_dataElements[data.id] = data;
			dataElements.push(data);
			
			if (data.parent == null)
			{
				this._dataParents[data.id] = data;
			}
//			data.addPropertyChangeListener(handleDataPropertyChange, Consts.PRIORITY_ABOVE_NORMAL);
			dispatchEvent(new DataBoxChangeEvent(DataBoxChangeEvent.ADD, data));
//			this.checkLimit();
			return;
		}
		
		public function removeData(value:IData):void{
			var index:int = dataElements.indexOf(value);
			var value_loc:*;
			if(index!=-1){
//				trace("index:"+index+",lenght:"+dataElements.length)
				delete _dataElements[value.id];
				value_loc = dataElements.splice(index,1)[0];
			}
//			trace("dataElements.length:"+dataElements.length)
//			trace("dataElements.indexOf(value):"+dataElements.indexOf(value))
			dispatchEvent(new DataBoxChangeEvent(DataBoxChangeEvent.REMOVE, value_loc));
		}
		
		/**
		 * 删除全部Node数据.
		 */
		public function removeAll():void{
			if(dataElements.length<1)
				return;
			var _values:Vector.<IData> = dataElements.splice(0,dataElements.length);
			for each(var d:IData in _dataElements){
				delete _dataElements[d.id];
			}
			dispatchEvent(new DataBoxChangeEvent(DataBoxChangeEvent.CLEAR,_values[0],_values));
		}
		
		public function contains(item:Object):Boolean{
			for (var i:int=0;i<dataElements.length;i++){
				if(item==dataElements[i])
					return true;
			}
			return false;
		}
		
		public function getDatas():Vector.<IData>{
			return dataElements;
		}
		
		public function setDatas(value:Vector.<IData>):void{
			if(value==null)
				return;
			
			dataElements = value;
			for(var i:int=0;i<dataElements.length;i++){
				_dataElements[dataElements[i].id] = dataElements[i];
				
				if (dataElements[i].parent == null)
				{
					this._dataParents[dataElements[i].id] = dataElements[i];
				}
				dispatchEvent(new DataBoxChangeEvent(DataBoxChangeEvent.ADD, dataElements[i]));
			}
		}
		
		/**
		 * 对每一个数据执行测试函数.<br>
		 * 该函数可以拥有0~3个参数，分别对应data:IData(Node或Link等该类型的子类)、index:int(当前子类的索引下标)、dataBox:DataBox(当前调用者ElementBox的引用).
		 */
		public function forEach(callbackFunction:Function) : void
		{
			var _callbackFunction:* = undefined;
			if (callbackFunction == null)
			{
				throw new Error("Callback function can not be null");
			}
			var _funcLen:* = callbackFunction.length;
			var len:* = dataElements.length;
			var index:int = 0;
			while (index < len)
			{
				
				if (_funcLen == 0)
				{
					_callbackFunction = callbackFunction();
				} 
				else if (_funcLen == 1)
				{
					_callbackFunction = callbackFunction(dataElements[index]);
				}
				else if (_funcLen == 2)
				{
					_callbackFunction = callbackFunction(dataElements[index], index);
				}
				else
				{
					_callbackFunction = callbackFunction(dataElements[index], index, this);
				}
				if (_callbackFunction is Boolean)
				{
					if (_callbackFunction == false)
					{
						return;
					}
				}
				index = index + 1;
			}
			return;
		}
		/**
		 * [只读] 此视图中的项目数。0 表示不包含项目，而 -1 表示长度未知。
		 */
		public function get length():int{
			return dataElements.length;
		}
		
		public function serializeXML(serializer:XMLSerializer, dataBox:DataBox) : void
		{
			var _loc_3:String = null;
			this.serializeProperty(serializer, "name", dataBox);
			this.serializeProperty(serializer, "icon", dataBox);
			this.serializeProperty(serializer, "toolTip", dataBox);
			return;
		}
		
		protected function serializeProperty(serializer:XMLSerializer, property:String, dataBox:DataBox) : void
		{
			serializer.serializeProperty(this, property, dataBox);
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
		}
		
		protected function deserializeProperty(serializer:XMLSerializer, xml:XML, property:String) : void
		{
			serializer.deserializeProperty(this, xml, property);
		}
		
	}
}