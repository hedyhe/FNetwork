package com.myflexhero.network.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class ActionElement
	{
		private var _id:Object;
		private var _image:String;
		private var _label:String;
		private var _shapeType:String;
		private var _elementClass:Class;
		private var _toolTip:String;
		private var _icon:String;
		private var _customField:*;
		
		public function get id():Object
		{
			return _id;
		}
		
		public function set id(value:Object):void
		{
			_id = value;
		}
		public function get icon():String
		{
			return _icon;
		}

		public function set icon(value:String):void
		{
			_icon = value;
		}

		public function get toolTip():String
		{
			return _toolTip;
		}

		public function set toolTip(value:String):void
		{
			_toolTip = value;
		}

		public function get elementClass():Class
		{
			return _elementClass;
		}

		public function set elementClass(value:Class):void
		{
			_elementClass = value;
		}

		public function get image():String{
			return _image;
		}
		
		public function set image(image:String):void{
			this._image=image;
		}
		
		public function get label():String{
			return this._label;
		}
		
		public function set label(label:String):void{
			this._label=label;
		}
		
		public function get shapeType():String{
			return _shapeType;
		}
		
		public function set shapeType(shapeType:String):void{
			this._shapeType=shapeType;
		}
		
		public function get customField():*
		{
			return _customField;
		}
		
		public function set customField(value:*):void
		{
			_customField = value;
		}
		
		public var action:Function;
	}
}
