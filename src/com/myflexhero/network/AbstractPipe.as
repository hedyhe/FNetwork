package com.myflexhero.network
{
	import com.myflexhero.network.Consts;
	import com.myflexhero.network.Element;
	import com.myflexhero.network.Follower;
	import com.myflexhero.network.Styles;
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.event.ElementPropertyChangeEvent;
	
	import flash.geom.Rectangle;
	

	/**
	 * 圆管的抽象类，继承自Follower类，拥有了跟随功能。
	 * 
	 * <br><br>数据元素的继承结构如下所示:
	 * <pre>
	 * Data(数据基类)
	 * 	|Element(元素基类)
	 *		|Node(节点类)
	 * 			|Follower(具有跟随功能的类)
	 *				|SubNetwork(具有显示多层次子类关系的类)
	 *				|<b>AbstractPipe</b>(具有内部显示不同形状的抽象类)
	 *					|RoundPipe(圆管,内部可显示父子关系的圆孔)
	 *					|SquarePipe(矩形管道,内部可显示不同大小的矩形)
	 *				|Group(内部作为一个整体，具有统一的边界外观)
	 *				|Grid(网格，可设置任意行、列)
	 *					|KPICard(可表示KPI的网格)
	 *		|Link(链接类，表示节点之类的关系)
	 * </pre>
	 * @see com.myflexhero.network.RoundPipe
	 * @see com.myflexhero.network.SquarePipe
	 * @author Hedy
	 */
	public class AbstractPipe extends Follower implements IPipe
	{
		/**
		 * 内部圆孔的索引下标。默认从0开始，如果未设置内部圆孔数量，则返回-1.
		 */
		private var _holeIndex:int = -1;
		private var _innerWidth:Number = 1.0;
		/**
		 * 圆孔的固定圆形边框虚线颜色，值为uint类型，默认为绿色(0x00B200)。
		 */
		private var _innerColor:uint = 0x00B200;
		/**
		 * 圆孔的固定圆形边框虚线Alpha 透明度值。有效值为 0（完全透明）到 1（完全不透明）。默认值为 1。
		 */
		private var _innerAlpha:Number = 1;
		/**
		 * 圆孔的固定圆形边框虚线(拖动圆孔后，该虚线位置不变，作为对比显示用)。<br>
		 * 值为array类型，且长度只能为2.如传入[2,3]。其中2意味着固定虚线的长度，3意味着固定虚线之间的间隔像素。<br>
		 * 默认值为[3,3].
		 */
		private var _innerPattern:Array = [3, 3];
		
		public function AbstractPipe(id:Object = null)
		{
			super(id);
			//重置图片为空，使用自定义绘图
			this.image = "";
			this.setSize(160, 160);
			this.setStyle(Styles.CONTENT_TYPE, Consts.CONTENT_TYPE_VECTOR);
			this.setStyle(Styles.VECTOR_FILL_COLOR, 0xC0C0C0);
			this.setStyle(Styles.VECTOR_OUTLINE_WIDTH, 1.0);
			this.setStyle(Styles.VECTOR_OUTLINE_COLOR, 0x00B200);
		}
		
		public override function serializeXML(serializer:XMLSerializer, newInstance:IData):void{
			super.serializeXML(serializer, newInstance);
			this.serializeProperty(serializer, "holeIndex", newInstance);
			this.serializeProperty(serializer, "innerWidth", newInstance);
			this.serializeProperty(serializer, "innerColor", newInstance);
			this.serializeProperty(serializer, "innerAlpha", newInstance);
			this.serializeProperty(serializer, "innerPattern", newInstance);
		}
		
		public function get innerWidth():Number
		{
			return this._innerWidth;
		}
		
		public function set innerWidth(innerWidth:Number):void
		{
			var oldValue:Number = this._innerWidth;
			this._innerWidth = innerWidth;
			this.dispatchPropertyChangeEvent("innerWidth", oldValue, innerWidth);
		}

		public function get innerColor():uint
		{
			return this._innerColor;
		}

		public function set innerColor(innerColor:uint):void
		{
			var oldValue:uint = this._innerColor;
			this._innerColor = innerColor;
			this.dispatchPropertyChangeEvent("innerColor", oldValue, innerColor);
		}
		
		public function get innerAlpha():Number
		{
			return this._innerAlpha;
		}
		
		public function set innerAlpha(innerAlpha:Number):void
		{
			var oldValue:int = this._innerAlpha;
			this._innerAlpha = innerAlpha;
			this.dispatchPropertyChangeEvent("innerAlpha", oldValue, innerAlpha);
		}

		public function get innerPattern():Array
		{
			return this._innerPattern;
		}

		public function set innerPattern(innerPattern:Array):void
		{
			var oldValue:Array = this._innerPattern;
			this._innerPattern = innerPattern;
			this.dispatchPropertyChangeEvent("innerPattern", oldValue, innerPattern);
		}

		public function get holeIndex():int
		{
			return this._holeIndex;
		}

		public function set holeIndex(holeIndex:int):void
		{
			var oldValue:int = this._holeIndex;
			this._holeIndex = holeIndex;
			this.dispatchPropertyChangeEvent("holeIndex", oldValue, holeIndex);
			adjustBounds();
		}
		
		protected override function updateFollowerImpl(e:ElementPropertyChangeEvent):void
		{
			super.updateFollowerImpl(e);
			this.adjustBounds();
		}
		
		public function adjustBounds():void
		{
			if (this.host is IPipe)
			{
				var pipe:IPipe = IPipe(this.host);
				var bounds:Rectangle = pipe.getPipeHoleBoundsByHole(this);
				if (bounds != null)
				{
					this.setLocation(bounds.x + pipe.innerWidth, bounds.y + pipe.innerWidth);
					this.setSize(bounds.width - pipe.innerWidth * 2, bounds.height - pipe.innerWidth * 2);
				}
			}
		}
		
		public function getPipeHoleBoundsByHole(hole:IPipe):Rectangle
		{
			return getPipeHoleBoundsByHoleIndex(hole.holeIndex);
		}
		
		public function getPipeHoleBoundsByHoleIndex(holeIndex:int):Rectangle
		{
			return null;
		}
		
		public function getPipeHoleByHoleIndex(holeIndex:int):IPipe
		{
			for (var i:int=0; i<this.children.length; i++)
			{
				var element:Element = this.children[i] as Element;
				if (element is IPipe)
				{
					var hole:IPipe = IPipe(element);
					if (hole.holeIndex == holeIndex)
					{
						return hole;
					}
				}
			}
			return null;
		}
		
//		public override function serializeXML(serializer:XMLSerializer, newInstance:IData):void{
//			super.serializeXML(serializer, newInstance);
//			this.serializeProperty(serializer, "holeIndex", newInstance);
//			this.serializeProperty(serializer, "innerWidth", newInstance);
//			this.serializeProperty(serializer, "innerColor", newInstance);
//			this.serializeProperty(serializer, "innerAlpha", newInstance);
//			this.serializeProperty(serializer, "innerPattern", newInstance);
//		}
	}
}