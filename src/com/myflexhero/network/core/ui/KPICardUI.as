package com.myflexhero.network.core.ui
{
	import com.myflexhero.network.Consts;
	import com.myflexhero.network.KPICard;
	import com.myflexhero.network.Network;
	import com.myflexhero.network.core.util.GraphicDrawHelper;
	
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	import mx.core.mx_internal;

	use namespace mx_internal;

	public class KPICardUI extends GridUI
	{
		public function KPICardUI(network:Network, card:KPICard)
		{
			super(network, card);
		}		
		
		override protected function drawContent():void{
			var card:KPICard = this.element as KPICard;
			var rect:Rectangle = card.rect;
			graphics.clear();
			graphics.beginFill(0x000000);
			graphics.drawRect(rect.x, rect.y, rect.width, rect.height);			
			graphics.endFill();		
			
			rect.inflate(-4, -4);
			graphics.lineStyle(1, 0xFFFFFF, 1, false, Consts.SCALE_MODE_NONE);
			graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			
			nodeWidth = rect.width;
			nodeHeight =  rect.height;
			element.nodeWidth = rect.width;
			element.nodeHeight =  rect.height;
			
			
			rect.inflate(-1, 0);
			var value:Number = card.getClient("value");
			//说明仍未调用setClient方法
			if(isNaN(value)||value==0)
				return;
			var h:Number = rect.height * value / 100;
			rect.y = rect.y + rect.height - h;
			rect.height = h;
			graphics.lineStyle();
			GraphicDrawHelper.beginFill(graphics, 0xFF9900, 1, rect.x, rect.y, rect.width, rect.height, Consts.GRADIENT_SPREAD_WEST, 0xFFFFFF, 1);
			graphics.drawRect(rect.x, rect.y, rect.width, rect.height);	
			graphics.endFill();
		
		}
		private static var a:int =0;
	}
}