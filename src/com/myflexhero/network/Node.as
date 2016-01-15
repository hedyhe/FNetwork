package com.myflexhero.network
{
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.core.IImageAsset;
	import com.myflexhero.network.core.layout.forcelayout.extend.GraphDataProvider;
	import com.myflexhero.network.core.ui.NodeUI;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.core.mx_internal;

	use namespace mx_internal;
	/**
	 * 节点类，是基本视图的显示单位，主要用于网元等图形的显示。<br>
	 * 该类为图形的显示提供了更多的支持，如支持鼠标拖拽、动态拖动图形以改变大小，动态设置节点间的连接(Link类)，并支持根据层显示对应的节点。<br>
	 * 如果不设置任何值，将默认字符串"node_image"(内嵌的图片,具体路径:ImageLoader.node_image)作为节点的显示图片.<br>
	 * 关于内嵌的全部图片，请查看ImageLoader类。
	 * 
	 * <br><br>数据元素的继承结构如下所示:
	 * <pre>
	 * Data(数据基类)
	 * 	|Element(元素基类)
	 *		|<b>Node</b>(节点类)
	 * 			|Follower(具有跟随功能的类)
	 *				|SubNetwork(具有显示多层次子类关系的类)
	 *				|AbstractPipe(具有内部显示不同形状的抽象类)
	 *					|RoundPipe(圆管,内部可显示父子关系的圆孔)
	 *					|SquarePipe(矩形管道,内部可显示不同大小的矩形)
	 *				|Group(内部作为一个整体，具有统一的边界外观)
	 *				|Grid(网格，可设置任意行、列)
	 *					|KPICard(可表示KPI的网格)
	 *		|Link(链接类，表示节点之类的关系)
	 * </pre>
	 * @see com.myflexhero.network.core.image.ImageLoader
	 * @see com.myflexhero.network.Link
	 * @see com.myflexhero.network.Styles
	 * @date  02/15/2011
	 * @author Hedy<br>
	 * 550561954#qq.com 
	 */
	public class Node extends Element
	{
		private var _image:String;
		protected var _width:Number = NaN;
		protected var _height:Number = NaN;
		private var _size:Size;
		private var _point:Point;
		protected var _followers:Vector.<Follower>;
		/**
		 * Resize组件专用，请勿使用.
		 */
		mx_internal var isLocked:Boolean = false;
		
		public var rotation:Number = 0;
		/**
		 * 当前是否为SmallNode模式。
		 */
		public var isSmallNode:Boolean = false;
		/************内部变量******************/
		
		/**
		 * 此属性用于拖动时禁止自动布局,见ForceDirectedLayout.forEachNode().
		 */
		mx_internal var isMouseDown:Boolean = false;
		
		/**
		 *  对比变量,只有通过调用set x() set y()方法时才会赋值.
		 */
		mx_internal var oldPoint:Point;
		/**
		 *  对比变量,只有通过调用set location()方法时才会赋值.
		 */
		mx_internal var oldPoint_location:Point;
		/**
		 * 程序内部使用(NodeUI),请不要直接调用
		 */
		mx_internal var imageWidth:Number=0;
		
		mx_internal var imageHeight:Number=0;
		private var _nodeWidth:Number = 0;
		private var _nodeHeight:Number = 0;
		
		/**
		 * 默认构造方法。
		 */
		public function Node(id:Object=null)
		{
			super(id);
			_size = new Size();
			_image = "node_image";
			icon = "node_icon";
			_point = new Point();
			oldPoint = new Point();
			oldPoint_location = new Point();
		}
		
		override public function serializeXML(serializer:XMLSerializer, data:IData) : void
		{
			super.serializeXML(serializer, data);
			this.serializeProperty(serializer, "image", data);
			this.serializeProperty(serializer, "location", data);
			if (!isNaN(this._width))
			{
				this.serializeProperty(serializer, "width", data);
			}
			if (!isNaN(this._height))
			{
				this.serializeProperty(serializer, "height", data);
			}
		}
		
		/**
		 * 返回当前数据元素的中心点坐标(基于width和height计算，而非imageWidth和imageHeight)。
		 */
		public function get centerLocation() : Point
		{
			//始终返回真实的width和height的中心点,
			//因为如果计算imageWidth，可能由于原始图片大小比率和重置设置大小的图片比率不一致，
			//而导致this.x值不是实际图片的起始绘画点
			return new Point(this.x + this.width / 2, this.y + this.height / 2);
		}
		
		/**
		 * 设置当前数据元素的中心点坐标。
		 * @param x 未设置缩放的X因子，如event.currentTarget.mouseX
		 * @param y 未设置缩放的Y因子，如event.currentTarget.mouseY
		 * @param imageScaleValue 供图片大小相乘的缩放因子,可通过network.getZoomScaleValue()方法获得.
		 */
		public function setCenterLocation(x:Number,y:Number,imageScaleValue:Number=1) : void
		{
			if(imageWidth==0||imageHeight==0)
				this.setLocation(x - this.width / 2*imageScaleValue, y - this.height / 2*imageScaleValue);
			else
				this.setLocation(x - this.imageWidth / 2*imageScaleValue, y - this.imageHeight / 2*imageScaleValue);
		}
		
		/**
		 * 便捷的方式设置x、y值。目前设置了x和y的最小值为0，如果传入小于0的值，将被设置为0。
		 * <br>
		 * 该操作将派发PropertyChangeEvent事件，并设置property属性为location。
		 */
		public function setLocation(x:Number,y:Number):void{
			if(x<0)
				x=1;
			if(y<0)
				y=1;
			if (x == this._point.x&&y == this._point.y)
			{
				return;
			}
			if (isNaN(x)||isNaN(y))
			{
				return;
			}
			this.oldPoint_location.x = this._point.x;
			this.oldPoint_location.y = this._point.y;
			this._point.x =  x;
			this._point.y =  y;
			
			if(!isLock)
				this.dispatchPropertyChangeEvent("location", oldPoint_location, this._point);
		}
		
		public function get location():Point{
			return this._point;
		}
		
		/**
		 * 此方法与setLocation方法效果相同
		 */
		public function set location(point:Point):void{
			setLocation(point.x,point.y);
		}
		
		/**
		 * 便捷的方式设置宽和高.
		 */	
		public function setSize(width:Number, height:Number) : void
		{
			var isLockOld:Boolean = isLock;
			isLock = true;
			this.width = width;
			isLock = isLockOld;
			this.height = height;
		}
		
		/**
		 * 返回当前的width和height组成的自定义Size对象。
		 */
		public function getSize():Size{
			_size.width = this.width;
			_size.height = this.height;
			return _size;
		}
		
		public function get width():Number
		{
			if (!isNaN(this._width))
			{
				if (this._width > 0)
				{
					return this._width;
				}
			}
			return imageWidth;
		}
		
		/**
		 * 设置数据元素的宽。<br>
		 * 该操作将派发PropertyChangeEvent事件，并设置property属性为width。
		 */
		public function set width(value:Number) : void
		{
			var _oldValue:* = this._width;
			if(_oldValue==value)
				return;
			this._width = value;
			if(!isLock)
				this.dispatchPropertyChangeEvent("width", _oldValue, value);
		}
		
		/**
		 * 设置数据元素的高。<br>
		 * 该操作将派发PropertyChangeEvent事件，并设置property属性为height。
		 */
		public function set height(value:Number):void
		{
			var _oldValue:* = this._height;
			if(_oldValue==value)
				return;
			this._height = value;
			if(!isLock)
				this.dispatchPropertyChangeEvent("height", _oldValue, value);
		}

		public function get height() : Number
		{
			if (!isNaN(this._height))
			{
				if (this._height > 0)
				{
					return this._height;
				}
			}
			return imageHeight;
		}

		/**
		 * 设置数据元素显示的图片路径。如果为空，则将显示默认图片。
		 * 该操作将派发PropertyChangeEvent事件，并设置property属性为image。
		 */
		public function set image(image:String) : void
		{
			var _oldValue:String = this._image;
			if(_oldValue==image)
				return;
			this._image = image;
			if(!isLock)
				this.dispatchPropertyChangeEvent("image", _oldValue, image);
		}
		
		public function get image() : String
		{
			return this._image;
		}
		
		/**
		 * 平移
		 */
		public function translate(_addX:Number, _addY:Number) : void
		{
			setLocation(x + _addX, y + _addY);
		}
		
		public function get x() : Number
		{
			return this._point.x;
		}
		
		public function get y() : Number
		{
			return this._point.y;
		}
		
		/**
		 * 设置x值，如果小于0，则会被设置为0.<br>
		 * 该操作将派发PropertyChangeEvent事件，并设置property属性为x。
		 */
		public function set x(value:Number):void
		{
			if(value<0)
				value =1;
			var _oldValue:* = this._point.x;
			if(_oldValue==value)
				return;
			this.oldPoint.x = _oldValue;
			this._point.x = value;
			if(!isLock)
				this.dispatchPropertyChangeEvent("x", _oldValue, value);
		}
		
		/**
		 * 设置y值，如果小于0，则会被设置为0.<br>
		 * 该操作将派发PropertyChangeEvent事件，并设置property属性为y。
		 */
		public function set y(value:Number) :void
		{
			if(value<0)
				value =1;
			var _oldValue:* = this._point.y;
			if(_oldValue==value)
				return;
			this.oldPoint.y = _oldValue;
			this._point.y = value;
			if(!isLock)
				this.dispatchPropertyChangeEvent("y", _oldValue, value);
		}
		
		public function get rect() : Rectangle
		{
			return new Rectangle(x, y,nodeWidth==0||isNaN(nodeWidth)?width:nodeWidth,nodeHeight==0||isNaN(nodeHeight)?height:nodeHeight);
		}
		
		public function get vectorRect() : Rectangle
		{
			return new Rectangle(x, y,width,height);
		}

//		mx_internal function get rotation():Number
//		{
//			return _rotation;
//		}
//
//		mx_internal function set rotation(value:Number):void
//		{
//			var _oldValue:* = this._rotation;
//			this._rotation = value;
//			this.dispatchPropertyChangeEvent("rotation", _oldValue, value);
//		}
		
		public function get followers() : Vector.<Follower>
		{
			return this._followers;
		}
		
		public function addFollower(value:Follower) : void
		{
			if (_followers == null)
			{
				_followers = new Vector.<Follower>();
			}
			if(_followers.indexOf(value)==-1)
				_followers.push(value);
		}
		
		public function removeFollower(value:Follower) : void
		{
			var index:int = _followers.indexOf(value);
			if(index==-1)
				return;
			_followers.splice(index,1);
			if (_followers.length == 0)
			{
				_followers = null;
			}
		}
		
		override public function get elementUIClass() : Class
		{
			return NodeUI;
		}
		
		/* ********** auto layout ************** */
		mx_internal var dy: Number = 0;
		mx_internal var repulsion: Number = 0;
		mx_internal var fixed: Boolean = false;
		/**
		 * 对自动布局中的环形布局数据提供管理器的引用
		 */
		mx_internal var context:GraphDataProvider = null;
		mx_internal function refresh(): void {
//			this.x = getX();
//			this.y = getY();
			this.repulsion = getRepulsion();
//			trace("refresh x:"+x+",y:"+y)
//			trace("refresh dx:"+dx+",dy:"+dy)
//			trace("refresh...")
		}
		
//		public function commit(): void {
//			setX(this.x);
//			setY(this.y);
//			trace("commit x:"+x+",y:"+y)
//			trace("commit dx:"+dx+",dy:"+dy)
//			trace("commit...")
//		}
		
		private var _dx: Number = 0;
		mx_internal function set dx(n: Number): void {
			if(isNaN(n)) {
				n = n;
			}
			
			_dx = n;
		}
		mx_internal function get dx(): Number {
			return _dx;
		}
		
		private function getRepulsion(): int {
			var result: int = (imageWidth + imageHeight) * context.repulsionFactor;
			if(result == 0)
				return context.defaultRepulsion;
			return result;
		}

		/**
		 * 节点的图片+文字的高度和宽度
		 */
		public function get nodeWidth():Number
		{
			return (_nodeWidth =  (isNaN(_nodeWidth)||_nodeWidth==0||_nodeWidth<width)?width:_nodeWidth);
		}

		public function set nodeWidth(value:Number):void
		{
			_nodeWidth = value;
		}

		public function get nodeHeight():Number
		{
			return (_nodeHeight =(isNaN(_nodeHeight)||_nodeHeight==0||_nodeHeight<height)?height:_nodeHeight);
		}

		public function set nodeHeight(value:Number):void
		{
			_nodeHeight = value;
		}


//		
//		override public function set visible(value:Boolean):void
//		{
//			var _oldValue:* = _visible;
//			this._visible = value;
//			if(!isLock&&_oldValue!=value)
//				this.dispatchPropertyChangeEvent("visible", _oldValue, value);
//		}
	}
}