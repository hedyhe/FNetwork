package com.myflexhero.network.core.ui
{
	import com.myflexhero.network.Consts;
	import com.myflexhero.network.Link;
	import com.myflexhero.network.Network;
	import com.myflexhero.network.Styles;
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.core.IElement;
	import com.myflexhero.network.core.IElementUI;
	import com.myflexhero.network.event.ElementPropertyChangeEvent;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.utils.getTimer;
	
	import mx.core.mx_internal;
	
	import spark.effects.AnimateFilter;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.RepeatBehavior;
	import spark.effects.animation.SimpleMotionPath;
	import spark.filters.GlowFilter;

	use namespace mx_internal;
	/**
	 * 连接包装操作基类
	 * @see com.myflexhero.network.core.ui.ElementUI
	 * @see com.myflexhero.network.core.ui.NodeUI
	 * @author Hedy<br>
	 * 如发现Bug请报告至email: 550561954@qq.com 
	 */
	public class LinkUI extends ElementUI
	{
		private var _linkAttachment:LinkAttachment;
		public var linkStyleChanged:Boolean = true;
		private var labelChanged:Boolean = false;
		private var hasNode:Boolean = false;
		mx_internal var nodeChanged:Boolean = true;
		
//		private var labelBitMap:Bitmap;
		//--------------------------------------------------------------------------
		//
		//  Construct
		//
		//--------------------------------------------------------------------------
		
		public function LinkUI(network:Network, element:IElement)
		{
			super(network, element);
//			var a:int = getTimer();
			network.setLinkReference(element as Link);
//			var b:int = getTimer();
//			trace("LinkUI.."+(b-a))
		
		}
		
		//--------------------------------------------------------------------------
		//
		//  继承自接口
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//  drawBody
		//--------------------------------------------------------------------------
		override public function drawBody():void
		{
			initAttachment();
		}
		
		protected function initAttachment():void{
			if(element.label){
				labelChanged = true;
				labelStyleChanged = true;
			}
			
			if(element.toolTip)
				this.toolTip = element.toolTip;
			
			if(element.fromNode||element.toNode)
				hasNode = true;
			
			if(element.highLightEnable)
				isHighLightEnable = true;
			
			updateProperties();
		}
		//--------------------------------------------------------------------------
		//  updateProperties
		//--------------------------------------------------------------------------
		override public function updateProperties():void{
			updateLinkAttachmentProperties();
			updateLabelAttachmentProperties();
			drawAttachment();
		}
		
		public function updateLinkAttachmentProperties():void{
			if(hasNode&&(nodeChanged||linkStyleChanged)){
				if(!_linkAttachment){
					_linkAttachment = new LinkAttachment(element,network);
				}
				if(linkStyleChanged){
					_linkAttachment.styleChanged = true;
					linkStyleChanged = false;
				}
				nodeChanged = false;
				_linkAttachment.updateProperties();
			}
		}
		
		public function drawAttachment() : void
		{
			graphics.clear();
			refreshAttachmentVisible();
			if(labelAttachment)
				labelAttachment.updateProperties();
			
			if(!_linkAttachment)
				return;
			setLinkProperties(graphics,element);
			refreshHighLight();
			_linkAttachment.drawLink(graphics);
		}
		
		private function setLinkProperties(g:Graphics,element:IElement):void{
			g.lineStyle(_linkAttachment.thickness,
				_linkAttachment.color,
				_linkAttachment.alpha,
				_linkAttachment.pixelHinting,
				_linkAttachment.scaleMode,
				_linkAttachment.caps,
				_linkAttachment.joints);
		}
		//--------------------------------------------------------------------------
		//
		//  重载的方法
		//
		//--------------------------------------------------------------------------
		override public function updateLabelAttachmentProperties():void{
			if(labelChanged||labelStyleChanged){
				if(!labelAttachment){
					labelAttachment = new LinkLabelAttachment(element,_linkAttachment);
					labelUI = labelAttachment.content;
					network.getLabelLayoutGroup().addData(labelUI);
				}
				if(labelChanged){
					labelAttachment.labelChanged = true;
					labelChanged = false;
				}
				if(labelStyleChanged){
					labelAttachment.styleChanged = true;
					labelStyleChanged = false;
				}
			}
		}
		
		override protected function refreshAttachmentVisible():void{
			/* from或者toNode不可见时，隐藏Link连接,直接返回 */
			if((!element.fromNode)&&(!element.toNode)||(element.fromNode&&!element.fromNode.visible)||(element.toNode&&!element.toNode.visible)){
				if(labelUI&&labelUI.visible)
					labelUI.visible = false;
				if(this.visible)
					this.visible = false;
				return;
			}else if(labelUI&&!labelUI.visible){
					labelUI.visible = true;
				if(!this.visible)
					this.visible = true;
			}
		}
		//--------------------------------------------------------------------------
		//  refreshHighLight
		//--------------------------------------------------------------------------
		/**
		 * 当前操作是否由箭头重绘发起。
		 */
		mx_internal var actionByArrow:Boolean = false;
		
		/**
		 * 鼠标滑过 及 获得焦点，是否显示箭头符号。
		 */
		override public function refreshHighLight():void{
			/* 画箭头 */
			if((mouseOver||isSelected||isHighLightEnable)&&_linkAttachment.showArrow){
				var _fromX:Number;
				var _fromY:Number;
				var _toX:Number;
				var _toY:Number;
				if(_linkAttachment.linkType==Consts.LINK_TYPE_ORTHOGONAL){
					_fromX = _linkAttachment.fromX_loc;
					_fromY =_linkAttachment.fromY_loc ;
				}else{
					_fromX = _linkAttachment.fromX;
					_fromY = _linkAttachment.fromY ;
				}
				
				_toX = Math.abs(_fromX-_linkAttachment.toX)*0.4;
				_toY = Math.abs(_fromY-_linkAttachment.toY)*0.4;
				_toX = _fromX>_linkAttachment.toX?
					_fromX-_toX:_fromX+_toX;
				_toY = _fromY>_linkAttachment.toY?
					_fromY-_toY:_fromY+_toY;
				_linkAttachment.drawArrow(graphics,_fromX,_fromY,_toX,_toY,_linkAttachment.arrowSize,_linkAttachment.arrowColor);
			}else{
				if(actionByArrow){
					actionByArrow = false;
					drawAttachment();
					return;
				}
			}
			super.refreshHighLight();
			
			if(_glow==null)
				createGlow();
			/* 选中状态 */
			if(isSelected){
				_glow.color = element.getStyle(Styles.SELECT_COLOR);
				_glow.blurX = 7;
				_glow.blurY = 7;
				_glow.strength = 3;
				showGlow()
				return;
			}
			
			_glow.blurX = 2;
			_glow.blurY = 2;
			_glow.strength = 1;
			/* 默认状态 */
			if(!mouseOver){
				showGlow(false);
				return;
			}

			showGlow();
		}
		
		override protected function createGlow():void{
			_glow = new GlowFilter(element.getStyle(Styles.SELECT_COLOR),1, 6, 6, 3, Consts.QUALITY_HIGH);
		}
		
		override protected function createHighLightGlow():void{
			_highLightGlow = new GlowFilter(element.getStyle(Styles.HIGH_LIGHT_COLOR),1, 6, 6, 3, Consts.QUALITY_HIGH,true);
		}
		
		//--------------------------------------------------------------------------
		//  dispose
		//--------------------------------------------------------------------------
		override public function dispose():void{
//			if(labelBitMap!=null){
//				network.getLabelLayoutGroup().removeData(labelBitMap);
//				labelBitMap = null;
//				labelAttachment.clear();
//			}
			super.dispose();
			
			if(labelUI!=null){
				network.getLabelLayoutGroup().removeData(labelUI);
				labelUI = null;
				labelAttachment.clear();
			}
			if(_linkAttachment!=null){
				_linkAttachment = null;
			}
			if(_glow!=null){
				_glow = null;
			}
			removePropertyChangeListener();
			
			graphics.clear();
			network.setLinkReference(element,true);
			network.getLinkLayoutGroup().removeData(this);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event
		//
		//--------------------------------------------------------------------------
		protected function onNodeChange(event:ElementPropertyChangeEvent):void
		{
			eventHandler(event.property as String);
		}

		private function onLinkChange(event:ElementPropertyChangeEvent):void
		{
			if(event.newValue==null&&(event.property=="fromNode"||event.property=="toNode")){
				dispose();
				return;
			}
			eventHandler(event.property as String,event);
		}
		
		private function eventHandler(property:String,event:ElementPropertyChangeEvent=null):void{
			if(property.substr(0,5)=="label"){
				labelChanged = true;
				updateLabelAttachmentProperties();
				return;
			}
			if(property.indexOf(Styles.HIGH_LIGHT_COLOR)!=-1){
				if(event==null)
					return;
				if(_highLightGlow==null){
					createHighLightGlow();
				}
				_highLightGlow.color = event.newValue as uint;
				return;
			}
			
			if(property.substr(0,1)=="S"){
				linkStyleChanged = true;
				updateProperties();
				return;
			}
			
			switch(property)
			{
				case "imageLoad":		
					nodeChanged = true;
					updateProperties();
					break;
				case "toolTip": 	
					if(this.toolTip!=element.toolTip)
						this.toolTip = element.toolTip;
					break;
				case "visible":
					visableChanged = true;
					refreshAttachmentVisible();
					break;
				case "highLightEnable":
					isHighLightEnable = element.highLightEnable;
					refreshHighLight();
					break;
				/**
				 * case "x":
					onNodeChange();
					break;
				case "y":  
					onNodeChange();
					break;
				case "xy":  
					onNodeChange();
					break;
				case "location":
					onNodeChange();
					break;
				//case "rotation": rotation = event.newValue as Number; break;
				case "width":  
					onNodeChange();
					break;
				case "height": 
					onNodeChange();
					break;
				 */
				default: onNodePropertyChange();
					break;
			}
		}
		
		private function onNodePropertyChange():void{
			nodeChanged = true;
			updateProperties();
		}
		
		public function showFromLink(fromNode:IElement,toX:Number,toY:Number):void{
			network.isDynamicLinkActive = false;
			if(!linkAttachment)
				_linkAttachment = new LinkAttachment(fromNode,network);
			else
				_linkAttachment.element = fromNode;
			
			_linkAttachment.updateCreateLinkProperties();
			graphics.clear();
			setLinkProperties(graphics,element);
//			trace("fromX:"+_linkAttachment.fromX+",fromY:"+_linkAttachment.fromY+",toX:"+toX+",toY:"+toY)
//			graphics.moveTo(_linkAttachment.fromX,_linkAttachment.fromY);
			_linkAttachment.toX = toX;
			_linkAttachment.toY = toY;
			_linkAttachment.drawLink(graphics);
//			if(isArrow)
//				drawArrow(_linkAttachment.fromX,_linkAttachment.fromY,toX,toY);
		}
		
		
		public function reset():void{
			network.isDynamicLinkActive = true;
			_linkAttachment = null;
			graphics.clear();
			removePropertyChangeListener();
		}
		//--------------------------------------------------------------------------
		//
		//  getter setter
		//
		//--------------------------------------------------------------------------
		override public function setElement(value:IData ) : void
		{		
			if(value==null){
				return;
			}
			
			removePropertyChangeListener();
			element = value;
			addPropertyChangeListener();
		}
		
		override public function removePropertyChangeListener() : void{
			if(element!=null){
				if(element.fromNode!=null)
				{
					element.fromNode.removeEventListener( Consts.EVENT_DATA_PROPERTY_CHANGE, onNodeChange );
				}	
				
				if(element.toNode!=null){
					//已经移除，不再移除
					if(element.fromNode!=element.toNode)
						element.toNode.removeEventListener( Consts.EVENT_DATA_PROPERTY_CHANGE, onNodeChange );
				}
				element.removeEventListener( Consts.EVENT_DATA_PROPERTY_CHANGE, onLinkChange);
			}
		}
		
		override public function addPropertyChangeListener() : void{
			if(element.fromNode&&element.toNode&&element.fromNode!=element.toNode){
				element.toNode.addEventListener( Consts.EVENT_DATA_PROPERTY_CHANGE, onNodeChange );
				element.fromNode.addEventListener( Consts.EVENT_DATA_PROPERTY_CHANGE, onNodeChange );
			}
			else if(element.fromNode){
				//toNode=fromNode
				element.fromNode.addEventListener( Consts.EVENT_DATA_PROPERTY_CHANGE, onNodeChange );
			}
			element.addEventListener( Consts.EVENT_DATA_PROPERTY_CHANGE, onLinkChange);
		}

		public function get linkAttachment():Attachment
		{
			return _linkAttachment;
		}
		
	}
}