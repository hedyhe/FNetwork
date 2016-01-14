package  com.myflexhero.network.core.util
{
	import com.myflexhero.network.Consts;
	import com.myflexhero.network.Follower;
	import com.myflexhero.network.Group;
	import com.myflexhero.network.Node;
	import com.myflexhero.network.Size;
	import com.myflexhero.network.Styles;
	import com.myflexhero.network.core.IData;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class ElementUtil
	{
		public function ElementUtil()
		{
		}
		public static function getRoundRect(childrenBodyRects:Vector.<Rectangle>) : Rectangle
		{
			var _loc_2:* = getUnionRect(childrenBodyRects);
			if (_loc_2 == null)
			{
				return null;
			}
			var _loc_3:* = Math.min(_loc_2.width, _loc_2.height) / 16;
			_loc_2.inflate(_loc_3, _loc_3);
			return _loc_2;
		}// end function
		
		public static function getUnionRect(childrenBodyRects:Vector.<Rectangle>) : Rectangle
		{
			if (childrenBodyRects != null)
			{
				if (childrenBodyRects.length == 0)
				{
					return null;
				}
				var _loc_2:* = Rectangle(childrenBodyRects[0]).clone();
				var _loc_3:int = 1;
				while (_loc_3 < childrenBodyRects.length)
				{
					
					_loc_2 = _loc_2.union(childrenBodyRects[_loc_3]);
					_loc_3 = _loc_3 + 1;
				}
			}
			return _loc_2;
		}
		
		public static function getOval(childrenBodyRects:Vector.<Rectangle>) : Rectangle
		{
			var _loc_11:Point = null;
			var _loc_12:Number = NaN;
			var _loc_13:Number = NaN;
			var _loc_14:Number = NaN;
			var _loc_2:* = getUnionRect(childrenBodyRects);
			if (_loc_2 == null)
			{
				return null;
			}
			if (_loc_2.width != 0)
			{
			}
			if (_loc_2.height == 0)
			{
				return _loc_2;
			}
			var _loc_3:Number = 0;
			var _loc_4:* = _loc_2.height / _loc_2.width;
			var _loc_5:* = _loc_4 * _loc_4;
			var _loc_6:* = _loc_2.x + _loc_2.width / 2;
			var _loc_7:* = _loc_2.y + _loc_2.height / 2;
			var _loc_8:Vector.<Point> = getPoints(childrenBodyRects);
			var _loc_9:int = 0;
			while (_loc_9 < _loc_8.length)
			{
				
				_loc_11 = _loc_8[_loc_9];
				_loc_12 = _loc_11.x - _loc_6;
				_loc_13 = _loc_11.y - _loc_7;
				_loc_14 = _loc_12 * _loc_12 + _loc_13 * _loc_13 / _loc_5;
				if (_loc_14 > _loc_3)
				{
					_loc_3 = _loc_14;
				}
				_loc_9 = _loc_9 + 1;
			}
			_loc_3 = Math.sqrt(_loc_3);
			var _loc_10:* = _loc_4 * _loc_3;
			return new Rectangle(_loc_6 - _loc_3, _loc_7 - _loc_10, _loc_3 * 2, _loc_10 * 2);
		}
		
		public static function getPoints(childrenBodyRects:Vector.<Rectangle>) : Vector.<Point>
		{
			var _loc_4:Rectangle = null;
			if (childrenBodyRects != null)
			{
				if (childrenBodyRects.length == 0)
				{
					return null;
				}
				var _loc_2:* = new Vector.<Point>();
				var _loc_3:int = 0;
				while (_loc_3 < childrenBodyRects.length)
				{
					
					_loc_4 = childrenBodyRects[_loc_3];
					_loc_2.push(new Point(_loc_4.x, _loc_4.y));
					_loc_2.push(new Point(_loc_4.x + _loc_4.width, _loc_4.y + _loc_4.height));
					_loc_2.push(new Point(_loc_4.x + _loc_4.width, _loc_4.y));
					_loc_2.push(new Point(_loc_4.x, _loc_4.y + _loc_4.height));
					_loc_3 = _loc_3 + 1;
				}
			}
			return _loc_2;
		}
		
		public static function getCircle(childrenBodyRects:Vector.<Rectangle>) : Rectangle
		{
			var _loc_8:Point = null;
			var _loc_9:Number = NaN;
			var _loc_10:Number = NaN;
			var _loc_11:Number = NaN;
			var _loc_2:* = getUnionRect(childrenBodyRects);
			if (_loc_2 == null)
			{
				return null;
			}
			var _loc_3:Number = 0;
			var _loc_4:* = _loc_2.x + _loc_2.width / 2;
			var _loc_5:* = _loc_2.y + _loc_2.height / 2;
			var _loc_6:Vector.<Point> = getPoints(childrenBodyRects);
			var _loc_7:int = 0;
			while (_loc_7 < _loc_6.length)
			{
				
				_loc_8 = _loc_6[_loc_7];
				_loc_9 = _loc_8.x - _loc_4;
				_loc_10 = _loc_8.y - _loc_5;
				_loc_11 = _loc_9 * _loc_9 + _loc_10 * _loc_10;
				if (_loc_11 > _loc_3)
				{
					_loc_3 = _loc_11;
				}
				_loc_7 = _loc_7 + 1;
			}
			_loc_3 = Math.sqrt(_loc_3);
			return new Rectangle(_loc_4 - _loc_3, _loc_5 - _loc_3, _loc_3 * 2, _loc_3 * 2);
		}
		
		public static function addPadding(rect:Rectangle, element:Object, K157K:String) : void
		{
			var _loc_4:* = element.getStyle(K157K);
			if (_loc_4 != 0)
			{
				rect.inflate(-_loc_4, -_loc_4);
			}
			_loc_4 = element.getStyle(K157K + ".left");
			if (_loc_4 != 0)
			{
				rect.x = rect.x + _loc_4;
				rect.width = rect.width - _loc_4;
			}
			_loc_4 = element.getStyle(K157K + ".right");
			if (_loc_4 != 0)
			{
				rect.width = rect.width - _loc_4;
			}
			_loc_4 = element.getStyle(K157K + ".top");
			if (_loc_4 != 0)
			{
				rect.y = rect.y + _loc_4;
				rect.height = rect.height - _loc_4;
			}
			_loc_4 = element.getStyle(K157K + ".bottom");
			if (_loc_4 != 0)
			{
				rect.height = rect.height - _loc_4;
			}
			if (rect.width < 0)
			{
				rect.width = -rect.width;
				rect.x = rect.x - rect.width;
			}
			if (rect.height < 0)
			{
				rect.height = -rect.height;
				rect.y = rect.y - rect.height;
			}
			return;
		}
		
		public static function moveElements(elements:Vector.<IData>, K369K:Number, K370K:Number, callFunction:Function = null) : void
		{
			var _loc_7:Node = null;
			var _loc_5:Vector.<IData> = filterMovingElements(elements);
			var _loc_6:int = 0;
			while (_loc_6 < _loc_5.length)
			{
				
				_loc_7 = _loc_5[_loc_6] as Node;
				_loc_7.translate(K369K, K370K);
				_loc_6 = _loc_6 + 1;
			}
			return;
		}
		
		public static function filterMovingElements(elements:Vector.<IData>, callFunction:Function = null) : Vector.<IData>
		{
			var _loc_5:IData = null;
			var _loc_6:Boolean = false;
			var _loc_7:Vector.<IData> = null;
			var _loc_8:int = 0;
			var _loc_9:IData = null;
			var _loc_3:Vector.<IData> = new Vector.<IData>();
			var _loc_4:int = 0;
			while (_loc_4 < elements.length)
			{
				_loc_5 = elements[_loc_4];
				if (!(_loc_5 is Node))
				{
				}
				else
				{
					if (callFunction != null)
					{
						if (!callFunction.call(_loc_5))
						{
						}
					}
					else
					{
						_loc_6 = true;
						_loc_7 = _loc_3.slice();
						_loc_8 = 0;
						while (_loc_8 < _loc_7.length)
						{
							
							_loc_9 = _loc_7[_loc_8];
							if (_loc_6)
							{
								if (_loc_9 is Follower)
								{
								
									if (_loc_5 is Follower)
									{
									
										if (Follower(_loc_5).isLoopedHostOn(Follower(_loc_9)))
										{
											_loc_6 = false;
										}
									}
								}
							}
							else
							{
								if (_loc_9 is Follower)
								{
									if (Follower(_loc_9).isHostOn(Node(_loc_5)))
									{
										_loc_3.splice(_loc_3.indexOf(_loc_9),1);;
									}
								}
								else
								{
									if (_loc_6)
									{
									
										if (_loc_5 is Follower)
										{
										
											if (_loc_9 is Node)
											{
											
												if (Follower(_loc_5).isHostOn(Node(_loc_9)))
												{
													_loc_6 = false;
												}
												else if (isDescendantOfGroup(_loc_9, _loc_5))
												{
													_loc_3.splice(_loc_3.indexOf(_loc_9),1);
												}
												else
												{
													if (_loc_6)
													{
														if (isDescendantOfGroup(_loc_5, _loc_9))
														{
															_loc_6 = false;
														}
													}
												}
											}
										}
									}
								}
							}
							_loc_8 = _loc_8 + 1;
						}
						if (_loc_6)
						{
							_loc_3.push(_loc_5);
						}
					}
				}
				_loc_4 = _loc_4 + 1;
			}
			return _loc_3;
		}
		
		public static function isDescendantOfGroup(element:IData, group:IData) : Boolean
		{
			if (element != null)
			{
				if (!(group is Group))
				{
					return false;
				}
				if (group.numChildren<=0)
				{
					return false;
				}
				element = element.parent;
				while (element is Group)
				{
					
					if (element == group)
					{
						return true;
					}
					element = element.parent;
				}
			}
			return false;
		}
		
		public static function hasDefault(node:Node) : Boolean
		{
			var _loc_2:* = node.getStyle(Styles.CONTENT_TYPE);
			if (_loc_2 != Consts.CONTENT_TYPE_DEFAULT)
			{
			}
			if (_loc_2 != Consts.CONTENT_TYPE_DEFAULT_VECTOR)
			{
			}
			return _loc_2 == Consts.CONTENT_TYPE_VECTOR_DEFAULT;
		}
		
		public static function getPosition(position:String, rectangle:Rectangle, size:Size = null) : Point
		{
			if (rectangle == null)
			{
				throw new Error("refRect can not be null");
			}
			if (size == null)
			{
				size = Consts.EMPTY_SIZE;
			}
			if (position == Consts.POSITION_TOPLEFT_TOPLEFT)
			{
				return new Point(rectangle.x - size.width, rectangle.y - size.height);
			}
			if (position == Consts.POSITION_TOPLEFT_TOPRIGHT)
			{
				return new Point(rectangle.x, rectangle.y - size.height);
			}
			if (position == Consts.POSITION_TOP_TOP)
			{
				return new Point(rectangle.x + rectangle.width / 2 - size.width / 2, rectangle.y - size.height);
			}
			if (position == Consts.POSITION_TOPRIGHT_TOPLEFT)
			{
				return new Point(rectangle.x + rectangle.width - size.width, rectangle.y - size.height);
			}
			if (position == Consts.POSITION_TOPRIGHT_TOPRIGHT)
			{
				return new Point(rectangle.x + rectangle.width, rectangle.y - size.height);
			}
			if (position == Consts.POSITION_TOPLEFT)
			{
				return new Point(rectangle.x - size.width / 2, rectangle.y - size.height / 2);
			}
			if (position == Consts.POSITION_TOP)
			{
				return new Point(rectangle.x - size.width / 2 + rectangle.width / 2, rectangle.y - size.height / 2);
			}
			if (position == Consts.POSITION_TOPRIGHT)
			{
				return new Point(rectangle.x - size.width / 2 + rectangle.width, rectangle.y - size.height / 2);
			}
			if (position == Consts.POSITION_TOPLEFT_BOTTOMLEFT)
			{
				return new Point(rectangle.x - size.width, rectangle.y);
			}
			if (position == Consts.POSITION_TOPLEFT_BOTTOMRIGHT)
			{
				return new Point(rectangle.x, rectangle.y);
			}
			if (position == Consts.POSITION_TOP_BOTTOM)
			{
				return new Point(rectangle.x + rectangle.width / 2 - size.width / 2, rectangle.y);
			}
			if (position == Consts.POSITION_TOPRIGHT_BOTTOMLEFT)
			{
				return new Point(rectangle.x - size.width + rectangle.width, rectangle.y);
			}
			if (position == Consts.POSITION_TOPRIGHT_BOTTOMRIGHT)
			{
				return new Point(rectangle.x + rectangle.width, rectangle.y);
			}
			if (position == Consts.POSITION_LEFT_LEFT)
			{
				return new Point(rectangle.x - size.width, rectangle.y + rectangle.height / 2 - size.height / 2);
			}
			if (position == Consts.POSITION_LEFT)
			{
				return new Point(rectangle.x - size.width / 2, rectangle.y + rectangle.height / 2 - size.height / 2);
			}
			if (position == Consts.POSITION_LEFT_RIGHT)
			{
				return new Point(rectangle.x, rectangle.y + rectangle.height / 2 - size.height / 2);
			}
			if (position == Consts.POSITION_CENTER)
			{
				return new Point(rectangle.x + rectangle.width / 2 - size.width / 2, rectangle.y + rectangle.height / 2 - size.height / 2);
			}
			if (position == Consts.POSITION_RIGHT_LEFT)
			{
				return new Point(rectangle.x + rectangle.width - size.width, rectangle.y + rectangle.height / 2 - size.height / 2);
			}
			if (position == Consts.POSITION_RIGHT)
			{
				return new Point(rectangle.x + rectangle.width - size.width / 2, rectangle.y + rectangle.height / 2 - size.height / 2);
			}
			if (position == Consts.POSITION_RIGHT_RIGHT)
			{
				return new Point(rectangle.x + rectangle.width, rectangle.y + rectangle.height / 2 - size.height / 2);
			}
			if (position == Consts.POSITION_BOTTOMLEFT_TOPLEFT)
			{
				return new Point(rectangle.x - size.width, rectangle.y + rectangle.height - size.height);
			}
			if (position == Consts.POSITION_BOTTOMLEFT_TOPRIGHT)
			{
				return new Point(rectangle.x, rectangle.y + rectangle.height - size.height);
			}
			if (position == Consts.POSITION_BOTTOM_TOP)
			{
				return new Point(rectangle.x + rectangle.width / 2 - size.width / 2, rectangle.y + rectangle.height - size.height);
			}
			if (position == Consts.POSITION_BOTTOMRIGHT_TOPLEFT)
			{
				return new Point(rectangle.x + rectangle.width - size.width, rectangle.y + rectangle.height - size.height);
			}
			if (position == Consts.POSITION_BOTTOMRIGHT_TOPRIGHT)
			{
				return new Point(rectangle.x + rectangle.width, rectangle.y + rectangle.height - size.height);
			}
			if (position == Consts.POSITION_BOTTOMLEFT)
			{
				return new Point(rectangle.x - size.width / 2, rectangle.y + rectangle.height - size.height / 2);
			}
			if (position == Consts.POSITION_BOTTOM)
			{
				return new Point(rectangle.x + rectangle.width / 2 - size.width / 2, rectangle.y + rectangle.height - size.height / 2);
			}
			if (position == Consts.POSITION_BOTTOMRIGHT)
			{
				return new Point(rectangle.x + rectangle.width - size.width / 2, rectangle.y + rectangle.height - size.height / 2);
			}
			if (position == Consts.POSITION_BOTTOMLEFT_BOTTOMLEFT)
			{
				return new Point(rectangle.x - size.width, rectangle.y + rectangle.height);
			}
			if (position == Consts.POSITION_BOTTOMLEFT_BOTTOMRIGHT)
			{
				return new Point(rectangle.x, rectangle.y + rectangle.height);
			}
			if (position == Consts.POSITION_BOTTOM_BOTTOM)
			{
				return new Point(rectangle.x + rectangle.width / 2 - size.width / 2, rectangle.y + rectangle.height);
			}
			if (position == Consts.POSITION_BOTTOMRIGHT_BOTTOMLEFT)
			{
				return new Point(rectangle.x + rectangle.width - size.width, rectangle.y + rectangle.height);
			}
			if (position == Consts.POSITION_BOTTOMRIGHT_BOTTOMRIGHT)
			{
				return new Point(rectangle.x + rectangle.width, rectangle.y + rectangle.height);
			}
			throw new Error("Can not resolve \'" + position + "\' position");
		}
		
		public static function getRectangle(x1:Number, y1:Number, x2:Number, y2:Number) : Rectangle
		{
			var _x1:* = x1 < x2 ? (x1) : (x2);
			var _y1:* = y1 < y2 ? (y1) : (y2);
			var _x2:* = Math.abs(x1 - x2);
			var _y2:* = Math.abs(y1 - y2);
			return new Rectangle(_x1, _y1, _x2, _y2);
		}
		
		public static function isIntersect(displayObject:DisplayObject, K974K:DisplayObject, K877K:Number = 1) : Boolean
		{
			var _loc_4:Rectangle = getIntersectionRectangle(displayObject, K974K, K877K);
			if (_loc_4 != null)
			{
				if (_loc_4.width != 0)
				{
					return true;
				}
				return _loc_4.height != 0;
			}
			return false;
		}
		
		private static function getIntersectionRectangle(elementUI:DisplayObject, mask:DisplayObject, K877K:Number = 1) : Rectangle
		{
			if (!elementUI.hitTestObject(mask))
			{
				return null;
			}
			var _loc_4:* = elementUI.getBounds(elementUI.root);
			if (_loc_4 == null)
			{
				return null;
			}
			var _loc_5:* = mask.getBounds(mask.root);
			if (_loc_5 == null)
			{
				return null;
			}
			var _loc_6:* = new Rectangle();
			_loc_6.x = Math.max(_loc_4.x, _loc_5.x);
			_loc_6.y = Math.max(_loc_4.y, _loc_5.y);
			_loc_6.width = Math.min(_loc_4.x + _loc_4.width - _loc_6.x, _loc_5.x + _loc_5.width - _loc_6.x);
			_loc_6.height = Math.min(_loc_4.y + _loc_4.height - _loc_6.y, _loc_5.y + _loc_5.height - _loc_6.y);
			if (_loc_6.width * K877K >= 1)
			{
				if (_loc_6.height * K877K < 1)
				{
					return null;
				}
			}
			var _loc_7:* = new BitmapData(_loc_6.width * K877K, _loc_6.height * K877K, false, 0);
			_loc_7.draw(elementUI, K980K(elementUI, _loc_6, K877K), new ColorTransform(1, 1, 1, 1, 255, -255, -255, 255));
			_loc_7.draw(mask, K980K(mask, _loc_6, K877K), new ColorTransform(1, 1, 1, 1, 255, 255, 255, 255), BlendMode.DIFFERENCE);
			var _loc_8:* = _loc_7.getColorBoundsRect(4294967295, 4278255615);
			_loc_7.dispose();
			if (_loc_8 == null)
			{
				return null;
			}
			if (K877K != 1)
			{
				_loc_8.x = _loc_8.x / K877K;
				_loc_8.y = _loc_8.y / K877K;
				_loc_8.width = _loc_8.width / K877K;
				_loc_8.height = _loc_8.height / K877K;
			}
			_loc_8.x = _loc_8.x + _loc_6.x;
			_loc_8.y = _loc_8.y + _loc_6.y;
			return _loc_8;
		}
		
		private static function K980K(target:DisplayObject, K981K:Rectangle, K877K:Number) : Matrix
		{
			var _loc_4:Point = null;
			var _loc_5:Matrix = null;
			var _loc_6:* = target.root.transform.concatenatedMatrix;
			_loc_4 = target.localToGlobal(new Point());
			_loc_5 = target.transform.concatenatedMatrix;
			_loc_5.tx = _loc_4.x - K981K.x;
			_loc_5.ty = _loc_4.y - K981K.y;
			_loc_5.a = _loc_5.a / _loc_6.a;
			_loc_5.d = _loc_5.d / _loc_6.d;
			if (K877K != 1)
			{
				_loc_5.scale(K877K, K877K);
			}
			return _loc_5;
		}
		
		public static function isIntersectionByRect(K975K:Rectangle, mask:DisplayObject, K979K:uint) : Boolean
		{
			var _loc_10:int = 0;
			K975K = new Rectangle(K975K.x - K979K, K975K.y - K979K, K975K.width + 2 * K979K, K975K.height + 2 * K979K);
			if (K975K.width >= 1)
			{
				if (K975K.height < 1)
				{
					return false;
				}
			}
			var _loc_4:* = mask.getBounds(mask.root);
			if (_loc_4 != null)
			{
			
				if (!_loc_4.intersects(K975K))
				{
					return false;
				}
				var _loc_5:* = new Rectangle();
				_loc_5.x = Math.max(K975K.x, _loc_4.x);
				_loc_5.y = Math.max(K975K.y, _loc_4.y);
				_loc_5.width = Math.min(K975K.x + K975K.width - _loc_5.x, _loc_4.x + _loc_4.width - _loc_5.x);
				_loc_5.height = Math.min(K975K.y + K975K.height - _loc_5.y, _loc_4.y + _loc_4.height - _loc_5.y);
				if (_loc_5.width >= 1)
				{
				
					if (_loc_5.height < 1)
					{
						return false;
					}
					var _loc_6:* = new BitmapData(_loc_5.width, _loc_5.height, true, 0);
					_loc_6.draw(mask, K980K(mask, _loc_5, 1));
					var _loc_7:* = _loc_6.width;
					var _loc_8:* = _loc_6.height;
					var _loc_9:int = 0;
					while (_loc_9 < _loc_7)
					{
						
						_loc_10 = 0;
						while (_loc_10 < _loc_8)
						{
							
							if (_loc_6.getPixel32(_loc_9, _loc_10) > 0)
							{
								return true;
							}
							_loc_10 = _loc_10 + 1;
						}
						_loc_9 = _loc_9 + 1;
					}
				}
			}
			return false;
		}
	}
}