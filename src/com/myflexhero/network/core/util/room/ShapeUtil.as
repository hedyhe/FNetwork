package com.myflexhero.network.core.util.room
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class ShapeUtil
	{

		public function ShapeUtil()
		{
		}

		public static function createParallelogram(x:Number, y:Number, width:Number, height:Number, xp:Number=0.4, yp:Number=0.4):Array
		{
			var xoff:Number=width * xp;
			var yoff:Number=height * yp;
			var p1:Point=new Point(x, y + yoff);
			var p2:Point=new Point(x + width - xoff, y + height);
			var p3:Point=new Point(x + width, y + height - yoff);
			var p4:Point=new Point(x + xoff, y);
			var array:Array=[p1, p2, p3, p4];
			return array;
		}

		public static function splitParallelogram(array:Array, row:int, col:int):Dictionary
		{
			var map:Dictionary=new Dictionary();

			var p1:Point=array[0];
			var p2:Point=array[1];
			var p3:Point=array[2];
			var p4:Point=array[3];
			var p14:Array=splitTwoPoint(p1, p4, col);
			var p23:Array=splitTwoPoint(p2, p3, col);

			var colPoints:Array=new Array();
			for (var i:int=0; i <= col; i++)
			{
				var t:Array=splitTwoPoint(p14[i], p23[i], row);
				colPoints.push(t);
			}
			for (var r:int=0; r < row; r++)
			{
				for (var c:int=0; c < col; c++)
				{
					var a:Array=new Array();
					a.push(colPoints[c][r]);
					a.push(colPoints[c][r + 1]);
					a.push(colPoints[c + 1][r + 1]);
					a.push(colPoints[c + 1][r]);
					map[r + ":" + c]=a;
				}
			}
			return map;
		}

		public static function splitTwoPoint(f:Point, t:Point, count:int):Array
		{
			var w:Number=t.x - f.x;
			var h:Number=t.y - f.y;
			var xgap:Number=w / count;
			var ygap:Number=h / count;
			var array:Array=new Array();
			array.push(f);
			for (var i:int=1; i < count; i++)
			{
				var p:Point=new Point(f.x + xgap * i, f.y + ygap * i);
				array.push(p);
			}
			array.push(t);
			return array;
		}



		public static function contains(points:Array, x:Number, y:Number):Boolean
		{
			var hits:int=0;
			var npoints:int=points.length;
			var xpoints:Array =new Array();
			var ypoints:Array = new Array();
			for (var i:int=0; i < npoints; i++)
			{
				var p:Point=points[i];
				xpoints.push(p.x);
				ypoints.push(p.y);
			}


			var lastx:int=xpoints[npoints - 1];
			var lasty:int=ypoints[npoints - 1];
			var curx:int, cury:int;

			// Walk the edges of the polygon
			for (i=0; i < npoints; lastx=curx, lasty=cury, i++)
			{
				curx=xpoints[i];
				cury=ypoints[i];

				if (cury == lasty)
				{
					continue;
				}

				var leftx:int;
				if (curx < lastx)
				{
					if (x >= lastx)
					{
						continue;
					}
					leftx=curx;
				}
				else
				{
					if (x >= curx)
					{
						continue;
					}
					leftx=lastx;
				}

				var test1:Number, test2:Number;
				if (cury < lasty)
				{
					if (y < cury || y >= lasty)
					{
						continue;
					}
					if (x < leftx)
					{
						hits++;
						continue;
					}
					test1=x - curx;
					test2=y - cury;
				}
				else
				{
					if (y < lasty || y >= cury)
					{
						continue;
					}
					if (x < leftx)
					{
						hits++;
						continue;
					}
					test1=x - lastx;
					test2=y - lasty;
				}

				if (test1 < (test2 / (lasty - cury) * (lastx - curx)))
				{
					hits++;
				}
			}

			return ((hits & 1) != 0);
		}
	}
}