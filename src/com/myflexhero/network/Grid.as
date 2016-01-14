package com.myflexhero.network
{
	import com.myflexhero.network.core.util.ElementUtil;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 该网格可以任意设置行、列数，并设置不同行、列的不同宽度、高度比，以及支持背景色等外观样式。<br>
	 * Grid继承自Follower类，这意味着放置于其上的数据对象(如Node等)都将自动获得跟随行为。
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
	 *					|SquarePipe(矩形管道,内部可显示不同大小的矩形)
	 *				|Group(内部作为一个整体，具有统一的边界外观)
	 *				|<b>Grid</b>(网格，可设置任意行、列)
	 *					|KPICard(可表示KPI的网格)
	 *		|Link(链接类，表示节点之类的关系)
	 * </pre>
	 */
	public class Grid extends Follower
	{
		
		public function Grid(id:Object = null)
		{
			super(id);
			this.icon = Defaults.ICON_GRID;
			this.image = null;
			return;
		}
		
		override public function get rect() : Rectangle
		{
			return new Rectangle(x, y,width,height);
		}

		/**
		 * 返回指定行列块的区域大小。
		 */
		public function getCellRect(rowIndex:Number, columnIndex:Number) : Rectangle
		{
			var _y_loc:Number = NaN;
			var _rowIndex_loc:Number = NaN;
			var _gridRowCount:* = this.getStyle(Styles.GRID_ROW_COUNT);
			var _gridColumnCount:* = this.getStyle(Styles.GRID_COLUMN_COUNT);
			if (_gridRowCount > 0)
			{
				if (_gridColumnCount <= 0)
				{
					return null;
				}
			}
			if (rowIndex >= 0)
			{
				if (rowIndex >= _gridRowCount)
				{
					return null;
				}
			}
			if (columnIndex >= 0)
			{
				if (columnIndex >= _gridColumnCount)
				{
					return null;
				}
			}
			var _rect:* = this.rect;
			ElementUtil.addPadding(_rect, this, Styles.GRID_BORDER);
			var _loc_6:int = 0;
			var _gridRowPercents:* = this.getStyle(Styles.GRID_ROW_PERCENTS);
			var _gridColumnPercents:* = this.getStyle(Styles.GRID_COLUMN_PERCENTS);
			if (_gridRowPercents != null)
			{
				if (_gridRowPercents.length == _gridRowCount)
				{
					_y_loc = 0;
					_loc_6 = 0;
					while (_loc_6 < rowIndex)
					{
						
						_y_loc = _y_loc + _rect.height * _gridRowPercents[_loc_6];
						_loc_6 = _loc_6 + 1;
					}
					_rect.y = _rect.y + _y_loc;
					_rect.height = _rect.height * _gridRowPercents[rowIndex];
				}
			}
				else
				{
					_rect.height = _rect.height / _gridRowCount;
					_rect.y = _rect.y + _rect.height * rowIndex;
				}
			
			if (_gridColumnPercents != null)
			{
				if (_gridColumnPercents.length == _gridColumnCount)
				{
					_rowIndex_loc = 0;
					_loc_6 = 0;
					while (_loc_6 < columnIndex)
					{
						
						_rowIndex_loc = _rowIndex_loc + _rect.width * _gridColumnPercents[_loc_6];
						_loc_6 = _loc_6 + 1;
					}
					_rect.x = _rect.x + _rowIndex_loc;
					_rect.width = _rect.width * _gridColumnPercents[columnIndex];
				}
			}
				else
				{
					_rect.width = _rect.width / _gridColumnCount;
					_rect.x = _rect.x + _rect.width * columnIndex;
				}
			
			ElementUtil.addPadding(_rect, this, Styles.GRID_PADDING);
			return _rect;
		}
		
		/**
		 * 根据传入的point点找出属于当前Grid中的行列块位置，
		 * 并返回Object类型的对象表示，该对象包括以下3个属性:
		 * <ul>
		 * <li><b>rowIndex</b>:所属Grid块的行下标。</li>
		 * <li><b>columnIndex</b>:所属Grid块的列下标。</li>
		 * <li><b>rect</b>:所属Grid块的区域大小)。</li>
		 * </ul>
		 */
		public function getCellObject(point:Point) : Object
		{
			var _columnIndex:int = 0;
			var _cellRect:Rectangle = null;
			var _gridRowCount:* = this.getStyle(Styles.GRID_ROW_COUNT);
			var _gridColumnCount:* = this.getStyle(Styles.GRID_COLUMN_COUNT);
			var _index:int = 0;
			while (_index < _gridRowCount)
			{
				
				_columnIndex = 0;
				while (_columnIndex < _gridColumnCount)
				{
					
					_cellRect = this.getCellRect(_index, _columnIndex);
					if (_cellRect.containsPoint(point))
					{
						return {rowIndex:_index, columnIndex:_columnIndex, rect:_cellRect};
					}
					_columnIndex = _columnIndex + 1;
				}
				_index = _index + 1;
			}
			return null;
		}
		
		override public function setStyle(property:String, newValue:*) : void
		{
			super.setStyle( property,newValue);
//			/* 顶级Grid */
//			if(IS_INTERESTED_HOST_GRID_PROPERTY[property]&&this.host==null&&this._followers){
//				for (var i:int=0;i<this._followers.length;i++){
//					this._followers[i].updateFollower(null);
//					this._followers[i].dispatchPropertyChangeEvent("S:hostChanged",null,null);
//				}
//			}
		}
	}
}