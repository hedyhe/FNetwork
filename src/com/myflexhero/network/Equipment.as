package com.myflexhero.network
{
	import com.myflexhero.network.event.ElementPropertyChangeEvent;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	

	public class Equipment extends Follower
	{
		private var _rowIndex:int=0;
		private var _colIndex:int=0;
		private var _floor:Floor;

		private var _rowSpan:int=1;
		private var _colSpan:int=1;

		public function Equipment(id:Object=null)
		{
			super(id);
//			this.width=150;
//			this.height=150;
		}

		/**
		 * 图片加载完毕后重新计算
		 */
		override public function creationCompleteFunction():void{
			creationCompleted = true;
			calculateLocation();
		}
		
		public function get colSpan():int
		{
			return _colSpan;
		}
		/**
		 * 所占列数,请根据情况跟换设备图片大小以适应列数的宽度
		 */
		public function set colSpan(value:int):void
		{
			var old:int=this.colSpan;
			_colSpan=value;
			this.dispatchPropertyChangeEvent("colSpan", old, colSpan);
		}

		public function get rowSpan():int
		{
			return _rowSpan;
		}

		/**
		 * 所占行数,请根据情况跟换设备图片大小以适应行数的高度
		 */
		public function set rowSpan(value:int):void
		{
			var old:int=this.rowSpan;
			_rowSpan=value;
			this.dispatchPropertyChangeEvent("rowSpan", old, rowSpan);
		}

		public function get floor():Floor
		{
			return _floor;
		}

		/**
		 * 需确保该属性在colIndex和rowIndex之前被设置。
		 */
		public function set floor(value:Floor):void
		{
			if (this.floor != null)
			{
				this.floor.removeEquipment(this);
				this.floor.removePropertyChangeListener(handleFloorPropertyChange);
			}
			_floor=value;
			this.host=floor;
			calculateLocation();
			if (this.floor != null)
			{
				this.floor.addEquipment(this);
				this.floor.addPropertyChangeListener(handleFloorPropertyChange);
			}
		}

		private function handleFloorPropertyChange(e:ElementPropertyChangeEvent):void
		{
			if ("location" == e.property || "width" == e.property || "height" == e.property||"x"==e.property||"y"==e.property)
			{
				calculateLocation();
			}
		}

		public function get colIndex():int
		{
			return _colIndex;
		}

		/**
		 * 设置列下标之前，需先设置所属地板(floor).
		 */
		public function set colIndex(value:int):void
		{
			var old:int=this.colIndex;
			_colIndex=value;
			if (this.dispatchPropertyChangeEvent("colIndex", old, this.colIndex))
			{
				calculateLocation();
			}
		}

		public function get rowIndex():int
		{
			return _rowIndex;
		}

		/**
		 * 设置行下标之前，需先设置所属地板(floor).
		 */
		public function set rowIndex(value:int):void
		{
			var old:int=this.rowIndex;
			_rowIndex=value;
			if (this.dispatchPropertyChangeEvent("rowIndex", old, this.rowIndex))
			{
				calculateLocation();
			}
		}
		public function reset():void{
			calculateLocation();
		}

		/**
		 * 是否已完成第一次计算.
		 */
		public var isCalculated:Boolean = false;
		/**
		 * 可在此处根据rowspan和clospan调整设备的大小。
		 * <br>该方法仅在更改了rowIndex或colIndex后才调用。
		 * <br>Equipment的x、y值应该由Floor和rowIndex、colIndex控制。
		 */
		private function calculateLocation():void
		{
			if (floor)
			{
				var rect:Rectangle=floor.getBounds(rowIndex, colIndex);
				var rbPoint:Point=new Point(rect.x+ rect.width, rect.y+ rect.height);
//				trace(rowIndex+":"+colIndex+"		x:"+x+",y:"+y+",w:"+this.width+",h:"+this.height+",rect.x："+rect.x+", rect.width:"+ rect.width+",rect.y:"+rect.y+",rect.height:"+rect.height)
				this.setLocation(rbPoint.x- this.width, rbPoint.y-this.height);
//				this.x =200;
//				this.y = 200;
					 
			}
		}

	}
}