package com.myflexhero.network
{
	import com.myflexhero.network.core.ui.WallUI;
	
	import flash.geom.Point;
	

	public class Wall extends Follower
	{
		public static const WALL_TOP:String="wall.top";
		public static const WALL_BOTTOM:String="wall.bottom";
		public static const WALL_LEFT:String="wall.left";
		public static const WALL_RIGHT:String="wall.right";

		private var _floor:Floor;
		private var _wallHeight:Number=200;
		private var _color:uint=0x90bcd1;
		private var _wallLocation:String=WALL_TOP;

		private var validateFlag:Boolean=true
		private var _borderArray:Array;

		public function Wall(floor:Floor, wallLocation:String=WALL_TOP, id:Object=null)
		{
			super(id);
			this._floor=floor;
			this.wallLocation=wallLocation;
			this.host=floor;
			this.parent=floor;
//			this.setStyle(Styles.BODY_ALPHA,0.8);
		}

		public function get wallLocation():String
		{
			return _wallLocation;
		}

		public function set wallLocation(value:String):void
		{
			var old:String=this.wallLocation;
			_wallLocation=value;
			if (this.dispatchPropertyChangeEvent("wallLocation", old, this.wallLocation))
			{
				validateFlag=true;
			}
		}

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			var old:uint=this.color;
			_color=value;
			this.dispatchPropertyChangeEvent("color", old, this.color);
		}

		public function get wallHeight():Number
		{
			return _wallHeight;
		}

		public function set wallHeight(value:Number):void
		{
			var old:Number=this.wallHeight;
			_wallHeight=value;
			if (this.dispatchPropertyChangeEvent("wallHeight", old, this.wallHeight))
			{
				validateFlag=true;
			}
		}

		override public function get elementUIClass():Class
		{
			return WallUI;
		}

		public function invalidateFlag():void
		{
			validateFlag=true;
			this.dispatchPropertyChangeEvent("change", true, false);
		}

		public function get floor():Floor
		{
			return _floor;
		}

		private function calculateBorder():void
		{
			if (validateFlag == true)
			{
				var p1:Point;
				var p2:Point;
				var p3:Point;
				var p4:Point;
				var ba:Array=floor.borderPoints;
				switch (wallLocation)
				{
					case WALL_TOP:
						p2=ba[0];
						p3=ba[3];
						p1=new Point(p2.x, p2.y - wallHeight * 0.85);
						p4=new Point(p3.x, p3.y - wallHeight * 0.8);
						break;
					case WALL_BOTTOM:
						p2=ba[1];
						p3=ba[2];
						p1=new Point(p2.x, p2.y - wallHeight);
						p4=new Point(p3.x, p3.y - wallHeight * 0.95);
						break;
					case WALL_LEFT:
						p2=ba[0];
						p3=ba[1];
						p1=new Point(p2.x, p2.y - wallHeight * 0.85);
						p4=new Point(p3.x, p3.y - wallHeight);
						break;
					case WALL_RIGHT:
						p2=ba[3];
						p3=ba[2];
						p1=new Point(p2.x, p2.y - wallHeight * 0.8);
						p4=new Point(p3.x, p3.y - wallHeight * 0.95);
						break;
				}

				_borderArray=[p1, p2, p3, p4];


				validateFlag=false;
			}
		}

		public function get borderArray():Array
		{
			calculateBorder();
			return _borderArray;
		}



	}
}