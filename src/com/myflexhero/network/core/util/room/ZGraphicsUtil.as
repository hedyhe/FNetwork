package com.myflexhero.network.core.util.room
{
	import flash.display.Graphics;
	import flash.geom.Point;

	public class ZGraphicsUtil
	{
		public static function drawPath(g:Graphics, a:Array, close:Boolean):void
		{
			if (close)
			{
				a.push(a[0]);

			}
			var size:int=a.length;
			for (var i:int=0; i < size; i++)
			{
				var p:Point=a[i];
				if (i == 0)
				{
					g.moveTo(p.x, p.y);
				}
				else
				{
					g.lineTo(p.x, p.y);
				}
			}
		}

		public static function fillPath(g:Graphics, a:Array, color:uint):void
		{
			g.beginFill(color, 0.8);
			var size:int=a.length;
			for (var i:int=0; i < size; i++)
			{
				var p:Point=a[i];
				if (i == 0)
				{
					g.moveTo(p.x, p.y);
				}
				else
				{
					g.lineTo(p.x, p.y);
				}
			}
			g.endFill();
		}
	}
}