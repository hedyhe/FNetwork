package com.myflexhero.network.core.ui
{
	import com.myflexhero.network.Consts;
	import com.myflexhero.network.Network;
	import com.myflexhero.network.Styles;
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.core.IElementUI;
	import com.myflexhero.network.core.util.ElementUtil;
	import com.myflexhero.network.event.ElementPropertyChangeEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.utils.UIDUtil;
	
	import spark.components.Group;
	import spark.effects.AnimateFilter;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.RepeatBehavior;
	import spark.effects.animation.SimpleMotionPath;

	use namespace mx_internal;
	/**
	 * 数据包装操作基类,继承自Sprite图形类，拥有基本的鼠标交互事件支持。
	 * @see com.myflexhero.network.core.ui.LinkUI
	 * @see com.myflexhero.network.core.ui.NodeUI
	 * @author Hedy<br>
	 * 如发现Bug请报告至email: 550561954@qq.com 
	 */
	public class SmallElementUI extends Sprite implements IElementUI
	{
		public var network:Network = null;
		private var _element:* = null;
		private var _mouseOver:Boolean;
		private var _mouseOut:Boolean;
		private var _mouseUp:Boolean;
		private var _mouseDown:Boolean;
		private var _isSelected:Boolean = false;
		/**
		 * 高亮动画
		 */
		protected var highLightAnimate:AnimateFilter;
		/**
		 * 多选高亮动画
		 */
		protected var multiSelectHighLightAnimate:AnimateFilter;
		/**
		 * 选中时的发光效果
		 */
		protected var _glow:flash.filters.GlowFilter;
		/**
		 * 高亮时的闪烁发光效果
		 */
		protected var _highLightGlow:GlowFilter;
		/**
		 * 鼠标多选时的高亮闪烁发光效果
		 */
		protected var _selectedGlow:GlowFilter;
		/**
		 * 是否启动自定义高亮动画
		 */
		public var isHighLightEnable:Boolean;
		private var _isMultiSelectHighLightEnable:Boolean;
		private var _layoutGroup:Group = null;
		public var labelAttachment:LabelAttachment = null;
		private var _labelStyleChanged:Boolean = true;
		public var visableChanged:Boolean = true;
		/**
		 * 对label属性创建的TextFiled对象的引用
		 */
		public var labelUI:TextField;
		protected var _attachments:Vector.<DisplayObject>;
		//--------------------------------------------------------------------------
		//
		//  Construct
		//
		//--------------------------------------------------------------------------
		
		public function SmallElementUI(network:Network, value:IData)
		{
			this.network = network;
			setElement(value);
			_attachments = new Vector.<DisplayObject>();
		}
		
		protected function getDyeColor(styleName:String) : Number
		{
			if (innerColor is Number)
			{
				if (element.getStyle(Styles.INNER_STYLE) == Consts.INNER_STYLE_DYE)
				{
					return Number(innerColor);
				}
			}
			return element.getStyle(styleName);
		}
		
		//--------------------------------------------------------------------------
		//
		//  getter setter
		//
		//--------------------------------------------------------------------------
		private var _innerColor:Object = null;
		protected function get innerColor() : Object
		{
			return this._innerColor;
		}
		
		public function setElement(value:IData ) : void
		{	
			this.element = value;
			addPropertyChangeListener();
		}
		
		public function removePropertyChangeListener() : void{
			if(element!=null){
				element.removePropertyChangeListener(onPropertyChange);
			}
		}
		
		public function addPropertyChangeListener() : void{
			if(element)
				element.addPropertyChangeListener(onPropertyChange,10);
		}
		
		//--------------------------------------------------------------------------
		//
		//  需子类继承的方法
		//
		//--------------------------------------------------------------------------
		protected function onPropertyChange(event:ElementPropertyChangeEvent):void{
			//to do
		}
		
		public function updateLabelAttachmentProperties():void{
			//to do
		}
		
		/**
		 * 尝试开始设置绘制图像所需的主要属性
		 */
		public function drawBody():void{
//			trace("drawBody")
			//to do
		}
		
		/**
		 * 更新组件属性
		 */
		public function updateProperties():void{
//			trace("updateProperties")
			//to do
		}
		
		/**
		 * 设置高亮层度，默认为0(不显示),1为最高,level数值越低，高亮filter效果越明显.
		 */
		public function setHighLightLevel(level:int):void{
			//to do
		}
		
		protected function refreshAttachmentVisible():void{
			//to do
		}
		public function refreshLabelAttachment():void{
			//to do
		}
		
		/**
		 * Small没有高亮
		 */
		public function refreshHighLight():void{
			//to do
		}
		
		protected function showGlow(showDefaultGlow:Boolean = true):void{
			if(isHighLightEnable){
				if(_highLightGlow==null)
					createHighLightGlow();
				filters = [_glow,_highLightGlow];
			}
			else if(isMultiSelectHighLightEnable){
				if(_selectedGlow==null)
					createMultiSelectGlow();
				filters = [_glow,_selectedGlow];
			}
			else if(showDefaultGlow)
				filters = [_glow];
			else if(filters!=null)
				filters = null;
		}
		
		protected function createGlow():void{
			_glow = new GlowFilter(element.getStyle(Styles.SELECT_COLOR),1, 10, 10, 6, Consts.QUALITY_HIGH);
		}
		
		protected function createHighLightGlow():void{
			_highLightGlow = new GlowFilter(element.getStyle(Styles.HIGH_LIGHT_COLOR),1, 6, 6, 3, Consts.QUALITY_HIGH,true);
		}
		
		protected function createMultiSelectGlow():void{
			_selectedGlow = new GlowFilter(element.getStyle(Styles.MULTISELECT_COLOR),1, 6, 6, 3, Consts.QUALITY_HIGH,true);
		}
		
		/**
		 * 清空组件引用及内部数据
		 */
		public function dispose():void{
			if(highLightAnimate!=null){
				highLightAnimate.stop();
				highLightAnimate = null;
			}
			
			if(_glow!=null){
				_glow = null;
			}
		}
		
		protected var unionBoundRectangle:Rectangle = null;
		public function get unionBounds() : Rectangle
		{
			
			var _displayObject:DisplayObject = null;
			var _rectangle:Rectangle = null;
			if (this.unionBoundRectangle == null)
			{
				//节点是使用图片还是Vector。如果是Vector，则使用nodeWidth。
				if(element.getStyle(Styles.CONTENT_TYPE)==Consts.CONTENT_TYPE_DEFAULT)
					this.unionBoundRectangle = new Rectangle(element.x, element.y, element.imageWidth,element.imageHeight);
				else
					this.unionBoundRectangle = new Rectangle(element.x, element.y, element.nodeWidth, element.nodeHeight);
				//是否将Label等附件作为判断依据
				if(network.isMultiSelectUseAttachment){
					var _index:int = 0;
					while (_index < this._attachments.length)
					{
						
						_displayObject = this._attachments[_index];
						if (_displayObject)
						{
							_rectangle = new Rectangle(_displayObject.x, _displayObject.y, _displayObject.width, _displayObject.height);
							this.unionBoundRectangle = this.unionBoundRectangle.union(_rectangle);
						}
						_index = _index + 1;
					}
				}
			}
			return this.unionBoundRectangle;
		}
		
		public function isHitByDisplayObject(displayObject:DisplayObject, intersectMode:Boolean = false, accuracy:Number = 1) : Boolean
		{
			var _index:int = 0;
			var _displayObject:DisplayObject = null;
			if (!this.visible)
			{
				return false;
			}
			var _unionBoundsRectangle:Rectangle = this.unionBounds;
			var _rectangle:Rectangle = displayObject.getRect(this.network.attachmentGroup);
			if (_unionBoundsRectangle != null)
			{
				if (_rectangle == null)
				{
					return false;
				}
				return _rectangle.intersects(_unionBoundsRectangle);
//				if (intersectMode)
//				{
//					if (!_unionBoundsRectangle.intersects(_rectangle))
//					{
//						return false;
//					}
//					if (ElementUtil.isIntersect(this, displayObject))
//					{
//						return true;
//					}
//					_index = 0;
//					while (_index < this._attachments.length)
//					{
//						
//						_displayObject = this._attachments[_index];
//						if (_displayObject)
//						{
//							if (ElementUtil.isIntersect(_displayObject, displayObject, accuracy))
//							{
//								return true;
//							}
//						}
//						_index = _index + 1;
//					}
//					return false;
//				}
//				else
//				{
////					return _rectangle.containsRect(_unionBoundsRectangle);
//					return _rectangle.intersects(_unionBoundsRectangle);
//				}
			}
			return false;
		}
		
		public function isHit(target:*, tolerance:int, intersectMode:Boolean, accuracy:Number = 1) : Boolean
		{
			if (target is Point)
			{
				return isHitByPoint(target as Point, tolerance);
			}
			if (target is Rectangle)
			{
				return isHitByRectangle(target as Rectangle, intersectMode, tolerance);
			}
			if (target is DisplayObject)
			{
				return isHitByDisplayObject(target as DisplayObject, intersectMode, accuracy);
			}
			throw new ArgumentError("target must be typeof Point, Rectangle or DisplayObject");
		}

		public function isHitByRectangle(stageRect:Rectangle, intersectMode:Boolean, tolerance:int) : Boolean
		{
			var _loc_4:int = 0;
			var _loc_5:DisplayObject = null;
			var _loc_6:Rectangle = null;
			if (!this.visible)
			{
				return false;
			}
			if (intersectMode)
			{
				if (tolerance < 0)
				{
					tolerance = network.selectionTolerance;
				}
				if (ElementUtil.isIntersectionByRect(stageRect, this, tolerance))
				{
					return true;
				}
				_loc_4 = 0;
				while (_loc_4 < this._attachments.length)
				{
					
					_loc_5 = this._attachments[_loc_4];
					if (_loc_5)
					{
						if (ElementUtil.isIntersectionByRect(stageRect, _loc_5, tolerance))
						{
							return true;
						}
					}
					_loc_4 = _loc_4 + 1;
				}
				return false;
			}
			else
			{
				_loc_6 = network.getStageRectangle(this.unionBounds);
				if (_loc_6 == null)
				{
					return false;
				}
				return stageRect.containsRect(_loc_6);
			}
		}
		
		public function isHitByPoint(stagePoint:Point, tolerance:int) : Boolean
		{
			if (!this.visible)
			{
				return false;
			}
			var _loc_3:* = new Rectangle((stagePoint.x - 1), (stagePoint.y - 1), 2, 2);
			return isHitByRectangle(_loc_3, true, tolerance);
		}
		
		/**
		 * 当前对象属于的层,无需赋值,程序将在创建完毕后自动赋值。
		 */
		public function get layoutGroup():Group
		{
			return _layoutGroup;
		}

		/**
		 * @private
		 */
		public function set layoutGroup(value:Group):void
		{
			_layoutGroup = value;
		}

		public function get mouseOver():Boolean
		{
			return _mouseOver;
		}

		public function set mouseOver(value:Boolean):void
		{
			_mouseOver = value;
		}

		public function get mouseOut():Boolean
		{
			return _mouseOut;
		}

		public function set mouseOut(value:Boolean):void
		{
			_mouseOut = value;
		}

		public function get mouseUp():Boolean
		{
			return _mouseUp;
		}

		public function set mouseUp(value:Boolean):void
		{
			_mouseUp = value;
		}

		public function get mouseDown():Boolean
		{
			return _mouseDown;
		}

		public function set mouseDown(value:Boolean):void
		{
			_mouseDown = value;
		}

		public function get isSelected():Boolean
		{
			return _isSelected;
		}

		public function set isSelected(value:Boolean):void
		{
			_isSelected = value;
		}
		public function get element():*
		{
			return _element;
		}
		
		public function set element(value:*):void
		{
			_element = value;
		}

		/**
		 * 是否启动多选时的高亮动画
		 */
		public function get isMultiSelectHighLightEnable():Boolean
		{
			return _isMultiSelectHighLightEnable;
		}

		/**
		 * @private
		 */
		public function set isMultiSelectHighLightEnable(value:Boolean):void
		{
			_isMultiSelectHighLightEnable = value;
		}

		public function get labelStyleChanged():Boolean
		{
			return _labelStyleChanged;
		}

		public function set labelStyleChanged(value:Boolean):void
		{
			_labelStyleChanged = value;
		}


	}
}