package com.myflexhero.network.core.image
{
	import com.myflexhero.network.Consts;
	import com.myflexhero.network.ImageConst;
	import com.myflexhero.network.core.IImageAsset;
	import com.myflexhero.network.event.ImageLoadEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.describeType;

	/**
	 * 该类提供了图片加载及内嵌图片管理功能。<br>
	 * 默认自带了部分内嵌图片,都以.Class的格式作为永久变量存储，具体内容名称请在编辑器中键入"ImageConst."并根据该类提供的提示输入信息进行查看(通过ImageLoader类依然可以,保持了旧版本兼容)。
	 * @author Hedy<br>
	 * 550561954#qq.com 
	 */
	public class ImageLoader
	{
		private static var _data:Object = null;
		
		private var _eventDispatcher:EventDispatcher = new EventDispatcher();

		//以下是为了保持旧版本兼容性添加的引用
		public static var shapenode_icon:Class = ImageConst.shapenode_icon;
		
		public static  var databox_icon:Class = ImageConst.databox_icon;
		
		public static  var cursor_move:Class = ImageConst.cursor_move;
		
		public static  var group_image:Class = ImageConst.group_image;
		
		public static  var shapelink_icon:Class = ImageConst.shapelink_icon;
		
		public static  var link_icon:Class = ImageConst.link_icon;
		
		public static  var subnetwork_icon:Class = ImageConst.subnetwork_icon;
		
		public static  var cursor_cross:Class = ImageConst.cursor_cross;
		
		public static  var group_icon:Class = ImageConst.group_icon;
		
		public static  var subnetwork_image:Class = ImageConst.subnetwork_image;
		
		public static  var grid_icon:Class = ImageConst.grid_icon;
		
		public static  var bus_icon:Class = ImageConst.bus_icon;
		
		public static  var node_image:Class= ImageConst.node_image;
		
		public static  var routerIcon:Class = ImageConst.routerIcon;
		
		public static  var routerImage:Class =ImageConst.routerImage;
		
		public static  var shapesubnetwork_icon:Class = ImageConst.shapesubnetwork_icon;
		
		public static  var data_icon:Class = ImageConst.data_icon;
		
		public static  var linksubnetwork_icon:Class = ImageConst.linksubnetwork_icon;
		
		public static  var cursor_resize0:Class = ImageConst.cursor_resize0;
		
		public static  var cursor_resize90:Class = ImageConst.cursor_resize90;
		
		public static  var cursor_resize135:Class = ImageConst.cursor_resize135;
		
		public static  var cursor_resize45:Class = ImageConst.cursor_resize45;
		
		public static  var port_image:Class = ImageConst.port_image;
		
		public static  var  resize_handle:Class = ImageConst.resize_handle;
		
		public function ImageLoader()
		{
		}
		
		public function registerImageByUrl(name:String, url:String) : void
		{
			var urlRequest:URLRequest = new URLRequest(url);
			var loader:Loader = new Loader();
			loader.name = name;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleImageLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function (event:IOErrorEvent) : void
				{
					throw new Error("加载图片错误!url:"+url+" \n(IOErrorEvent.toString():"+event.toString()+")");
					return;
				}
			);
			loader.load(urlRequest, new LoaderContext(false));
		}
		
		public static function contains(name:String) : Boolean
		{
			if (_data == null)
			{
				resetDataCaches();
			}

			if (!name)
			{
				return false;
			}
			return _data[name] != null;
		}
		
		private function handleImageLoaded(event:Event) : void
		{
			var _bitmapData:BitmapData = null;
			var _imageAsset:IImageAsset = null;
			var _loader:Loader = LoaderInfo(event.target).loader;
			if (_loader.content is Bitmap)
			{
				_bitmapData = Bitmap(_loader.content).bitmapData;
				_imageAsset = _bitmapData == null ? (null) : (new ImageCache(_bitmapData));
				ImageLoader.register(_loader.name, _imageAsset);
				_eventDispatcher.dispatchEvent(new ImageLoadEvent(_loader.name, _imageAsset));
			}
//			else
//			{
//				K789K(event, _loc_2.name);
//			}
			return;
		}
		
		public static function register(name:String, imageAsset:IImageAsset) : void
		{
			if (name == null)
			{
				throw new Error("图片名称不能为空");
			}
			if (imageAsset == null)
			{
				delete _data[name];
				return;
			}
			if (_data == null)
			{
				resetDataCaches();
			}
			
			_data[name] = imageAsset;
			return;
		}
		
		public static function getImageAsset(imageLoader:ImageLoader,name:String, throwErrors:Boolean = true) : IImageAsset
		{
			if (_data == null)
			{
				resetDataCaches();
			}

			if (name == "")
			{
				return null;
			}
			
			var _imageData:* = _data[name];
			if (_imageData == null)
			{
				imageLoader.registerImageByUrl(name, name);
				
				if (throwErrors)
				{
					throw new Error("名为\'" + name + "\'的图片还没有被注册");
				}
				return null;
			}
			return _imageData;
		}
		
		/**
		 * 重新保存当前类的所有内置资源引用
		 */
		private static function resetDataCaches() : void
		{
			var _xml:XML = null;
			var _imageName:String = null;
			var _class:Class = null;
			_data = new Object();
			
			//返回注册的图片
			var _ImageLoader:* = describeType(ImageConst);
			for each (_xml in _ImageLoader..constant)
			{
				
				_imageName = String(_xml.@name);
				_class = ImageLoader[_imageName];
				_data[_imageName] = new ImageCache(Bitmap(new _class).bitmapData);
			}
			return;
		}
		
		internal function addImageLoadedListener(callBackFunction:Function, priority:int = 0) : void
		{
			_eventDispatcher.addEventListener(Consts.EVENT_IMAGE_LOAD, callBackFunction, false, priority, true);
		}
		
		internal function removeImageLoadedListener(callBackFunction:Function) : void
		{
			_eventDispatcher.removeEventListener(Consts.EVENT_IMAGE_LOAD, callBackFunction);
		}
	}
}