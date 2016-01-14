package com.myflexhero.network
{
	import com.myflexhero.network.core.ICustomLayout;
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.core.IElement;
	import com.myflexhero.network.core.IElementUI;
	import com.myflexhero.network.core.ILayer;
	import com.myflexhero.network.core.ILayoutManager;
	import com.myflexhero.network.core.animate.ScaleEffect;
	import com.myflexhero.network.core.image.ImageLoader;
	import com.myflexhero.network.core.image.ImageUtils;
	import com.myflexhero.network.core.layout.AutoLayout;
	import com.myflexhero.network.core.layout.SpringLayout;
	import com.myflexhero.network.core.ui.Attachment;
	import com.myflexhero.network.core.ui.ElementUI;
	import com.myflexhero.network.core.ui.FloorUI;
	import com.myflexhero.network.core.ui.GridUI;
	import com.myflexhero.network.core.ui.GroupUI;
	import com.myflexhero.network.core.ui.KPICardUI;
	import com.myflexhero.network.core.ui.LinkUI;
	import com.myflexhero.network.core.ui.NodeUI;
	import com.myflexhero.network.core.ui.QuadrilateralGroupUI;
	import com.myflexhero.network.core.ui.RoundPipeUI;
	import com.myflexhero.network.core.ui.SmallNodeUI;
	import com.myflexhero.network.core.ui.SquarePipeUI;
	import com.myflexhero.network.core.ui.WallUI;
	import com.myflexhero.network.core.util.ElementUtil;
	import com.myflexhero.network.core.util.resize.HandleRoles;
	import com.myflexhero.network.core.util.resize.ObjectHandles;
	import com.myflexhero.network.core.util.resize.VisualElementHandle;
	import com.myflexhero.network.core.util.select.SelectHelper;
	import com.myflexhero.network.event.DataBoxChangeEvent;
	import com.myflexhero.network.event.InteractionEvent;
	import com.myflexhero.network.event.MaxPointEvent;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.CloseEvent;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.events.ResizeEvent;
	import mx.graphics.GradientEntry;
	import mx.graphics.LinearGradient;
	import mx.graphics.SolidColor;
	import mx.styles.IStyleClient;
	import mx.utils.object_proxy;
	
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.components.Scroller;
	import spark.effects.Fade;
	import spark.effects.Scale;
	import spark.filters.GlowFilter;
	import spark.primitives.Rect;
	import spark.skins.spark.ScrollerSkin;

	use namespace mx_internal;
	/**
	 * 组件基类，Network层只有一个单类(Network.as),作为整个图形组件的入口类，代表着整个图形组件。该类直接对用户开放，提供相应的公开属性和方法供用户调用。
	 * <p>
	 * Network类提供以下功能点：
	 * <ul>
	 * <li>设置自动布局器类型(树型自动布局、弹力自动布局)。</li>
	 * <li>设置可视对象是否可拖动。</li>
	 * <li>设置可视对象是否可改变尺寸大小。</li>
	 * <li>设置是否开启动态创建Link元素。</li>
	 * <li>导出当前图形界面为图片格式(png格式)。</li>
	 * <li>设置诸如背景颜色、透明度等属性。</li>
	 * </ul>
	 * </p>
	 * <p>
	 * Network类实现了以下逻辑：
	 * <ul>
	 * <li>完成对DataBox层的监听，调用ElementUI完成DataBox层数据的新增、修改、删除等事件处理。</li>
	 * <li>控制EelementUI层元素的新增、修改、删除操作，并调用其公开方法完成图形展示、图形清除等操作。</li>
	 * </ul>
	 * </p>
	 * Network容器关系如下:
	 * <pre>
	 * |rootGroup
	 * 		|backgroundGroup
	 * 		|scroller
	 * 			|scrollerGroup
	 * 				|dataGroup
	 * 					|bottomGroup
	 * 					|attachmentGroup
	 * 							|nodeGroup
	 * 							|linkGroup
	 * 							|layerGroup
	 * 					|topGroup
	 * 		|customGroup
	 * </pre>
	 * Network图形组件中的很多功能和TWaver组件类似，所以TWaver的开发文档和帮助手册同样可作为部分参考.
	 * <p>
	 * If you find any bugs please contact our developer(Hedy):78474497#qq.com
	 * </p>
	 * @author Hedy
	 */
	public class Network extends Group
	{
		//***************************************************************************************
		//
		//    内部及外部变量
		//
		//***************************************************************************************
		/**
		 * 控制布局，用于_scroller的滚动条调整，使修改_rootGroup的尺寸而不影响滚动条的显示。
		 */
		private var _scrollerGroup:Group;
		/**
		 * 基础布局层
		 */
		private var _rootGroup:BasicGroup;
		private var _topGroup:BasicGroup;
		/**
		 * 该Group有2个子BasicGroup组件，一个放置Link(index=0)，一个放置Node(index=1)。
		 */
		private var _attachmentGroup:BasicGroup;
		/**
		 * 默认放置节点Node
		 */
		private var _nodeGroup:BasicGroup;
		/**
		 * 默认放置线条Link
		 */
		private var _linkGroup:BasicGroup;
		/**
		 * 放置layer的顶级容器
		 */
		private var _layerGroup:BasicGroup;
		private var _bottomGroup:BasicGroup;
		private var _backgroundGroup:BasicGroup;
		/**
		 * 可供自定义调用addElement方法传入子组件的容器。
		 */
		private var _customGroup:BasicGroup;
		private var _dataGroup:BasicGroup;
		/**
		 * 背景颜色,传入Array数组,其内为uint类型。如果为渐变效果，请设置backgroundColorLinear属性为true，并传入多个颜色值,否则，只传一个颜色值。
		 */
		private var _backgroundColor:Array;
		private var _backgroundColorChanged:Boolean = false;
		/**
		 * 背景颜色是否使用渐变效果
		 */
		private var _backgroundColorLinear:Boolean = true;
		private var _backgroundColorLinearChanged:Boolean = false;
		/**
		 * 背景颜色的透明度
		 */
		private var _backgroundColorAlpha:Number = 1;
		private var _backgroundColorAlphaChanged:Boolean = false;
		/**
		 * 背景图片
		 */
		private var _backgroundImage:String;
		private var _backgroundImageChanged:Boolean = false;
		/**
		 * 数据元素容器
		 */
		private var _elementBox:ElementBox;
		
		/**
		 * 通过该对象可控制组件的移动、改变大小
		 */
		public var resizeHandles:ObjectHandles;
		
		/**
		 * 通过该对象可控制组件的移动、改变大小
		 */
		public var moveHandles:ObjectHandles;
		
		/**
		 * elementUI集合
		 */
		private var _elementUICollection:Dictionary;
		
		/**
		 * 层集合
		 */
		public var _layerCollection:Dictionary;
		
		/**
		 * 布局事件判断的集合,都是以"布局名称_事件类型"的方式存储,如"attachmentGroup_resizable",存储为布尔类型。
		 */
		private var layoutEvent:Dictionary;
		
		/**
		 * 自动布局管理器
		 */
		private var _autoLayout:AutoLayout = null;
		/**
		 * 自动布局器
		 */
		private var _currentAutoLayout:ICustomLayout = null;
		
		/**
		 * 滚动组件
		 */
		private var _scroller:Scroller;
		
		/**
		 * getLink方法专用,快捷的方式返回节点对应的link对象.
		 */
		private var _linkDictionary:Dictionary;
		/**
		 * 是否鼠标处于按下状态
		 */
		private var isMouseDown:Boolean = false;
		
		private var _selectedElements:Vector.<Element>;
		
		/**
		 * 临时变量，作为上一次选中的节点引用.
		 */
		private var _oldSelectedElements:Vector.<Element>;
		
		/**
		 * 当前的子显示对象,默认为null,双击SubNetwork对象将显示其子集，并隐藏其他不相干的节点.
		 */
		public var currentSubNetwork:SubNetwork;
		
		/**
		 * 放大缩小的Effect类
		 */
		public var scaleEffect:ScaleEffect;
		/**
		 * 图片加载器引用
		 */
		private var _imageLoader:ImageLoader;
		/**
		 * 
		 */
		private var networkSelectOutlineWidth:Number;
		/**
		 * 多选择提示的线条颜色
		 */
		private var networkSelectOutlineColor:Number;
		
		private var networkSelectFillAlpha:Number;
		
		private var networkSelectFillColor:Number;
		
		private var networkTransparentSelectionEnable:Boolean;
		
		private var networkSelectionTolerance:int;
		
		private var _selectHelper:SelectHelper;
		/**
		 * 鼠标进行多选时操作时，是否添加对元素的附件进行计算,默认为false。
		 */
		public var isMultiSelectUseAttachment:Boolean = false;
		//***************************************************************************************
		//
		//    构造
		//
		//***************************************************************************************
		/**
		 * 默认构造方法。
		 * @param elementBox 可以传入自定义的数据容器。如果为空，将由程序新建一个数据容器。
		 */
		public function Network(elementBox:ElementBox = null)
		{
			networkSelectOutlineColor = Defaults.NETWORK_SELECT_OUTLINE_COLOR;
			networkSelectOutlineWidth = Defaults.NETWORK_SELECT_OUTLINE_WIDTH;
			networkSelectFillColor = Defaults.NETWORK_SELECT_FILL_COLOR;
			networkSelectFillAlpha = Defaults.NETWORK_SELECT_FILL_ALPHA;
			networkTransparentSelectionEnable = Defaults.NETWORK_TRANSPARENT_SELECTION_ENABLE;
			networkSelectionTolerance = Defaults.NETWORK_SELECTION_TOLERANCE;
			_selectHelper = new SelectHelper(this);
			
			_selectedElements = new Vector.<Element>();
			
			/* 数据临时集合 */
			_elementUICollection = new Dictionary();
			_layerCollection = new Dictionary();
			_linkDictionary = new Dictionary();
			_imageLoader = new ImageLoader();
			_rootGroup = createLayoutGroup("rootGroup",true,true);
			_topGroup = createLayoutGroup("topGroup",false,true);
			_attachmentGroup =  createLayoutGroup("attachmentGroup");
			_layerGroup = createLayoutGroup("layerGroup",true,true);
			_nodeGroup = new BasicGroup("nodeGroup",true);
			_linkGroup = new BasicGroup("linkGroup",true);
			_bottomGroup =  createLayoutGroup("bottomGroup",false,true);
			_backgroundGroup = createLayoutGroup("backgroundGroup",false,true);
			_customGroup =  createLayoutGroup("customGroup",true,true);
			_dataGroup =  createLayoutGroup("dataGroup",true,true);
			_scrollerGroup = new Group();
			_backgroundColor = [];
			_backgroundGroup.setBackgroudGroupEnable(true);
			/**
			 * _rootGroup
			 * 		_backgroundGroup
			 * 		_scroller
			 * 			_scrollerGroup
			 * 				_dataGroup
			 * 					_bottomGroup
			 * 					_attachmentGroup
			 * 							_nodeGroup
			 * 							_linkGroup
			 * 							_layerGroup
			 * 					_topGroup
			 * 		_customGroup
			 */
			_rootGroup.addElement(_backgroundGroup);
			_dataGroup.addData(_bottomGroup);
			_attachmentGroup.addData(_nodeGroup);
			_attachmentGroup.addData(_linkGroup);
			_attachmentGroup.addData(_layerGroup);
			_dataGroup.addData(_attachmentGroup);
			_dataGroup.addData(_topGroup);
			_scrollerGroup.addElement(_dataGroup);
			/* 设置滚动条为自动显示 */
			_scroller = new Scroller();
			_scroller.percentWidth = 100;
			_scroller.percentHeight = 100;//水平滚动条不出现时，可能是_scroller高度设置过低。使滚动条不可见。
//			horizontalScrollPolicy = "off";
//			verticalScrollPolicy = "off";
			_scroller.viewport = _scrollerGroup;
			
			var t:* = _scroller.getStyle("skinClass");
			if(t==undefined){
				_scroller.setStyle("skinClass",ScrollerSkin);
			}
			
			//直接添加_scrollerGroup而非滚动条的_scroller
			_rootGroup.addElement(_scrollerGroup);
			_rootGroup.addElement(_customGroup);
			this.addElement(_rootGroup);
			
			this.mouseEnabled = true;
			this.doubleClickEnabled = true;
			this.addEventListener(KeyboardEvent.KEY_DOWN,onKeyboardDown);
			this.addEventListener(MouseEvent.DOUBLE_CLICK,onNetworkDoubleClick);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onNetworkMouseDown,false,0);
			this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			this.addEventListener(ResizeEvent.RESIZE,resizeInitHandler);
			
			//默认不激活，待允许移动或resize时再激活
//			_selectHelper.init(this);
					
			_rootGroup.addEventListener(ResizeEvent.RESIZE,rootResizeHandler);
			_dataGroup.addEventListener(ResizeEvent.RESIZE,dataGroupResizeHandler);

			/* 数据容器 */
			if (elementBox == null)
			{
				elementBox = new ElementBox();
			}
			this.elementBox = elementBox;
			scaleEffect = new ScaleEffect([_dataGroup],elementBox.forEach);
			
			//避免窗口重复关闭打开后，静态变量重置默认值。
			this.reset();
			
			this.addEventListener( Event.ADDED_TO_STAGE, registerListeners);
			showHandCursor();
		}
		
		
		[Embed(source="assets/hand/openHand.png")]
		private var openHand:Class;
		
		[Embed(source="assets/hand/closeHand.png")]
		private var closeHand:Class;
		
		private var cursorID:int;
		private var _useDefaultHandCursor:Boolean = false;

		/**
		 * 由于超过1100个节点时，使用自定义光标且滑动鼠标时光标移动变得缓慢，所以通过设置该字段来开启是否使用系统自带手型光标,默认不使用自带的.
		 */
		public function get useDefaultHandCursor():Boolean
		{
			return _useDefaultHandCursor;
		}

		/**
		 * @private
		 */
		public function set useDefaultHandCursor(value:Boolean):void
		{
			if(isMouseOverEventListenerAdded)
				this.removeEventListener(MouseEvent.MOUSE_OVER,onNetworkMouseOver);
			_useDefaultHandCursor = value;
			showHandCursor(!_selectHelper.isActived);
		}
		
		/**
		 * 是否已对network添加了MouseOver事件监听
		 */
		private var isMouseOverEventListenerAdded:Boolean = false;
		/**
		 * 默认显示手型光标
		 */
		public function showHandCursor(value:Boolean=true):void{
			//大于1100个节点时使用默认光标,否则光标移动变得缓慢
			if(_useDefaultHandCursor){
				this.useHandCursor = this.buttonMode = value;
				return;
			}
			
			if(value){
				this.addEventListener(MouseEvent.MOUSE_OVER,onNetworkMouseOver);
				isMouseOverEventListenerAdded = true;
			}
			else{
				this.removeEventListener(MouseEvent.MOUSE_OVER,onNetworkMouseOver);
				isMouseOverEventListenerAdded = false;
				cursorManager.removeAllCursors();
			}
//			this.useHandCursor = this.buttonMode = value;
		}
		// Helpers
		private function registerListeners( event : Event ) : void
		{
			// Panning
			this.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			this.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			
			// Mouse wheel support for zooming
			this.addEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheel,false,100);
			
			// Keyboard support for zooming
//			stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown )			
		}
		
		// Event Handlers
		private function onMouseWheel( event : MouseEvent ) : void
		{
			// set the origin of the transformation
			// to the current position of the mouse
			var originX : Number = this.width/2;
			var originY : Number = this.height/2;
			
			// zoom
			if( !event.altKey )
			{
				if( event.delta > 0 )
				{					
					// zoom in
					scaleAt( 6/5, originX, originY ) ;
				}
				else
				{
					// zoom out					
					scaleAt( 5/6, originX, originY );
				}
			}
//			else
//			{
//				// rotate
//				rotateAt( event.delta / 20, originX, originY )
//			}
			event.stopImmediatePropagation();
		}
		
		private var affineTransform : Matrix;
		// Transformations
		public function scaleAt( scale : Number, originX : Number, originY : Number ) : void
		{
			// get the transformation matrix of this object
			affineTransform = _dataGroup.transform.matrix;
			
			// move the object to (0/0) relative to the origin
			affineTransform.translate( -originX, -originY );
			// scale
			affineTransform.scale( scale, scale );
			
			// move the object back to its original position
			affineTransform.translate( originX, originY );
			
			
			if(affineTransform.a<0.01||affineTransform.a>100)
				return;
			// apply the new transformation to the object
			_dataGroup.transform.matrix = affineTransform;
//			trace("x:"+_dataGroup.x+",y:"+_dataGroup.y)
		}
		
		/**
		 * 当前是否属于拖动界面操作.
		 */
		private var isNetworkDragActived:Boolean = false;
		private var networkDragBeginPoint:Point = new Point();
		private var dataGroupBeginPoint:Point = new Point();
		
		/**
		 * 允许通过点击空白处(Network区域之内)将重置当前的选中状态(Resize)
		 */
		private function onNetworkMouseDown(event:MouseEvent):void{
			//当前selectHelper为激活状态
			if(_selectHelper.isActived){
				//当前点击对象为network，而非ElementUI(向上传递的事件)。
				if(event.target is Group&&event.currentTarget==this){
					//清除选中的对象
					if(resizeHandles&&selectedElements.length>0){
						for each(var element:Element in selectedElements){
							resizeHandles.unSelected(element);
						}
					}
					if(selectedElements.length>0)
						setSelectedElements();
					//派发点击背景事件
					dispatchEvent(new InteractionEvent(InteractionEvent.CLICK_BACKGROUND,this,event,null));//派发点击背景事件。即未点击元素。
				}
				//清空当前状态.可能是鼠标划出了network显示区域.再次点击时去除已有的.
				if(_selectHelper.isMarkShowing)
					_selectHelper.clearMouseUp();
			}else{
				startDragNetwork();
			}
		}
		
		private function startDragNetwork():void{
			//属于拖动界面操作,先清空选中的对象外观(可能是选中节点后，取消了resize或move，所以对象外观未能及时清除).
			if(selectedElements.length>0)
				setSelectedElements();
			//开始拖拽界面
			isNetworkDragActived = true;
			if(!useDefaultHandCursor){
				cursorManager.removeAllCursors();
				cursorID = cursorManager.setCursor(closeHand);
			}
			networkDragBeginPoint.x = _rootGroup.mouseX;
			networkDragBeginPoint.y = _rootGroup.mouseY;
			dataGroupBeginPoint.x = _dataGroup.x;
			dataGroupBeginPoint.y = _dataGroup.y;
			this.addEventListener(MouseEvent.MOUSE_UP,onNetworkMouseUp);
		}
		
		/**
		 * 当按下的鼠标在Network内被释放时,显示open手型光标
		 */
		private function onNetworkMouseUp(event:MouseEvent):void{ 
			this.removeEventListener(MouseEvent.MOUSE_UP,onNetworkMouseUp);
			isNetworkDragActived = false;
			if(!useDefaultHandCursor){
				cursorManager.removeAllCursors();
				cursorID = cursorManager.setCursor(openHand);
			}
		}
		
		/**
		 * 当鼠标进入了Network范围内才显示open手型光标
		 */
		private function onNetworkMouseOver(event:MouseEvent):void{
			if(event.target is Group&&event.currentTarget==this){
				this.removeEventListener(MouseEvent.MOUSE_OVER,onNetworkMouseOver);
				this.addEventListener(MouseEvent.MOUSE_OUT,onNetworkMouseOut);
				if(!useDefaultHandCursor){
					cursorManager.removeAllCursors();
					cursorID = cursorManager.setCursor(openHand);
				}
			}
		}
		/**
		 * 当鼠标离开了Network范围时去掉显示所有手型光标,并添加再次进入的监听
		 */
		private function onNetworkMouseOut(event:MouseEvent):void{ 
			if(event.target is Group&&event.currentTarget==this){
				this.addEventListener(MouseEvent.MOUSE_OVER,onNetworkMouseOver);
				this.removeEventListener(MouseEvent.MOUSE_OUT,onNetworkMouseOut);
				if(!useDefaultHandCursor){
					cursorManager.removeAllCursors();
				}
			}
	}
		/**
		 * 	按下键盘中的delete按键。
		 */
		private function onKeyboardDown(event:KeyboardEvent):void{
			//delete
			if(event.charCode==127){
				var _msg:String;
				var len:int = selectedElements.length;
				for(var i:int=0;i<len;i++){
					var element:Element = selectedElements[i];
					if(element){
						if(i==0)
							_msg = "确定要删除";
						if(element.label&&element.label.length>0)
							_msg+= "["+element.label+"]";
						else if(element.toolTip&&element.toolTip.length>0)
							_msg+=  "["+element.toolTip+"]";
						else if((element is Link)&&element.visible)
								_msg+= "["(element as Link).fromNode.label+"到"+(element as Link).toNode.label+"的连接]";
						if(i!=len-1)
							_msg+="、";
					}
				}
				Alert.show(_msg, "Confirm", 3, this, deleteHandler);
			}
		}
		
		/**
		 * network组件是否为第一次调用resize事件。<br>
		 * 该值将在network初始化结束后被设置为true，当用户自定义调整network的宽高时会导致resize事件的第二次派发，
		 * 此时将自动重设各子容器大小，所以需要重新判定所有子数据的x、y值是否已越界。
		 */
//		private var sizeInited:Boolean = false;
		
		/**
		 *  Network尺寸调整完毕后，对RootGroup子容器设置默认宽高，只会调用一次。
		 */
		private function resizeInitHandler(event:ResizeEvent):void
		{
			var fromUIComponent:UIComponent = event.target as UIComponent;
			//只设置一次.该变量作为NodeUI的refreshScroll方法的判断条件。
			if(rootGroupWidth==0
				||rootGroupHeight==0
				||fromUIComponent.width!=rootGroupWidth||fromUIComponent.height!=rootGroupHeight){
				setBounds(fromUIComponent,_rootGroup);
				rootGroupWidth = fromUIComponent.width;
				rootGroupHeight = fromUIComponent.height;
			}
			//删除监听
			//removeEventListener(ResizeEvent.RESIZE,resizeInitHandler);
			
			//当全屏模式时，该bug不再存在，所以将滚动条还原到100%显示。
//			this._scroller.percentHeight = this.height==Capabilities.screenResolutionY?100:93;
		}
		
		/**
		 * 更改rootGroup后将调整子类的大小
		 */
		private function rootResizeHandler(event:ResizeEvent=null):void
		{
			var fromUIComponent:UIComponent = event.target as UIComponent;
			setBounds(fromUIComponent,_backgroundGroup);
			
			//只有当maxPoint.x小于时才调整,否则可能maxPoint.x=2000，而当前宽度才1024.
			if(maxPoint.x<=fromUIComponent.width)
				_dataGroup.width = fromUIComponent.width;
			if(maxPoint.y<=fromUIComponent.height)
				_dataGroup.height = fromUIComponent.height;
			
			setBounds(fromUIComponent,_customGroup);
			if(_backgroundGroup.getBackgroundImage())
				_backgroundGroup.backgroundImageChanged = true;
			_backgroundGroup.backgroundChanged = true;
			_backgroundGroup.invalidateDisplayList();
//			_rootGroup.removeEventListener(ResizeEvent.RESIZE,rootResizeHandler);
			//是否有必要重绘界面,这里屏蔽
//			elementBox.forEach(function(data:IData):void{
//				if(data is Node)
//					data.dispatchPropertyChangeEvent("xy",null,null);
//			});
		}
		
		/**
		 * 更改attachmentGroup后将调整子类的大小
		 */
		private function dataGroupResizeHandler(event:ResizeEvent):void
		{
			var fromUIComponent:UIComponent = event.target as UIComponent;
			setBounds(fromUIComponent,_bottomGroup);
			setBounds(fromUIComponent,_nodeGroup);
			setBounds(fromUIComponent,_linkGroup);
			setBounds(fromUIComponent,_layerGroup);
			setBounds(fromUIComponent,_attachmentGroup);
			setBounds(fromUIComponent,_topGroup);
//			_dataGroup.removeEventListener(ResizeEvent.RESIZE,dataGroupResizeHandler);
		}
		
		private function setBounds(fromUIComponent:UIComponent,toUIComponent:UIComponent):void{
			toUIComponent.width = fromUIComponent.width;
			toUIComponent.height = fromUIComponent.height;
		}
		
		/**
		 * onKeyboardDown方法的回调方法(点击[确定]按钮）。该方法将执行删除Data数据操作.删除的对象为当前选中的ElementUI对象.
		 */
		private function deleteHandler(event:CloseEvent=null):void{
			if (event==null||event.detail == Alert.YES){
				for each(var element:Element in selectedElements){
					elementBox.removeData(element);
				}
				setSelectedElements(null);
				return;
			}
			for each(var element1:Element in selectedElements){
				var elementUI:IElementUI = getElementUI(element1);
				//是ElementUI而非SmallElementUI
				if(elementUI&&elementUI is ElementUI){
					/* 点击了取消，则重新获得焦点(UIComponent.setFocus()) */
	//				_currentSelectedElementUI.setFocus();
					this.setFocus();//只设置一次
					return;
				}
				
			}
			
		}

		/**
		 * 返回当前选中的ElementUI对象
		 */
		public function getSelectedElemenetUI():Vector.<ElementUI>{
			if(selectedElements.length==0)
				return null;
			var elementUI:Vector.<ElementUI> = new Vector.<ElementUI>();
			for each(var e:Element in selectedElements){
				elementUI.push(getElementUI(e));
			}
			return elementUI;
		}
		
		
		//***************************************************************************************
		//
		//    容器布局操作
		//
		//***************************************************************************************
		/**
		 * 根据传入的basicGroup层，返回对应的dataBox容器.如果为空，则默认返回attachmentGroup对应的elementBox.
		 * @param layoutGroup 布局层
		 */
		public function getDataBox(_group:BasicGroup=null):DataBox{
			if(_group==_nodeGroup){
				return elementBox;
			}
			if(_group==_linkGroup){
				return elementBox.linkBox;
			}
			if(_group==_layerGroup){
				return elementBox.layerBox;
			}
			if(_group==_topGroup){
				return elementBox.alarmBox;
			}
			
			/*default*/
			return elementBox;
		}
		
		/**
		 * 创建默认的布局容器
		 * @param name 布局的名称,可以重复，程序不使用，仅供参考。
		 */
		private function createLayoutGroup(groupName:String,mouseChildrenEnable:Boolean = true,useDefaultChild:Boolean = false) : BasicGroup
		{
			var _group:BasicGroup = new BasicGroup(groupName,useDefaultChild);
			_group.clipAndEnableScrolling = true;
			_group.mouseEnabled = false;
			_group.mouseChildren = mouseChildrenEnable;
//			_group.name = groupName;
			return _group;
		}
		
		/**
		 * 设置布局层上的可视对象是否可接收鼠标事件交互
		 * @param enable 布局层的子组件是否可交互，默认为false
		 * @param layoutGroup 哪一层布局，如果为空，则默认为attachmentGroup层。
		 */
		public function setLayoutGroupInteractionEnable(enable:Boolean=false,layoutGroup:BasicGroup=null):void{
			layoutGroup = getDefaultAttachGroup(layoutGroup);
			layoutGroup.mouseChildren = enable;
			layoutGroup.mouseFocusEnabled = enable;
		}
		
		mx_internal var rootGroupWidth:Number;
		mx_internal var rootGroupHeight:Number;
		
		/**
		 * 设置画布的尺寸
		 * @param value 新的值
		 * @param property 更改的属性名
		 */
		mx_internal function setRootGroupSize(value:Number,propertyName:String):void{
//			for(var i:int=0;i<_rootGroup.numChildren;i++){
//					this._rootGroup.getElementAt(i)[propertyName] = value;
//			}
			if(propertyName=="width"){
				if(value<this.width||value<this._scrollerGroup.width)
					return;
				rootGroupWidth = value;
				this._dataGroup.width = value;
			}
			else if(propertyName=="height"){
				if(value<this.height||value<this._scrollerGroup.height)
					return;
				rootGroupHeight = value;
				this._dataGroup.height = value;
			}
			else
				this._dataGroup[propertyName] = value;
			this._backgroundGroup.backgroundChanged = true;
			this._backgroundGroup.invalidateDisplayList();
		}
		
		public function refreshRootGroupSize():void{
			Alert.show("."+rootGroupWidth);
			if(_dataGroup.width<rootGroupWidth)	
				_dataGroup.width = rootGroupWidth;
			if(_dataGroup.height<rootGroupHeight)	
				_dataGroup.height = rootGroupHeight;
		}
		
		/**
		 * 重设RootGroup容器的宽高为初始值(等于Network的宽高)。<br>
		 * @param isCallResetMethod 如果该参数为true,则调用的同时会调用network.reset()方法(该方法访问域为mx_internal)，
		 * 该方法将清除已保留的最大、最小节点坐标值，以及保留的最大、最小坐标值节点的引用，
		 * 和超出屏幕的节点引用，这些值和引用在容器判断滚动条和设置容器尺寸时作为依据。。
		 */
		public function resetRootGroupSize(isCallResetMethod:Boolean = true):void{
			/* 重设界面的尺寸 */
			this.setRootGroupSize(this.width,"width");
			this.setRootGroupSize(this.height,"height");
			/* 重设node的静态引用 */
			if(isCallResetMethod)
				this.reset();
			
			//com.myflexhero.network.core.layout.CustomLayout类的refreshLayout()方法调用时，
			//正在刷新旧的布局器，所以此时如果调用this.zoomReset()，
			//所设置最大节点为旧布局器的，这不是我们所需要的。
			//this.zoomReset();
		}
		/**
		 * 设置自动布局器类型,设置该参数并不会自动执行自动布局。如需执行自动布局，请调用返回参数的refreshLayout()方法。<br>
		 * 参数值请参见:Consts.LAYOUT前缀.
		 * @param layoutType 自动布局类型,为空则使用默认布局(环形弹力布局).
		 * @return 返回当前所创建的自动布局器.也可以通过network.getCurrentAutoLayout()方法调用获得.
		 */
		public function setAutoLayout(layoutType:String=""):ICustomLayout{
			if(_autoLayout==null)
				_autoLayout = new AutoLayout(this);
			_autoLayout.setLayout(layoutType);
			_currentAutoLayout = _autoLayout.getCurrentLayout();
			return _currentAutoLayout;
		}
		public  function getAutoLayout():AutoLayout{
			return _autoLayout;
		}
		
		public  function setAutoLayoutToNull():void{
			this._autoLayout = null;
		}
		//***************************************************************************************
		//
		//    容器数据操作
		//
		//***************************************************************************************
		public function get elementBox():ElementBox{
			return this._elementBox;
		}
		
		/**
		 * 设置数据容器ElementBox，程序将自动更新已有数据。<br>
		 * <ul>
		 * <li>请通过elementBox操作Node及其子类的数据。</li>
		 * <li>请尽量d通过elementBox.linkBox操作Link类型数据。</li>
		 * <li>请通过elementBox.layerBox操作Layer类型数据。</li>
		 * </ul>
		 */
		public function set elementBox(elementBox:ElementBox) : void
		{
			if (elementBox == null)
			{
				throw new Error("ElementBox不能为空");
			}
			if (this._elementBox == elementBox)
			{
				return;
			}
			//删除已有
//			if(this._elementBox!=null){
//				_elementBox.removeAll();
//				_elementBox.linkBox.removeAll();
//				_elementBox.layerBox.removeAll();
//			}
			this._elementBox = elementBox;
			ImageUtils.addImageLoadedListener(this.imageLoader,this._elementBox.handleImageLoaded);
			this._elementBox.addDataBoxChangeListener(elementBoxChangeHandler);
			this._elementBox.linkBox.addDataBoxChangeListener(elementBoxChangeHandler);
			this._elementBox.layerBox.addDataBoxChangeListener(elementBoxChangeHandler);
			if(_elementBox.length>0){
				for(var i:int =0;i<_elementBox.length;i++)
					_elementBox.dispatchEvent(new DataBoxChangeEvent(DataBoxChangeEvent.ADD, _elementBox.getDatas()[i]));
			}
			
			if(_elementBox.linkBox&&_elementBox.linkBox.length>0){
				for(i=0;i<_elementBox.linkBox.length;i++)
					_elementBox.linkBox.dispatchEvent(new DataBoxChangeEvent(DataBoxChangeEvent.ADD, _elementBox.linkBox.getDatas()[i]));
			}
			if(_elementBox.layerBox&&_elementBox.layerBox.length>0){
				for(i=0;i<_elementBox.layerBox.length;i++)
					_elementBox.layerBox.dispatchEvent(new DataBoxChangeEvent(DataBoxChangeEvent.ADD, _elementBox.layerBox.getDatas()[i]));
			}
			return;
		}
		
		/**
		 * 当清空数据容器内数据时(即派发DataBoxChangeEvent.CLEAR事件)是否需重置RootGroup的大小到初始状态(即network大小),默认为true.
		 */ 
		public var isResetRootGroupSizeOnDataBoxCleared:Boolean = true;
		/**
		 * 监听数据容器ElementBox的事件处理函数，完成对应的UI包装类的设置，包括自动布局的数据更新。
		 */
		protected function elementBoxChangeHandler(event:DataBoxChangeEvent) : void
		{
			var element:IData;
			
			switch(event.kind){
				case DataBoxChangeEvent.ADD:
					element = IData(event.data);
					/*  针对拥有布局器的节点，不做限制，交给布局器作显示的限制控制。 
						对于没有布局器的节点，则判断是否使用了subNetwork容器层。如果是否了，则显示当前对应的容器层。
					*/
					if(checkSubNetworkRelation(element)){
						this.showElement(element);
					}
					break;
				
				case DataBoxChangeEvent.REMOVE:
					removeElementUI(event.data);
					/* 删除的节点是作为判断的依据，则使用父级节点替换 */
					if(_currentAutoLayout&&event.data==_currentAutoLayout.currentCompareNode){
						if(event.data&&event.data.parent){
							/* 有多个邻居节点，则使用上一级作为currentCompareNode */
							_currentAutoLayout.currentCompareNode = event.data.parent as Node;
						}else
							_currentAutoLayout.currentCompareNode = null;
					}
					
					if(event.data is Node){
						removeLinkRelationForNode(event.data);
						if(getElementUI(event.data)!=null){
							/* 删除move鼠标操作事件引用 */
							if(moveHandles.modelList.indexOf(event.data)!=-1){
								removeElementResizeOrMoveModel(event.data,false);
							}
							/* 删除resize鼠标操作事件引用 */
							if(resizeHandles.modelList.indexOf(event.data)!=-1){
								removeElementResizeOrMoveModel(event.data,true);
							}
						}
					}
					else if(event.data is Link){
						/* 删除内部关系 */
						removeLinkRelation(event.data as Link);
						refreshLinksUI(element as Link);
					}
					break;
				
				case DataBoxChangeEvent.CLEAR:
					var _elementType:String = event.data  is Node?"node":event.data  is Link?"link":"";
					if(_elementType=="node"){
						//重置回默认
						if(isResetRootGroupSizeOnDataBoxCleared){
							this.reset();
							setRootGroupSize(this.width,"width");
							setRootGroupSize(this.height,"height");
						}
						currentSubNetwork = null;
						var selectedCount:int = _selectedElements.length;
						if(selectedCount>0)
							_selectedElements.splice(0,selectedCount);
					}
					
//					/* Node、Link都需要删除快速引用 */
//					if(_elementType=="node"||_elementType=="link"){
//						/* 删除全部快速link引用 */
//						for(var key:String in _linkDictionary){
////							removeLinkRelation(_linkDictionary[key]);
//							delete _linkDictionary[key];
//						}
//					}
					
					for(var i:int=0;i<event.datas.length;i++){
						if(getElementUI(event.datas[i])==null)
							continue;
						/* 删除UI */
						removeElementUI(event.datas[i]);
						
						if(_elementType=="link")
							removeLinkRelation(event.datas[i] as Link);
					}
					
					//删除move和resize数据
					if(resizeHandles){
						for each(var obj:Object in resizeHandles.modelList){
							resizeHandles.unregisterModel(obj);
						}
						resizeHandles.modelList.splice(0,resizeHandles.modelList.length);
					}
					if(moveHandles){
						for each(obj in moveHandles.modelList){
							moveHandles.unregisterModel(obj);
						}
						moveHandles.modelList.splice(0,moveHandles.modelList.length);
					}
					break;
			case DataBoxChangeEvent.LAYOUT_REFRESH:
				refreshLayoutDatas();
				return;//直接返回
				break;
			}
			//采用手动刷新
//			refreshLayoutDatas(event.kind,event.data);
			return;
		}
		
		public function refreshLayout():void{
			refreshLayoutDatas(DataBoxChangeEvent.CLEAR);
		}
		
		private function refreshLayoutDatas(eventProperty:String="",eventData:*=null):void{
			/* 是否使用自动布局 */
			if(_autoLayout!=null&&_currentAutoLayout!=null){
				/* 刷新自动布局的数据 */
				_autoLayout.links = Vector.<Link>(elementBox.linkBox.getDatas());
				/* 传递删除的数据给_autoLayout，作为清空用 */
				
				var  datas:Vector.<IData> = Vector.<IData>(elementBox.getDatas());
				var  nodes:Vector.<Node> = new Vector.<Node>();
				for each(var data:IData in datas){
					if(data is Node){
						nodes.push(data);
					}
				}
				_autoLayout.nodes = nodes;
				_autoLayout.clearAll = true;
				_autoLayout.refreshLayout();
				//派发InteractionEvent事件
				dispatchEvent(new InteractionEvent(InteractionEvent.LAYTOUT_UPDATED,this,null,null));
			}
		}
		
		/**
		 * 验证当前element是否可见(如果当前element的子集存在SubNetwork，则该子集的SubNetwork的子类们将返回false)。
		 * @return 返回当前element是否可见
		 */
		private function checkSubNetworkRelation(element:IData):Boolean{
			var e:* = element;
			var visible_loc:Boolean = false;
			
			/* 有2种情况，分别是currentSubNetwork为空和不为空. */
			/**
			 * 如果为空，则显示顶层元素。
			 * 否则，显示当前subNetwork的子类(不包括subNetwork本身,如果子类中存在其他SubNetwork子类，则显示该SubNetwork子类，但不显示该SubNetwork子类的子节点。)。
			 */
			if(currentSubNetwork){
				//currentSubNetwork不为空的情况下(双击了SubNetwork)，如果当前element和currentSubNetwork是link关系，则不显示（应当在currentSubNetwork为空的情况下显示）
				if(getLinkCounts(currentSubNetwork,element)>0)
					return false;
				
				/* 当前节点为SubNetwork */
				var isSubNetwork:Boolean = (element is SubNetwork);
				var findSubNetwork:Boolean = false;
				
				//当前element为currentSubNetwork,不显示(只显示子类).
				if(element==currentSubNetwork)
					return visible_loc;
				
				while(e){
					if(e==currentSubNetwork){
						//如果在父类中找到的第一个SubNetwork为currentSubNetwork,则显示。否则为这样的结构:currentSubNetwork-->SubNetwork(父类)--->element(当前节点)
						if(!findSubNetwork)
							visible_loc = true;
						break;
					}
					
					/*  找到SubNetwork类型的父类，且该父类不为当前currentSubNetwork */
					if(e is SubNetwork&&e!=element){
						findSubNetwork = true;
					}
					
					e = e.parent;
				}
			}else{
				//首先设为true
				visible_loc = true;
				
				/* 此时currentSubNetwork为空，如果在父类中找到一个是subnetwork，则不显示 */
				while(e){
					//找到父类为SubNetwork类型的节点，不显示(如果存在link关系，则显示,因为本来如果不是上下级关系的节点，设置link关系后，成了上下级关系)
					if(e is SubNetwork&&e!=element&&getLinkCounts(e,element)==0){
						visible_loc = false;
						break;
					}
					
					e = e.parent;
				}
			}
			return visible_loc;
		}
		
		/**
		 * 删除link的关系,并删除fromNode和toNode的父子关系
		 */
		private function removeLinkRelation(link:Link):void{
			if(link==null)
				return;
			setLinkReference(link,true);
			
			if(link.fromNode&&link.toNode)
				link.fromNode.removeChild(link.toNode);
//			if(link.fromNode&&link.fromNode.children&&link.toNode)
//			trace("link.fromNode.child:"+link.fromNode.children.indexOf(link.toNode))
//			if(link.toNode&&link.toNode.parent)
//				link.toNode.parent =null;
			link.fromNode = null;
			link.toNode = null;
		}
		
		/**
		 * 删除节点所在link的连接关系(link)
		 */
		private function removeLinkRelationForNode(node:IData):void{
			if(node!=null)
				removeNodeRelation(node);
			
			if(elementBox.linkBox.length<1)
				return;
			var _links:Vector.<Link> = Vector.<Link>(elementBox.linkBox.getDatas());
			var _find:Boolean = false;
			for each(var ln:Link in _links){
				if(ln.fromNode==node||ln.toNode==node)
					_find = true;
				
				/* 只要其中一个不存在 则直接删除该link及linkUI */
				if(_find){
					_find = false;
//					removeElementUI(_links[i]);
					elementBox.linkBox.removeData(ln);
					setLinkReference(ln,true);
				}
			}
		}
		
		/**
		 * 删除节点的上下级引用
		 */
		private function removeNodeRelation(node:IData):void{
			/* 删除当前节点上级引用 */
			if(node.parent)
				node.parent.removeChild(node);
			
			/* 删除当前节点子级引用 */
			if(node.numChildren>0){
				for(var j:int=0;j<node.numChildren;j++){
					node.children[j].parent = null;
				}
			}
		}
		/**
		 * 删除Element对象，包括对应的包装类ElementUI、事件监听,如果为Link，则还会删除快速引用。
		 */
		private function removeElementUI(element:IData):void{
			var _elementUI:IElementUI = getElementUI(element);
			if(_elementUI==null)
				return;
			/* dispose */
			_elementUI.dispose();
			/* 删除事件引用*/
			removeElementUIEventListener(_elementUI);
			/* 删除UI字典引用 */
			if(_elementUICollection[element.id]!=null)
				delete _elementUICollection[element.id];
		}
		/**
		 * 坐标参考节点是否已初始化
		 */ 
		mx_internal var isReferenceNodeInited:Boolean = false;
		/**
		 * 展示Element数据(生成对应的ElementUI包装类进行展示)
		 */
		private function showElement(element:IData) : void
		{
			var _elementUI:* = getElementUI(element);
			if(_elementUI==null)
				_elementUI = createElementUI(element);
			if (_elementUI != null)
			{
				element.isLock = false;
				if(element is Link)
					refreshLinksUI(element as Link);
				else{
					//赋初值
					if(!isReferenceNodeInited){
						var n:Node = element as Node;
							this.maxXPointNode = n;
							this.minXPointNode = n;
							this.maxYPointNode = n;
							this.minYPointNode = n;
						isReferenceNodeInited = true;
					}
					//当允许移动时显示手型光标,参见onMouseUp.
					_elementUI.useHandCursor = true;
					_elementUI.drawBody();
				}
				/* 如果当前已经处于调整状态，则允许调整全部元素的尺寸 */
			    /* resize优先于大于move */
				if(_elementUI.layoutGroup)
					var _elementLayoutGroup:*;
					//如果不是BasicGroup类型，则所属层为layer，layer的顶级容器为_layerGroup.
					if(_elementUI.layoutGroup is BasicGroup)
						_elementLayoutGroup = _elementUI.layoutGroup;
					else
						_elementLayoutGroup = _layerGroup;
					
					if(_elementLayoutGroup.isResizeAll){
						setResizeInteractionHandler(true,_elementLayoutGroup,new Vector.<IData>([element]));
					}else if(_elementLayoutGroup.isMoveAll){
						setMoveInteractionHandler(true,_elementLayoutGroup,new Vector.<IData>([element]));
					}
			}
		}
		
		/**
		 * 如果存在多个link属于同一个Bundle，则其中一个有更新操作时，则刷新全部linkUI。
		 */
		private function refreshLinksUI(link:Link):void{
			var links:Vector.<Link> = getLinkReference(link.fromNode,link.toNode);
			//存在多个link，则刷新属于一个Bundle的link位置。
			if(links&&links.length>1){
				for each(var _l:Link in links){
					var linkUI:LinkUI = getElementUI(_l) as LinkUI;
					linkUI.nodeChanged = true;
					linkUI.drawBody();
				}
				return;
			}
			getElementUI(link).drawBody();
		}
		/**
		 * 传入point(x,y),其中</br>
		 * <ul>
		 * 		<li>x = event.stageX(事件发生点在全局舞台坐标中的水平坐标)</li>
		 * 		<li>y = event.stageY(事件发生点在全局舞台坐标中的垂直坐标)</li>
		 * </ul>
		 * 
		 */
		public function getLogicalPoint(point:Point) : Point
		{
			//以前Node.centerLocation=network.getLogicalPoint(point);
			return this._rootGroup.globalToLocal(point);
		}
		
		/**
		 * 设置节点对应的link对象，仅供组件内部使用
		 * @param link 操作的link对象.
		 * @param isRemove 如果为true，则意味着删除该link引用，否则为新增.
		 */
		mx_internal function setLinkReference(link:Link,isRemove:Boolean=false):void{
			if(link==null)
				return;
			if(isRemove){
				if(link.fromNode&&link.toNode){
					var _links:Vector.<Link>  = _linkDictionary[link.fromNode.id+link.toNode.id];
					if(_links==null)
						_links= _linkDictionary[link.toNode.id+link.fromNode.id];//替换起始位置
					if(_links==null)
						return;
					for(var i:int=0;i<_links.length;i++){
						if(_links[i]==link){
							//不适用delete操作符删除。
							_links.splice(i,1);
							break;
						}
					}
					return;
				}
			}
			
			if(link.fromNode&&link.toNode){
				_links  = _linkDictionary[link.fromNode.id+link.toNode.id];
				if(_links==null){
					//替换起始顺序再次获取
					_links  = _linkDictionary[link.toNode.id+link.fromNode.id];
					if(_links==null){
						_links = Network.createVectorLinks();
						_linkDictionary[link.fromNode.id+link.toNode.id] = _links;
					}
				}
				
				for(i=0;i<_links.length;i++){
					//已经存在，则返回。
					if(_links[i]==link){
						return;
					}
				}
				//新增link
				_links.push(link);
			}
		}
		
		/**
		 * 快捷的方式返回节点对应的link集合对象.将返回不区分fromNode和ToNode的Links集合。
		 */
		public function getLinkReference(node1:IData,node2:IData):Vector.<Link>{
//			trace("---getLink:"+fromNode.label+toNode.label+"="+_linkDictionary[fromNode.id+toNode.id])
			if(node1&&node2){
				var _links:Vector.<Link> = _linkDictionary[node1.id+node2.id];
				if(_links==null)
					return _linkDictionary[node2.id+node1.id];
				return _links;
			}
			return null;
		}
		
		/**
		 * 返回对应的fromNode和toNode的Link总数。
		 * @return int link总数，如果为空，或fromNode、toNode二者之一为空，则返回0.
		 */
		public function getLinkCounts(fromNode:IData,toNode:IData):int{
			//			trace("---getLink:"+fromNode.label+toNode.label+"="+_linkDictionary[fromNode.id+toNode.id])
			if(fromNode&&toNode){
				var _links:Vector.<Link> =  _linkDictionary[fromNode.id+toNode.id];
				return _links==null?0:_links.length;
			}
			return 0;
		}
		
		/**
		 * 刷新界面节点，使传入的节点集往屏幕的最左侧和顶部靠近。
		 * @param isAutoAdjust 是否自动进行调整
		 * @param xPadding 节点集离屏幕左侧的X轴距离。正为增加，负为减少。
		 * @param yPadding 节点集离屏幕顶部的Y轴距离。正为增加，负为减少。
		 */
		public function refreshNodesToLeftAndTop(nodes:Vector.<Node>,isAutoAdjust:Boolean= true,xPadding:Number=15,yPadding:Number=10):void{
			if(this.maxXPointNode==null||this.maxYPointNode==null){
				return;
			}
			
			if(isAutoAdjust){
				if(this.maxXPointNode.x<this.width){
					var distanceForCenterX:Number = this.minXPointNode.x+Math.abs(this.minXPointNode.x- (this.maxXPointNode.x+this.maxXPointNode.nodeWidth))/2;
					if(distanceForCenterX<this.width/2){
						xPadding = this.width/2-distanceForCenterX;
					}else
						xPadding = distanceForCenterX- this.width/2;
				}else{
					xPadding = getAdjustXPading();
				}
				if(this.maxYPointNode.y<this.height){
					var distanceForCenterY:Number = this.minYPointNode.y+Math.abs(this.minYPointNode.y- (this.maxYPointNode.y+this.maxYPointNode.nodeHeight))/2;
					if(distanceForCenterY<this.height/2){
						yPadding = this.height/2-distanceForCenterY;
					}else
						yPadding = distanceForCenterY - this.height/2 ;
				}
				else{
					yPadding = getAdjustYPading();
				}
				
				Network.scroll(xPadding,yPadding,nodes);
				return;
			}
			
			Network.scroll(getAdjustXPading(),getAdjustYPading(),nodes);
		}
		
		private function getAdjustXPading():Number{
			if(this.minXPointNode.x<1){
				this.minXPointNode.x = 15;
				this.minPoint.x = 15;
			}
			return 10-this.minPoint.x+this.minXPointNode.nodeWidth/2;
		}
		
		private function getAdjustYPading():Number{
			if(this.minYPointNode.y<1){
				this.minYPointNode.y = 15;
				this.minPoint.y = 15;
			}
			return 10-this.minPoint.y+this.minYPointNode.nodeHeight/2 ; 
		}
		
		/**
		 * 
		 * 根据传入的偏移值对指定的Node数据集进行水平或垂直平移。
		 * @param deltaX 水平滚动值，如果为负，则向左侧屏幕靠近.
		 * @param deltaY 垂直滚动值，如果为负，则向顶部屏幕靠近.
		 */
		public static function scroll(deltaX: int, deltaY: int,nodes:Vector.<Node>): void {
			for each(var n:Node in nodes) {
				n.x = n.x + deltaX;
				n.y = n.y + deltaY;
			}
		}
		
		//***************************************************************************************
		//
		//    ElementUI
		//
		//***************************************************************************************
		public function getElementUI(element:IData) : IElementUI
		{
			if (element == null)
			{
				return null;
			}
			return this._elementUICollection[element.id];
		}
		
		private function createElementUI(element:*):IElementUI{
			var _elementUI:*;
			var elementLayoutGroup:*;
			if(element is Link){
				_elementUI =  new LinkUI(this,element);
			}
			else if(element is Node&&element.isSmallNode){
				_elementUI = new SmallNodeUI(this,element);
			}
			else if(element is Layer){
				//使用Group作为层
				var _layerCanvas:Group = new Group();
				_layerCollection[element] = _layerCanvas;
				_layerGroup.addElement(_layerCanvas);
				return null;
			}
			else if(element is RoundPipe){
				_elementUI = new RoundPipeUI(this,RoundPipe(element));
			}
			else if(element is SquarePipe){
				_elementUI = new SquarePipeUI(this,SquarePipe(element));
			}
			else if(element is KPICard){
				_elementUI = new KPICardUI(this,KPICard(element));
			}
			else if(element is Grid){
				_elementUI = new GridUI(this,element);
			}
			else if(element is ParallelogramGroup||element is TrapezoidGroup){
				_elementUI = new QuadrilateralGroupUI(this,element);
			} 
			else if(element is com.myflexhero.network.Group){
				_elementUI = new GroupUI(this,element);
			} 
			else if(element is Wall){
				_elementUI = new WallUI(this,element);
			}
			else if(element is Floor){
				_elementUI = new FloorUI(this,element);
			}
			else if(element is Node){
				_elementUI = new NodeUI(this,element);
			}
			//可能为Dummy类型的对象
			if(_elementUI==null)
				return null;
			
			if((element as Element).layerID!=null){
				elementLayoutGroup = getLayerCanvasByElement(element);
				if(elementLayoutGroup==null)
					elementLayoutGroup = getDefaultLayoutGroupByElementUI(_elementUI);
				elementLayoutGroup.addElement(_elementUI);
			}else{
				elementLayoutGroup = getDefaultLayoutGroupByElementUI(_elementUI);
				elementLayoutGroup.addData(_elementUI);
			}
			
			_elementUI.layoutGroup = elementLayoutGroup;
			_elementUICollection[element.id] = _elementUI;
			addElementUIEventListener(_elementUI);
			return _elementUI;
		}
		
		/**
		 * 根据传入的ElementUI类型，返回所属UI类型系统默认的BasicGroup容器。
		 */
		public function getDefaultLayoutGroupByElementUI(elementUI:IElementUI):BasicGroup{
			var defaultGroup:BasicGroup;
				switch(Utils.getClass(elementUI)){
					case LinkUI:
						defaultGroup = getLinkLayoutGroup();
						break;
					case RoundPipeUI:
						defaultGroup = getNodeLayoutGroup();
						break;
					case SquarePipeUI:
						defaultGroup = getNodeLayoutGroup();
						break;
					case KPICardUI:
						defaultGroup = getNodeLayoutGroup();
						break;
					case GridUI:
						defaultGroup = getNodeLayoutGroup();
						break;
					case QuadrilateralGroupUI:
						defaultGroup = getGroupLayoutGroup();
						break;
					case GroupUI:
						defaultGroup = getGroupLayoutGroup();
						break;
					case WallUI:
						defaultGroup = getNodeLayoutGroup();
						break;
					case FloorUI:
						defaultGroup = getNodeLayoutGroup();
						break;
					case NodeUI:
						defaultGroup = getNodeLayoutGroup();
						break;
					default: 
						defaultGroup = getNodeLayoutGroup();
						break;
				}
				return defaultGroup;
		}
		
		/**
		 *  为ElementUI添加事件监听.
		 * <p>
		 *	组件获得焦点后移至顶部<br>
		 *	注意此处resize 和move都被删除了send to top <br>
		 * </p>
		 */
		private function addElementUIEventListener(elementUI:IElementUI):void{
			elementUI.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,1);
//			elementUI.addEventListener(MouseEvent.MOUSE_OVER,onMouseMove);
			elementUI.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut,false,1);
			elementUI.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,1);
			elementUI.addEventListener(MouseEvent.DOUBLE_CLICK,onElementUIDoubleClick,false,1);
			if(elementUI is ElementUI){
				UIComponent(elementUI).addEventListener(FlexEvent.SHOW,onShow);
				UIComponent(elementUI).addEventListener(FlexEvent.HIDE,onHide);
			}
			Sprite(elementUI).doubleClickEnabled = true;
		}
		
		private var fadeShow:Fade = new Fade();
		private function onShow(e:Event):void{
			fadeShow.duration = 900;
			fadeShow.alphaFrom =0;
			fadeShow.alphaTo =1;
			fadeShow.target = e.target;
			fadeShow.play();
		}
		
		private var fadeHide:Fade = new Fade();
		private function onHide(e:Event):void{
			fadeHide.duration = 500;
			fadeHide.alphaFrom =1;
			fadeHide.alphaTo =0;
			fadeHide.target = e.target;
			fadeHide.play();
		}
		/**
		 *	删除ElementUI事件监听
		 */
		private function removeElementUIEventListener(elementUI:IElementUI):void{
			elementUI.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
//			elementUI.removeEventListener(MouseEvent.MOUSE_OVER,onMouseMove);
			elementUI.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			elementUI.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			elementUI.removeEventListener(MouseEvent.DOUBLE_CLICK,onElementUIDoubleClick);
			if(elementUI is ElementUI){
				UIComponent(elementUI).removeEventListener(FlexEvent.SHOW,onShow);
				UIComponent(elementUI).removeEventListener(FlexEvent.HIDE,onHide);
			}
			Sprite(elementUI).doubleClickEnabled = false;
		}
		/**
		 * 返回Node元素所在的布局层
		 */
		public function getNodeLayoutGroup():BasicGroup{
			return _nodeGroup;
		}
		
		/**
		 * 返回Group元素所在的布局层
		 */
		public function getGroupLayoutGroup():BasicGroup{
			return _bottomGroup;
		}
		
		/**
		 * 返回Link元素所在的布局层
		 */
		public function getLinkLayoutGroup():BasicGroup{
			return _linkGroup;
		}
		
		/**
		 * 返回Label元素所在的布局层
		 */
		public function getLabelLayoutGroup():BasicGroup{
			return _topGroup;
		}
		
		/**
		 * 内部程序临时变量，用于存储当前鼠标焦点指向的对象
		 */
		private var _currentFocusNode:Node;
		/**
		 * 阻止当前节点获得晃动阻力
		 */
		private function preventNodeRepulsion(event:MouseEvent):void{
			
			if(event.target is NodeUI){
				_currentFocusNode = Node(NodeUI(event.target).element);
				_currentFocusNode.isMouseDown = true;
			}
		}
		
		private function restoreNodeRepulsion(event:MouseEvent):void{
			restoreNodeRepulsionHandler();
		}
		
		/**
		 * 恢复获得阻力
		 */
		private function restoreNodeRepulsionHandler():void{
			if(_currentFocusNode){
				_currentFocusNode.isMouseDown = false;
				_currentFocusNode = null;
			}
		}
		
		/**
		 * 双击事件.显示或隐藏子节点或父节点
		 */   
		private function onElementUIDoubleClick(event:MouseEvent):void{ 
//			trace("event.currentTarget:"+event.currentTarget+",target:"+event.target)
			//进入下一层
			if(event.target is NodeUI){
				//step1.属于SubNetwork,即使有subnetwork，也这样显示
				if(event.target.element is SubNetwork){
					currentSubNetwork = event.target.element;
					//Node及其子类
					var es:Vector.<IData> = elementBox.getDatas();
					var e:IData;
					/* 重新设置可见性 */
					for(var i:int=0;i<es.length;i++){
						e = es[i];
						if(checkSubNetworkRelation(e)){
							e.visible = true;
							//不管有没有绘画过，避免第一次未绘画过，再次绘画
							showElement(e);
						}else if(es[i].visible)
							es[i].visible = false;
					}
					
					//Link
					es = elementBox.linkBox.getDatas();
					for(i=0;i<es.length;i++){
						e = es[i];
						if(checkSubNetworkRelation(e)){
							e.visible = true;
							//不管有没有绘画过，避免第一次未绘画过，再次绘画
							showElement(e);
						}else if(es[i].visible)
							es[i].visible = false;
					}
					
				}
				//step2.属于自动布局器
				else if(_currentAutoLayout){
					//重置设置容器大小。
					this.resetRootGroupSize(false);
					
					_currentAutoLayout.currentCompareNode = event.target.element;
					_currentAutoLayout.refreshLayout();
					var datas:Vector.<Node> = Vector.<Node>(this.elementBox.getDatas());
					var filterDatas:Vector.<Node> = new Vector.<Node>();
					for each(var n:Node in datas){
						if(n.visible)
							filterDatas.push(n);
					}
					this.refreshNodesToLeftAndTop(filterDatas);
				}
				//派发InteractionEvent事件
				dispatchEvent(new InteractionEvent(InteractionEvent.DOUBLE_CLICK_ELEMENT,this,event,event.target.element));
				return;
			}
		}
		
		/**
		 * Network双击事件.显示或隐藏子节点或父节点
		 */   
		private function onNetworkDoubleClick(event:MouseEvent):void{ 
			//返回上一层
			if((event.target is Group)&&currentSubNetwork){
				var es:Vector.<IData> = elementBox.getDatas();
				var e:IData;
				var parentSubNetwork:SubNetwork;
				var eventE:IElement = currentSubNetwork;
				/* 返回到上一层视图 */
				if(currentSubNetwork.parent){
					e = currentSubNetwork.parent;
					while(e){
						/* 上一层依然为SubNetwork */
						if(e is SubNetwork){
							parentSubNetwork = e as SubNetwork;
							break;
						}
						e = e.parent;
					}
				}
				
				//上一层为空，则设置currentSubNetwork为空
				if(parentSubNetwork==null)
					currentSubNetwork = null;
				
				es = elementBox.getDatas();
				for(var i:int=0;i<es.length;i++){
					e = es[i];
					if(checkSubNetworkRelation(e)){
						if(!e.visible)
							e.visible = true;
						//不管有没有绘画过，避免第一次未绘画过，再次绘画
						showElement(e);
					}else if(es[i].visible)
						es[i].visible = false;
				}
				//派发InteractionEvent事件
				dispatchEvent(new InteractionEvent(InteractionEvent.DOUBLE_CLICK_SUBNETWORK_BACKGROUND,this,event,eventE));
				return;
			}
			//确保双击的不是节点.
			//此外,doubleClickHandler的step2也会派发该事件。
			if(event.target is NodeUI){
//				var point:Point = this.getLogicalPoint(new Point(event.stageX,event.stageY));
//				if((((event.target) as NodeUI).element as Node).rect.containsPoint(point))
//					return;
				return;
			}
			dispatchEvent(new InteractionEvent(InteractionEvent.DOUBLE_CLICK_BACKGROUND,this,event,null));
			
		}
		
		
		
		//***************************************************************************************
		//
		//
		//
		//
		//
		//    Mouse Event
		//
		//
		//
		//
		//***************************************************************************************
		/**
		 * 添加Network组件内部事件(InteractionEvent)监听
		 * @param listener 监听方法。<br>
		 * 					事件类：com.myflexhero.network.event.InteractionEvent,事件类型统一为:type Consts.EVENT_INTERACTION。请通过InteractionEvent.king属性区分事件子类型。
		 * @see com.myflexhero.network.event.InteractionEvent
		 */
		public function addInteractionListener(listener:Function, priority:int = 0, useWeakReference:Boolean = false) : void
		{
			this.addEventListener(Consts.EVENT_INTERACTION, listener, false, priority, useWeakReference);
		}
		
		/**
		 * send element to top,分别针对link 和 node类型
		 */
		public function sendToTop(data:IElement):void{
			if(data is Link){
				getLinkLayoutGroup().setDataIndex(getElementUI(data) as DisplayObject,getLinkLayoutGroup().numDatas-1);
				return;
			}
			
			if(data.layerID!=null){
				return;
			}
			if(data is com.myflexhero.network.Group){
				getGroupLayoutGroup().setDataIndex(getElementUI(data) as DisplayObject,getGroupLayoutGroup().numDatas-1);
				return;
			}
			
			//剩下的为Node节点
			var nodes:Dictionary = new Dictionary();
			var n:Node = data as Node;
			var maxIndex:int = getNodeLayoutGroup().numDatas-1;
			/* 为followers和children设置下标 */
			if(n.children&&n.children.length>0||n.followers&&n.followers.length>0){
				forEachChildOrFollower(n,-1,nodes);
				var currentChildren:Vector.<IData>;
				var currentChild:IElement;
				var nodesNum:int=0;
				/* 取集合长度 */
				for(var key:String in nodes){
					nodesNum++;
				}
				
				/* 迭代每一层，分别设置下标 */
				for(var i:int=nodesNum-1;i>-1;i--){
					currentChildren = nodes[i] as Vector.<IData>;
					if(currentChildren)
						for(var j:int=currentChildren.length-1;j>-1;j--){
							currentChild = currentChildren[j] as Element;
							if(currentChild==null||currentChild.layerID!=null)
								continue;
							if(maxIndex<0)
								maxIndex = 0;
							if(getElementUI(currentChild))
								getNodeLayoutGroup().setDataIndex(getElementUI(currentChild),maxIndex);
							maxIndex--;
						}
				}
			}
			/* 单独的节点以及有followers及children的节点 */
			if(maxIndex<0)
				maxIndex = 0;
			getNodeLayoutGroup().setDataIndex(getElementUI(data),maxIndex);
		}
		
		/**
		 *  迭代每一层,保存该层的所有节点引用
		 */
		private function forEachChildOrFollower(n:Node,depth:int,nodes:Dictionary):void{
			depth++;
			if(n.children)
				for(var i:int=0;i<n.children.length;i++){
					var c:Node = n.children[i] as Node;
					if(c&&c.children&&c.children.length>0)
						forEachChildOrFollower(c,depth,nodes);
					
				}
			if(n.followers)
				for(i=0;i<n.followers.length;i++){
					var f:Follower = n.followers[i] as Follower;
					if(f.followers&&f.followers.length>0)
						forEachChildOrFollower(f,depth,nodes);
					
				}
			
			var exists:Boolean = false;
			if(n.children&&n.children.length>0){
				if(nodes[depth]==null){
					nodes[depth] = n.children.slice()  as Vector.<IData>;
				}
				else{
					for(i=0;i<n.children.length;i++){
						if(nodes[depth].indexOf(n.children[i])==-1)
							nodes[depth].push(n.children[i]);
					}
				}
			}
			if(n.followers&&n.followers.length>0){
				if(nodes[depth]==null)
					nodes[depth] = n.followers.slice() as Vector.<IData>;
				else{
					for(i=0;i<n.followers.length;i++){
						if(nodes[depth].indexOf(n.followers[i])==-1)
							nodes[depth].push(n.followers[i]);
					}
				}
			}
		}
		
		private var isLayoutMouseMove:Boolean = false;
		/**
		 * 设置边框样式
		 */   
		private function onMouseMove(event:MouseEvent):void{
//			event.target.filters =  [new GlowFilter(Styles.getStyle(Styles.SELECT_COLOR),1, 8, 8, 2, Consts.QUALITY_HIGH)];
			if(isNetworkDragActived){
				// get the transformation matrix of this object
				affineTransform = _dataGroup.transform.matrix;
				_dataGroup.x = dataGroupBeginPoint.x+(_rootGroup.mouseX-networkDragBeginPoint.x);
				_dataGroup.y = dataGroupBeginPoint.y+(_rootGroup.mouseY-networkDragBeginPoint.y);
				return;
			}
			
			if(event.target is IElementUI){
//				if(event.target is GridUI)
//					return;
				if(event.target is NodeUI||event.target is SmallNodeUI){
					if(!event.target.mouseDown){
						event.target.mouseOver = true;
						event.target.refreshHighLight();
						
					}
					/* 可移动 但不能resize */
					if(!event.target.buttonMode&&
						isInteractionActivated(InteractionType.MOVE)&&
						!isInteractionActivated(InteractionType.RESIZE))
						event.target.buttonMode = true;
				}
				if(event.target is LinkUI){
					event.target.mouseOver = true;
					event.target.refreshHighLight();
				}
				
				/* 当前正在使用自动布局中的springLayout*/
				if(!isMouseDown&&_currentAutoLayout&&_currentAutoLayout is SpringLayout){
					SpringLayout(_currentAutoLayout).changeStatus(false);
					isLayoutMouseMove = true;
				}
				
				//派发InteractionEvent事件
				dispatchEvent(new InteractionEvent(InteractionEvent.ELEMENT_FOCUS,this,event,event.target.element));
				return;
			}
//			dispatchEvent(new InteractionEvent(InteractionEvent.ELEMENT_NOT_FOCUS,this,event,null));
		}
		
		/**
		 * 去掉设置边框样式
		 */   
		private function onMouseOut(event:MouseEvent):void{ 
			event.target.filters =null;
			if(event.target is IElementUI){
				event.target.mouseOut = true;
				event.target.mouseOver = false;
				if(event.target is NodeUI||event.target is SmallNodeUI){
					if(event.target.labelUI){
						event.target.labelUI.filters =null;
						event.target.labelStyleChanged = true;
					}
					if(event.target.buttonMode)
						event.target.buttonMode = false;
					event.target.refreshHighLight();
				}
				
				/* 当前正在使用自动布局中的springLayout*/
				if(isLayoutMouseMove&&_currentAutoLayout&&_currentAutoLayout is SpringLayout){
					SpringLayout(_currentAutoLayout).changeStatus(true);
					isLayoutMouseMove = false;
				}
				
				//linkUI
				if(event.target is LinkUI)
					event.target.drawAttachment();
					
				//派发InteractionEvent事件
				dispatchEvent(new InteractionEvent(InteractionEvent.OUT,this,event,event.target.element));
			}
		}
		
		private function onMouseUp(event:MouseEvent):void{ 
			if(isMouseDown)
				isMouseDown = false;
			if(event.target is IElementUI){
				event.target.mouseDown = false;
				
				//派发InteractionEvent事件
				dispatchEvent(new InteractionEvent(InteractionEvent.SELECTED_END,this,event,event.target.element));
			}
		}
		
		/**
		 * 对比变量
		 */
		private var lastMouseDownTime:int;
		/**
		 * 更改文本和UI组件在父容器的显示位置.将派发InteractionEvent.SELECTED_START或InteractionEvent.SELECTED_START事件.
		 */
		private function onMouseDown(event:MouseEvent):void{
			/* 选中后，清除已有的单个效果,多个效果则不清除 */
//			if(!event.shiftKey&&selectedElements.length<=1)
//				setSelectedElements();
			
			if(event.target is IElementUI){
				event.target.mouseUp = false;
				event.target.mouseOut = false;
				event.target.mouseOver = false;
				var now: int = getTimer();
				
				//double-click
				if((now - lastMouseDownTime) < 300) {
					lastMouseDownTime = now;
					event.target.mouseDown = false;
					event.target.isSelected = false;
					isMouseDown = false;
					setSelectedElements();
					return;
				}
				else
					lastMouseDownTime = now;
//				if(event.target is GridUI){
//					/*  没有父亲节点 */
//					if(!((event.target).element.host)){
//						return;
//					}
//				}
				
				//点击的是节点，判断是否可以拖动整个界面，如果可以，先清空选中状态
				if(!isInteractionActivated(InteractionType.MOVE)&&!isInteractionActivated(InteractionType.RESIZE))
					startDragNetwork();
				
				sendToTop(event.target.element);
				
				if(event.target.hasOwnProperty("labelUI")&&event.target.labelUI!=null){
					getLabelLayoutGroup().setDataIndex(event.target.labelUI,getLabelLayoutGroup().numDatas-1);
				}
				
				/* 如果不是鼠标进行的多选操作，则单选中对象 */
//				if(selectedElements.length<=1){
				_oldSelectedElements = _selectedElements;
				//设置当前外观
				setSelectedElements(event.target.element,event.shiftKey,event);
//				}
				
				if(event.target is NodeUI||event.target is SmallNodeUI){
					//	event.target.mouseOver = false;
					/*继续进行布局位置调整*/
					if(_currentAutoLayout&&_currentAutoLayout is SpringLayout){
						SpringLayout(_currentAutoLayout).changeStatus(true);
					}
				}
				isMouseDown = true;
				this.setFocus();
				//派发CLICK_ELEMENT时间
				dispatchEvent(new InteractionEvent(InteractionEvent.CLICK_ELEMENT,this,event,event.target.element));
				event.stopImmediatePropagation();
			}
		}
		
		
		
		public function addPropertyChangeListener(listener:Function, priority:int = 0, useWeakReference:Boolean = false) : void
		{
			this.addEventListener(Consts.EVENT_PROPERTY_CHANGE, listener, false, priority, useWeakReference);
		}
		
		public function removePropertyChangeListener(listener:Function) : void
		{
			this.removeEventListener(Consts.EVENT_PROPERTY_CHANGE, listener);
		}
		
		public function addSelectionChangeListener(listener:Function, priority:int = 0, useWeakReference:Boolean = false) : void
		{
			this.addEventListener(Consts.EVENT_SELECTION_CHANGE, listener, false, priority, useWeakReference);
		}
		
		public function removeSelectionChangeListener(listener:Function) : void
		{
			this.removeEventListener(Consts.EVENT_SELECTION_CHANGE, listener);
		}
		//***************************************************************************************
		//
		//    用户交互公用方法
		//
		//***************************************************************************************
		public var isResizeHandleMouseDown:Boolean = false;
		public function dispachElementMouseDownEvent(data:IData):void{
			getElementUI(data).dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN))
		}
		
		/**
		 * 根据传入的交互类型参数值，如果当前交互类型中有大于一个节点处于激活状态，则返回true，否则返回false。<br>
		 * 可选的interactionType参数类型值有：<br>InteractionType.MOVE <b>(值为"move")</b>、<br>InteractionType.RESIZE <b>(值为"resize")</b>。<br>
		 * 如果未传入任何参数，则返回false。
		 * @see InteractionType
		 */
		public function isInteractionActivated(interactionType:String):Boolean{
			if(interactionType==InteractionType.MOVE)
				return moveHandles!=null&&moveHandles.modelList.length>1;//默认modelList中都有一个元素
			else if(interactionType==InteractionType.RESIZE)
				return resizeHandles!=null&&resizeHandles.modelList.length>1;//默认modelList中都有一个元素
			return false;
		}
		
		/**
		 * 更新指定的Element的四周Resize提示图标点的位置(更改Element大小后需要通知Resize组件)。
		 */
		public function updateResizeHandlerPositions(element:Element):void{
			if(resizeHandles){
				resizeHandles.updateHandlePositions(element);
			}
		}
		
		//***************************************************************************************
		//
		//    Resize
		//
		//***************************************************************************************
		/**
		 * 设置可视对象是否可拖动并改变其尺寸大小
		 * @param resizable 是否可以拖动组件改变其大小，默认值为true。
		 * @param layoutGroup 设置在哪一层操作，默认为attachmentGroup的nodeGroup层(Node层)。
		 * @param elementCollection 设置对哪些节点或可视对象进行操作，如果为空，则默认对参数layoutGroup层上的所有Node进行操作。
		 */
		public function setResizeInteractionHandler(resizable:Boolean=true,layoutGroup:BasicGroup=null,elementCollection:Vector.<IData>=null,isCallFromMoveHandler:Boolean = false):void{
			//激活selectHelper
			if(resizable)
				_selectHelper.init(this);
			else if(!isCallFromMoveHandler&&!isInteractionActivated(InteractionType.MOVE))//如果当前不存在可移动的节点，则卸载selectHelper监听.
				_selectHelper.uninstall();
			if(!isInteractionActivated(InteractionType.RESIZE)){
				if(!resizable)
					return;
			}
			
			layoutGroup = getDefaultAttachGroup(layoutGroup);
			
			//设置全局标识符
			if(elementCollection==null){
				layoutGroup.resizable = resizable;
				layoutGroup.isResizeAll = resizable;
				layoutGroup.isMoveAll = resizable;
			}
			
			
			if(resizable){
				addElementsResizeModel(layoutGroup,elementCollection);
				getNodeLayoutGroup().addEventListener(MouseEvent.MOUSE_DOWN,preventNodeRepulsion);
				getNodeLayoutGroup().addEventListener(MouseEvent.MOUSE_UP,restoreNodeRepulsion);
			}else{
				removeElementsResizeOrMoveModels(layoutGroup,elementCollection);
				getNodeLayoutGroup().removeEventListener(MouseEvent.MOUSE_DOWN,preventNodeRepulsion);
				getNodeLayoutGroup().removeEventListener(MouseEvent.MOUSE_UP,restoreNodeRepulsion);
				
				//为空则意味着针对该布局上所有元素
				if(elementCollection==null){
//					setLayoutGroupInteractionEnable(false,layoutGroup);
					layoutGroup.resizable = false;
				}
				restoreNodeRepulsionHandler();
			}
		}
		
		/**
		 * 使当前对象为选中状态。
		 */
		public function addToSelected(model:IData):void{
			var ui:IElementUI = getElementUI(model);
			if(ui==null)
				return;
			//设置为选中，但不调用文本加亮
			ui.isSelected = true;
			ui.isMultiSelectHighLightEnable = true;
			ui.refreshHighLight();
			if(!(model is Node))
				return;
			if(selectedElements.indexOf(model)==-1)
				selectedElements.push(model);
			
			//根据相应的ObjectHandles添加实体,排除默认添加的com.myflexhero.network.core.util.resize.DragGeometry
			if(moveHandles.modelList.length>1)
				moveHandles.selectionManager.addToSelected(model);
			else if(resizeHandles.modelList.length>1)
				resizeHandles.selectionManager.addToSelected(model);
		}
		
		public function getSelectionModels():Array{
			return moveHandles.selectionManager.currentlySelected.length>0?
						moveHandles.selectionManager.currentlySelected:
						(resizeHandles.selectionManager.currentlySelected.length>0?
							resizeHandles.selectionManager.currentlySelected:null);
		}
		
		public function clearSelectionModels():void{
			if(moveHandles.selectionManager.currentlySelected.length>0)
				moveHandles.selectionManager.currentlySelected.splice(0);
			if(resizeHandles.selectionManager.currentlySelected.length>0)
				resizeHandles.selectionManager.currentlySelected.splice(0);
			setSelectedElements(null);
		}
		
		public function removeSelectionModel(element:IData):void{
			if((element is Node)){
				moveHandles.selectionManager.removeFromSelected(element);
				resizeHandles.selectionManager.removeFromSelected(element);
				var eIndex:int = selectedElements.indexOf(element);
				if(eIndex!=-1)
					selectedElements.splice(eIndex,1);
			}
		}
		
		public function containsSelectionModel(data:IData):Boolean{
			var  currentlySelected:Array = moveHandles.selectionManager.currentlySelected;
			for(var i:int =0;i<currentlySelected.length;i++){
				if(currentlySelected[i]==data)
					return true;
			}
			currentlySelected = resizeHandles.selectionManager.currentlySelected;
			for(i =0;i<currentlySelected.length;i++){
				if(currentlySelected[i]==data)
					return true;
			}
			return false;
		}
		
		/**
		 * 根据传入的布局层为上面的所有数据元素注册事件.
		 * @param layoutGroup 影响的布局层
		 * @param nodeCollection 影响的数据元素集合。该参数针对已有的多个数据元素。该参数和element参数请2选一。
		 * @param element 对于新增单个数据元素，请通过该参数设置。该参数和nodeCollection参数请2选一。
		 */
		private function addElementsResizeModel(layoutGroup:BasicGroup,nodeCollection:Vector.<IData>=null,element:IElement=null):void{
			var datas:Vector.<IData>;
			/**
			 * 是否为layer布局器.
			 */
			var isLayerGroup:Boolean = false;
			
			if(nodeCollection&&nodeCollection.length>0){
				datas =  nodeCollection;
			}
			else if(element){
				datas = new Vector.<IData>();
				datas.push(element);
			}else{
				datas = getDataBox(layoutGroup).getDatas();
				//属于layer布局器,则跳过layer，设置有layerID属性的元素
				if(layoutGroup==_layerGroup){
					datas = elementBox.getDatas();
					isLayerGroup = true;
				}
			}
			
			var _element:*;
			for(var i:int=0;i< datas.length;i++){
				_element = datas[i];
				if(isLayerGroup){
					if(!_element.layerID)
						continue;
				}
				if(getElementUI(_element)==null){
					createElementUI(_element);
				}
				//已添加内部判断
				resizeHandles.registerComponent(_element,_elementUICollection[_element.id]);
			}
		}
		
		/**
		 * 根据容器删除全部Resize或Move事件对象引用.
		 * 
		 */
		private function removeElementsResizeOrMoveModels(layoutGroup:BasicGroup,elementCollection:Vector.<IData>=null,isResize:Boolean = true):void{
			var dataElements:* = elementCollection==null?getDataBox(layoutGroup).getDatas():elementCollection;
			for(var i:int=0;i< dataElements.length;i++){
				removeElementResizeOrMoveModel(dataElements[i],isResize);
			}
		}
		
		/**
		 * 删除单个Resize(或Move)事件对象引用
		 */
		private function removeElementResizeOrMoveModel(element:Object,isResize:Boolean):void{
			isResize?resizeHandles.unregisterModel(element):moveHandles.unregisterModel(element);
		}
		
		//***************************************************************************************
		//
		//    Move Interaction
		//
		//***************************************************************************************
		//当前调用是否非开发人员调用而是由内部的setResizeInteractionHandler()方法自动发起，默认为false。
		private var isCallFromResizeHandler:Boolean = false;
		//当前调用是否非开发人员调用而是由内部的setMoveInteractionHandler()方法自动发起，默认为false。
		private var isCallFromMoveHandler:Boolean = false;
		/**
		 * 设置可视对象是否可拖动
		 * @param movable 是否可以拖动组件，默认值为true。
		 * @param layoutGroup 设置在哪一层操作，默认为attachmentGroup的nodeGroup层(Node层)。
		 * @param elementCollection 设置对哪些节点或可视对象进行操作，如果为空，则默认对参数layoutGroup层上的所有Node进行操作。
		 * @param isCallFromResizeHandler 当前调用是否非开发人员调用而是由内部的setResizeInteractionHandler()方法自动发起，默认为false。
		 */
		public function setMoveInteractionHandler(movable:Boolean=true,layoutGroup:BasicGroup=null,elementCollection:Vector.<IData>=null):void{
			//激活selectHelper
			if(movable)
				_selectHelper.init(this);
			else if(!isCallFromResizeHandler&&!isInteractionActivated(InteractionType.RESIZE))//如果当前不存在可改变大小的节点，则卸载selectHelper监听.
				_selectHelper.uninstall();
			if(!isInteractionActivated(InteractionType.MOVE)){
				if(!movable)
					return;
			}
			
			layoutGroup = getDefaultAttachGroup(layoutGroup);
			
			/*首先设置原有的元素resize为move*/
			if(resizeHandles.modelList.length>0){
				isCallFromMoveHandler = true;
				setResizeInteractionHandler(false,layoutGroup,elementCollection,true);
				isCallFromMoveHandler = false;
			}
			/*再设置全局标识符为正确的标识符*/
			if(elementCollection==null){
				layoutGroup.movable = movable;
				layoutGroup.isMoveAll = movable;
			}
			
			if(movable){
				addElementsMovableModel(layoutGroup,elementCollection);
				/*去掉handle的圆点外观*/
				while(moveHandles.defaultHandles.length>0){
					moveHandles.defaultHandles.pop();
				}
				getNodeLayoutGroup().addEventListener(MouseEvent.MOUSE_DOWN,preventNodeRepulsion);
				getNodeLayoutGroup().addEventListener(MouseEvent.MOUSE_UP,restoreNodeRepulsion);
			}else{
				removeElementsResizeOrMoveModels(layoutGroup,elementCollection,false);
				getNodeLayoutGroup().removeEventListener(MouseEvent.MOUSE_DOWN,preventNodeRepulsion);
				getNodeLayoutGroup().removeEventListener(MouseEvent.MOUSE_UP,restoreNodeRepulsion);
				/*为空则意味着针对该布局上所有元素*/
				if(elementCollection==null){
//					setLayoutGroupInteractionEnable(false,layoutGroup);
					movable = false;
				}
				restoreNodeRepulsionHandler();
			}
		}
		
		private function addElementsMovableModel(layoutGroup:BasicGroup,nodeCollection:Vector.<IData>=null,element:IElement=null):void{
			var datas:Vector.<IData>;
			/**
			 * 是否为layer布局器.
			 */
			var isLayerGroup:Boolean = false;
			if(nodeCollection&&nodeCollection.length>0){
				datas =  nodeCollection;
			}
			else if(element){
				datas = new Vector.<IData>();
				datas.push(element);
			}else{
				datas = getDataBox(layoutGroup).getDatas();
				//属于layer布局器,则跳过layer，设置有layerID属性的元素
				if(layoutGroup==_layerGroup){
					datas = elementBox.getDatas();
					isLayerGroup = true;
				}
			}
			
			var _element:*;
			for(var i:int=0;i< datas.length;i++){
				_element = datas[i];
				if(isLayerGroup){
					if(!_element.layerID)
						continue;
				}
				if(getElementUI(_element)==null){
					var elementUI:IElementUI =  createElementUI(_element);
					/* 排除com.myflexhero.network.Dummy类 */
					if(elementUI==null)
						continue;
				}
				//已添加内部判断
				moveHandles.registerComponent(_element,_elementUICollection[_element.id]);
			}
		}

		//***************************************************************************************
		//
		//    激活Link创建
		//
		//***************************************************************************************
		/**
		 * 当前是否在创建动态连接
		 */
		public var isDynamicLinkActive:Boolean = false;
		/**
		 * 动态创建link连接点.
		 * <p>
		 * 如需对返回的动态创建的link进行操作，请通过对network进行事件监听来获得对该link的引用.<br>
		 * (事件名：<b>DataBoxChangeEvent</b>,<br>事件<b>kind:DataBoxChangeEvent.ADD</b>,<br>对事件data进行"<b>is Link</b>"的判断)。
		 * </p>
		 * @param enable 是否激活,false为关闭激活。
		 */
		public function setDynamicLinkInteractionHandler(enable:Boolean = true):void{
			/* 当前处于激活状态，则删除监听 */
			if(!enable){
				if(linkUIDummy)
					linkUIDummy.reset();
				removeEventListener(MouseEvent.MOUSE_MOVE,createLinkInteractionOnMouseMove);
				sendNodeGroupToTop(false);
			}
			if(!this.isDynamicLinkActive){
				if(!enable)
					return;
			}

			if(enable){
				getNodeLayoutGroup().addEventListener(MouseEvent.CLICK,createLinkInteractionOnMouseDown);
				this.isDynamicLinkActive = true;
				sendNodeGroupToTop();
			}
			else{
				getNodeLayoutGroup().removeEventListener(MouseEvent.CLICK,createLinkInteractionOnMouseDown);
				if(linkUIDummy){
					linkUIDummy.reset();
					if(getLinkLayoutGroup().containsData(linkUIDummy)){
						getLinkLayoutGroup().removeData(linkUIDummy);
					}
					linkUIDummy = null;
				}
				removeEventListener(MouseEvent.MOUSE_MOVE,createLinkInteractionOnMouseMove);
			}
		}
		
		/**
		 * 一些临时变量
		 */
		private var nodeUIDummy:NodeUI=null;
		private var linkUIDummy:LinkUI = null;
		private var linkDummy:Link = null;
		private function createLinkInteractionOnMouseDown(event:MouseEvent):void{
			if(event.target is NodeUI){
				nodeUIDummy = event.target as NodeUI;
				
				//首次创建
				if(isDynamicLinkActive){
					linkDummy = new Link();
					linkDummy.fromNode = nodeUIDummy.element;
					if(!linkUIDummy){
						linkUIDummy = new LinkUI(this,linkDummy);
						getLinkLayoutGroup().addData(linkUIDummy);
						/*移除节点事件监听*/
						linkUIDummy.reset();
					}
					linkUIDummy.element = linkDummy;
					addEventListener(MouseEvent.MOUSE_MOVE,createLinkInteractionOnMouseMove);
				}else{
					/*仅创建link，并清除linkUI的属性，供下次使用*/
					linkUIDummy.reset();
					var toNode:Node = (event.target as NodeUI).element;
					/****************************  
					 * 
					 * 位置调换,将原来的toNode.parent改为了linkDummy.fromNode.parent,此处已删除
					 ****************************/
					
//					/* 已经有相反连接，则删除原有的link关联 */
//					var _oldLink:Link = getLinkReference(toNode,linkDummy.fromNode);
//					if(_oldLink!=null){
//						setLinkReference(_oldLink,true);
//					}
//					elementBox.linkBox.removeData(_oldLink);
					
					/* 这里不允许fromNode=toNode的节点存在，根据情况去掉限制 */
					if(toNode!=linkDummy.fromNode){
						var link:Link = new Link();
						/****************************  
						 * 
						 * 位置调换，一般的逻辑是箭头指向的节点是父亲节点。
						 * 点击第一次时，fromNode作为toNode(子节点),
						 * 点击第二次时,此时toNode作为箭头的指向作为父节点。
						 ****************************/
						link.fromNode = linkDummy.fromNode;
						link.toNode = toNode; 			

						elementBox.add(link);
					}
					removeEventListener(MouseEvent.MOUSE_MOVE,createLinkInteractionOnMouseMove);
				}
			}
		}
		
		/**
		 * 解决Link和Node不能同时都监听到MouseDown事件。当Node可以移动时，link无法获得焦点。此时通过设置LinkGroup的index大于NodeGroup的index即可。
		 * @param sendToTop 当值为true时，只有Node能获得焦点。当为false时，Link和Node都能够获得焦点。
		 */
		private function sendNodeGroupToTop(sendToTop:Boolean = true):void{
			_attachmentGroup.setDataIndex(_linkGroup,sendToTop?0:1);
			_attachmentGroup.setDataIndex(_nodeGroup,sendToTop?1:0);
		}
		private function createLinkInteractionOnMouseMove(event:MouseEvent):void{
//			trace("_rootGroup.mouseX:"+_rootGroup.mouseX+",_rootGroup.mouseY:"+_rootGroup.mouseY)
			if(nodeUIDummy){
				linkUIDummy.showFromLink(nodeUIDummy.element,_rootGroup.mouseX, _rootGroup.mouseY);
				linkUIDummy.removePropertyChangeListener();
			}
		}
		
		//***************************************************************************************
		//
		//   Override
		//
		//***************************************************************************************
		override protected function commitProperties():void{
			super.commitProperties();
			if(_backgroundColorChanged){
				_backgroundGroup.backgroundColor = _backgroundColor;
				_backgroundColorChanged = false;
			}
			
			if(_backgroundColorAlphaChanged){
				_backgroundGroup.backgroundColorAlpha = _backgroundColorAlpha;
				_backgroundColorAlphaChanged = false;
			}
			
			if(_backgroundColorLinearChanged){
				_backgroundGroup.backgroundColorLinear = _backgroundColorLinear;
				_backgroundColorLinearChanged = false;
			}
			if(_backgroundImageChanged){
				_backgroundGroup.setBackgroundImage(_backgroundImage);
				_backgroundImageChanged = false;
			}
		} 
		
		//***************************************************************************************
		//
		//    getter setter
		//
		//***************************************************************************************
		public function get scroller():Scroller
		{
			return _scroller;
		}
		
		public function get scrollerGroup():Group
		{
			return _scrollerGroup;
		}
		
		public function get rootGroup():BasicGroup
		{
			return _rootGroup;
		}

		public function get topGroup():BasicGroup
		{
			return _topGroup;
		}

		public function get attachmentGroup():BasicGroup
		{
			return _attachmentGroup;
		}

		public function get layerGroup():BasicGroup
		{
			return _layerGroup;
		}
		
		public function get bottomGroup():BasicGroup
		{
			return _bottomGroup;
		}

		public function get backgroundGroup():BasicGroup
		{
			return _backgroundGroup;
		}
		
		public function get customGroup():BasicGroup
		{
			return _customGroup;
		}
		
		
		public function get dataGroup():BasicGroup
		{
			return _dataGroup;
		}
		
		public function getImageName(element:IElement) : String
		{
			return element.icon;
		}
		
		private function getDefaultAttachGroup(layoutGroup:BasicGroup):BasicGroup{
			return layoutGroup==null?getNodeLayoutGroup():layoutGroup;
		}
		
		/**
		 * (仅供程序内部使用)<br>
		 * 用于判断是否外部设置了水平滚动属性
		 */
		mx_internal var horizontalScollPolicyChanged:Boolean = true;
		[Inspectable(category="General", enumeration="on,off,auto", defaultValue="auto")]
		/**
		 * 设置水平滚动条显示策略,可选的值有on,off,auto.
		 */
		public function set horizontalScrollPolicy(value:String):void{
			_scroller.setStyle("horizontalScrollPolicy",value);
			if(value=="off")
				horizontalScollPolicyChanged = false;
			else
				horizontalScollPolicyChanged = true;
		}
		
		public function get horizontalScrollPolicy():String{
			return horizontalScollPolicyChanged?_scroller.getStyle("horizontalScrollPolicy"):"off";
		}
		
		/**
		 * (仅供程序内部使用)<br>
		 * 用于判断是否外部设置了垂直滚动属性
		 */
		mx_internal var verticalScollPolicyChanged:Boolean = true;
		[Inspectable(category="General", enumeration="on,off,auto", defaultValue="auto")]
		/**
		 * 设置垂直滚动条显示策略,可选的值有on,off,auto.
		 */
		public function set verticalScrollPolicy(value:String):void{
			_scroller.setStyle("verticalScrollPolicy",value);
			if(value=="off")
				verticalScollPolicyChanged = false;
			else
				verticalScollPolicyChanged = true;
		}
		
		public function get verticalScrollPolicy():String{
			return verticalScollPolicyChanged?_scroller.getStyle("verticalScrollPolicy"):"off";
		}
		
		public function getCurrentAutoLayout():ICustomLayout{
			return _currentAutoLayout;
		}
		
		public function setCurrentAutoLayout(autoLayout:ICustomLayout):void{
			_currentAutoLayout = autoLayout;
		}
		
		/**
		 * 重置界面到原始大小。请通过调用network.scaleEffect.scaleXBy和network.scaleEffect.scaleYBy参数调整每次的放大缩小对比因子。
		 */
		public function zoomReset() : void
		{
			beforeScrollAdjust();
			scaleEffect.zoomReset();
		}
		
		/**
		 * 放大界面。请通过调用network.scaleEffect.scaleXBy和network.scaleEffect.scaleYBy参数调整每次的放大缩小对比因子。
		 */
		public function zoomIn() : void
		{
			beforeScrollAdjust();
			scaleEffect.zoomIn();
		}
		/**
		 * 缩小界面。请通过调用network.scaleEffect.scaleXBy和network.scaleEffect.scaleYBy参数调整每次的放大缩小对比因子。
		 */
		public function zoomOut() : void
		{
			beforeScrollAdjust();
			scaleEffect.zoomOut();
		}
		
		private function beforeScrollAdjust():void{
			this.scaleEffect.zoomInscale.addEventListener(EffectEvent.EFFECT_END,adjustScrollBar);
			this.scaleEffect.zoomOutscale.addEventListener(EffectEvent.EFFECT_END,adjustScrollBar);
			this.scaleEffect.zoomResetscale.addEventListener(EffectEvent.EFFECT_END,adjustScrollBar);
		}
		
		/**
		 * 调整滚动条位置
		 */
		private function adjustScrollBar(e:EffectEvent):void{
			ensureElementIsVisible();
		}
		
		/**
		 * 设置元素可见.当调整屏幕缩放比例等属性后，部分元素可能不在当前屏幕内，需要滑动滚动条才能可见。通过调用该方法，使该元素尽量居中显示。
		 * @param node 需要滑动滚动条使元素
		 */
		public function ensureElementIsVisible(node:Node=null):void{
			if(this.attachmentGroup.width>this.width||this.attachmentGroup.height>this.height){
				var compareNode:Node;
				var xScale:Number = this.dataGroup.scaleX;
				var yScale:Number = this.dataGroup.scaleY;
				if(node){
					//Step1 设置操作对象
					compareNode = node;
				}
				else{
					//Step2 如果存在多选的对象，则以多选的对象作为中心点
					if(selectedElements.length>0){
						var sum:Number=0;
						for each(var element:Element in selectedElements){
							if(element is Node){
								var n:Node = element as Node;
								if(sum==0||n.x+n.y<sum){
									sum = n.x+n.y;
									compareNode = n;
								}
								
							}
						}
					}
					else{
						//Step3 如果当前未选中任何节点，则在屏幕中心模拟一个节点
						compareNode = new Node();
						compareNode.isLocked = true;
						compareNode.x = dataGroup.width/2-16;
						compareNode.y = dataGroup.height/2-16;
						compareNode.width = 32;
						compareNode.height = 32;
					}
				}
				//SmallNodeUI为非IVisualElement.
				//ensureElementIsVisible中调用 var eltBounds:Rectangle = layout.getChildElementBounds(element)时计算无法获取有效值，这里手动更改
				//this.scroller.ensureElementIsVisible(getElementUI(compareNode) as UIComponent);
				var eltBounds:Rectangle =  new Rectangle(compareNode.x*xScale,
					compareNode.y*yScale,
					compareNode.width*xScale,
					compareNode.height*yScale);
				var focusThickness:Number = 2;
				var elementUI:IElementUI = getElementUI(compareNode);
				if (elementUI is IStyleClient)
					focusThickness = IStyleClient(elementUI).getStyle("focusThickness");
				
				// Step3 调整滚动条，使节点居中显示.
				if (focusThickness)
				{
					scroller.viewport.verticalScrollPosition = eltBounds.bottom + focusThickness - scroller.height+scroller.height/2;
					scroller.viewport.horizontalScrollPosition = eltBounds.right + focusThickness - scroller.width+scroller.width/2;
				}
				if(scroller.viewport is UIComponent)
					UIComponent(scroller.viewport).validateNow()
				
			}
			this.scaleEffect.zoomInscale.removeEventListener(EffectEvent.EFFECT_END,adjustScrollBar);
			this.scaleEffect.zoomOutscale.removeEventListener(EffectEvent.EFFECT_END,adjustScrollBar);
			this.scaleEffect.zoomResetscale.removeEventListener(EffectEvent.EFFECT_END,adjustScrollBar);
		}
		
		/**
		 * 通过缩放显示比例来让所有节点都展示出来，
		 */
		public function zoomShowAll():void{
			if(this.maxXPointNode==null||this.maxYPointNode==null){
				scaleEffect.zoomShowAll(Math.min(this.width/this.rootGroup.width,this.height/this.rootGroup.height));
				return;
			}
			var zoomX:Number = this.maxPoint.x;
			var zoomY:Number = this.maxPoint.y;
			
			//如果小于屏幕大小，则按原始大小进行显示。
			if(zoomX<this.width
				&&zoomY<this.height){
				scaleEffect.zoomReset();
				return;
			}
			
			if(isNaN(zoomX)||zoomX<=0)
				zoomX = this.rootGroup.width;
			if(isNaN(zoomY)||zoomY<=0)
				zoomY = this.rootGroup.height;
			
			//最大节点坐标+节点宽度或高度+默认添加30作为扩展边缘。
			var zoomToXValue:Number = this.width/zoomX;
			var zoomToYValue:Number = this.height/zoomY;
			var zoomToMin:Number = Math.min(zoomToXValue,zoomToYValue);
			if((zoomToXValue>=0.83&&zoomToYValue>=0.97)||zoomToMin>1)
				scaleEffect.zoomReset();
			else
				scaleEffect.zoomShowAll(zoomToMin);
		}
		
		/**
		 * 返回主容器的缩放因子大小(以X轴为标准)。默认为1.
		 */
		public function getZoomScaleValue():Number{
			return this.rootGroup.scaleX;
		}
		
		/**
		 * 根据特定的显示对象返回元素集合
		 */
		public function getElementsByDisplayObject(displayObject:DisplayObject, intersectMode:Boolean = true, accuracy:Number = 1) : Vector.<Element>
		{
			var _datas:Vector.<Element> = new Vector.<Element>();
			var displayObject:* = displayObject;
			forEachElementUI(function (ui:IElementUI) : Boolean
			{
				if (ui.isHitByDisplayObject(displayObject, intersectMode, accuracy))
				{
					_datas.push(ui.element);
				}
				return true;
			});
			return _datas;
		}
		
		public function getElementByMouseEvent(event:MouseEvent, shouldBeSelectable:Boolean = true, tolerance:int = -1) : IElement
		{
			var e:* = event;
			var shouldBeSelectable:* = shouldBeSelectable;
			var element:IElement;
			if (networkTransparentSelectionEnable)
			{
				if (e.target is IElementUI)
				{
					element = IElementUI(e.target).element;
				}
				else if (e.target is Attachment)
				{
					element = Attachment(e.target).element;
				}
			}
			if (!_selectHelper.isValidMouseEvent(e))
			{
				return null;
			}
			if (tolerance < 0)
			{
				tolerance = networkSelectionTolerance;
			}
			if (element == null)
			{
			
				if (tolerance > 0)
				{
					forEachElementUI(function (ui:IElementUI) : Boolean
					{
						if (ui.isHit(new Point(e.stageX, e.stageY), tolerance, true))
						{
							element = ui.element;
							return false;
						}
						return true;
					}// end function
					);
				}
			
				if (shouldBeSelectable)
				{
	//				if (this.selectionModel.isSelectable(element))
	//				{
					if(element is Node)
						return element;
	//				}
				}
				return null;
			}
			else
			{
				return element;
			}
		}
		
		public function forEachElementUI(callFunc:Function, layer:ILayer = null) : void
		{
			var datas:Vector.<IData> = elementBox.getDatas();
			if(datas!=null)
			for each(var data:IData in datas){
				var ui:IElementUI = getElementUI(data);
				if(ui!=null)
					callFunc(ui);
			}
		}
		public function getScopeRect(type:String) : Rectangle
		{
			if (type == Consts.SCOPE_VIEWSIZE)
			{
				return new Rectangle(0, 0,_dataGroup.width,_dataGroup.height);
			}
			throw new Error("Can not resolve \'" + type + "\' scope");
		}
		
		public function getStageRectangle(rect:Rectangle) : Rectangle
		{
			if (rect == null)
			{
				return null;
			}
			var _point1:* = this.rootGroup.localToGlobal(rect.topLeft);
			var _point2:* = this.rootGroup.localToGlobal(rect.bottomRight);
			return ElementUtil.getRectangle(_point1.x, _point1.y, _point2.x, _point2.y);
		}
		
		
		/**
		 * 快捷的方式导出为图片格式.
		 * @param rectangle 需要自定义的图片尺寸大小,建议为空.
		 * @param zoom 放大缩小的倍数，默认值为1,建议使用默认值.
		 * 程序中请使用以下方式调用:<pre>
		 * var fr:Object = new FileReference();	
				if(fr.hasOwnProperty("save")){
					var bitmapData:BitmapData = network.exportAsBitmapData(); 
					var encoder:PNGEncoder = new PNGEncoder();
					var data:ByteArray = encoder.encode(bitmapData);
					fr.save(data, 'network.png');
				}
		 * </pre>.
		 */
		public function exportAsBitmapData(rectangle:Rectangle = null, zoom:Number = 1) : BitmapData
		{
			if (rectangle == null)
			{
				rectangle = getScopeRect(Consts.SCOPE_VIEWSIZE);
			}
			var _imageWidth:Number = Math.max(1, rectangle.width * zoom);
			var _imageHeight:Number = Math.max(1, rectangle.height * zoom);
			var totalPixel:Number = _imageWidth*_imageHeight;
			//不能超过最大像素
			if(totalPixel>16777215){
				var tw:Number = _imageWidth;
				var th:Number = _imageHeight;
				zoom = Math.sqrt(16777200/(tw*th));
				_imageWidth = _imageWidth*zoom;
				_imageHeight = _imageHeight*zoom;
//				Alert.show("由于导出的图片宽高超过Flash Player所支持的最大限度,将以此限度进行缩小.","导出提示")
			}
			
			var _matrix_loc:* = new Matrix();
			_matrix_loc.scale(zoom, zoom);
			_matrix_loc.translate((-rectangle.x) * zoom, (-rectangle.y) * zoom);
			var _bitmapData:BitmapData = new BitmapData(_imageWidth, _imageHeight, true, 0);
			_bitmapData.draw(_dataGroup, _matrix_loc);
			return _bitmapData;
		}
		/**
		 * 背景颜色
		 */
		public function get backgroundColor():Array
		{
			return _backgroundColor;
		}
		/**
		 * 背景颜色
		 */
		public function set backgroundColor(value:Array):void
		{
			_backgroundColor = value;
			_backgroundColorChanged = true;
			invalidateProperties();
		}
		/**
		 * 背景颜色是否使用渐变效果,默认值为true
		 */
		public function get backgroundColorLinear():Boolean
		{
			return _backgroundColorLinear;
		}

		/**
		 * 背景颜色是否使用渐变效果,默认值为true
		 */
		public function set backgroundColorLinear(value:Boolean):void
		{
			_backgroundColorLinear = value;
			_backgroundColorLinearChanged = true;
			invalidateProperties();
		}

		/**
		 * 背景颜色透明度
		 */
		public function get backgroundColorAlpha():Number
		{
			return _backgroundColorAlpha;
		}

		/**
		 * 背景颜色透明度
		 */
		public function set backgroundColorAlpha(value:Number):void
		{
			_backgroundColorAlpha = value;
			_backgroundColorAlphaChanged = true;
			invalidateProperties();
		}
		/**
		 * 背景图片URL
		 */
		public function get backgroundImage():String
		{
			return _backgroundImage;
		}
		
		public function set backgroundImage(value:String):void
		{
			_backgroundImage = value;
			_backgroundImageChanged = true;
			invalidateProperties();
		}
		
		public function get selectOutlineColor() : Number
		{
			return this.networkSelectOutlineColor;
		}
		
		public function get selectOutlineWidth() : Number
		{
			return this.networkSelectOutlineWidth;
		}
		
		public function get selectFillColor() : Number
		{
			return this.networkSelectFillColor;
		}
		public function get selectFillAlpha() : Number
		{
			return this.networkSelectFillAlpha;
		}
		
		public function get transparentSelectionEnable() : Boolean
		{
			return this.networkTransparentSelectionEnable;
		}
		
		public function get selectionTolerance() : int
		{
			return this.networkSelectionTolerance;
		}
		
		/**
		 * 当鼠标按下时(MouseDown)，该Data数据对象的UI包装类将处于选中状态。
		 */
		public function get selectedElements():Vector.<Element>
		{
			return _selectedElements;
		} 

		public function get imageLoader():ImageLoader{
			return _imageLoader;
		}
		/**
		 * 根据传入的element.layerID属性返回对应的layer画布层(Group类型)
		 */
		public function getLayerCanvasByElement(element:IElement):Group{
			var _layer:ILayer = this._elementBox.layerBox.getLayerByElement(element);
			if (_layer == null)
			{
				return null;
			}
			return this._layerCollection[_layer];	
		}
		
		/**
		 * 返回一个空的new Vector(Node)对象。供程序快速使用,一般无需调用。
		 */
		public static function createVectorNodes():Vector.<Node>{
			return new Vector.<Node>();
		}
		
		/**
		 * 返回一个空的new Vector(Link)对象。供程序快速使用,一般无需调用。
		 */
		public static function createVectorLinks():Vector.<Link>{
			return new Vector.<Link>();
		}
		
		/**
		 * 根据传入的Layer返回对应的layer画布层(Group类型)
		 */
		public function getLayerCanvas(layer:Layer):Group{
			return this._layerCollection[layer];	
		}
		/**
		 * 界面模拟windows的鼠标拉线选择器,通过该选择器进行多选控制.
		 */
		public function get selectHelper():SelectHelper
		{
			return _selectHelper;
		}
		
		/**
		 * 设置当前选中元素.三种模式：<br>
		 * 1，如果传入value为空，则清空当前selectedElements对象。<br>
		 * 2，如果传入value不为空，如果isAppendMode参数为true，则进行添加操作.<br>
		 * 3，如果传入value不为空，如果isAppendMode参数为false，则先进行清空，再进行添加操作.<br>
		 * 如果传入的Element不为空，还将派发InteractionEvent.SELECTED_START事件。<br>
		 * @param isAppendMode 是否为添加模式。如果是添加模式，则如果element参数不为空，将进行添加，而不清空先前的。
		 */
		public function setSelectedElements(value:Element=null,isAppendMode:Boolean = false,mouseEvent:MouseEvent=null):void
		{
			//已存在，返回.
			if(value!=null&&_selectedElements.indexOf(value)!=-1)
				return;
			var ui:IElementUI;
			//清除已有
			if((!isAppendMode||value==null)&&_selectedElements.length>0){
				for each(var element:Element in _selectedElements){
					ui = getElementUI(element);
					if(ui){
						ui.isSelected = false;
						ui.mouseDown = false;
						ui.isMultiSelectHighLightEnable = false;
						ui.labelStyleChanged = true;
						if(ui is LinkUI)
							LinkUI(ui).actionByArrow = true;//如果是LinkUI，需设置该标示位进行界面重绘
						ui.updateLabelAttachmentProperties();
						ui.refreshLabelAttachment();
						ui.refreshHighLight();
					}
				}
				_selectedElements.splice(0,_selectedElements.length);
			}
			
			if(value){
				_selectedElements.push(value);
				ui = getElementUI(value);
				/* 重新赋值 */
				ui.mouseDown = true;
				ui.isSelected = true;
				if(ui is LinkUI)
					LinkUI(ui).actionByArrow = true;//如果是LinkUI，需设置该标示位进行界面重绘
				ui.labelStyleChanged = true;
				ui.updateLabelAttachmentProperties();
				ui.refreshLabelAttachment();
				ui.refreshHighLight();
				dispatchEvent(new InteractionEvent(InteractionEvent.SELECTED_START,this,mouseEvent,value));
				
			}
		}
		
		//***************************************************************************************
		//
		//    原先放置于Node的全局变量，现在改成局部变量。
		//
		//***************************************************************************************
		
		mx_internal var maxXPointNode:Node;
		mx_internal var maxYPointNode:Node;
		
		mx_internal var minXPointNode:Node;
		mx_internal var minYPointNode:Node;
		/**
		 * 用于对比，当前所有节点中x、y值最大的坐标(添加了nodeWidth和nodeHeight值)
		 */
		mx_internal var maxPoint:Point = new Point();
		
		/**
		 * 当前所有节点中x、y值最小的坐标(未添加nodeWidth和nodeHeight值)，用于调整所有节点，使其靠近左侧和顶部边缘。
		 */
		mx_internal var minPoint:Point = new Point();
		
		/**
		 * 用于对比超出屏幕的x节点
		 */
		mx_internal var outOfBoundXNodes:Dictionary = new Dictionary();
		/**
		 * 用于对比超出屏幕的y节点
		 */
		mx_internal var outOfBoundYNodes:Dictionary = new Dictionary();
		/**
		 * 超出屏幕的X节点集合
		 */
		mx_internal var outOfBoundXNodeVector:Vector.<Node> = new Vector.<Node>;
		/**
		 * 超出屏幕的Y节点集合
		 */
		mx_internal var outOfBoundYNodeVector:Vector.<Node> = new Vector.<Node>;
		/**
		 * 最小节点知否已初始化
		 */ 
		mx_internal var isMinPointInited:Boolean = false;
		/**
		 * 是否需要检查Node的边界(即调用NodeUI的coordinateHandler方法。该方法在绘制Node时将检查RootGroup边界).
		 */
		mx_internal var needCheckBoundary:Boolean = true;
		/**
		 * 重置该节点的静态变量，将outOfBoundXNodeVector、outOfBoundYNodeVector等数据清空，去掉相应对象的引用。
		 */
		mx_internal function reset():void{
			outOfBoundXNodeVector.splice(0,outOfBoundXNodeVector.length);
			outOfBoundYNodeVector.splice(0,outOfBoundYNodeVector.length);
			maxPoint.x =0;
			maxPoint.y =0;
			minPoint.x =this.width;
			minPoint.y =this.height;
			maxXPointNode =null;
			maxYPointNode =null;
			minXPointNode =null;
			minYPointNode =null;
			isReferenceNodeInited = false;
			isMinPointInited = false;
			for(var key:Object in outOfBoundXNodes){
				delete outOfBoundXNodes[key];
			}
			for(key in outOfBoundYNodes){
				delete outOfBoundYNodes[key];
			}
		}

		mx_internal var nodeImages:Dictionary = new Dictionary();
		
	}
}