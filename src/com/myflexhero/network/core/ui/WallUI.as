package com.myflexhero.network.core.ui
{
	import com.myflexhero.network.Network;
	import com.myflexhero.network.Wall;
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.core.util.room.ZGraphicsUtil;
	
	import flash.display.Graphics;


	public class WallUI extends NodeUI
	{
		public function WallUI(network:Network, data:IData)
		{
			super(network, data);
		}

		override protected function drawContent():void
		{
			graphics.clear();
			super.refreshAttachmentVisible();
			var wall:Wall=this.element as Wall;
			if (wall)
			{
				var a:Array = wall.borderArray;
				ZGraphicsUtil.fillPath(graphics, wall.borderArray, wall.color);
				graphics.lineStyle(2, 0xcccccc, 0.6);
				ZGraphicsUtil.drawPath(graphics, wall.borderArray, true);
			}
		}
	}
}