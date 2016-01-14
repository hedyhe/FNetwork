package com.myflexhero.network.event
{
	import com.myflexhero.network.Consts;
	import com.myflexhero.network.core.IImageAsset;
	
	import flash.events.*;
	/**
	 * 图形加载事件类
	 * @author Hedy<br>
	 * 如发现Bug请报告至email: 550561954@qq.com 
	 */
	public class ImageLoadEvent extends Event
	{
		public var name:String;
		public var imageAsset:IImageAsset;
		
		public function ImageLoadEvent(name:String, imageAsset:IImageAsset)
		{
			super(Consts.EVENT_IMAGE_LOAD, false, false);
			this.name = name;
			this.imageAsset = imageAsset;
			return;
		}
		
	}
}
