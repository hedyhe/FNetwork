package com.myflexhero.network.core.ui
{
	import com.myflexhero.network.Floor;
	import com.myflexhero.network.Network;
	import com.myflexhero.network.Node;
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.core.util.room.ZGraphicsUtil;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	

	public class FloorUI extends NodeUI
	{
		public function FloorUI(network:Network, data:IData)
		{
			super(network, data);
		}


		override protected function drawContent():void
		{
			graphics.clear();
			super.refreshAttachmentVisible();
			var floor:Floor=this.element as Floor;
			if (floor == null)
			{
				return;
			}
			var col:int=floor.col;
			var row:int=floor.row;

			graphics.lineStyle(2, 0xFF0000);
			var n:Node=this.element;
			var arr:Array=floor.borderPoints;
			var s:int=arr.length;

			if (col > 1 || row > 1)
			{
				graphics.lineStyle(2, 0x00FF00);
				for (var r:int=0; r < row; r++)
				{
					for (var c:int=0; c < col; c++)
					{
						var a:Array=floor.getPointArray(r, c);
						ZGraphicsUtil.fillPath(graphics, a, floor.getFillColor(r, c));
					}
				}
			}
			ZGraphicsUtil.drawPath(graphics, arr, true);
		}

	}
}