package com.myflexhero.network.core.image
{
	import com.myflexhero.network.core.IImageAsset;
	import com.myflexhero.network.core.util.GraphicDrawHelper;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;

	public class ImageCache extends Object implements IImageAsset
	{
		private var _smoothing:Boolean = false;
		private var _args:Array = null;
		private var _bitmapData:BitmapData = null;
		private var _bitmapDataDummy:Object = null;
		
		private var _displayObject:DisplayObject = null;
		private var _displayObjectDummy:Object = null;
		
		private var _componentClass:Class = null;
		private var _componentClassDummy:Object = null;
		
		
		private var _componentDisplayObject:DisplayObject;
		
		private var _rectangle:Rectangle = null;
		
		public function ImageCache(bitmapData:BitmapData, displayObject:DisplayObject = null, componentClass:Class = null, bounds:Rectangle = null, args:Array = null, smoothing:Boolean = false)
		{
			var _component:UIComponent = null;
			this._bitmapData = bitmapData;
			this._displayObject = displayObject;
			this._componentClass = componentClass;
			this._rectangle = bounds;
			this._args = args;
			this._smoothing = smoothing;
			if (this._rectangle == null)
			{
				if (bitmapData != null)
				{
					this._rectangle = new Rectangle(0, 0, bitmapData.width, bitmapData.height);
				}
				else if (displayObject != null)
				{
					this._rectangle = displayObject.getBounds(null);
					if (this._rectangle != null)
					{
					}
					if (this._rectangle.width != 0)
					{
					}
					if (this._rectangle.height == 0)
					{
						this._rectangle = new Rectangle(0, 0, displayObject.width, displayObject.height);
					}
				}
				else
				{
					if (args == null)
					{
						this._componentDisplayObject = new componentClass;
					}
					_rectangle = _componentDisplayObject.getBounds(null);
					if (_componentDisplayObject is UIComponent)
					{
						if (_rectangle != null)
						{
						}
						if (_rectangle.width != 0)
						{
						}
					}
					if (_rectangle.height == 0)
					{
						_component = UIComponent(_componentDisplayObject);
						_rectangle = new Rectangle(0, 0, _component.measuredWidth, _component.measuredHeight);
					}
					if (_rectangle != null)
					{
					}
					if (_rectangle.width != 0)
					{
					}
					if (_rectangle.height == 0)
					{
						_rectangle = new Rectangle(0, 0, _componentDisplayObject.width, _componentDisplayObject.height);
					}
				}
			}
			return;
		}
		
		public function get width() : Number
		{
			return this._rectangle.width;
		}
		
		public function get args() : Array
		{
			return this._args;
		}
		
		public function get height() : Number
		{
			return this._rectangle.height;
		}
		
		public function get displayObject() : DisplayObject
		{
			return this._displayObject;
		}
		
		private function isDefaultColor(color:Object) : Boolean
		{
			if (color != null)
			{
				if (!(color is Number))
				{
					return true;
				}
				if (color is Number)
				{
					if (Number(color) < 0)
					{
						return true;
					}
				}
			}
			return false;
		}
		
		public function get smoothing() : Boolean
		{
			return this._smoothing;
		}
		
		public function get bounds() : Rectangle
		{
			return this._rectangle;
		}
		
		public function get bitmapData() : BitmapData
		{
			return this._bitmapData;
		}
		
		public function get componentClass() : Class
		{
			return this._componentClass;
		}
		
		private function createBitmapData(object:DisplayObject, useHelper:Boolean, color:Object, scaleWidth:Number, scaleHieght:Number) : BitmapData
		{
			var _loc_1:BitmapData = new BitmapData(Math.max(1, _rectangle.width * scaleWidth), Math.max(1, _rectangle.height * scaleHieght), true, 0);
			var _matrix:Matrix = new Matrix();
			_matrix.translate(-_rectangle.x, -_rectangle.y);
			_matrix.scale(scaleWidth, scaleHieght);
			_loc_1.draw(object, _matrix);
			if (!useHelper)
			{
				_loc_1 = GraphicDrawHelper.createBitmapData(_loc_1, Number(color));
			}
			return _loc_1;
		}
	}
}