package com.myflexhero.network
{
	import com.myflexhero.network.Consts;
	import com.myflexhero.network.Styles;
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.core.ui.RoundPipeUI;
	
	import flash.geom.Rectangle;
	
	/**
	 * 圆管,通过设置holeCount和isCenterHole属性，指定内部显示多少个圆孔。<br>
	 * isCenterHole属性默认为true，意味着holeCount指定的最后一个圆孔将居中显示(第1-9个圆孔将呈圆环型均匀排列)。<br>
	 * 如果isCenterHole属性值为false，则holeCount指定的所有圆孔将呈圆环型撑满整个圆管。
	 * 
	 * <br><br>数据元素的继承结构如下所示:
	 * <pre>
	 * Data(数据基类)
	 * 	|Element(元素基类)
	 *		|Node(节点类)
	 * 			|Follower(具有跟随功能的类)
	 *				|SubNetwork(具有显示多层次子类关系的类)
	 *				|AbstractPipe(具有内部显示不同形状的抽象类)
	 *					|<b>RoundPipe</b>(圆管,内部可显示父子关系的圆孔)
	 *					|SquarePipe(矩形管道,内部可显示不同大小的矩形)
	 *				|Group(内部作为一个整体，具有统一的边界外观)
	 *				|Grid(网格，可设置任意行、列)
	 *					|KPICard(可表示KPI的网格)
	 *		|Link(链接类，表示节点之类的关系)
	 * </pre>
	 * @author Hedy
	 */
	public class RoundPipe extends AbstractPipe
	{
		/**
		 * 内部子圆管数量，默认为0.<br>
		 * <b>[注意]</b>最后一个子孔将默认居中显示，且大小将撑满中心区域所剩余的面积。<br><br>
		 * 如设置holeCount为10，且isCenterHole为默认值true,圆管将按照自身面积大小在内部边界划分9个同等大小的圆孔，呈圆环型排列且相互相切。第10个圆孔将撑满整个中心区域。<br>
		 * 如果设置isCenterHole为false，则圆管将按照自身面积大小在内部边界划分10个同等大小的圆孔。
		 */
		private var _holeCount:int = 0;
		/**
		 * 是否为中心孔,默认为true.<br><br>
		 * 如设置holeCount为10，且isCenterHole为默认值true,圆管将按照自身面积大小在内部边界划分9个同等大小的圆孔，呈圆环型排列且相互相切。第10个圆孔将撑满整个中心区域。<br>
		 * 如果设置isCenterHole为false，则圆管将按照自身面积大小在内部边界划分10个同等大小的圆孔呈圆环排列。
		 */
		private var _isCenterHole:Boolean = true;
		
		public function RoundPipe(id:Object=null)
		{
			super(id);
			this.icon = "RoundPipe";
			this.setStyle(Styles.VECTOR_SHAPE, Consts.SHAPE_CIRCLE);
			this.setStyle(Styles.VECTOR_GRADIENT, Consts.GRADIENT_RADIAL_NORTHWEST);
		}
		
		public override function serializeXML(serializer:XMLSerializer, newInstance:IData):void{
			super.serializeXML(serializer, newInstance);
			this.serializeProperty(serializer, "holeCount", newInstance);
			this.serializeProperty(serializer, "isCenterHole", newInstance);
		}
		
		public override function get elementUIClass():Class
		{
			return RoundPipeUI;
		}
		/**
		 * 内部子圆管数量，默认为0.<br>
		 * <b>[注意]</b>最后一个子孔将默认居中显示，且大小将撑满中心区域所剩余的面积。<br><br>
		 * 如设置holeCount为10，且isCenterHole为默认值true,圆管将按照自身面积大小在内部边界划分9个同等大小的圆孔，呈圆环型排列且相互相切。第10个圆孔将撑满整个中心区域。<br>
		 * 如果设置isCenterHole为false，则圆管将按照自身面积大小在内部边界划分10个同等大小的圆孔。
		 */
		public function get holeCount():int
		{
			return this._holeCount;
		}
		/**
		 * 内部子圆管数量，默认为0.<br>
		 * <b>[注意]</b>最后一个子孔将默认居中显示，且大小将撑满中心区域所剩余的面积。<br><br>
		 * 如设置holeCount为10，且isCenterHole为默认值true,圆管将按照自身面积大小在内部边界划分9个同等大小的圆孔，呈圆环型排列且相互相切。第10个圆孔将撑满整个中心区域。<br>
		 * 如果设置isCenterHole为false，则圆管将按照自身面积大小在内部边界划分10个同等大小的圆孔。
		 */
		public function set holeCount(holeCount:int):void
		{
			var oldValue:int = this._holeCount;
			this._holeCount = holeCount;
			this.dispatchPropertyChangeEvent("holeCount", oldValue, holeCount);
		}
		
		/**
		 * 是否为中心孔,默认为true.<br><br>
		 * 如设置holeCount为10，且isCenterHole为默认值true,圆管将按照自身面积大小在内部边界划分9个同等大小的圆孔，呈圆环型排列且相互相切。第10个圆孔将撑满整个中心区域。<br>
		 * 如果设置isCenterHole为false，则圆管将按照自身面积大小在内部边界划分10个同等大小的圆孔呈圆环排列。
		 */
		public function get isCenterHole():Boolean
		{
			return this._isCenterHole;
		}
		/**
		 * 是否为中心孔,默认为true.<br><br>
		 * 如设置holeCount为10，且isCenterHole为默认值true,圆管将按照自身面积大小在内部边界划分9个同等大小的圆孔，呈圆环型排列且相互相切。第10个圆孔将撑满整个中心区域。<br>
		 * 如果设置isCenterHole为false，则圆管将按照自身面积大小在内部边界划分10个同等大小的圆孔呈圆环排列。
		 */
		public function set isCenterHole(isCenterHole:Boolean):void
		{
			var oldValue:Boolean = this._isCenterHole;
			this._isCenterHole = isCenterHole;
			this.dispatchPropertyChangeEvent("isCenterHole", oldValue, isCenterHole);
		}
		
		public override function getPipeHoleBoundsByHoleIndex(holeIndex:int):Rectangle
		{
			if (holeIndex < 0 || holeIndex >= this.holeCount)
			{
				return null;
			}
			var R:Number = Math.min(this.width, this.height) / 2.0;
			var cx:Number = this.x + this.width / 2.0;
			var cy:Number = this.y + this.height / 2.0;
			var count:int = this.isCenterHole ? this.holeCount - 1 : this.holeCount;
			var angle:Number = Math.PI / count;
			var r:Number = R * Math.sin(angle) / (1 + Math.sin(angle));
			var x:Number = (R - r) * Math.sin(angle * 2 * holeIndex);
			var y:Number = (R - r) * Math.cos(angle * 2 * holeIndex);
			if (this.isCenterHole && holeIndex == this.holeCount - 1)
			{
				r = R - 2 * r;
				return new Rectangle(cx - r, cy - r, 2 * r, 2 * r);
			}
			else
			{
				return new Rectangle(cx + x - r, cy + y - r, 2 * r, 2 * r);
			}
		}
	}
}