package com.myflexhero.network.core.util
{
	import com.myflexhero.network.Styles;
	
	public class SerializationSettings
	{
		public var styleSerializable:Boolean;
		public var layerBoxSerializable:Boolean;
		public var dataBoxSerializable:Boolean;
		public var clientSerializable:Boolean;
		public static var globalLayerBoxSerializable:Boolean = true;
		private static const globalPropertyCdata:Object = new Object();
		private static const globalClientCdata:Object = new Object();
		private static const globalPropertyMap:Object = new Object();
		private static const globalStyleCdata:Object = new Object();
		public static var globalStyleSerializable:Boolean = true;
		private static const globalClientMap:Object = new Object();
		public static var globalClientSerializable:Boolean = true;
		private static const globalStyleMap:Object = new Object();
		public static var globalDataBoxSerializable:Boolean = true;
		
		public function SerializationSettings()
		{
			dataBoxSerializable = globalDataBoxSerializable;
			layerBoxSerializable = globalLayerBoxSerializable;
			styleSerializable = globalStyleSerializable;
			clientSerializable = globalClientSerializable;
			if(getPropertyType("id")==null)
				Styles.initStyles();
			return;
		}
		
		public function registerStyle(property:String, type:String, cdata:Boolean = false) : void
		{
			globalStyleMap[property] = type;
			globalStyleCdata[property] = cdata;
			return;
		}
		
		public function getStyleType(property:String) : String
		{
			return globalStyleMap[property];
		}
		
		public function registerProperty(property:String, type:String, cdata:Boolean = false) : void
		{
			globalPropertyMap[property] = type;
			globalPropertyCdata[property] = cdata;
			return;
		}
		
		public function getClientType(clientProp:String) : String
		{
			return globalClientMap[clientProp];
		}
		
		public function registerClient(clientProp:String, type:String, cdata:Boolean = false) : void
		{
			globalClientMap[clientProp] = type;
			globalClientCdata[clientProp] = cdata;
			return;
		}
		
		public function getPropertyType(property:String) : String
		{
			return globalPropertyMap[property];
		}
		
		public function isStyleCdata(property:String) : Boolean
		{
			return globalStyleCdata[property];
		}
		
		public function isPropertyCdata(property:String) : Boolean
		{
			return globalPropertyCdata[property];
		}
		
		public function isClientCdata(property:String) : Boolean
		{
			return globalClientCdata[property];
		}
		
		public static function isGlobalPropertyCdata(property:String) : Boolean
		{
			return globalPropertyCdata[property];
		}
		
		public static function registerGlobalClient(clientProp:String, type:String, cdata:Boolean = false, overrideExist:Boolean = true) : void
		{
			if (!overrideExist)
			{
			}
			if (globalClientMap.hasOwnProperty(clientProp))
			{
				return;
			}
			globalClientMap[clientProp] = type;
			globalClientCdata[clientProp] = cdata;
			return;
		}
		
		public static function registerGlobalProperty(property:String, type:String, cdata:Boolean = false, overrideExist:Boolean = true) : void
		{
			if (!overrideExist)
			{
				if (globalPropertyMap.hasOwnProperty(property))
				{
					return;
				}
			}
			globalPropertyMap[property] = type;
			globalPropertyCdata[property] = cdata;
			return;
		}
		
		public static function getGlobalClientType(clientProp:String) : String
		{
			return globalClientMap[clientProp];
		}
		
		public static function getGlobalPropertyType(property:String) : String
		{
			return globalPropertyMap[property];
		}
		
		public static function isGlobalStyleCdata(property:String) : Boolean
		{
			return globalStyleCdata[property];
		}
		
		public static function registerGlobalStyle(property:String, type:String, cdata:Boolean = false, overrideExist:Boolean = true) : void
		{
			if (!overrideExist)
			{
			}
			if (globalStyleMap.hasOwnProperty(property))
			{
				return;
			}
			globalStyleMap[property] = type;
			globalStyleCdata[property] = cdata;
			return;
		}
		
		public static function getGlobalStyleType(property:String) : String
		{
			return globalStyleMap[property];
		}
		
		public static function isGlobalClientCdata(property:String) : Boolean
		{
			return globalClientCdata[property];
		}
		
		public static function clone(object:Object) : Object
		{
			var _dummy:Object = null;
			var _obejct:* = new Object();
			for (_dummy in object)
			{
				
				_obejct[_dummy] = object[_dummy];
			}
			return _obejct;
		}
	}
}
