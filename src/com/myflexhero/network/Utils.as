package com.myflexhero.network
{
	import com.myflexhero.network.core.IImageAsset;
	import com.myflexhero.network.core.image.ImageCache;
	import com.myflexhero.network.core.image.ImageLoader;
	import com.myflexhero.network.core.util.GraphicDrawHelper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import spark.filters.DisplacementMapFilter;

	final public class Utils extends Object
	{
		
		public function Utils()
		{
			return;
		}
		
		public static function beginFill(g:Graphics, fillColor:Number, fillAlpha:Number = 1, x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0, gradient:String = null, gradientColor:Number = 0, gradientAlpha:Number = 1) : void
		{
			GraphicDrawHelper.beginFill(g,fillColor,fillAlpha,x,y,width,height,gradient,gradientColor,gradientAlpha);
		}
		
		/**
		 * 注册一个Display Object。
		 * @param name 资源名称
		 * @param displayObject 已嵌入了显示资源的对象
		 * @param bounds 资源的边界
		 */
		public static function registerImageByDisplayObject(name:String, displayObject:DisplayObject, bounds:Rectangle = null) : void
		{
			if (displayObject == null)
			{
				ImageLoader.register(name, null);
			}
			else if (displayObject is Bitmap)
			{
				ImageLoader.register(name, new ImageCache(Bitmap(displayObject).bitmapData));
			}
			else
			{
				ImageLoader.register(name, new ImageCache(null, displayObject, null, bounds));
			}
			return;
		}
		
		/**
		 * 根据url注册图片资源
		 */
		public static function registerImageByUrl(imageLoader:ImageLoader,name:String, url:String) : void
		{
			imageLoader.registerImageByUrl(name, url);
			return;
		}
		
		/**
		 * 注册一个bitmap image。
		 */
		public static function registerImageByBitmapData(name:String, bitmapData:BitmapData) : void
		{
			ImageLoader.register(name, bitmapData == null ? (null) : (new ImageCache(bitmapData)));
			return;
		}// end function
		
		/**
		 * 根据class类型在组件中注册一个资源(图片)。
		 * @param name 注册的资源名称
		 * @param imageClass 资源的class type，可以是 image asset或者display object
		 * @param asComponent 该图片是否已经在一个组件中
		 */
		public static function registerImageByClass(name:String, imageClass:Class, asComponent:Boolean = false, bounds:Rectangle = null, args:Array = null) : void
		{
			if (imageClass == null)
			{
				ImageLoader.register(name, null);
			}
			else if (asComponent)
			{
				ImageLoader.register(name, new ImageCache(null, null, imageClass, bounds, args));
			}
			else
			{
				registerImageByDisplayObject(name, new imageClass as DisplayObject, bounds);
			}
		}
		
		public static function getBounds(attachmentSprite:DisplayObject, parent:DisplayObject) : Rectangle
		{
			return GraphicDrawHelper.getBounds(attachmentSprite,parent);
		}
		
		
		public static function createMagnifierFilter(scaleX:int, scaleY:int, fisheye:Boolean, point:Point = null) : DisplacementMapFilter
		{
			return GraphicDrawHelper.createMapFilter(scaleX, scaleY, fisheye, point);
		}
		
		public static function getImageAsset(imageLoader:ImageLoader,name:String, throwErrors:Boolean = true) : IImageAsset
		{
			return ImageLoader.getImageAsset(imageLoader,name, throwErrors);
		}
		
		public static function getClass(object:Object) : Class
		{
			var _loc_2:* = getQualifiedClassNameForObject(object);
			return getDefinitionByName(_loc_2) as Class;
		}
		
		public static function getQualifiedClassNameForObject(object:Object) : String
		{
			var _loc_2:* = getQualifiedClassName(object);
			return _loc_2.replace("::", ".");
		}
		
		public static function randomColor() : Number
		{
			var _loc_1:* = randomInt(255);
			var _loc_2:* = randomInt(255);
			var _loc_3:* = randomInt(255);
			return _loc_1 << 16 | _loc_2 << 8 | _loc_3;
		}
		
		public static function randomBoolean() : Boolean
		{
			return randomInt(2) != 0;
		}
		
		
		public static function randomInt(n:int) : int
		{
			return Math.floor(Math.random() * n);
		}
		
		
		public static function get VERSION() : String
		{
			return "0.1";
		}
		
		public static function randomRange(min:Number, max:Number) : Number
		{
			return Math.random() * (max - min) + min;
		}
		
		/**
		 * 弧度转换为角度
		 */
		public static function toDegrees(radian:Number) : Number
		{
			return radian * 180 / Math.PI;
		}
		
		/**
		 * 角度转换为弧度
		 */
		public static function toRadians(degrees:Number) : Number
		{
			return degrees / 180 * Math.PI;
		}
		
	}
}