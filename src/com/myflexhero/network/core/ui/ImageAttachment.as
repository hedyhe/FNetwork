package com.myflexhero.network.core.ui
{
	import com.myflexhero.network.Node;
	import com.myflexhero.network.Utils;
	import com.myflexhero.network.core.IElement;
	import com.myflexhero.network.core.image.ImageLoader;

	public class ImageAttachment extends Attachment
	{
		public var loading:Boolean = false;
		private var imageLoader:ImageLoader;
		public function ImageAttachment(element:IElement,imageLoader:ImageLoader)
		{
			super(element);
			this.imageLoader = imageLoader
		}
		
		override public function updateProperties() : void
		{
			super.updateProperties();
			var _node:* = Node(element);
			
			var _imageAsset:* = Utils.getImageAsset(imageLoader,_node.image,false);
			//通过派发事件再次进入
			if(_imageAsset==null){
				loading = true;
				return;
			}
			
			if(!loading)
				loading = false;
			var _bitmapData:* =  _imageAsset.bitmapData;
			if(content==null||content != _bitmapData){
				content = _bitmapData;
			}
		}
	}
}