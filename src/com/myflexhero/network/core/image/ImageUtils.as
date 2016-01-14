package com.myflexhero.network.core.image
{
	import com.myflexhero.network.core.IImageAsset;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import spark.filters.DisplacementMapFilter;

	final public class ImageUtils extends Object
	{
		
		public function ImageUtils()
		{
			return;
		}
		
		/**
		 * 加载图片成功后调用的回调方法,加载错误时不会调用
		 */
		public static function addImageLoadedListener(imageLoader:ImageLoader,callBackFunction:Function, priority:int = 0) : void
		{
			imageLoader.addImageLoadedListener(callBackFunction, priority);
		}
		
		/**
		 * 删除添加的图片加载回调方法
		 * @param callBackFunction 需要删除的回调方法
		 */
		public static function removeImageLoadedListener(imageLoader:ImageLoader,callBackFunction:Function) : void
		{
			imageLoader.removeImageLoadedListener(callBackFunction);
		}
		/**
		 * 是否包含该资源
		 */
		public static function containsImage(name:String) : Boolean
		{
			return ImageLoader.contains(name);
		}
	}
}