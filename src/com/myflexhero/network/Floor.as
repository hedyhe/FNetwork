package com.myflexhero.network
{
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.core.ui.FloorUI;
	import com.myflexhero.network.core.util.room.ShapeUtil;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;


	public class Floor extends Node
	{
		private var _row:int=1;
		private var _col:int=1;
		private var pointMap:Dictionary;
		private var _borderPoints:Array;
		private var validateFlag:Boolean=true;

		private var eqCollection:Vector.<IData>=new Vector.<IData>();

		public function addEquipment(eq:Equipment):void
		{
			eqCollection.push(eq);
		}

		public function removeEquipment(eq:Equipment):void
		{
			var eqIndex:int = eqCollection.indexOf(eq);
			if(eqIndex!=-1)
				eqCollection.splice(eqIndex,1);
		}

		public function getInUseList():Dictionary
		{
			var col:Dictionary=new Dictionary();
			eqCollection.forEach(function(eq:Equipment,index:int, array:Vector.<IData>):void
				{
					var rSpan:int=eq.rowSpan;
					var cSpan:int=eq.colSpan;
					for (var i:int=0; i < cSpan; i++)
					{
//						col.addItem(eq.rowIndex + ":" + (eq.colIndex + i));
						if((eq.colIndex+i)<_col)
							col[eq.rowIndex + ":" + (eq.colIndex + i)]=eq;
					}
					for (i=0; i < rSpan; i++)
					{
//						col.addItem((eq.rowIndex - i) + ":" + eq.colIndex);
						if((eq.rowIndex+i)<_row)
							col[(eq.rowIndex + i) + ":" + eq.colIndex]=eq;
					}
				});
			return col;
		}


		public function Floor(id:Object=null)
		{
			super(id);
			this.width=500;
			this.height=400;
		}

		public function get col():int
		{
			return _col;
		}

		public function set col(value:int):void
		{
			var old:int=this.col;
			_col=value;
			if (this.dispatchPropertyChangeEvent("col", old, col))
			{
				validateFlag=true;
			}
		}

		public function get row():int
		{
			return _row;
		}

		public function set row(value:int):void
		{
			var old:int=this.row;
			_row=value;
			if (this.dispatchPropertyChangeEvent("row", old, row))
			{
				validateFlag=true;
			}
		}

		override public function get elementUIClass():Class
		{
			return FloorUI;
		}

		private function calculatePoint():void
		{
			if (validateFlag)
			{
				_borderPoints=ShapeUtil.createParallelogram(this.x, this.y, this._width, this._height, 0.3, 0.3);
				var s:int=_borderPoints.length;
				if (col > 1 || row > 1)
				{
					pointMap=ShapeUtil.splitParallelogram(_borderPoints, row, col);
				}
				validateFlag=false;

				var children:Vector.<IData>=this.children;
				children.forEach(function(c:Element,index:int, array:Vector.<IData>):void
					{
						var wall:Wall=c as Wall;
						if (wall)
						{
							wall.invalidateFlag();
						}
					});
			}
		}

		/**
		 * 监听属性更改，如果发生改变，则设置validateFlag为true，供calculatePoint方法判断。
		 */
		override public function dispatchPropertyChangeEvent(property:String, oldValue:Object, newValue:Object):Boolean
		{
			var result:Boolean=super.dispatchPropertyChangeEvent(property, oldValue, newValue);
			if (result)
			{
				if ("location" == property || "width" == property || "height" == property||"x" == property || "y"==property||"addChild"==property)
				{
					validateFlag=true;
				}
			}
			return result;
		}

		public function get borderPoints():Array
		{
			calculatePoint();
			return _borderPoints;
		}

		public function getPointArray(r:int, c:int):Array
		{
			calculatePoint();
			return pointMap[r + ":" + c];
		}

		public function getBounds(r:int, c:int):Rectangle
		{
			var a:Array=getPointArray(r, c);
			var l:int=a.length;
			var minx:Number=0;
			var miny:Number=0;
			var maxx:Number=0;
			var maxy:Number=0;
			//计算四边形的四个顶点
			for (var i:int=0; i < l; i++)
			{
				var p:Point=a[i];
				if (i == 0)
				{
					minx=p.x;
					miny=p.y;
					maxx=p.x;
					maxy=p.y;
				}
				else
				{
					if (minx > p.x)
					{
						minx=p.x;
					}
					if (miny > p.y)
					{
						miny=p.y;
					}
					if (maxx < p.x)
					{
						maxx=p.x;
					}
					if (maxy < p.y)
					{
						maxy=p.y;
					}
				}
			}
			return new Rectangle(minx, miny, maxx - minx, maxy - miny);
		}

		public function getFillColor(r:int, c:int):uint
		{
			if (r % 2 == 0)
			{
				if (c % 2 == 0)
				{
					return 0x000000;
				}
				else
				{
					return 0xFFFFFF;
				}
			}
			else
			{
				if (c % 2 == 0)
				{
					return 0xFFFFFF;
				}
				else
				{
					return 0x000000;
				}
			}
		}


	}
}