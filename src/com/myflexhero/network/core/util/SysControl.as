package com.myflexhero.network.core.util
{
	import com.myflexhero.network.Consts;
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.event.ElementPropertyChangeEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import mx.collections.*;
	import mx.core.*;
	import mx.events.*;
	import mx.managers.*;
	
	final public class SysControl extends Object
	{
		public static var isDeserializingXML:Boolean = false;
		
		public function SysControl()
		{
		}

		public static function clear(object:Object) : void
		{
			var _loc_2:Object = null;
			for (_loc_2 in object)
			{
				
				delete object[_loc_2];
			}
			return;
		}
		
		public static function getPhysicalPoint(uiComponent:UIComponent, e:MouseEvent) : Point
		{
			var _loc_3:* = uiComponent.globalToLocal(new Point(e.stageX, e.stageY));
			_loc_3.x = _loc_3.x * uiComponent.scaleX;
			_loc_3.y = _loc_3.y * uiComponent.scaleY;
			return _loc_3;
		}
		
		public static function dispatchPropertyChangeEvent(K59K:IEventDispatcher, property:String, oldValue:Object, newValue:Object, type:String = null) : Boolean
		{
			if (oldValue == newValue)
			{
				return false;
			}
			if (type == null)
			{
				type = Consts.EVENT_PROPERTY_CHANGE;
			}
			var _loc_6:* = new ElementPropertyChangeEvent(type);
			_loc_6.kind = ElementPropertyChangeEvent.UPDATE;
			_loc_6.source = K59K;
			_loc_6.property = property;
			_loc_6.oldValue = oldValue;
			_loc_6.newValue = newValue;
			K59K.dispatchEvent(_loc_6);
			return true;
		}
		
		public static function clone(object:Object) : Object
		{
			var _loc_3:Object = null;
			var _loc_2:* = new Object();
			for (_loc_3 in object)
			{
				
				_loc_2[_loc_3] = object[_loc_3];
			}
			return _loc_2;
		}
		
		public static function createInstance(obj:Object, ... args):IData{
			var _args:Class = null;
			if (obj is Class)
			{
				_args = obj as Class;
			}
			else
			{
				_args = getDefinitionByName(obj.toString()) as Class;
			}
			if (args.length == 1)
			{
				if (args[0] is Array)
				{
					_args = args[0];
				}
			}
			if (args.length == 0)
			{
				return new _args;
			}
			if (args.length == 1)
			{
				return new _args(args[0]);
			}
			if (args.length == 2)
			{
				return new _args(args[0], args[1]);
			}
			if (args.length == 3)
			{
				return new _args(args[0], args[1], args[2]);
			}
			if (args.length == 4)
			{
				return new _args(args[0], args[1], args[2], args[3]);
			}
			if (args.length == 5)
			{
				return new _args(args[0], args[1], args[2], args[3], args[4]);
			}
			if (args.length == 6)
			{
				return new _args(args[0], args[1], args[2], args[3], args[4], args[5]);
			}
			if (args.length == 7)
			{
				return new _args(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
			}
			throw new Error("不支持args长度超过7");
		}
	}
}