package com.myflexhero.network.core.ui
{
	import com.myflexhero.network.Consts;
	import com.myflexhero.network.Network;
	import com.myflexhero.network.Node;
	import com.myflexhero.network.Styles;
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.core.util.ElementUtil;
	import com.myflexhero.network.core.util.GraphicDrawHelper;
	import com.myflexhero.network.event.ElementPropertyChangeEvent;
	import com.myflexhero.network.event.MaxPointEvent;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.container.ScrollPolicy;
	
	import mx.core.mx_internal;
	
	import spark.filters.GlowFilter;

	use namespace mx_internal;
	
	/**
	 * 节点包装操作基类
	 * @see com.myflexhero.network.core.ui.ElementUI
	 * @see com.myflexhero.network.core.ui.LinkUI
	 * @author Hedy<br>
	 * 550561954#qq.com 
	 */
	public class NodeUI extends ElementUI
	{
		private var _imageAttachment:ImageAttachment = null;
		
		private var _sourceImageRatio:Number;
		private var _matrixScale:Number;
		/*节点宽度*/
		protected var _nodeWidth:Number;
		/*节点高度*/
		protected var _nodeHeight:Number;
		
		private var imageChanged:Boolean = false;
		private var labelChanged:Boolean = false;
		private var toolTipChanged:Boolean = false;
		public static var bitmapDatas:Dictionary = new Dictionary();
		/**
		 * 最左侧的点(对比图片和文字,用于判断与其他节点的相交)
		 */
		public var leftMostPoint:Point;
		/**
		 * 最右侧的点(对比图片和文字,用于判断与其他节点的相交)
		 */
		public var rightMostPoint:Point;
		/**
		 * 是否更改了尺寸
		 */
		private var sizeChanged:Boolean = true;
		/**
		 * 是否改变了图片的大小
		 */
		private var imageSizeChanged:Boolean = false;
		/**
		 * 当节点的X轴值超出Root布局的宽度时，Root布局默认新增的宽度。
		 */
		public var horizontalScrollerIncrement:int = 300;
		/**
		 * 当节点的Y轴值超出Root布局的高度时，Root布局默认新增的高度。
		 */
		public var verticalScrollerIncrement:int = 300;
		
		public function NodeUI(network:Network, value:IData)
		{
			super(network,value);
			value.addEventListener(MaxPointEvent.INCREASE,refreshScroll);
			value.addEventListener(MaxPointEvent.DECREASE,refreshScroll);
//			_colors = Vector.<uint>([0xff0000,0x660000,0x335500,0x000000]);
			//默认只显示2级的颜色
			_colors = Vector.<uint>([0xff0000,0x660000,0x335500]);
			leftMostPoint = new Point();
			rightMostPoint = new Point();
		}
		
		//--------------------------------------------------------------------------
		//
		//  继承自接口
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//  drawBody
		//--------------------------------------------------------------------------
		override public function drawBody():void{
			contentType = element.getStyle(Styles.CONTENT_TYPE);
			initAttachment();
		}
		
		protected var contentType:String;
		protected function initAttachment():void{
			if(element.label){
				labelChanged = true;
				labelStyleChanged = true;
			}
			
			if(element.image){
				if(contentType==Consts.CONTENT_TYPE_DEFAULT||contentType==Consts.CONTENT_TYPE_DEFAULT_VECTOR||contentType==Consts.CONTENT_TYPE_VECTOR_DEFAULT)
					imageChanged = true;
			}
			
			if(element.toolTip)
				this.toolTip = element.toolTip;
			
			if(element.highLightEnable)
				isHighLightEnable = true;
			
			updateProperties();
		}

		//--------------------------------------------------------------------------
		//  updateProperties
		//--------------------------------------------------------------------------
		private var bitmapData:BitmapData;
		override public function updateProperties():void{
			if(!updateImageAttachmentProperties())
				return;
			updateLabelAttachmentProperties();
			drawContent();
		}
		
		/**
		 * 如果图片仍未加载完成，则返回false(函数中断执行)。否则，返回true。
		 */
		public function updateImageAttachmentProperties():Boolean{
			if(imageChanged){
				if(!_imageAttachment){
					_imageAttachment = new ImageAttachment(element,network.imageLoader);
				}
				if(_imageAttachment.loading)
					return false;
				
				if(imageChanged){
					imageAttachment.updateProperties();
				}
				
				//所有拥有element.image属性的元素再次检查
				if(!imageAttachment.content){
					//throw Error("找不到图标,图标名称:"+element.image);
					return false;
				}
				
				if(imageChanged){
					element.imageWidth = imageAttachment.content.width;
					element.imageHeight = imageAttachment.content.height;
					//保存原始图像的宽高比
					_sourceImageRatio = imageAttachment.content.width/imageAttachment.content.height;
					
					imageChanged = false;
					sizeChanged = true;
					createNewBitmapData();
				}
			}
			return true;
		}
		
		/* 是否已经测量过边界 */
		protected var boundaryChecked:Boolean = false;
		protected function drawContent() : void
		{
			if (contentType == Consts.CONTENT_TYPE_DEFAULT)
			{
				this.drawDefaultContent();
			}
			else if (contentType == Consts.CONTENT_TYPE_VECTOR)
			{
				this.drawVectorContent();
			}
			else if (contentType == Consts.CONTENT_TYPE_DEFAULT_VECTOR)
			{
				this.drawVectorContent();
				this.drawDefaultContent();
			}
			else if (contentType == Consts.CONTENT_TYPE_VECTOR_DEFAULT)
			{
				this.drawDefaultContent();
				this.drawVectorContent();
			}
			else if (contentType == Consts.CONTENT_TYPE_NONE)
			{
			}
			if(!element.creationCompleted)
				element.creationCompleteFunction();
			return;
		}
		//--------------------------------------------------------------------------
		//  drawDefaultContent
		//--------------------------------------------------------------------------
		/**
		 * 画节点图标
		 */
		protected function drawDefaultContent() : void
		{
			graphics.clear();
			/* 无图片或未加载完成,直接返回 */
			if(!element.image||imageAttachment==null||imageAttachment.content==null)
				return;
			
			//Step1. 刷新Label组件 
			refreshLabelAttachment();
			
			//Step2. 设置nodeWidth、nodeHeight属性
			if(sizeChanged)
				checkSize();
			
			//Step3. 调整元素的x、y值,如果超出屏幕大小，将刷新屏幕的边界。需要使用到Step2的nodeWidth、nodeHeight属性 */
			if(network.needCheckBoundary&&!boundaryChecked){
				boundaryChecked = true;
				coordinateHandler(0);
			}
			
			//Step4 刷新组件的可视状态
			refreshAttachmentVisible();
			
			//Step5 刷新组件外观,如果有Label，则需要LabelAttachment最后的x、y值。
			refreshHighLight();
			
			var matrix:Matrix = new Matrix();
			/* 缩放 */			
			matrix.scale(matrixScale,matrixScale);
			
			//此处translate必须置于scale之后
			matrix.translate(element.x,element.y);
			
			graphics.beginBitmapFill(bitmapData, matrix,false);
			graphics.drawRect(element.x,element.y,element.imageWidth,element.imageHeight);
			graphics.endFill( );
		}
		
		//--------------------------------------------------------------------------
		//
		//  重载的方法
		//
		//--------------------------------------------------------------------------
		override public function updateLabelAttachmentProperties():void{
			//使用labelStyleChanged作为进入条件判断(MouseOver)
			if(labelChanged||labelStyleChanged||mouseOver||mouseDown){
				if(!labelAttachment){
					labelAttachment = new LabelAttachment(element);
					network.getLabelLayoutGroup().addData(labelAttachment.content);
				}
				if(labelChanged){
					labelAttachment.labelChanged = true;
					labelChanged = false;
					sizeChanged = true;
				}
				if(labelStyleChanged){
					labelAttachment.styleChanged = true;
					labelStyleChanged = false;
					sizeChanged = true;
				}
				
				if(labelAttachment.content){
					//					labelAttachment.content.id= this.id;
					if(labelUI==null){
						labelUI = labelAttachment.content;
						_attachments.push(labelUI);
					}
				}
				
				/* 文本选中效果 */
				if(mouseOver||mouseDown)
					labelAttachment.selected = true;
				else
					labelAttachment.selected = false;
			}
		}
		
		override public function refreshLabelAttachment():void{
			if(labelAttachment){
				labelAttachment.rectangle.x = element.x;
				labelAttachment.rectangle.y = element.y;
				labelAttachment.rectangle.width = element.width;
				labelAttachment.rectangle.height = element.height;
				labelAttachment.updateProperties();
			}
		}
		
		override protected function refreshAttachmentVisible():void{
			/* 不可见 */
			if(visableChanged){
				if(!element.visible){
					if(labelUI&&labelUI.visible)
						labelUI.visible = false;
					if(this.visible)
						this.visible = false;
					return;
				}else{
					if(labelUI&&!labelUI.visible)
						labelUI.visible = true;
					if(!this.visible)
						this.visible = true;
				}
				visableChanged = false;
			}
		}
		
		/**
		 * @private
		 */
		override public function setHighLightLevel(level:int):void{
			_highLightLevel = level;
			showHighLightChanged = true;
		}
		
		/**
		 * @private
		 */
		override public function refreshHighLight():void{
			isHighLightEnable = element.highLightEnable;
			isSecondHighLightEnable = element.secondHighLightEnable;
			super.refreshHighLight();
			
//			drawLabelSelectedStyle();
			
			/* 鼠标处于元素上方状态 */
			if(mouseOver){
				if(_glow==null)
					createGlow();
				_glow.color = element.getStyle(Styles.SELECT_COLOR);
				_glow.blurX = 8;
				_glow.blurY = 8;
				_glow.strength = 4;
				showGlow();
				return;
			}
			/* 选中状态 */
			if(isSelected){
				if(_glow==null)
					createGlow();
				_glow.color = element.getStyle(Styles.SELECT_COLOR);
				_glow.blurX = 8;
				_glow.blurY = 8;
				_glow.strength = 8;
				showGlow();
				return;
			}
			
			/* 默认值_highLightLevel超过显示颜色长度，则直接返回,如果注释掉_highLightLevel>_colors.length的限制，则超过的部分使用_colors的最后一种色. */
			if(_highLightLevel<1||_highLightLevel>_colors.length){
				if(_glow==null)
					createGlow();
				showGlow(false);
				return;
			}
			
			var _color:uint = _highLightLevel>_colors.length?
				_colors[_colors.length-1]:_colors[_highLightLevel-1];
			
			if(_glow==null)
				createGlow();
			_glow.color = _color;
			_glow.blurX = 4;
			_glow.blurY = 4;
			_glow.strength = 4;
			/* 为告警节点设置闪动效果 */
			//			if(_highLightLevel==1){
			//				if(!_blurAnim){
			//					blurAnim = new AnimateFilter(this, _glow);
			//					_blurAnim.motionPaths = Vector.<MotionPath>([new SimpleMotionPath("blurX",0,8),new SimpleMotionPath("blurY",0,8)]);
			//					blurAnim.repeatCount = 0;
			//					_blurAnim.repeatBehavior = RepeatBehavior.REVERSE;
			//				}
			//				
			//				if(!_blurAnim.isPlaying)
			//					_blurAnim.play();
			//				return;
			//			}
			//			
			//			if(blurAnim)
			//				blurAnim.end();
			showGlow();
		}
		
		//--------------------------------------------------------------------------
		//  dispose
		//--------------------------------------------------------------------------
		override public function dispose():void{
			super.dispose();
			_imageAttachment = null;
			if(labelUI!=null){
				_attachments.splice(0,_attachments.length);
				network.getLabelLayoutGroup().removeData(labelUI);
				labelUI = null;
				labelAttachment.clear();
			}
			
			if(_colors){
				_colors.splice(0,_colors.length);
				_colors = null;
			}
			
			graphics.clear();
			/*  可能有其他的对象在使用 */
			//			NodeUI.bitmapDatas[element.image].dispose();
			if(element)
			{
				removePropertyChangeListener();
				element = null;
			}
			if(network){
				network.getNodeLayoutGroup().removeData(this);
				network = null;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event
		//
		//--------------------------------------------------------------------------
		
		override protected function onPropertyChange(event:ElementPropertyChangeEvent):void{
			if(event.property!="visible"&&!this.element.visible)
				return;
			
			if(event.property.substr(0,2)=="S:"){
				//文本属性更新
				if(event.property.indexOf("label")!=-1){
					labelStyleChanged = true;
					labelChanged = true;
					updateLabelAttachmentProperties();
					refreshLabelAttachment();
					return;
				}
				if(event.property.indexOf(Styles.HIGH_LIGHT_COLOR)!=-1){
					_highLightGlow = null;
				}
				contentType = element.getStyle(Styles.CONTENT_TYPE);
				updateProperties();
				return;
			}
			
			if(event.property.substr(0,2)=="C:"){
				drawContent();
				return;
			}
			var callMeasure:Boolean = false;
			switch(event.property)
			{
				case "x":
					coordinateHandler(1);
					drawContent();
					callMeasure = true;
					break;
				case "y":  
					coordinateHandler(2);
					drawContent();
					callMeasure = true;
					break;
				case "xy":  
					coordinateHandler(0);
					drawContent();
					callMeasure = true;
					break;
				case "location":  
					coordinateHandler(0);
					drawContent();
					callMeasure = true;
					break;
				case "rotation": 	
					drawContent(); 
					callMeasure = true;
					break;
				case "width":
					sizeChanged = true;
					drawContent(); 
					callMeasure = true;
					break;
				case "height":
					sizeChanged = true;
					drawContent();
					callMeasure = true;
					break;
				case "image":		
					imageChanged=true;
					updateImageAttachmentProperties();
					drawContent();
					callMeasure = true;
					break;
				case ElementPropertyChangeEvent.IMAGE_LOADED:
					imageChanged=true;
					if(_imageAttachment)
						_imageAttachment.loading = false;
					updateImageAttachmentProperties();
					drawContent();
					callMeasure = true;
					break;
				case "label": 		
					labelChanged= true;
					updateLabelAttachmentProperties();
					refreshLabelAttachment();
					callMeasure = true;
					break;
				case "toolTip":
					if(this.toolTip!=element.toolTip)
						this.toolTip = element.toolTip;
					break;
				case "visible":
					visableChanged = true;
					refreshAttachmentVisible();
					break;
				case "layerID":
					var elementLayoutGroup:* = network.getLayerCanvasByElement(element);
					if(elementLayoutGroup==null)
						elementLayoutGroup = network.getDefaultLayoutGroupByElementUI(this);
					if(!elementLayoutGroup.containsElement(this))
						elementLayoutGroup.addElement(this);
					break;
				case "highLightEnable":
					refreshLabelAttachment();
					refreshHighLight();
					break;
				case "secondHighLightEnable":
					refreshLabelAttachment();
					refreshHighLight();
					break;
				default: drawContent();return;
			}
			//			event.stopImmediatePropagation();
			if(callMeasure)
				unionBoundRectangle  = null;
		}
		
		
		/**
		 * 快捷的方式获得BitmapData对象,该方法节省了大量重复内存(500个节点，没有使用连接,测试使用了8M内存；否则,使用27M左右内存.)
		 */
		private function createNewBitmapData():void{
			bitmapData = NodeUI.bitmapDatas[element.image]; 
			if(bitmapData==null){
				var bw:Number =  imageAttachment.content.width,bh:Number = imageAttachment.content.height;
				var totalPixel:Number = bw*bh;
				if(totalPixel>16777215){
					var testZoom:Number;
					testZoom = Math.sqrt(16777200/(bw*bh));
					bw = bw*testZoom;
					bw = bw*testZoom;
					element.imageWidth = bw;
					element.imageHeight = bh;
					isAdjusted = true;
				}
				if(bitmapData)
					bitmapData.dispose();
				else
					bitmapData = new BitmapData(bw,bh,true,0);
				bitmapData.draw(imageAttachment.content);
				NodeUI.bitmapDatas[element.image] =	bitmapData;
			}
			
		}
		private var isAdjusted:Boolean =false;
		
		private var matrixScale:Number = 1;
		
		protected function checkSize():void{
			
			if(contentType==Consts.CONTENT_TYPE_VECTOR){
				element.imageHeight = element.height;
				element.imageWidth = element.width;
			}
			else{
				var elementScaleRatio:Number =  element.width/element.height;
				//当手动设置width和height的值后，如果设置的width比height增加多,以高度的显示值作为界面图形的高度值,反之亦然.
				if(!isAdjusted){
					if(elementScaleRatio>_sourceImageRatio){
						element.imageHeight = element.height;
						matrixScale = element.height/imageAttachment.content.height;
						element.imageWidth = imageAttachment.content.width*matrixScale;
					}else if(elementScaleRatio<_sourceImageRatio){
						element.imageWidth = element.width;
						matrixScale = element.width/imageAttachment.content.width;
						element.imageHeight = imageAttachment.content.height*matrixScale;
					}else{
						matrixScale = element.width/imageAttachment.content.width;
						element.imageWidth = element.width*matrixScale;
						element.imageHeight = element.height*matrixScale;
						//或者
						//matrixScale = element.height/imageAttachment.content.height;
					}
				}else{
					matrixScale = element.imageWidth/imageAttachment.content.width;
				}
			}
			
			if(element.imageWidth<1)
				element.imageWidth = 1;
			
			if(element.imageHeight<1)
				element.imageHeight = 1;
			
			nodeHeight = labelAttachment?labelAttachment.content.y-element.y+labelAttachment.content.height:element.imageHeight;
			nodeWidth = labelAttachment?(labelAttachment.content.width>element.imageWidth)?labelAttachment.content.width:element.imageWidth:element.imageWidth;
			if(nodeHeight<0)
				nodeHeight = 0;
			if(nodeWidth<0)
				nodeWidth = 0;
			element.nodeWidth = nodeWidth;
			element.nodeHeight = nodeHeight
				
			leftMostPoint.x = labelAttachment?labelAttachment.content.x>element.x?labelAttachment.content.x:element.x:element.x;
			leftMostPoint.y = labelAttachment?labelAttachment.content.y>element.y?labelAttachment.content.y:element.y:element.y;
			
			rightMostPoint.x = labelAttachment?(labelAttachment.content.x+labelAttachment.content.width)>(element.x+element.width)?
				(labelAttachment.content.x+labelAttachment.content.width):(element.x+element.width):(element.x+element.width);
			rightMostPoint.y =  labelAttachment?(labelAttachment.content.y+labelAttachment.content.height)>(element.y+element.imageHeight)?
				(labelAttachment.content.y+labelAttachment.content.height):(element.y+element.imageHeight):(element.y+element.imageHeight);
			
			sizeChanged = false;
		}
		
		/**
		 * 设置选中的组件外观,暂未使用
		 */
		protected function drawLabelSelectedStyle():void{
//			if(!mouseOver||labelAttachment==null)
//				return;
//			
//			if(element.label==null||element.label=="")
//				return;
//			graphics.beginFill(network.backgroundGroup.backgroundColor[0],1);
//			graphics.drawRoundRect(labelAttachment.content.x-2,labelAttachment.content.y,labelAttachment.content.textWidth+8,labelAttachment.content.height,5,5);
//			graphics.endFill();
		}
		
		private var showHighLightChanged:Boolean = false;
		private var _highLightLevel:int = 0;
		private var _colors:Vector.<uint>;
		
		//--------------------------------------------------------------------------
		//  setHighLightLevel
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  drawVectorContent
		//--------------------------------------------------------------------------
		protected function drawVectorContent() : void
		{
			graphics.clear();
			if(!boundaryChecked){
				boundaryChecked = true;
				coordinateHandler(0);
			}
			var fillColor:Number = NaN;
			var deep:Number = NaN;
			var _e:* = this.element;
			var vectorShape:* = _e.getStyle(Styles.VECTOR_SHAPE);
			var vectorFill:* = _e.getStyle(Styles.VECTOR_FILL);
			if(labelAttachment){
				refreshLabelAttachment();
			}
			
			if(sizeChanged)
				checkSize();
				
			//Vector使用width和height，不使用nodeWidth和nodeHeight。因为去掉了label占用的空间。
			var vectorRect:* = this.element.vectorRect;
			
			ElementUtil.addPadding(vectorRect, element, Styles.VECTOR_PADDING);
			if (element.getStyle(Styles.INNER_STYLE) == Consts.INNER_STYLE_DYE)
			{
				if (innerColor is Number)
				{
					if (!ElementUtil.hasDefault(_e))
					{
						fillColor = Number(innerColor);
					}
				}
				else
				{
					fillColor = _e.getStyle(Styles.VECTOR_FILL_COLOR);
				}
			}
			var outlinePattern:* = _e.getStyle(Styles.VECTOR_OUTLINE_PATTERN);
			if (outlinePattern != null)
			{
				var temp:* = outlinePattern.length > 0;
				if (temp)
				{
					beginFill( vectorFill, fillColor, vectorRect);
					drawShape( vectorRect, vectorShape, false, false);
					endFill( vectorFill);
					drawShape( vectorRect, vectorShape, true, true);
				}
			}
			else
			{
				beginFill(vectorFill, fillColor, vectorRect);
				drawShape( vectorRect, vectorShape, true, false);
				endFill( vectorFill);
			}
			
			if (vectorFill)
			{
				deep = _e.getStyle(Styles.VECTOR_DEEP);
				if (deep != 0)
				{
					if (vectorShape == Consts.SHAPE_RECTANGLE)
					{
						GraphicDrawHelper.draw3DRect(graphics, fillColor, deep, vectorRect.x, vectorRect.y, vectorRect.width, vectorRect.height);
					}
				}
			}
			_nodeWidth = vectorRect.width;
			_nodeHeight =  vectorRect.height;
			element.nodeWidth = vectorRect.width;
			element.nodeHeight =  vectorRect.height;
			return;
		}
		
		private function beginFill(fill:Boolean, fillColor:Number, rect:Rectangle) : void
		{
			var _rect:Rectangle = null;
			if (fill)
			{
				_rect = element.getStyle(Styles.VECTOR_GRADIENT_RECT);
				if (_rect == null)
				{
					_rect = rect;
				}
				GraphicDrawHelper.beginFill(graphics, fillColor, element.getStyle(Styles.VECTOR_FILL_ALPHA), _rect.x, _rect.y, _rect.width, _rect.height, element.getStyle(Styles.VECTOR_GRADIENT), element.getStyle(Styles.VECTOR_GRADIENT_COLOR), element.getStyle(Styles.VECTOR_GRADIENT_ALPHA));
			}
			return;
		}
		
		protected function drawShape(rect:Rectangle, shape:String, isOutlineWidth:Boolean, isOutlinePattern:Boolean) : void
		{
			var outLineWidth:* = isOutlineWidth ? (element.getStyle(Styles.VECTOR_OUTLINE_WIDTH)) : (-1);
			var outLinePattern:* = isOutlinePattern ? (element.getStyle(Styles.VECTOR_OUTLINE_PATTERN)) : (null);
			if (outLineWidth >= 0)
			{
				graphics.lineStyle(outLineWidth, element.getStyle(Styles.VECTOR_OUTLINE_COLOR), element.getStyle(Styles.VECTOR_OUTLINE_ALPHA), element.getStyle(Styles.VECTOR_PIXEL_HINTING), element.getStyle(Styles.VECTOR_SCALE_MODE), element.getStyle(Styles.VECTOR_CAPS_STYLE), element.getStyle(Styles.VECTOR_JOINT_STYLE));
			}
			else
			{
				graphics.lineStyle();
			}
			GraphicDrawHelper.drawShape(graphics, shape, rect.x, rect.y, rect.width, rect.height, element.getStyle(Styles.VECTOR_ROUNDRECT_RADIUS), outLinePattern);
		}// end function
		
		protected function endFill(fill:Boolean) : void
		{
			if (fill)
			{
				graphics.endFill();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		// 节点调整
		//
		//--------------------------------------------------------------------------
		/**
		 * x小于等于1和y小于等于1时，为最低控制线，不允许再减少。<br>
		 * x大于主容器rootGroup的最大宽度和y大于画布的最大高度时，允许动态更改画布大小以支持显示。
		 * 最大节点坐标需要加上节点的宽度或高度，而最小坐标节点无需添加宽度或高度。
		 * @param type=1,类型为x; type=2,类型为y，type=0时，x和y都包括.
		 */
		protected function coordinateHandler(type:int):void{
			var currentLock:Boolean = element.isLock;
			element.isLock = true;
				/* X轴 */
				if(type==0||type==1){
					if(!network.isReferenceNodeInited){
						if(network.maxXPointNode==null)
							network.maxXPointNode = element;
						if(network.minXPointNode==null)
							network.minXPointNode = element;
						network.minPoint.x = 9999;
						network.isReferenceNodeInited = true;
					}
					
					if(element.x<1){
						element.x = 1;
						if(!element.isLock)
							return;
					}
					
					if(!element.visible)
						return;
					
					/*大于容器的高度,属于超出屏幕的节点*/
					if(element.x+nodeWidth+nodeSpace>network.width){
						/* 禁止水平滚动条 */
						if(network.horizontalScrollPolicy==ScrollPolicy.OFF){
							element.x = network.width-nodeWidth;
							/* 重置界面 */
							drawContent();
							return;
						}
						
						/*当前x值为所有节点中最大*/
						if(element.x+nodeWidth>network.maxPoint.x){
							network.maxPoint.x = element.x+nodeWidth;
							network.maxXPointNode = element;
							refreshScroll(MaxPointEvent.INCREASE);
						}
						/*或者当前为最大X轴节点，但正在减少x值，需要刷新滚动条*/
						else if(network.maxXPointNode==element){
							if(element.x+nodeWidth<network.maxPoint.x){
								//判断是否仍存在X值大于当前节点，存在时则返回
								var findMaxNode:Boolean = false;
								for each(var n:Node in network.outOfBoundXNodeVector){
									if(n!=element&&(n.x+n.nodeWidth)>(network.maxXPointNode.x+network.maxXPointNode.nodeWidth)){
										network.maxPoint.x = n.x+n.nodeWidth;
										network.maxXPointNode = n;
										findMaxNode = true;
										break;
									}
								}
								if(!findMaxNode){
									network.maxPoint.x = element.x+nodeWidth;
									refreshScroll(MaxPointEvent.DECREASE);
								}
							}
						}
						
						//添加进超出屏幕的节点集
						if(network.outOfBoundXNodes[element.id]==null){
							network.outOfBoundXNodes[element.id] = element;
							network.outOfBoundXNodeVector.push(element);
						}
					}
					/* 属于超出X轴的节点 */
					else if(network.outOfBoundXNodes[element.id]!=null){
						refreshScroll(MaxPointEvent.DELETE);
					}
					
					//需要再次判断，以免x值并没有超出屏幕，但Node.maxPoint.x却没有值。
					if(element.x+nodeWidth>network.maxPoint.x){
						network.maxPoint.x = element.x+nodeWidth;
						network.maxXPointNode = element;
//						不刷新界面
//						refreshScroll(MaxPointEvent.INCREASE);
					}
					//赋值最小节点,最小X坐标不需要设置nodeWidth。
					if(element.x<network.minPoint.x){
						network.minPoint.x = element.x;
						network.minXPointNode = element;
					}
				}

				/* Y轴 */
				if(type==0||type==2){
					if(!network.isReferenceNodeInited){
						if(network.maxYPointNode==null)
							network.maxYPointNode = element;
						if(network.minYPointNode==null)
							network.minYPointNode = element;
						network.minPoint.y = 9999;
						network.isReferenceNodeInited = true;
					}
					
					if(element.y<1){
						element.y = 1;
						if(!element.isLock)
							return;
					}
					
					if(!element.visible)
						return;
					
					/*大于容器的高度,属于超出屏幕的节点*/
					if(element.y+nodeHeight+nodeSpace>network.height){
						/* 禁止垂直滚动条 */
						if(network.verticalScrollPolicy==ScrollPolicy.OFF){
							element.y = network.height-nodeHeight;
							/* 重置界面 */
							drawContent();
							return;
						}
						
						/*当前y值为所有节点中最大*/
						if(element.y+nodeHeight>network.maxPoint.y){
							network.maxPoint.y = element.y+nodeHeight;
							network.maxYPointNode = element;
							refreshScroll(MaxPointEvent.INCREASE,false);
						}
						/*或者当前为最大Y轴节点，但可能y值减少了，需要刷新滚动条*/
						else if(network.maxYPointNode==element){
							if(element.y+nodeHeight<network.maxPoint.y){
								//判断是否仍存在X值大于当前节点，存在时则返回
								findMaxNode = false;
								for each(n in network.outOfBoundYNodeVector){
									if(n!=element&&(n.y+n.nodeHeight)>(network.maxYPointNode.y+network.maxYPointNode.nodeHeight)){
										network.maxPoint.y = n.y+n.nodeHeight;
										network.maxYPointNode = n;
										findMaxNode = true;
										break;
									}
								}
								if(!findMaxNode){
									network.maxPoint.y = element.y+nodeHeight;
									refreshScroll(MaxPointEvent.DECREASE,false);
								}
							}
						}
						
						if(network.outOfBoundYNodes[element.id]==null){
							network.outOfBoundYNodes[element.id] = element;
							network.outOfBoundYNodeVector.push(element);
						}
					}else if(network.outOfBoundYNodes[element.id]!=null){
						refreshScroll(MaxPointEvent.DELETE,false);
					}
					
					//需要再次判断，以免y值并没有超出屏幕，但Node.maxPoint.y却没有值。
					if(element.y+nodeHeight>network.maxPoint.y){
						network.maxPoint.y = element.y+nodeHeight;
						network.maxYPointNode = element;
					}
					//赋值最小节点,最小Y坐标不需要设置nodeHeight。
					if(!network.isMinPointInited||element.y<network.minPoint.y){
						network.minPoint.y = element.y;
						network.minYPointNode = element;
					}
				}
				
				if(!network.isMinPointInited)
					network.isMinPointInited = true;
			element.isLock = currentLock;
		}

		
		
		/**
		 * 节点距离屏幕右侧或底部的空隙,默认为50.
		 */
		public var nodeSpace:int = 50;
		
		public function refreshScroll(eventType:String,isX:Boolean = true):void{
			switch(eventType){
				case MaxPointEvent.INCREASE:
					//大于屏幕显示范围
					if(isX){
						if((network.maxPoint.x+nodeSpace)>network.rootGroupWidth){
							network.setRootGroupSize(network.maxPoint.x+nodeSpace+this.horizontalScrollerIncrement,"width");//额外增加300作扩充
						}
					}else{
						if((network.maxPoint.y+nodeSpace)>network.rootGroupHeight){
							network.setRootGroupSize(network.maxPoint.y+nodeSpace+this.verticalScrollerIncrement,"height");//额外增加300作扩充
						}
					}
					break;
				case MaxPointEvent.DECREASE:
					var _maxPoint:Point = new Point();
					var _maxXPointNode:Node;
					var _maxYPointNode:Node;
					if(isX){
						if(network.maxXPointNode.x+nodeSpace+this.horizontalScrollerIncrement<network.rootGroupWidth){
							network.setRootGroupSize(network.maxPoint.x+nodeSpace,"width");
						}
					}else{
						if(network.maxYPointNode.y+nodeSpace+this.verticalScrollerIncrement<network.rootGroupHeight){
							network.setRootGroupSize(network.maxPoint.y+nodeSpace,"height");
						}
					}

					break;
				case MaxPointEvent.DELETE:
					if(isX){
						/*删除对比引用*/
						if(network.outOfBoundXNodes[element]==null)
							return;
						
						delete network.outOfBoundXNodes[element];
						/*删除节点集合引用*/
						for(var i:int=0;i<network.outOfBoundXNodeVector.length;i++){
							if(network.outOfBoundXNodeVector[i]==element){
								network.outOfBoundXNodeVector.splice(i,1);
								break;
							}
						}
					}else{
						/*删除对比引用*/
						if(network.outOfBoundYNodes[element]==null)
							return;
						delete network.outOfBoundYNodes[element];
						/*删除节点集合引用*/
						for(i=0;i<network.outOfBoundYNodeVector.length;i++){
							if(network.outOfBoundYNodeVector[i]==element){
								network.outOfBoundYNodeVector.splice(i,1);
								break;
							}
						}
					}
					break;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  getter setter
		//
		//--------------------------------------------------------------------------
		public function get imageAttachment():ImageAttachment
		{
			return _imageAttachment;
		}
		
		public function get bodyRect() : Rectangle
		{
			return element.rect;
		}

		public function get nodeWidth():Number
		{
			return isNaN(_nodeWidth)?0:_nodeWidth;
		}

		public function set nodeWidth(value:Number):void
		{
			_nodeWidth = value;
		}

		public function get nodeHeight():Number
		{
			return _nodeHeight;
		}

		public function set nodeHeight(value:Number):void
		{
			_nodeHeight = value;
		}


	}
}