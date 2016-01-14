package com.myflexhero.network.core.util
{
	import com.myflexhero.network.Consts;
	
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.utils.*;
	
	import spark.filters.DisplacementMapFilter;
	/**
	 * Graphic工具类
	 */
	final public class GraphicDrawHelper extends Object
	{
		
		public function GraphicDrawHelper()
		{
			return;
		}
	
		public static function getBounds(attachmentSprite:DisplayObject, parent:DisplayObject) : Rectangle
		{
			var _filter:* = undefined;
			var _rectangle:* = attachmentSprite.getBounds(parent);
			if (_rectangle == null)
			{
				return null;
			}
			var _filters:* = attachmentSprite.filters;
			if (_filters != null)
			{
				if (_rectangle.width > 0)
				{
				}
				if (_rectangle.height > 0)
				{
					for each (_filter in _filters)
					{
						
						if (_filter.hasOwnProperty("blurX"))
						{
							_filter.hasOwnProperty("blurX");
						}
						if (_filter.hasOwnProperty("blurY"))
						{
							_rectangle.inflate(_filter.blurX * 1.5, _filter.blurY * 1.5);
						}
					}
				}
			}
			return _rectangle;
		}
		public static function createBitmapData(bitmapData:BitmapData, color:Number) : BitmapData
		{
			var _loc_7:int = 0;
			var _bitmapData:BitmapData = bitmapData.clone();
			var _loc_4:* = _bitmapData.width;
			var _loc_5:* = _bitmapData.height;
			var _loc_6:int = 0;
			while (_loc_6 < _loc_4)
			{
				
				_loc_7 = 0;
				while (_loc_7 < _loc_5)
				{
					
					_bitmapData.setPixel(_loc_6, _loc_7, dyeRGB(_bitmapData.getPixel(_loc_6, _loc_7), color));
					_loc_7 = _loc_7 + 1;
				}
				_loc_6 = _loc_6 + 1;
			}
			return _bitmapData;
		}
		
		public static function dyeRGB(color:uint, dye:uint) : uint
		{
			var _loc_3:* = color >> 16 & 255;
			var _loc_4:* = color >> 8 & 255;
			var _loc_5:* = color & 255;
			color = _loc_3 * 77 + _loc_4 * 151 + _loc_5 * 28 >> 8;
			color = color << 16 | color << 8 | color;
			return color & dye;
		}
		
		/**
		 * 鱼眼方法
		 * scaleX 用于缩放映射计算的 x 置换结果的乘数。
		 * scaleY 用于缩放映射计算的 y 置换结果的乘数。
		 */
		public static function createMapFilter(scaleX:int, scaleY:int, fisheye:Boolean, point:Point = null) : DisplacementMapFilter
		{
			var _loc_9:int = 0;
			var _loc_10:Number = NaN;
			var _loc_11:Number = NaN;
			var _loc_12:Number = NaN;
			var _loc_13:int = 0;
			var _loc_14:int = 0;
			var _loc_15:uint = 0;
			var _loc_16:Number = NaN;
			var _loc_5:* = 2 * scaleX;
			var _loc_6:* = 2 * scaleY;
			var _loc_7:* = new BitmapData(_loc_5, _loc_6, false, 8421504);
			var _loc_8:int = 0;
			while (_loc_8 < _loc_5)
			{
				
				_loc_9 = 0;
				while (_loc_9 < _loc_6)
				{
					
					_loc_10 = (_loc_8 - scaleX) / scaleX;
					_loc_11 = (_loc_9 - scaleY) / scaleY;
					_loc_12 = Math.sqrt(_loc_10 * _loc_10 + _loc_11 * _loc_11);
					if (_loc_12 < 1)
					{
						_loc_13 = 255 * (1 - _loc_8 / _loc_5);
						_loc_14 = 255 * (1 - _loc_9 / _loc_6);
						if (fisheye)
						{
							_loc_16 = 128 - Math.sqrt(1 - _loc_12 * _loc_12) * 128;
							_loc_13 = _loc_13 + _loc_16 - _loc_13 * _loc_16 / 128;
							_loc_14 = _loc_14 + _loc_16 - _loc_14 * _loc_16 / 128;
						}
						_loc_15 = _loc_13 << 16 | _loc_14 << 8 | 0;
						_loc_7.setPixel(_loc_8, _loc_9, _loc_15);
					}
					_loc_9 = _loc_9 + 1;
				}
				_loc_8 = _loc_8 + 1;
			}
			if (point == null)
			{
				point = new Point(0, 0);
			}
			return new DisplacementMapFilter(_loc_7, point, BitmapDataChannel.RED, BitmapDataChannel.GREEN, scaleX, scaleY);
		}
		
		public static function beginFill(g:Graphics, fillColor:Number, fillAlpha:Number = 1, x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0, gradient:String = null, gradientColor:Number = 0, gradientAlpha:Number = 1) : void
		{
			if (gradient == Consts.GRADIENT_NONE||gradient == null)
			{
					g.beginFill(fillColor, fillAlpha);
					return;
			}
			var _loc_11:Number = 0;
			var _loc_12:String = null;
			var _loc_13:Array = [gradientColor, fillColor];
			var _loc_14:Array = [gradientAlpha, fillAlpha];
			var _loc_15:Array = [0, 255];
			var _loc_16:Matrix = new Matrix();
			var _loc_17:String = SpreadMethod.PAD;
			if (gradient == Consts.GRADIENT_LINEAR_SOUTHWEST)
			{
				_loc_12 = GradientType.LINEAR;
				_loc_16.createGradientBox(width, height, (-Math.PI) / 4, x, y);
			}
			else if (gradient == Consts.GRADIENT_LINEAR_SOUTHEAST)
			{
				_loc_12 = GradientType.LINEAR;
				_loc_16.createGradientBox(width, height, -3 * Math.PI / 4, x, y);
			}
			else if (gradient == Consts.GRADIENT_LINEAR_NORTHWEST)
			{
				_loc_12 = GradientType.LINEAR;
				_loc_16.createGradientBox(width, height, Math.PI / 4, x, y);
			}
			else if (gradient == Consts.GRADIENT_LINEAR_NORTHEAST)
			{
				_loc_12 = GradientType.LINEAR;
				_loc_16.createGradientBox(width, height, 3 * Math.PI / 4, x, y);
			}
			else if (gradient == Consts.GRADIENT_LINEAR_NORTH)
			{
				_loc_12 = GradientType.LINEAR;
				_loc_16.createGradientBox(width, height, Math.PI / 2, x, y);
			}
			else if (gradient == Consts.GRADIENT_LINEAR_SOUTH)
			{
				_loc_12 = GradientType.LINEAR;
				_loc_16.createGradientBox(width, height, (-Math.PI) / 2, x, y);
			}
			else if (gradient == Consts.GRADIENT_LINEAR_WEST)
			{
				_loc_12 = GradientType.LINEAR;
				_loc_16.createGradientBox(width, height, 0, x, y);
			}
			else if (gradient == Consts.GRADIENT_LINEAR_EAST)
			{
				_loc_12 = GradientType.LINEAR;
				_loc_16.createGradientBox(width, height, Math.PI, x, y);
			}
			else if (gradient == Consts.GRADIENT_RADIAL_CENTER)
			{
				_loc_12 = GradientType.RADIAL;
				_loc_16.createGradientBox(width, height, 0, x, y);
			}
			else if (gradient == Consts.GRADIENT_RADIAL_SOUTHWEST)
			{
				_loc_12 = GradientType.RADIAL;
				_loc_11 = 0.75;
				_loc_16.createGradientBox(width, height, 3 * Math.PI / 4, x, y);
			}
			else if (gradient == Consts.GRADIENT_RADIAL_SOUTHEAST)
			{
				_loc_12 = GradientType.RADIAL;
				_loc_11 = 0.75;
				_loc_16.createGradientBox(width, height, Math.PI / 4, x, y);
			}
			else if (gradient == Consts.GRADIENT_RADIAL_NORTHWEST)
			{
				_loc_12 = GradientType.RADIAL;
				_loc_11 = 0.75;
				_loc_16.createGradientBox(width, height, -3 * Math.PI / 4, x, y);
			}
			else if (gradient == Consts.GRADIENT_RADIAL_NORTHEAST)
			{
				_loc_12 = GradientType.RADIAL;
				_loc_11 = 0.75;
				_loc_16.createGradientBox(width, height, (-Math.PI) / 4, x, y);
			}
			else if (gradient == Consts.GRADIENT_RADIAL_NORTH)
			{
				_loc_12 = GradientType.RADIAL;
				_loc_11 = 0.75;
				_loc_16.createGradientBox(width, height, (-Math.PI) / 2, x, y);
			}
			else if (gradient == Consts.GRADIENT_RADIAL_SOUTH)
			{
				_loc_12 = GradientType.RADIAL;
				_loc_11 = 0.75;
				_loc_16.createGradientBox(width, height, Math.PI / 2, x, y);
			}
			else if (gradient == Consts.GRADIENT_RADIAL_WEST)
			{
				_loc_12 = GradientType.RADIAL;
				_loc_11 = 0.75;
				_loc_16.createGradientBox(width, height, Math.PI, x, y);
			}
			else if (gradient == Consts.GRADIENT_RADIAL_EAST)
			{
				_loc_12 = GradientType.RADIAL;
				_loc_11 = 0.75;
				_loc_16.createGradientBox(width, height, 0, x, y);
			}
			else if (gradient == Consts.GRADIENT_SPREAD_HORIZONTAL)
			{
				_loc_12 = GradientType.LINEAR;
				_loc_16.createGradientBox(width, height, 0, x, y);
				_loc_13 = [fillColor, gradientColor, fillColor];
				_loc_14 = [fillAlpha, gradientAlpha, fillAlpha];
				_loc_15 = [0, 127, 255];
			}
			else if (gradient == Consts.GRADIENT_SPREAD_VERTICAL)
			{
				_loc_12 = GradientType.LINEAR;
				_loc_16.createGradientBox(width, height, Math.PI / 2, x, y);
				_loc_13 = [fillColor, gradientColor, fillColor];
				_loc_14 = [fillAlpha, gradientAlpha, fillAlpha];
				_loc_15 = [0, 127, 255];
			}
			else if (gradient == Consts.GRADIENT_SPREAD_DIAGONAL)
			{
				_loc_12 = GradientType.LINEAR;
				_loc_16.createGradientBox(width, height, -Math.atan(width / height), x, y);
				_loc_13 = [fillColor, gradientColor, fillColor];
				_loc_14 = [fillAlpha, gradientAlpha, fillAlpha];
				_loc_15 = [0, 127, 255];
			}
			else if (gradient == Consts.GRADIENT_SPREAD_ANTIDIAGONAL)
			{
				_loc_12 = GradientType.LINEAR;
				_loc_16.createGradientBox(width, height, Math.atan(width / height), x, y);
				_loc_13 = [fillColor, gradientColor, fillColor];
				_loc_14 = [fillAlpha, gradientAlpha, fillAlpha];
				_loc_15 = [0, 127, 255];
			}
			else if (gradient == Consts.GRADIENT_SPREAD_NORTH)
			{
				_loc_12 = GradientType.LINEAR;
				_loc_16.createGradientBox(width, height / 2, Math.PI / 2, x, y + height / 4);
				_loc_17 = SpreadMethod.REFLECT;
			}
			else if (gradient == Consts.GRADIENT_SPREAD_SOUTH)
			{
				_loc_12 = GradientType.LINEAR;
				_loc_16.createGradientBox(width, height / 2, Math.PI / 2, x, y + 3 * height / 4);
				_loc_17 = SpreadMethod.REFLECT;
			}
			else if (gradient == Consts.GRADIENT_SPREAD_WEST)
			{
				_loc_12 = GradientType.LINEAR;
				_loc_16.createGradientBox(width / 2, height, 0, x + width / 4, y);
				_loc_17 = SpreadMethod.REFLECT;
			}
			else if (gradient == Consts.GRADIENT_SPREAD_EAST)
			{
				_loc_12 = GradientType.LINEAR;
				_loc_16.createGradientBox(width / 2, height, 0, x + 3 * width / 4, y);
				_loc_17 = SpreadMethod.REFLECT;
			}
			g.beginGradientFill(_loc_12, _loc_13, _loc_14, _loc_15, _loc_16, _loc_17, InterpolationMethod.RGB, _loc_11);
		}
		
		public static function brighter(color:Number, brite:Number = 50) : Number
		{
			return ColorUtil.adjustBrightness2(color, brite);
		}
		
		public static function darker(color:Number, brite:Number = 50) : Number
		{
			return ColorUtil.adjustBrightness2(color, -brite);
		}
		
		public static function draw3DRect(g:Graphics, color:Number, lineColor:Number, x:Number, y:Number, width:Number, height:Number, alpha:Number = 1) : void
		{
			var brighterColor:uint = 0;
			var darkerColor:uint = 0;
			var _loc_12:Number = NaN;
			var _loc_13:Number = NaN;
			var _loc_14:Number = NaN;
			if (lineColor == 0)
			{
				return;
			}
			var _loc_9:* = lineColor > 0;
			lineColor = Math.abs(lineColor);
			if (lineColor == 1)
			{
				brighterColor = brighter(color);
				darkerColor = darker(color);
				g.lineStyle(1, _loc_9 ? (brighterColor) : (darkerColor), alpha, false, Consts.SCALE_MODE_NONE, Consts.CAPS_STYLE_NONE);
				g.moveTo(x, y);
				g.lineTo(x, y + height);
				g.moveTo(x, y);
				g.lineTo(x + width, y);
				g.lineStyle(1, _loc_9 ? (darkerColor) : (brighterColor), alpha, false, Consts.SCALE_MODE_NONE, Consts.CAPS_STYLE_NONE);
				g.moveTo(x, y + height);
				g.lineTo(x + width, y + height);
				g.moveTo(x + width, y);
				g.lineTo(x + width, y + height);
			}
			else
			{
				_loc_12 = lineColor * 2;
				_loc_13 = 50 / _loc_12;
				_loc_14 = 0;
				while (_loc_14 < lineColor * 2)
				{
					
					brighterColor = brighter(color, 50 - _loc_14 * _loc_13);
					darkerColor = darker(color, 50 - _loc_14 * _loc_13);
					x = x + 0.5;
					y = y + 0.5;
					width = width - 1;
					height = height - 1;
					g.lineStyle(1, _loc_9 ? (brighterColor) : (darkerColor), alpha, true, Consts.SCALE_MODE_NORMAL, Consts.CAPS_STYLE_SQUARE);
					g.moveTo(x, y);
					g.lineTo(x, y + height);
					g.moveTo(x, y);
					g.lineTo(x + width, y);
					g.lineStyle(1, _loc_9 ? (darkerColor) : (brighterColor), alpha, true, Consts.SCALE_MODE_NORMAL, Consts.CAPS_STYLE_SQUARE);
					g.moveTo(x, y + height);
					g.lineTo(x + width, y + height);
					g.moveTo(x + width, y);
					g.lineTo(x + width, y + height);
					_loc_14 = _loc_14 + 1;
				}
			}
			g.moveTo(0, 0);
		}
		
		
		public static function drawShape(g:Graphics, shape:String, x:Number, y:Number, width:Number, height:Number, vectorRoundRectRadius:Number = -1, outLinePattern:Array = null) : void
		{
			var _loc_13:Vector.<Point> = null;
			var _loc_14:Object = null;
			var _loc_15:Number = NaN;
			var _loc_16:Number = NaN;
			var _loc_17:Number = NaN;
			var _loc_18:Number = NaN;
			var _loc_19:Number = NaN;
			var _loc_20:Number = NaN;
			var _loc_21:Number = NaN;
			var _loc_22:Number = NaN;
			var _loc_23:Number = NaN;
			var _loc_24:Number = NaN;
			var _loc_25:Number = NaN;
			var _loc_26:Number = NaN;
			
			var _loc_9:*;
			if (outLinePattern != null)
			{
				_loc_9 = outLinePattern.length > 0;
			}
			var _loc_10:Vector.<Point> = null;
			var _loc_11:Vector.<String> = null;
			var _loc_12:int = 0;
			if (shape == Consts.SHAPE_RECTANGLE)
			{
				if (_loc_9)
				{
					_loc_10 = new Vector.<Point>();
					_loc_10.push(new Point(x, y));
					_loc_10.push(new Point(x + width, y));
					_loc_10.push(new Point(x + width, y + height));
					_loc_10.push(new Point(x, y + height));
					_loc_10.push(new Point(x, y));
				}
				else
				{
					g.drawRect(x, y, width, height);
				}
			}
			else if (shape == Consts.SHAPE_OVAL)
			{
				if (_loc_9)
				{
					_loc_13 = new Vector.<Point>();
					drawArc(null, x + width / 2, y + height / 2, 0, Math.PI * 2, width / 2, height / 2, false, _loc_13);
					_loc_11 = new Vector.<String>();
					_loc_11.push(Consts.SEGMENT_MOVETO);
					_loc_12 = 1;
					while (_loc_12 < _loc_13.length)
					{
						
						_loc_11.push(Consts.SEGMENT_QUADTO);
						_loc_12 = _loc_12 + 1;
					}
					_loc_10 = new Vector.<Point>();
					_loc_12 = 0;
					while (_loc_12 < _loc_13.length)
					{
						
						_loc_14 = _loc_13[_loc_12];
						if (_loc_14 is Point)
						{
							_loc_10.push(_loc_14);
						}
						else if (_loc_14 is Array)
						{
							_loc_10.push(_loc_14[0]);
							_loc_10.push(_loc_14[1]);
						}
						_loc_12 = _loc_12 + 1;
					}
				}
				else
				{
					g.drawEllipse(x, y, width, height);
				}
			}
			else if (shape == Consts.SHAPE_ROUNDRECT)
			{
				_loc_15 = vectorRoundRectRadius < 0 ? (Math.min(width, height) / 4) : (vectorRoundRectRadius);
				if (_loc_9)
				{
					_loc_10 = new Vector.<Point>();
					_loc_16 = x + width;
					_loc_17 = y + height;
					_loc_18 = width < height ? (width * 2) : (height * 2);
					_loc_15 = _loc_15 < _loc_18 ? (_loc_15) : (_loc_18);
					_loc_19 = _loc_15 * 0.292893;
					_loc_20 = _loc_15 * 0.585786;
					_loc_10.push(new Point(_loc_16, _loc_17 - _loc_15));
					_loc_10.push(new Point(_loc_16, _loc_17 - _loc_20));
					_loc_10.push(new Point(_loc_16 - _loc_19, _loc_17 - _loc_19));
					_loc_10.push(new Point(_loc_16 - _loc_20, _loc_17));
					_loc_10.push(new Point(_loc_16 - _loc_15, _loc_17));
					_loc_10.push(new Point(x + _loc_15, _loc_17));
					_loc_10.push(new Point(x + _loc_20, _loc_17));
					_loc_10.push(new Point(x + _loc_19, _loc_17 - _loc_19));
					_loc_10.push(new Point(x, _loc_17 - _loc_20));
					_loc_10.push(new Point(x, _loc_17 - _loc_15));
					_loc_10.push(new Point(x, y + _loc_15));
					_loc_10.push(new Point(x, y + _loc_20));
					_loc_10.push(new Point(x + _loc_19, y + _loc_19));
					_loc_10.push(new Point(x + _loc_20, y));
					_loc_10.push(new Point(x + _loc_15, y));
					_loc_10.push(new Point(_loc_16 - _loc_15, y));
					_loc_10.push(new Point(_loc_16 - _loc_20, y));
					_loc_10.push(new Point(_loc_16 - _loc_19, y + _loc_19));
					_loc_10.push(new Point(_loc_16, y + _loc_20));
					_loc_10.push(new Point(_loc_16, y + _loc_15));
					_loc_10.push(new Point(_loc_16, _loc_17 - _loc_15));
					_loc_11 = new Vector.<String>();
					_loc_12 = 0;
					while (_loc_12 < 4)
					{
						
						if (_loc_12 == 0)
						{
							_loc_11.push(Consts.SEGMENT_MOVETO);
						}
						else
						{
							_loc_11.push(Consts.SEGMENT_LINETO);
						}
						_loc_11.push(Consts.SEGMENT_QUADTO);
						_loc_11.push(Consts.SEGMENT_QUADTO);
						if (_loc_12 == 3)
						{
							_loc_11.push(Consts.SEGMENT_LINETO);
						}
						_loc_12 = _loc_12 + 1;
					}
				}
				else
				{
					GraphicsUtil.drawRoundRectComplex(g, x, y, width, height, _loc_15, _loc_15, _loc_15, _loc_15);
				}
			}
			else if (shape == Consts.SHAPE_STAR)
			{
				_loc_21 = width * 2;
				_loc_22 = height * 2;
				_loc_23 = x + width / 2;
				_loc_24 = y + height / 2;
				_loc_10 = new Vector.<Point>();
				_loc_10.push(new Point(_loc_23 - _loc_21 / 4, _loc_24 - _loc_22 / 12));
				_loc_10.push(new Point(x + width * 0.306, y + height * 0.579));
				_loc_10.push(new Point(_loc_23 - _loc_21 / 6, _loc_24 + _loc_22 / 4));
				_loc_10.push(new Point(x + width / 2, y + height * 0.733));
				_loc_10.push(new Point(_loc_23 + _loc_21 / 6, _loc_24 + _loc_22 / 4));
				_loc_10.push(new Point(x + width * 0.693, y + height * 0.579));
				_loc_10.push(new Point(_loc_23 + _loc_21 / 4, _loc_24 - _loc_22 / 12));
				_loc_10.push(new Point(x + width * 0.611, y + height * 0.332));
				_loc_10.push(new Point(_loc_23 + 0, _loc_24 - _loc_22 / 4));
				_loc_10.push(new Point(x + width * 0.388, y + height * 0.332));
				_loc_10.push(new Point(_loc_23 - _loc_21 / 4, _loc_24 - _loc_22 / 12));
				_loc_11 = new Vector.<String>();
				_loc_11.push(Consts.SEGMENT_MOVETO);
				_loc_12 = 0;
				while (_loc_12 < 10)
				{
					
					_loc_11.push(Consts.SEGMENT_LINETO);
					_loc_12 = _loc_12 + 1;
				}
			}
			else if (shape == Consts.SHAPE_TRIANGLE)
			{
				_loc_10 = new Vector.<Point>();
				_loc_10.push(new Point(x + width / 2, y));
				_loc_10.push(new Point(x + width, y + height));
				_loc_10.push(new Point(x, y + height));
				_loc_10.push(new Point(x + width / 2, y));
			}
			else if (shape == Consts.SHAPE_CIRCLE)
			{
				_loc_15 = Math.min(width, height) / 2;
				if (_loc_9)
				{
					_loc_10 = new Vector.<Point>();
					x = x + width / 2;
					y = y + height / 2;
					_loc_25 = _loc_15 * Math.tan(Math.PI / 8);
					_loc_26 = _loc_15 * Math.sin(Math.PI / 4);
					_loc_10.push(new Point(x + _loc_15, y));
					_loc_10.push(new Point(x + _loc_15, y + _loc_25));
					_loc_10.push(new Point(x + _loc_26, y + _loc_26));
					_loc_10.push(new Point(x + _loc_25, y + _loc_15));
					_loc_10.push(new Point(x, y + _loc_15));
					_loc_10.push(new Point(x - _loc_25, y + _loc_15));
					_loc_10.push(new Point(x - _loc_26, y + _loc_26));
					_loc_10.push(new Point(x - _loc_15, y + _loc_25));
					_loc_10.push(new Point(x - _loc_15, y));
					_loc_10.push(new Point(x - _loc_15, y - _loc_25));
					_loc_10.push(new Point(x - _loc_26, y - _loc_26));
					_loc_10.push(new Point(x - _loc_25, y - _loc_15));
					_loc_10.push(new Point(x, y - _loc_15));
					_loc_10.push(new Point(x + _loc_25, y - _loc_15));
					_loc_10.push(new Point(x + _loc_26, y - _loc_26));
					_loc_10.push(new Point(x + _loc_15, y - _loc_25));
					_loc_10.push(new Point(x + _loc_15, y));
					_loc_11 = new Vector.<String>();
					_loc_11.push(Consts.SEGMENT_MOVETO);
					_loc_12 = 0;
					while (_loc_12 < 8)
					{
						
						_loc_11.push(Consts.SEGMENT_QUADTO);
						_loc_12 = _loc_12 + 1;
					}
				}
				else
				{
					g.drawCircle(x + width / 2, y + height / 2, _loc_15);
				}
			}
			else if (shape == Consts.SHAPE_HEXAGON)
			{
				_loc_10 = new Vector.<Point>();
				_loc_10.push(new Point(x, y + height / 2));
				_loc_10.push(new Point(x + width / 4, y + height));
				_loc_10.push(new Point(x + width * 3 / 4, y + height));
				_loc_10.push(new Point(x + width, y + height / 2));
				_loc_10.push(new Point(x + width * 3 / 4, y));
				_loc_10.push(new Point(x + width / 4, y));
				_loc_10.push(new Point(x, y + height / 2));
			}
			else if (shape == Consts.SHAPE_PENTAGON)
			{
				_loc_21 = width * 2;
				_loc_22 = height * 2;
				_loc_23 = x + width / 2;
				_loc_24 = y + height / 2;
				_loc_10 = new Vector.<Point>();
				_loc_10.push(new Point(_loc_23 - _loc_21 / 4, _loc_24 - _loc_22 / 12));
				_loc_10.push(new Point(_loc_23 - _loc_21 / 6, _loc_24 + _loc_22 / 4));
				_loc_10.push(new Point(_loc_23 + _loc_21 / 6, _loc_24 + _loc_22 / 4));
				_loc_10.push(new Point(_loc_23 + _loc_21 / 4, _loc_24 - _loc_22 / 12));
				_loc_10.push(new Point(_loc_23 + 0, _loc_24 - _loc_22 / 4));
				_loc_10.push(new Point(_loc_23 - _loc_21 / 4, _loc_24 - _loc_22 / 12));
			}
			else if (shape == Consts.SHAPE_DIAMOND)
			{
				_loc_10 = new Vector.<Point>();
				_loc_10.push(new Point(x + width / 2, y));
				_loc_10.push(new Point(x, y + height / 2));
				_loc_10.push(new Point(x + width / 2, y + height));
				_loc_10.push(new Point(x + width, y + height / 2));
				_loc_10.push(new Point(x + width / 2, y));
			}
			else
			{
				throw new Error("Can not resolve \'" + shape + "\' shape");
			}
			if (_loc_10 != null)
			{
				if (_loc_9)
				{
					drawDashedPolyLine(g, outLinePattern, _loc_10, _loc_11);
				}
				else
				{
					drawPolyLine(g, _loc_10, _loc_11);
				}
			}
			g.moveTo(0, 0);
			return;
		}
		
		
		
		public static function drawDashedPolyLine(g:Graphics, outLinePattern:Array, points:Vector.<Point>, segments:Vector.<String>  = null, xInstance:Number = 0, K463K:Number = 0, K966K:Boolean = false) : void
		{
			var _loc_10:Point = null;
			var _loc_11:int = 0;
			var _loc_12:int = 0;
			var _loc_13:int = 0;
			var _loc_14:int = 0;
			var _loc_15:GraphicsDrawUtils = null;
			var _loc_16:String = null;
			var _loc_17:Point = null;
			var _loc_18:Point = null;
			if (points.length < 2)
			{
				return;
			}
			if (K966K)
			{
				points = new Vector.<Point>(points);
				points.push(points[0]);
				if (segments != null)
				{
					segments = new Vector.<String>(segments);
					segments.push(Consts.SEGMENT_LINETO);
				}
			}
			var _loc_8:* = points[0];
			var _loc_9:* = new GraphicsDrawDummy();
			if (segments == null)
			{
				g.moveTo(_loc_8.x + xInstance, _loc_8.y + K463K);
				_loc_11 = 1;
				while (_loc_11 < points.length)
				{
					
					_loc_10 = points[_loc_11];
					K956K(g, outLinePattern, _loc_9, _loc_8.x + xInstance, _loc_8.y + K463K, _loc_10.x + xInstance, _loc_10.y + K463K);
					_loc_8 = _loc_10;
					_loc_11 = _loc_11 + 1;
				}
			}
			else
			{
				_loc_8 = new Point();
				_loc_12 = 0;
				_loc_13 = points.length;
				_loc_14 = segments.length;
				_loc_15 = new GraphicsDrawUtils(g, outLinePattern[0], outLinePattern.length > 1 ? (outLinePattern[1]) : (outLinePattern[0]));
				_loc_11 = 0;
				while (_loc_11 < _loc_14)
				{
					
					_loc_16 = segments[_loc_11];
					if (_loc_16 == Consts.SEGMENT_LINETO)
					{
						if (_loc_12 >= _loc_13)
						{
							g.moveTo(0, 0);
							return;
						}
						_loc_10 = points[_loc_12++];
						_loc_15.lineTo(_loc_10.x, _loc_10.y);
						_loc_8 = _loc_10;
					}
					else if (_loc_16 == Consts.SEGMENT_QUADTO)
					{
						if (_loc_12 >= (_loc_13 - 1))
						{
							g.moveTo(0, 0);
							return;
						}
						_loc_17 = points[_loc_12++];
						_loc_18 = points[_loc_12++];
						_loc_15.curveTo(_loc_17.x, _loc_17.y, _loc_18.x, _loc_18.y);
						_loc_8 = _loc_18;
					}
					else if (_loc_16 == Consts.SEGMENT_MOVETO)
					{
						if (_loc_12 >= _loc_13)
						{
							g.moveTo(0, 0);
							return;
						}
						_loc_10 = points[_loc_12++];
						_loc_15.moveTo(_loc_10.x + xInstance, _loc_10.y + K463K);
						_loc_8 = _loc_10;
					}
					else
					{
						throw new Error("Can not resolve \'" + _loc_16 + "\' segment");
					}
					_loc_11 = _loc_11 + 1;
				}
			}
			g.moveTo(0, 0);
			return;
		}
		
		private static function K956K(g:Graphics, K947K:Array, graphicsDrawDummy:GraphicsDrawDummy, K958K:Number, K959K:Number, K923K:Number, K924K:Number) : void
		{
			var _loc_8:* = K923K - K958K;
			var _loc_9:* = K924K - K959K;
			var _loc_10:* = Math.sqrt(_loc_8 * _loc_8 + _loc_9 * _loc_9);
			if (_loc_10 == 0)
			{
				return;
			}
			_loc_8 = _loc_8 / _loc_10;
			_loc_9 = _loc_9 / _loc_10;
			var _loc_11:* = _loc_10;
			var _loc_12:* = -graphicsDrawDummy.numVal;
			var _loc_13:* = graphicsDrawDummy.booleanVal;
			var _loc_14:* = graphicsDrawDummy.intVal;
			while (_loc_12 < _loc_11)
			{
				
				_loc_12 = _loc_12 + K947K[_loc_14];
				if (_loc_12 >= _loc_11)
				{
					graphicsDrawDummy.numVal = K947K[_loc_14] - (_loc_12 - _loc_11);
					graphicsDrawDummy.intVal = _loc_14;
					graphicsDrawDummy.booleanVal = _loc_13;
					_loc_12 = _loc_11;
				}
				if (_loc_13)
				{
					g.lineTo(K958K + _loc_12 * _loc_8, K959K + _loc_12 * _loc_9);
				}
				else
				{
					g.moveTo(K958K + _loc_12 * _loc_8, K959K + _loc_12 * _loc_9);
				}
				_loc_13 = !_loc_13;
				_loc_14 = (_loc_14 + 1) % K947K.length;
			}
			return;
		}
		
		public static function drawPolyLine(g:Graphics, points:Vector.<Point>, segments:Vector.<String> = null, xInstance:Number = 0, yInstance:Number = 0, createNew:Boolean = false) : void
		{
			var _loc_7:int = 0;
			var _loc_8:int = 0;
			var _loc_9:Point = null;
			var _loc_10:int = 0;
			var _loc_11:int = 0;
			var _loc_12:String = null;
			var _loc_13:Point = null;
			var _loc_14:Point = null;
			if (points != null)
			{
				if (points.length < 2)
				{
					return;
				}
			}
			if (createNew)
			{
				points = new Vector.<Point>(points);
				points.push(points[0]);
				if (segments != null)
				{
					segments = new Vector.<String>(segments);
					segments.push(Consts.SEGMENT_LINETO);
				}
			}
			if (segments != null)
			{
				if (segments.length == 0)
				{
					_loc_9 = points[0];
					g.moveTo(_loc_9.x + xInstance, _loc_9.y + yInstance);
					_loc_8 = points.length;
					_loc_7 = 1;
					while (_loc_7 < _loc_8)
					{
						
						_loc_9 = points[_loc_7];
						g.lineTo(_loc_9.x + xInstance, _loc_9.y + yInstance);
						_loc_7 = _loc_7 + 1;
					}
				}
				else
				{
					_loc_10 = 0;
					_loc_11 = points.length;
					_loc_8 = segments.length;
					_loc_7 = 0;
					while (_loc_7 < _loc_8)
					{
						
						_loc_12 = segments[_loc_7];
						if (_loc_12 == Consts.SEGMENT_LINETO)
						{
							if (_loc_10 >= _loc_11)
							{
								g.moveTo(0, 0);
								return;
							}
							_loc_9 = points[_loc_10++];
							g.lineTo(_loc_9.x + xInstance, _loc_9.y + yInstance);
						}
						else if (_loc_12 == Consts.SEGMENT_QUADTO)
						{
							if (_loc_10 >= (_loc_11 - 1))
							{
								g.moveTo(0, 0);
								return;
							}
							_loc_13 = points[_loc_10++];
							_loc_14 = points[_loc_10++];
							g.curveTo(_loc_13.x + xInstance, _loc_13.y + yInstance, _loc_14.x + xInstance, _loc_14.y + yInstance);
						}
						else if (_loc_12 == Consts.SEGMENT_MOVETO)
						{
							if (_loc_10 >= _loc_11)
							{
								g.moveTo(0, 0);
								return;
							}
							_loc_9 = points[_loc_10++];
							g.moveTo(_loc_9.x + xInstance, _loc_9.y + yInstance);
						}
						else
						{
							throw new Error("Can not resolve \'" + _loc_12 + "\' segment");
						}
						_loc_7 = _loc_7 + 1;
					}
				}
			}
			g.moveTo(0, 0);
			return;
		}
		
		
		public static function drawArc(g:Graphics, x:Number, y:Number, K930K:Number, arc:Number, xRadius:Number, yRadius:Number = NaN, K934K:Boolean = false, points:Vector.<Point> = null) : void
		{
			var _loc_10:Number = NaN;
			var _loc_11:Number = NaN;
			var _loc_12:Number = NaN;
			var _loc_13:Number = NaN;
			var _loc_14:Number = NaN;
			var _loc_15:Number = NaN;
			var _loc_16:Number = NaN;
			var _loc_17:Number = NaN;
			var _loc_18:Number = NaN;
			var _loc_19:Number = NaN;
			var _loc_20:Number = NaN;
			var _loc_21:uint = 0;
			if (isNaN(yRadius))
			{
				yRadius = xRadius;
			}
			if (Math.abs(arc) > 2 * Math.PI)
			{
				arc = 2 * Math.PI;
			}
			_loc_14 = Math.ceil(Math.abs(arc) / (Math.PI / 4));
			_loc_10 = arc / _loc_14;
			_loc_11 = -_loc_10;
			_loc_12 = -K930K;
			if (_loc_14 > 0)
			{
				_loc_15 = x + Math.cos(K930K) * xRadius;
				_loc_16 = y + Math.sin(-K930K) * yRadius;
				if (points != null)
				{
					points.push(new Point(_loc_15, _loc_16));
				}
				if (K934K == true)
				{
					if (g != null)
					{
						g.lineTo(_loc_15, _loc_16);
					}
				}
				else if (g != null)
				{
					g.moveTo(_loc_15, _loc_16);
				}
				_loc_21 = 0;
				while (_loc_21 < _loc_14)
				{
					
					_loc_12 = _loc_12 + _loc_11;
					_loc_13 = _loc_12 - _loc_11 / 2;
					_loc_17 = x + Math.cos(_loc_12) * xRadius;
					_loc_18 = y + Math.sin(_loc_12) * yRadius;
					_loc_19 = x + Math.cos(_loc_13) * (xRadius / Math.cos(_loc_11 / 2));
					_loc_20 = y + Math.sin(_loc_13) * (yRadius / Math.cos(_loc_11 / 2));
					if (g != null)
					{
						g.curveTo(_loc_19, _loc_20, _loc_17, _loc_18);
					}
					if (points != null)
					{
						points.push([new Point(_loc_19, _loc_20), new Point(_loc_17, _loc_18)]);
					}
					_loc_21 = _loc_21 + 1;
				}
				if (g != null)
				{
					g.moveTo(0, 0);
				}
			}
			return;
		}
	}
	
}
