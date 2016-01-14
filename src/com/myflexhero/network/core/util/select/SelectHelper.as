package com.myflexhero.network.core.util.select
{
	import com.myflexhero.network.BasicGroup;
	import com.myflexhero.network.Consts;
	import com.myflexhero.network.Defaults;
	import com.myflexhero.network.Element;
	import com.myflexhero.network.Network;
	import com.myflexhero.network.Node;
	import com.myflexhero.network.Utils;
	import com.myflexhero.network.core.IElement;
	import com.myflexhero.network.core.image.ImageLoader;
	import com.myflexhero.network.core.ui.ElementUI;
	import com.myflexhero.network.core.ui.SmallElementUI;
	import com.myflexhero.network.core.util.ElementUtil;
	import com.myflexhero.network.core.util.resize.ObjectHandles;
	import com.myflexhero.network.core.util.resize.VisualElementHandle;
	import com.myflexhero.network.event.InteractionEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;
	
	import mx.controls.Button;
	import mx.controls.scrollClasses.ScrollThumb;
	import mx.core.UIComponent;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.HScrollBar;
	import spark.components.VScrollBar;

	/**
	 * 类似windows的鼠标选择器.添加了对其功能.
	 * @author hedy
	 */
	public class SelectHelper
	{
		private var network:Network = null;
		private var networkMouseDownPoint:Point;
		private var networkMouseMovePoint:Point;
		private var mark:UIComponent = null;
		private var networkSelectMode:String = Defaults.NETWORK_SELECT_MODE;
		/**
		 * 保存上一次的坐标
		 */
		private var elementOldCoordinates:Dictionary;
		
		public function SelectHelper(network:Network)
		{
			this.network = network;
			this.elementOldCoordinates = new Dictionary();
		}
		
		protected function dispatchEvent(kind:String, e:MouseEvent, element:IElement = null, resizeDirection:String = null, pointIndex:int = -1) : void
		{
			var _interactionEvent:InteractionEvent = new InteractionEvent(kind, this.network, e, element);
			_interactionEvent.resizeDirection = resizeDirection;
			_interactionEvent.pointIndex = pointIndex;
			network.dispatchEvent(_interactionEvent);
		}
		/**
		 * 是否处于激活状态
		 */
		public var isActived:Boolean = false;
		public function init(network:Network) : void
		{
			if(isActived)
				return;
			this.network.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown,false,0,true);
			this.network.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp,false,0,true);
			if(VisualElementHandle.resizeIconData==null)
				VisualElementHandle.resizeIconData =  Utils.getImageAsset(network.imageLoader,"resize_handle",false).bitmapData;
			if(network.resizeHandles ==null)
				network.resizeHandles =  new ObjectHandles(network.attachmentGroup);
			if(network.moveHandles ==null)
				network.moveHandles =  new ObjectHandles(network.attachmentGroup);
			network.resizeHandles.network = network;
			network.moveHandles.network = network;
			network.showHandCursor(false);
			if(leftJustify==null){
				leftJustify = new ContextMenuItem("向最左边的元素垂直对齐",true,true,true); 
				leftJustify.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,leftJustifyHandler);
			}
			if(rightJustify==null){
				rightJustify = new ContextMenuItem("向最右边的元素垂直对齐",true,true,true); 
				rightJustify.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,rightJustifyHandler);
			}
			if(topJustify==null){
				topJustify = new ContextMenuItem("向最上边的元素水平对齐",true,true,true); 
				topJustify.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,topJustifyHandler);
			}
			if(bottomJustify==null){
				bottomJustify = new ContextMenuItem("向最下边的元素水平对齐",true,true,true); 
				bottomJustify.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,bottomJustifyHandler);
			}
			if(revertJustify==null){
				revertJustify = new ContextMenuItem("恢复到上次对齐前的位置",true,true,true); 
				revertJustify.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,revertJustifyHandler);
			}
			
			if(customContextMenu==null){
				customContextMenu  = new ContextMenu();   
				customContextMenu.hideBuiltInItems();
				customContextMenu.customItems.push(leftJustify); 
				customContextMenu.customItems.push(rightJustify); 
				customContextMenu.customItems.push(topJustify); 
				customContextMenu.customItems.push(bottomJustify); 
				customContextMenu.customItems.push(revertJustify);
			}
			isActived = true;
		}
		
		public function uninstall() : void
		{
			if(!isActived)
				return;
			this.network.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			this.network.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
//			network.resizeHandles.network = null;
//			network.moveHandles.network = null;
//			this.handleMouseUp(null);
			network.showHandCursor();
			isActived = false;
		}
		
		private var isClickOther:Boolean = false;
		public function handleMouseDown(event:MouseEvent) : void
		{
			if(event.target is ElementUI||event.target is SmallElementUI){
				isClickOther = true;
				return;
			}
			//Step1 首先判断点击的是否为容器
			if(!(event.target is Group)){
				var element:* = event.target;
				var p:*;
				var isClickAttachment:Boolean = false;
				while(element){
					//Step2 点击的是滚动条
					if((element is spark.components.Button)||(element is mx.controls.Button))
						break;
					//Step3 当前元素(如背景图片)的父类为BasicGroup，且当前不是滚动条的按钮
					if(element is BasicGroup){
						isClickAttachment = true;
						//派发点击背景事件。即未点击元素。
						network.dispatchEvent(new InteractionEvent(InteractionEvent.CLICK_BACKGROUND,network,event,null));
						break;
					}
					element = element.parent;
				}
				if(!isClickAttachment){
					isClickOther = true;
					return;
				}
			}
			
			//Step4 是否为Resize组件发起的MouseDown事件
			if(network.isResizeHandleMouseDown)
				return;
			if(isMarkShowing)
				isMarkShowing = false;
			var _element:IElement = network.getElementByMouseEvent(event);
			var _elementUI:ElementUI;
			if (_element == null)
			{
				if (!event.ctrlKey)
				{
					this.network.clearSelectionModels();
				}
				this.start(event);
			}
			else if (event.ctrlKey)
			{
				if (this.network.containsSelectionModel(_element))
				{
					this.network.removeSelectionModel(_element);
				}
				else
				{
					this.network.addToSelected(_element);
				}
			}
			//已经由Network的mouseDown监听
//			else if ((_element is Node)&&!this.network.containsSelectionModel(_element))
//			{
//				this.network.addToSelected(_element);
//			}
			
		}
		
		public var isMarkShowing:Boolean = false;
		private function start(event:MouseEvent) : void
		{
			this.networkMouseDownPoint = this.network.customGroup.globalToLocal(new Point(event.stageX, event.stageY));
			this.networkMouseDownPoint.x = this.networkMouseDownPoint.x*this.network.attachmentGroup.scaleX;
			this.networkMouseDownPoint.y = this.networkMouseDownPoint.y*this.network.attachmentGroup.scaleY;
			this.network.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
		}
		
		private function handleMouseMove(event:MouseEvent) : void
		{
			
			if (!this.isValidMouseEvent(event))
			{
				return;
			}
			if (this.mark == null)
			{
				this.mark = new UIComponent();
				this.network.customGroup.addElement(this.mark);
				//				this.isSelectingElement = true;
				//				this.K2564K = SystemLicense.setCursorCross();
				this.dispatchEvent(InteractionEvent.SELECTED_START, event);
			}
			else
			{
				this.dispatchEvent(InteractionEvent.SELECT_BETWEEN, event);
			}
			this.networkMouseMovePoint = network.customGroup.globalToLocal(new Point(event.stageX, event.stageY));
			this.networkMouseMovePoint.x = this.networkMouseMovePoint.x*this.network.attachmentGroup.scaleX;
			this.networkMouseMovePoint.y = this.networkMouseMovePoint.y*this.network.attachmentGroup.scaleY;
			var _rectangle:* = ElementUtil.getRectangle(networkMouseDownPoint.x, networkMouseDownPoint.y, networkMouseMovePoint.x, networkMouseMovePoint.y);
			var _markGraphics:Graphics = mark.graphics;
			_markGraphics.clear();
			_markGraphics.lineStyle(this.network.selectOutlineWidth, this.network.selectOutlineColor, 1, false, Consts.SCALE_MODE_NONE);
			if (compareSelectMode)
			{
				_markGraphics.beginFill(this.network.selectFillColor, this.network.selectFillAlpha);
			}
			_markGraphics.drawRect(_rectangle.x, _rectangle.y, _rectangle.width, _rectangle.height);
			if (compareSelectMode)
			{
				_markGraphics.endFill();
			}
			isMarkShowing = true;
			return;
		}
		
		
		public function handleMouseUp(event:MouseEvent) : void
		{
			if(isClickOther){
				isClickOther = false;
				return;
			}
				
			if(network.isResizeHandleMouseDown){
				clearMouseUp();
				return;
			}
			var _elements: Vector.<Element> = null;
			var selectionModels: Vector.<Element> = null;
			var _index:int = 0;
			var _element:IElement = null;
			var destroy:Boolean = true;
			if (this.networkMouseDownPoint != null)
			{
				if (this.mark != null)
				{
//					trace("compareSelectMode->"+compareSelectMode+",dx"+this.networkMouseDownPoint.x+",mx:"+networkMouseMovePoint.x+",dy:"+networkMouseDownPoint.y+",my:"+networkMouseMovePoint.y)
					if (this.networkMouseDownPoint.x != this.networkMouseMovePoint.x)
					{
						if (this.networkMouseDownPoint.y != this.networkMouseMovePoint.y)
						{
							_elements = this.network.getElementsByDisplayObject(this.mark, compareSelectMode);
//							trace("length:"+_elements.length)
							if (_elements.length > 0)
							{
								selectionModels = new Vector.<Element>(this.network.getSelectionModels);
								_index = 0;
								while (_index < _elements.length)
								{
									
									_element = _elements[_index];
									if (this.network.containsSelectionModel(_element))
									{
										selectionModels.splice(_index,1,_element);
									}
									else
									{
										selectionModels.push(_element);
									}
									_index = _index + 1;
								}
								var len:int = selectionModels.length;
								if(len>0){
									for(var i:int=0;i<len;i++){
										if(selectionModels[i]!=null) 
											this.network.addToSelected(selectionModels[i]);
									}
									//多余一个成才显示对齐菜单
									if(len>1&&network.resizeHandles.modelList.length>1||network.moveHandles.modelList.length>1)
										createContextMenu();
									destroy = false;
									this.dispatchEvent(InteractionEvent.MULTIL_SELECTED, event);
								}
							}
							
						}
						
					}
			
//					this.network.isSelectingElement = false;
				}
				clearMouseUp();
				
			}
			
			if(destroy&&isMarkShowing){
				this.network.clearSelectionModels();
				destoryContextMenu();
			}
		}
		
		public function clearMouseUp():void{
			if(this.mark){
				this.network.customGroup.removeElement(this.mark);
				this.mark = null;
			}
			if(isMarkShowing)
				isMarkShowing = false;
			this.network.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			this.networkMouseDownPoint = null;
			this.networkMouseMovePoint = null;
		}
		
		private var customContextMenu:ContextMenu;   
		private var topJustify:ContextMenuItem,rightJustify:ContextMenuItem,bottomJustify:ContextMenuItem,leftJustify:ContextMenuItem,revertJustify:ContextMenuItem;
		/**
		 * 创建对齐菜单
		 */
		private function createContextMenu():void{
			if(contextMenuEnable&&network.contextMenu!=customContextMenu)
				network.contextMenu=customContextMenu;  
		}
		
		public var contextMenuEnable:Boolean = true;
		private function destoryContextMenu():void{
			if(network.contextMenu&&contextMenuEnable)
				network.contextMenu=null; 
		}
		
		private function topJustifyHandler(e:ContextMenuEvent):void{
			justifyCoordinate(SelectHelper.TOP);
		}
		
		private function rightJustifyHandler(e:ContextMenuEvent):void{
			justifyCoordinate(SelectHelper.RIGHT);
		}
		
		private function bottomJustifyHandler(e:ContextMenuEvent):void{
			justifyCoordinate(SelectHelper.BOTTOM);
		}
		
		private function leftJustifyHandler(e:ContextMenuEvent):void{
			justifyCoordinate(SelectHelper.LEFT);
		}
		
		private function revertJustifyHandler(e:ContextMenuEvent):void{
			var datas:Vector.<Element> = network.selectedElements;
			if(datas)
				for each(var element:Element in datas){
					if(element is Node){
						var node:Node = element as Node;
						var oldCoordinate:* = elementOldCoordinates[node];
						if(oldCoordinate!=null){
							node.x = oldCoordinate['x'];
							node.y = oldCoordinate['y'];
						}
					}
				}
		}
		
		private static const TOP:int = 1;
		private static const RIGHT:int = 2;
		private static const BOTTOM:int = 3;
		private static const LEFT:int = 4;
		
		/**
		 * 调整选中对象的x或y轴值。
		 */
		private function justifyCoordinate(direction:int):void{
			var datas:Vector.<Element> = network.selectedElements;
			//根据x或y值排序后的节点列表
			var sortedDatas:Vector.<Element> = datas.slice();
			var xPadding:Number=0,yPadding:Number=0;
			var isTopOrBottom:Boolean = false,isLeftOrRight:Boolean = false;
			var t:Node;
			if(datas){
				
				if(direction==SelectHelper.TOP||direction==SelectHelper.BOTTOM)
					isTopOrBottom = true;
				else
					isLeftOrRight = true;
				
				//step1 先排序
				var node1:Node,node2:Node;
				for(var i:int=datas.length-1;i>0;i--){
					for(var j:int=0;j<i;j++){
						if((datas[j] is Node)&&(datas[j+1] is Node)){
							node1 = datas[j] as Node;
							node2 = datas[j+1] as Node;
							if(isTopOrBottom &&(node1.x>node2.x)){
									t = node1;
									sortedDatas[j] = node2;
									sortedDatas[j+1] = t;
							}else if(isLeftOrRight&&(node1.y>node2.y)){
									t = node1;
									sortedDatas[j] = node2;
									sortedDatas[j+1] = t;
							}
						}
					}
				}
				//step2 获取最节点
				for each(var element:Node in datas){
					if(xPadding==0)
						xPadding = element.x;
					if(yPadding==0)
						yPadding = element.y;
					if(direction==SelectHelper.TOP){
						if(element.y<yPadding)
							yPadding = element.y;
					}
					else if(direction==SelectHelper.RIGHT){
						if(element.x>xPadding)
							xPadding = element.x;
					}
					else if(direction==SelectHelper.BOTTOM){
						if(element.y>yPadding)
							yPadding = element.y;
					}
					else if(direction==SelectHelper.LEFT){
						if(element.x<xPadding)
							xPadding = element.x;
					}
						
				}
				
				//step3 对齐节点
				for each(element in datas){
					elementOldCoordinates[element] = {x:element.x,y:element.y};
					if(direction==SelectHelper.TOP||direction==SelectHelper.BOTTOM){
						element.y = yPadding;
					}
					else if(direction==SelectHelper.RIGHT||direction==SelectHelper.LEFT){
						element.x = xPadding;
					}
				}
				
				//step4 设置节点间隔，避免重叠
				for(i=0;i<sortedDatas.length;i++){
					if(i!=0){
						node1 = sortedDatas[i] as Node;
						node2 = sortedDatas[i-1] as Node;
						if(isTopOrBottom)
							node1.x = node2.x+node2.nodeWidth+10;
						else if(isLeftOrRight)
							node1.y = node2.y+node2.nodeHeight+10;
					}
				}
			}
		}
		
		
		private function get compareSelectMode() : Boolean
		{
//			if (this.network.selectMode == Consts.SELECT_MODE_INTERSECT)
//			{
//				return true;
//			}
//			if (this.network.selectMode == Consts.SELECT_MODE_CONTAIN)
//			{
//				return false;
//			}
			if (networkMouseDownPoint.x > networkMouseMovePoint.x)
			{
				if (networkMouseDownPoint.y > networkMouseMovePoint.y)
				{
					return true;
				}
			}
			return false;
		}
		
		public function isValidMouseEvent(event:MouseEvent) : Boolean
		{
			if (!(event.target is mx.controls.Button)&&!(event.target is spark.components.Button))
			{
				if (event.target is mx.controls.scrollClasses.ScrollThumb)
				{
					if (this.network.scroller.horizontalScrollBar != null)
					{
						if (HScrollBar(this.network.scroller.horizontalScrollBar).contains(DisplayObject(event.target)))
						{
							return false;
						}
					}
					if (this.network.scroller.verticalScrollBar != null)
					{
						if (VScrollBar(this.network.scroller.verticalScrollBar).contains(DisplayObject(event.target)))
						{
							return false;
						}
					}
				}
			}
			return true;
		}
	}
}