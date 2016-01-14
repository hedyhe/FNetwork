package com.myflexhero.network.core.ui
{
	import com.myflexhero.network.Follower;
	import com.myflexhero.network.Grid;
	import com.myflexhero.network.Network;
	import com.myflexhero.network.Styles;
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.core.IElement;
	import com.myflexhero.network.core.util.GraphicDrawHelper;
	
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	

	public class GridUI extends NodeUI
	{
		
		public function GridUI(network:Network, grid:IData)
		{
			super(network, grid);
			
		}
		
		override protected function drawDefaultContent():void
		{
			if (element.image != null)
			{
				super.drawDefaultContent();
			}
			else
			{
				this.drawGridContent();
			}
		}
		
		public function get grid() : Grid
		{
			return Grid(element);
		}
		
		protected function drawGridContent() : void
		{
			graphics.clear();
			if(labelAttachment)
				labelAttachment.updateProperties();
			
			/* 调整element的x、y值,需要nodeWidth、nodeHeight属性 */
			if(!boundaryChecked){
				boundaryChecked = true;
				coordinateHandler(0);
			}
			
			/* 需要element最后的x、y值 */
			refreshAttachmentVisible();
			
			var _gridRowCount:Number = NaN;
			var _gridColumnCount:Number = NaN;
			var _gridRowIndex:int = 0;
			var _gridColumnIndex:Number = NaN;
			var _cellRect:Rectangle = null;
			var _bodyRect:* = this.element.vectorRect;;
			var _gridFillColor:* = this.getDyeColor(Styles.GRID_FILL_COLOR);
			graphics.lineStyle();
			var _gridFill:* = grid.getStyle(Styles.GRID_FILL);
			if (_gridFill)
			{
				graphics.beginFill(_gridFillColor, grid.getStyle(Styles.GRID_FILL_ALPHA));
			}
			graphics.drawRect(_bodyRect.x, _bodyRect.y, _bodyRect.width, _bodyRect.height);
			if (_gridFill)
			{
				graphics.endFill();
			}
			var _gridDeep:* = grid.getStyle(Styles.GRID_DEEP);
			GraphicDrawHelper.draw3DRect(graphics, _gridFillColor, _gridDeep, _bodyRect.x, _bodyRect.y, _bodyRect.width, _bodyRect.height);
			_gridDeep = grid.getStyle(Styles.GRID_CELL_DEEP);
			if (_gridDeep != 0)
			{
				_gridRowCount = grid.getStyle(Styles.GRID_ROW_COUNT);
				_gridColumnCount = grid.getStyle(Styles.GRID_COLUMN_COUNT);
				_gridRowIndex = 0;
				while (_gridRowIndex < _gridRowCount)
				{
					_gridColumnIndex = 0;
					while (_gridColumnIndex < _gridColumnCount)
					{
						_cellRect = grid.getCellRect(_gridRowIndex, _gridColumnIndex);
						GraphicDrawHelper.draw3DRect(graphics, _gridFillColor, _gridDeep, _cellRect.x, _cellRect.y, _cellRect.width, _cellRect.height);
						_gridColumnIndex = _gridColumnIndex + 1;
					}
					_gridRowIndex = _gridRowIndex + 1;
				}
			}
			_nodeWidth = _bodyRect.width;
			_nodeHeight =  _bodyRect.height;
			element.nodeWidth = _bodyRect.width;
			element.nodeHeight =  _bodyRect.height;
		}
	}
}