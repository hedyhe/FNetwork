package com.myflexhero.network.core
{
	import flash.display.*;
	import flash.geom.*;
	
	public interface IImageAsset
	{
		
		public function IImageAsset();
		
		function get displayObject() : DisplayObject;
		
		function get smoothing() : Boolean;
		
		function get bounds() : Rectangle;
		
		function get width() : Number;
		
		function get height() : Number;
		
		function get bitmapData() : BitmapData;
		
		function get componentClass() : Class;
		
		function get args() : Array;
		
//		function getBitmapData(color:Object = null, xScale:Number = 1, yScale:Number = 1) : BitmapData;
		
	}
}