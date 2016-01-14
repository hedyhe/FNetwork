package com.myflexhero.network.core.ui
{
	import com.myflexhero.network.Consts;
	import com.myflexhero.network.Network;
	import com.myflexhero.network.RoundPipe;
	import com.myflexhero.network.core.ui.NodeUI;
	import com.myflexhero.network.core.util.DashedLine;
	import com.myflexhero.network.core.util.GraphicDrawHelper;
	
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	/**
	 * 管道截面UI类，继承自NodeUI。请参阅com.myflexhero.network.RoundPipe类查看其功能。
	 * @see com.myflexhero.network.RoundPipe
	 */
	public class RoundPipeUI extends NodeUI
	{
		public function RoundPipeUI(network:Network, roundPipe:RoundPipe){
			super(network, roundPipe);
		}
		
		protected override function drawContent():void{
			super.drawContent();
			var roundPipe:RoundPipe = RoundPipe(this.element);
			if (roundPipe == null || roundPipe.holeCount <= 0)
			{
				return;
			}
			for (var i:int = 0; i < roundPipe.holeCount; i++)
			{
				var rect:Rectangle = roundPipe.getPipeHoleBoundsByHoleIndex(i);
				if (roundPipe.innerWidth > 0 && rect != null)
				{
					graphics.lineStyle(roundPipe.innerWidth, roundPipe.innerColor, roundPipe.innerAlpha);
					if (roundPipe.innerPattern != null && roundPipe.innerPattern.length == 2)
					{
						var dashedLine:DashedLine = new DashedLine(graphics, roundPipe.innerPattern[0], roundPipe.innerPattern[1]);
						var x:Number = rect.x + rect.width/2;
						var y:Number = rect.y + rect.height/2;
						var r:Number = rect.width > rect.height ? rect.height/2 : rect.width/2;
						var a:Number = r*Math.tan(Math.PI/8);
						var b:Number = r*Math.sin(Math.PI/4);
						dashedLine.moveTo(x+r,y);
						dashedLine.curveTo(x+r,y+a,x+b,y+b);
						dashedLine.curveTo(x+a,y+r,x,y+r);
						dashedLine.curveTo(x-a,y+r,x-b,y+b);
						dashedLine.curveTo(x-r,y+a,x-r,y);
						dashedLine.curveTo(x-r,y-a,x-b,y-b);
						dashedLine.curveTo(x-a,y-r,x,y-r);
						dashedLine.curveTo(x+a,y-r,x+b,y-b);
						dashedLine.curveTo(x+r,y-a,x+r,y);
						graphics.moveTo(0, 0);
					}else{
						GraphicDrawHelper.drawShape(graphics, Consts.SHAPE_CIRCLE, rect.x, rect.y, rect.width, rect.height);
					}
				}else{
					graphics.lineStyle();
				}
			}
		}
	}
}