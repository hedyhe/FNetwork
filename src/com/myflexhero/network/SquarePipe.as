package com.myflexhero.network
{
	import com.myflexhero.network.Consts;
	import com.myflexhero.network.Styles;
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.core.ui.SquarePipeUI;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 矩形管道。通过cellCount属性设置内部显示多少多少行、每一行显示多少列(请参阅cellCounts属性)，通过isHorizontal属性设置内部排列方式(请参阅isHorizontal属性)。
	 * 
	 * <br><br>数据元素的继承结构如下所示:
	 * <pre>
	 * Data(数据基类)
	 * 	|Element(元素基类)
	 *		|Node(节点类)
	 * 			|Follower(具有跟随功能的类)
	 *				|SubNetwork(具有显示多层次子类关系的类)
	 *				|AbstractPipe(具有内部显示不同形状的抽象类)
	 *					|RoundPipe(圆管,内部可显示父子关系的圆孔)
	 *					|<b>SquarePipe</b>(矩形管道,内部可显示不同大小的矩形)
	 *				|Group(内部作为一个整体，具有统一的边界外观)
	 *				|Grid(网格，可设置任意行、列)
	 *					|KPICard(可表示KPI的网格)
	 *		|Link(链接类，表示节点之类的关系)
	 * </pre>
	 * @see com.myflexhero.network.SquarePipe#cellCounts
	 * @see com.myflexhero.network.SquarePipe#isHorizontal
	 * @see com.myflexhero.network.AbstractPipe
	 * @author Hedy
	 */
	public class SquarePipe extends AbstractPipe
	{
		private var _cellCounts:Array = null;
		private var _isHorizontal:Boolean = true;
		
		public function SquarePipe(id:Object=null)
		{
			super(id);
			this.icon = "SquarePipe";
			this.setStyle(Styles.VECTOR_SHAPE, Consts.SHAPE_RECTANGLE);
			this.setStyle(Styles.VECTOR_GRADIENT, Consts.GRADIENT_LINEAR_NORTHWEST);
		}
		
		public override function serializeXML(serializer:XMLSerializer, newInstance:IData):void{
			super.serializeXML(serializer, newInstance);
			this.serializeProperty(serializer, "cellCounts", newInstance);
			this.serializeProperty(serializer, "isHorizontal", newInstance);
		}
		
		public override function get elementUIClass():Class
		{
			return SquarePipeUI;
		}
		
		public function get cellCounts():Array
		{
			return this._cellCounts;
		}
		
		/**
		 * 设置每一行将显示的矩形数量。
		 * <p>如传入cellCounts=<b>[ 3, 4, 5]</b>，
		 * 则该矩形管道将内部划分为同样大小的3等份(默认isHorizontal属性为true，即从左至右排列，如果为false，则将从上至下排列)，
		 * 第一行显示3个子矩形，第二行将显示4个子矩形，第三行显示5个子矩形。每一行都将撑满所属等份区域。</p>
		 */
		public function set cellCounts(cellCounts:Array):void
		{
			var oldValue:Array = this._cellCounts;
			this._cellCounts = cellCounts;
			this.dispatchPropertyChangeEvent("cellCounts", oldValue, cellCounts);
		}
		
		public function get isHorizontal():Boolean
		{
			return this._isHorizontal;
		}
		
		/**
		 * 设置内部矩形排列方式。
		 * <p>
		 * 设当前管道被划分为3等份，则：<br>
		 * 如果设置isHorizontal为true，则3等份内部将从左至右排列，且这3等份自身将按照从上至下排列。<br>
		 * 如果设置isHorizontal为false，则3等份内部将从上至下排列，且这3等份自身将按照从左至右排列。
		 * </p>
		 */
		public function set isHorizontal(isHorizontal:Boolean):void
		{
			var oldValue:Boolean = this._isHorizontal;
			this._isHorizontal = isHorizontal;
			this.dispatchPropertyChangeEvent("isHorizontal", oldValue, isHorizontal);
		}
		
		public function getAllCellCount():int
		{
			if (this.cellCounts == null || this.cellCounts.length == 0)
			{
				return 0;
			}
			var count:int = 0;
			for (var i:int = 0; i < this.cellCounts.length; i++)
			{
				count += this.cellCounts[i];
			}
			return count;
		}
		
		public function getRowIndexByPoint(point:Point):int
		{
			var count:int = this.getAllCellCount();
			for (var i:int = 0; i < count; i++)
			{
				var rect:Rectangle = this.getPipeHoleBoundsByHoleIndex(i);
				if (rect != null && rect.containsPoint(point))
				{
					return this.getRowIndexByCellIndex(i);
				}
			}
			return -1;
		}
		
		public function getRowIndexByCellIndex(cellIndex:int):int
		{
			if (cellIndex < 0 || cellIndex >= this.getAllCellCount())
			{
				return -1;
			}
			var count:int = 0;
			for (var i:int = 0; i < this.cellCounts.length; i++)
			{
				var rowCount:int = this.cellCounts[i];
				count += rowCount;
				if (count >= cellIndex + 1)
				{
					if (this.isHorizontal)
					{
						return i;
					}
					else
					{
						return rowCount - (count - cellIndex);
					}
				}
			}
			return -1;
		}
		
		public function getColumnIndexByPoint(point:Point):int
		{
			var count:int = this.getAllCellCount();
			for (var i:int = 0; i < count; i++)
			{
				var rect:Rectangle = this.getPipeHoleBoundsByHoleIndex(i);
				if (rect != null && rect.containsPoint(point))
				{
					return this.getColumnIndexByCellIndex(i);
				}
			}
			return -1;
		}
		
		public function getColumnIndexByCellIndex(cellIndex:int):int
		{
			if (cellIndex < 0 || cellIndex >= this.getAllCellCount())
			{
				return -1;
			}
			var count:int = 0;
			for (var i:int = 0; i < this.cellCounts.length; i++)
			{
				var columnCount:int = this.cellCounts[i];
				count += columnCount;
				if (count >= cellIndex + 1)
				{
					if (this.isHorizontal)
					{
						return columnCount - (count - cellIndex);
					}
					else
					{
						return i;
					}
				}
			}
			return -1;
		}
		
		public override function getPipeHoleBoundsByHoleIndex(holeIndex:int):Rectangle
		{
			if (holeIndex < 0 || holeIndex >= this.getAllCellCount())
			{
				return null;
			}
			var row:int = this.getRowIndexByCellIndex(holeIndex);
			var column:int = this.getColumnIndexByCellIndex(holeIndex);
			if (row < 0 || column < 0)
			{
				return null;
			}
			
			var location:Point = this.location;
			var borderWidth:Number = this.getStyle(Styles.VECTOR_OUTLINE_WIDTH);
			if (borderWidth < 0)
			{
				borderWidth = 0;
			}
			var x:Number = location.x + borderWidth;
			var y:Number = location.y + borderWidth;
			var w:Number = this.width - borderWidth * 2;
			var h:Number = this.height - borderWidth * 2;
			
			var rect:Rectangle = new Rectangle();
			if (this.isHorizontal)
			{
				var rowCount:int = this.cellCounts[row];
				rect.width = w / rowCount;
				rect.height = h / this.cellCounts.length;
				rect.x = x + column * w / rowCount;
				rect.y = y + row * h / this.cellCounts.length;
			}
			else
			{
				var columnCount:int = this.cellCounts[column];
				rect.width = w / this.cellCounts.length;
				rect.height = h / columnCount;
				rect.x = x + column * w / this.cellCounts.length;
				rect.y = y + row * h / columnCount;
			}
			return rect;
		}
		
//		public override function serializeXML(serializer:XMLSerializer, newInstance:IData):void{
//			super.serializeXML(serializer, newInstance);
//			this.serializeProperty(serializer, "cellCounts", newInstance);
//			this.serializeProperty(serializer, "isHorizontal", newInstance);
//		}
	}
}