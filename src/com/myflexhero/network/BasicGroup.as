package com.myflexhero.network
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.graphics.BitmapFillMode;
	import mx.graphics.GradientEntry;
	import mx.graphics.LinearGradient;
	import mx.graphics.SolidColor;
	
	import spark.components.Group;
	import spark.components.Image;
	import spark.primitives.Graphic;
	import spark.primitives.Rect;

	/**
	 * 图形容器基类,扩展自Group容器，所有图形数据展示的操作通过覆盖Group的XXchild方法进行。
	 * @author Hedy<br>
	 * 如发现Bug请报告至email: 550561954@qq.com 
	 */
	public class BasicGroup extends Group
	{
		/**
		 * 布局中的元素是否可移动。<br>
		 * 判断是针对于该布局中的部分元素还是所有元素(包括即将新增的)，
		 * 请在此属性的基础上再判断isResizeAll的值。
		 */
		public var resizable:Boolean = false;
		
		/**
		 * 判断是否针对布局中的所有元素,
		 * 如果为true，且resizable=true,则这意味着有新的元素加入时将允许其改变尺寸大小。
		 */
		public var isResizeAll:Boolean = false;

		/**
		 * 是否可移动。
		 * 判断是针对于该布局中的部分元素还是所有元素(包括即将新增的)，
		 * 请在此属性的基础上再判断isMoveAll的值。
		 */
		public var movable:Boolean = false;
		/**
		 * 判断是否针对布局中的所有元素都可移动，
		 * 如果该属性值为true，且movable=true,这意味着有新的元素加入时将允许其移动。
		 */
		public var isMoveAll:Boolean = false;
		
//		/**
//		 * 允许resize的所有数据元素
//		 */
//		public var resizableElements:Dictionary;
//		/**
//		 * 允许move的所有数据元素
//		 */
//		public var movableElements:Dictionary;
		
		/**
		 * 背景颜色
		 */
		private var _backgroundColor:Array = [0xFFFFFF];
		/**
		 * 背景颜色是否使用渐变
		 */
		private var _backgroundColorLinear:Boolean = true ;
		
		/**
		 * 背景颜色透明度
		 */
		private var _backgroundColorAlpha:Number =1;
		/**
		 * 背景图片URL
		 */
		private var _backgroundImage:String;
		
		public var backgroundChanged:Boolean = true;
		public var backgroundImageChanged:Boolean = true;
		
		private var _child:UIComponent;
		public var isMeasureCallLater:Boolean = false;
		
		/**
		 * 是否将所有元素添加到一个名为child的UIComponent组件中，然后将该组件添加到当前容器中。<br>
		 * 如果需要设置当前容器的布局器为tileLayout，需要设置useDefaultChild为false，使所有子元素跳过名为child的UIComponent组件，而直接添加到当前容器中。
		 */
		public var useDefaultChild:Boolean = false;
		public function BasicGroup(name:String="",useDefaultChild:Boolean = true)
		{ 
			super();
//			resizableElements = new Dictionary();
//			movableElements = new Dictionary();
			if(useDefaultChild){
				this.useDefaultChild = useDefaultChild;
				_child = new UIComponent();
				addElement(_child);
			}
			if(name)
				this.name = name;
		}
		
		/**
		 * 设置当前BasicGroup的背景颜色功能可用,即可以添加其他附件。
		 */
		public function setBackgroudGroupEnable(enable:Boolean=false):void{
			if(enable){
				if(bgGraphics==null){
					bgGraphics = new Graphic();
					bgGraphics.addElement(backgroundImager);
					this.addElement(bgGraphics);
				}
			}
			else{
				if(bgGraphics){
					if(bgGraphics.numElements>0)
						bgGraphics.removeAllElements();
					var eIndex:int = this.getElementIndex(bgGraphics);
					if(eIndex!=-1)
						this.removeElementAt(eIndex);
				}
			}
		}

		public function get data():UIComponent{
			return _child;
		}
		
		public function getUnscaledHeight() : Number
		{
			return this.unscaledHeight;
		}
		
		public function getUnscaledWidth() : Number
		{
			return this.unscaledWidth;
		}

		public function get backgroundColor():Array
		{
			return _backgroundColor;
		}

		public function set backgroundColor(value:Array):void
		{
			_backgroundColor = value;
			backgroundChanged = true;
			invalidateDisplayList();
		}
		
		/**
		 * 背景颜色
		 */
		public function get backgroundColorLinear():Boolean
		{
			return _backgroundColorLinear;
		}
		
		/**
		 * @private
		 */
		public function set backgroundColorLinear(value:Boolean):void
		{
			_backgroundColorLinear = value;
			backgroundChanged = true;
			invalidateDisplayList();
		}
		
		public function get backgroundColorAlpha():Number
		{
			return _backgroundColorAlpha;
		}

		public function set backgroundColorAlpha(value:Number):void
		{
			_backgroundColorAlpha = value;
			backgroundChanged = true;
			invalidateDisplayList();
		}
		
		private var imageLoadedCallbackFunction:Function;
		/**
		 * 设置背景图片.
		 * @param value 图片路径
		 * @param fillMode 填充方式.如BitmapFillMode.REPEAT.
		 * @param callbackFunction 图片加载完成后的回调方法，方法格式:function onBackgroundImageNodeImageLoaded(e:Event):void{}
		 */
		public function setBackgroundImage(value:String,fillMode:String=BitmapFillMode.REPEAT,callbackFunction:Function=null):void
		{
			_backgroundImage = value;
			if(backgroundImager)
				backgroundImager.fillMode = fillMode;
			if(callbackFunction!=null)
				imageLoadedCallbackFunction = callbackFunction;
			backgroundImageChanged = true;
			invalidateDisplayList();
		}
		
		public function getBackgroundImage():String
		{
			return _backgroundImage;
		}
		
		public var bgGraphics:Graphic;
		/**
		 * 背景图片引用，供自定义设置属性.
		 */
		public var backgroundImager:Image = new Image();
		
		/**
		 * 画背景图片
		 */
		public function drawBackgroundImage():void{
			if(_backgroundImage){
				if(backgroundImager.source!=_backgroundImage){
					backgroundImager.addEventListener(Event.COMPLETE,onBackgroundImageLoaded);
					backgroundImager.source = _backgroundImage;
				}
				else
					onBackgroundImageLoaded(null);//否则属于容易尺寸更改，重新设置背景图片大小
//				var p:* = this.parent;
//				while(p){
//					if(p is Network){
//						var network:Network = Network(p);
//						if(bgGraphics.viewWidth!=network.attachmentGroup.width)
//							bgGraphics.viewWidth = network.attachmentGroup.width;
//						if(bgGraphics.viewHeight!=network.attachmentGroup.height)
//							bgGraphics.viewHeight = network.attachmentGroup.height;
//						if(backgroundImager.width!=network.attachmentGroup.width)
//							backgroundImager.width = network.attachmentGroup.width;
//						if(backgroundImager.height!=network.attachmentGroup.height)
//							backgroundImager.height = network.attachmentGroup.height;
//						break;
//					}
//					p = p.parent;
//				}
//				
			}
			backgroundImageChanged = false;
		}
		
		/**
		 * 监听图片加载完成
		 */
		private function onBackgroundImageLoaded(e:Event):void{
			var p:* = this.parent;
			var network:Network;
			while(p){
				if(p is Network){
					network = Network(p);
					use namespace mx_internal;
					if(backgroundImager.sourceWidth>network.dataGroup.width)
						network.setRootGroupSize(backgroundImager.sourceWidth,"width");
					if(backgroundImager.sourceHeight>network.dataGroup.height)
						network.setRootGroupSize(backgroundImager.sourceHeight,"height");
					
					break;
				}
				p = p.parent;
			}
			if(backgroundImager.fillMode==BitmapFillMode.CLIP){
				if(bgGraphics.viewWidth!=backgroundImager.sourceWidth)
					bgGraphics.viewWidth = backgroundImager.sourceWidth;
				if(bgGraphics.viewHeight!=backgroundImager.sourceHeight)
					bgGraphics.viewHeight = backgroundImager.sourceHeight;
				if(backgroundImager.width!=backgroundImager.sourceWidth)
					backgroundImager.width = backgroundImager.sourceWidth;
				if(backgroundImager.height!=backgroundImager.sourceHeight)
					backgroundImager.height = backgroundImager.sourceHeight;
			}
			else{
				if(bgGraphics.viewWidth!=network.dataGroup.width)
					bgGraphics.viewWidth = network.dataGroup.width;
				if(bgGraphics.viewHeight!=network.dataGroup.height)
					bgGraphics.viewHeight = network.dataGroup.height;
				if(backgroundImager.width!=network.dataGroup.width)
					backgroundImager.width = network.dataGroup.width;
				if(backgroundImager.height!=network.dataGroup.height)
					backgroundImager.height = network.dataGroup.height;
			}
			if(imageLoadedCallbackFunction!=null&&e!=null)
				imageLoadedCallbackFunction.call(null,e);
		}
		
		private var _rect:Rect;
		private var _solidColor:SolidColor;
		/**
		 * 画背景颜色
		 */
		public function drawBackground():void{
			if(_backgroundColorLinear){
				var w:Number = this.width;
				var h:Number = this.height;
				
				var g:Graphics = this.graphics;
				
				var fill:LinearGradient = new LinearGradient();
				var ges:Array = [];
				for(var bi:int =0;bi<_backgroundColor.length;bi++){
					var ge:GradientEntry = new GradientEntry(_backgroundColor[bi],NaN,_backgroundColorAlpha);
					ges.push(ge);
					
				}
//				var g1:GradientEntry = new GradientEntry(0xFFFFFF,NaN,_backgroundColorAlpha);
//				var g2:GradientEntry = new GradientEntry(_backgroundColor,NaN,_backgroundColorAlpha);
				
				fill.entries = ges;
				g.clear();
				// 画一个矩形并填充它,with the LinearGradient.
				g.moveTo(0, 0);
				fill.begin(g, new Rectangle(0, 0, w, h),new Point());
				g.lineTo(w, 0);
				g.lineTo(w, h);
				g.lineTo(0, h);
				g.lineTo(0, 0);		
				fill.end(g);
			}
			else{
				if(!_rect){
					_rect = new Rect();
					_rect.percentWidth=100;
					_rect.percentHeight =100;
					addElement(_rect);
				}
				if(!_solidColor){
					_solidColor = new SolidColor();
					_rect.fill = _solidColor;
				}
				_solidColor.color = _backgroundColor[0];
				_solidColor.alpha = _backgroundColorAlpha;
			}
			backgroundChanged = false;
		}
		
		/**
		 * 重写Group的addChild方法，该方法在Group中被禁止，但此处用于添加布局数据。<br>
		 * 该布局中的所有数据都被保存在唯一的_child对象中。
		 */
		public function addData(value:*):Object
		{
			if(useDefaultChild)
				return _child.addChild(value);
			return addElement(value);
		}
		
		/**
		 * 删除通过addChild方法添加的数据
		 */
		public function removeData(value:*):Object
		{
				var find:Boolean = false;
				if(useDefaultChild){
					for(var i:int=0;i<_child.numChildren;i++){
						if(_child.getChildAt(i)==value){
							find = true
							break;
						}
					}
				}
				else{
					for(i=0;i<numElements;i++){
						if(getElementAt(i)==value){
							find = true
							break;
						}
					}
				}
				if(!find)
					return null;
				return useDefaultChild?_child.removeChild(value):removeElement(value);
		}
		
		/**
		 * 查看是否存在通过addChild方法添加的数据
		 */
		public function containsData(value:*):Boolean
		{
			return useDefaultChild?_child.contains(value):containsElement(value);
		}
		


		/**
		 * 返回通过addChild方法添加的数据总数。
		 */
		public function get numDatas():int{
			return useDefaultChild?_child.numChildren:numElements;
		}
		
		public function getDataIndex(value:*):int{
			return useDefaultChild?_child.getChildIndex(value):getElementIndex(value);
		}
		
		/**
		 * 根据useDefaultChild，可能返回DisplayObject，也可能返回IVisualElement.
		 */
		public function getDataAt(index:int):*{
			return useDefaultChild?_child.getChildAt(index):getElementAt(index);
		}
		
		
		/**
		 *  删除所有通过addChild方法添加的数据
		 */
		public function removeAllDatas():void
		{
			if(useDefaultChild){
				for(var i:int=0;i<_child.numChildren;i++)
					_child.removeChildAt(i);
			}else{
				for(i=0;i<numElements;i++)
					removeElementAt(i);
			}
		}
		
		public function setDataIndex(value:*, index:int):void{
			useDefaultChild?_child.setChildIndex(value,index):setElementIndex(value,index);
		}
//		private var measured:Boolean = false;
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			if(backgroundChanged)
				drawBackground();
			if(backgroundImageChanged)
				drawBackgroundImage();
//			if(isMeasureCallLater){
//				isMeasureCallLater = false;
//				unscaledWidth = _width_loc;
//				unscaledHeight = _height_loc;
//				width = unscaledWidth;
//				height= unscaledHeight;
////				_width_loc = super.width;
////				_height_loc = super.height;
////				measured= true;
//				trace("更改_width_loc:"+_width_loc+",_height_loc:"+_height_loc)
//			}
			
		}
//		/**
//		 * 类似Invalidataion机制。该方法减少界面重绘的次数，仅在需要的时候才重绘界面。
//		 */
//		public function commitMeasure():void{
//			if(!isNaN(_width_loc)&&super.width!=_width_loc)
//				super.width = _width_loc;
//			if(!isNaN(_height_loc)&&super.height!=_height_loc){
////				trace("不一样,height:"+height+",_height_loc:"+_height_loc)
//				super.height = _height_loc;
//			}
//		}

	}
}