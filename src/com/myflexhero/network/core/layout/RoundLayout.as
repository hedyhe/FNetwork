package com.myflexhero.network.core.layout
{
	import com.myflexhero.network.ElementBox;
	import com.myflexhero.network.Network;
	import com.myflexhero.network.Node;
	import com.myflexhero.network.event.DataBoxChangeEvent;
	import com.myflexhero.network.event.ElementPropertyChangeEvent;
	import com.myflexhero.network.event.IndexChangeEvent;
	import com.myflexhero.network.event.SelectionChangeEvent;
	
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import mx.events.*;
	
	public class RoundLayout extends CustomLayout
	{
		private var _mouseMoveFunction:Function = null;
		private var K1170K:Number;
		private var K1182K:Number;
		private var K1179K:Number;
		private var K1200K:Object;
		private var _mouseOverFunction:Function = null;
		private var _moveSpeed:Number = 2;
		private var K1171K:Number = 1;
		private var isReloadOnDataBoxChanged:Boolean = true;
		private var K1172K:Rectangle;
		private var _ceaseRate:Number = 0.9;
		private var K1201K:Boolean = false;
		private var K1169K:Number;
		private var _updateLayoutRectOnResized:Boolean = true;
		private var _ceaseLimit:Number = 0.01;
		private var logicalPoint:Point;
		private var _percentPadding:Number = 0.25;
		private var elementBox:ElementBox;
		private var layoutStageWidth:Number = -1000;
		private var K1186K:Number;
		private var K1190K:Number = 1;
		private var K1199K:Boolean = false;
		private var K1187K:Number;
		private var layoutStageHeight:Number = -1000;
		private var _isElliptical:Boolean = true;
		private var layoutNodesArray:Array;
		/**
		 * 当前鼠标是否处于节点范围内
		 */
		private var isActive:Boolean;
		private var K1180K:Number;
		private var _timer:Timer;
		private var K1189K:Number = 1;
		private var K1177K:Number;
		private var _updateNodeFunction:Function = null;
		private var K1181K:Number;
		private var K1178K:Number;
		
		public function RoundLayout(network:Network)
		{
			super(network);
			layoutNodesArray = new Array();
			_timer = new Timer(50, 0);
			this._network = network;
//			this.network.interactionHandlers = new Collection([new SelectInteractionHandler(network)]);
		}
		
		override public function refreshLayout():void{
			start();
		}
		private function timerHandler(event:TimerEvent = null) : void
		{
			this.tick();
		}
		
		public function stop(isUninstallListeners:Boolean = true) : void
		{
			if (_timer.running)
			{
				_timer.stop();
				if (isUninstallListeners)
				{
					this.uninstallListeners();
				}
			}
			return;
		}
		
		public function get count() : int
		{
			return layoutNodesArray.length;
		}
		
		public function get mouseOverFunction() : Function
		{
			return this._mouseOverFunction;
		}
		
		public function get percentPadding() : Number
		{
			return this._percentPadding;
		}
		
		protected function handleSelectionChange(event:SelectionChangeEvent) : void
		{
			if(_network.selectedElements.length==1)
				centerNode(_network.selectedElements[0] as Node);
		}
		
		public function get mouseMoveFunction() : Function
		{
			return this._mouseMoveFunction;
		}
		
		public function set percentPadding(value:Number) : void
		{
			this._percentPadding = value;
			return;
		}
		
		public function set active(value:Boolean) : void
		{
			this.isActive = value;
		}
		
		public function set mouseMoveFunction(value:Function) : void
		{
			this._mouseMoveFunction = value;
		}
		
		public function set mouseOverFunction(value:Function) : void
		{
			this._mouseOverFunction = value;
		}
		
		public function get active() : Boolean
		{
			return this.isActive;
		}
		
		public function get reloadOnDataBoxChanged() : Boolean
		{
			return this.isReloadOnDataBoxChanged;
		}
		
		public function get elliptical() : Boolean
		{
			return this._isElliptical;
		}
		
		public function get network() : Network
		{
			return this._network;
		}
		
		public function get layoutRect() : Rectangle
		{
			/**
			 * 未提供zoom
			 */
//			var _loc_1:* = this.network.width / this.network.zoom;
//			var _loc_2:* = this.network.height / this.network.zoom;
			var _loc_1:* = this._network.width;
			var _loc_2:* = this._network.height;
			var _loc_3:* = _loc_1 * percentPadding;
			var _loc_4:* = _loc_2 * percentPadding;
			return new Rectangle(_loc_3, _loc_4, _loc_1 - 2 * _loc_3, _loc_2 - 2 * _loc_4);
		}
		
		public function get updateLayoutRectOnResized() : Boolean
		{
			return this._updateLayoutRectOnResized;
		}
		
		private function setLogicalPoint(event:MouseEvent) : void
		{
			logicalPoint = _network.getLogicalPoint(new Point(event.stageX,event.stageY));
		}
		
		protected function handleRollOut(event:MouseEvent) : void
		{
			this.isActive = false;
		}
		
		public function isLayoutable(node:Node) : Boolean
		{
//			if (this._network.isVisible(node))
//			{
//				this._network.isVisible(node);
//			}
			return node.visible;
		}
		
		protected function createControlPoint(node:Node) : Point
		{
			var _loc_2:* = node.centerLocation;
			//layoutRect--> x=500,y=125,width=500,height=250
			var _loc_3:* = layoutRect;
			//500+500/2 =725
			var _loc_4:* = _loc_3.x + _loc_3.width / 2;
			//125+250/2 = 250 
			var _loc_5:* = _loc_3.y + _loc_3.height / 2;
			//返回角度=node.centerLocation.y - 250, node.centerLocation.x - 725
			var _loc_6:* = Math.atan2(_loc_2.y - _loc_5, _loc_2.x - _loc_4);
			//500_250 = 750
			var _loc_7:* = _loc_3.width + _loc_3.height;
			//725+750*余弦值(以弧度为单位的角度_loc_6),250+750*正弦值(以弧度为单位的角度_loc_6)
			return new Point(_loc_4 + _loc_7 * Math.cos(_loc_6), _loc_5 + _loc_7 * Math.sin(_loc_6));
		}
		
		public function get ceaseRate() : Number
		{
			return this._ceaseRate;
		}
		
		public function get timer() : Timer
		{
			return this._timer;
		}
		
		public function get timerDelay() : Number
		{
			return this._timer.delay;
		}
		
		/**
		 * 是否为椭圆
		 */
		public function set elliptical(value:Boolean) : void
		{
			this._isElliptical = value;
		}
		
		/**
		 * 节点排序
		 */
		private function sortOnNodes() : void
		{
			var _loc_3:Node = null;
			var _loc_4:int = 0;
			layoutNodesArray.sortOn("cz", Array.DESCENDING | Array.NUMERIC);
			var _loc_1:* = layoutNodesArray.length;
			var _loc_2:Number = 0;
			while (_loc_2 < _loc_1)
			{
				
				_loc_3 = layoutNodesArray[_loc_2].node;
				_loc_4 = elementBox.getDatas().indexOf(_loc_3);
				elementBox.getDatas().splice(_loc_4,1);
				elementBox.getDatas().splice(_loc_2,0,_loc_3);
				elementBox.dispatchEvent(new IndexChangeEvent(_loc_3, _loc_4, _loc_2));
				this.updateNode(_loc_3, _loc_2, _loc_1, layoutNodesArray[_loc_2].alpha);
				_loc_2 = _loc_2 + 1;
			}
		}
		
		private function K1168K(a:Number, b:Number, c:Number) : void
		{
			var _loc_5:* = undefined;
			var _loc_6:Number = NaN;
			var _loc_7:Number = NaN;
			var _loc_8:Number = NaN;
			var _loc_9:Number = NaN;
			var _loc_10:Number = NaN;
			var _loc_11:Number = NaN;
			var _loc_12:Number = NaN;
			var _loc_13:Number = NaN;
			var _loc_14:Number = NaN;
			var _loc_15:Number = NaN;
			var _loc_16:Number = NaN;
			var _loc_17:Number = NaN;
			reloadFunction1(a, b, c);
			var _loc_4:int = 0;
			while (_loc_4 < layoutNodesArray.length)
			{
				
				_loc_5 = layoutNodesArray[_loc_4];
				_loc_6 = _loc_5.cx;
				_loc_7 = _loc_5.cy * K1178K + _loc_5.cz * (-K1177K);
				_loc_8 = _loc_5.cy * K1177K + _loc_5.cz * K1178K;
				_loc_9 = _loc_6 * K1180K + _loc_8 * K1179K;
				_loc_10 = _loc_7;
				_loc_11 = _loc_6 * (-K1179K) + _loc_8 * K1180K;
				_loc_12 = _loc_9 * K1182K + _loc_10 * (-K1181K);
				_loc_13 = _loc_9 * K1181K + _loc_10 * K1182K;
				_loc_14 = _loc_11;
				_loc_5.cx = _loc_12;
				_loc_5.cy = _loc_13;
				_loc_5.cz = _loc_14;
				_loc_15 = this.K1171K * 2;
				_loc_15 = _loc_15 / (_loc_15 + _loc_14);
				_loc_5.perspective = _loc_15;
				_loc_16 = K1189K * _loc_12 * _loc_15 - K1189K * 2 + K1169K;
				_loc_17 = _loc_13 * _loc_15 * K1190K + K1170K;
				_loc_5.node.setCenterLocation(_loc_16, _loc_17);
				_loc_4 = _loc_4 + 1;
			}
			this.sortOnNodes();
		}
		
		public function set reloadOnDataBoxChanged(value:Boolean) : void
		{
			this.isReloadOnDataBoxChanged = value;
		}
		
		public function start(isLayoutRectChanged:Boolean = true) : void
		{
			if (_timer.running)
			{
				return;
			}
			this.installListeners();
			if (isLayoutRectChanged)
			{
				this.updateLayoutRect(true);
			}
			_timer.start();
			this.tick();
		}
		
		public function get updateNodeFunction() : Function
		{
			return this._updateNodeFunction;
		}
		
		protected function handleNetworkPropertyChange(event:ElementPropertyChangeEvent) : void
		{
			if (event.property == "elementBox")
			{
				this.elementBox.removeDataBoxChangeListener(this.handleDataBoxChange);
				this.elementBox = this._network.elementBox;
				this.elementBox.addDataBoxChangeListener(this.handleDataBoxChange);
				this.reload();
			}
			if (event.property == "zoom")
			{
				this.logicalPoint = null;
				this.updateLayoutRect();
			}
		}
		
		public function get ceaseLimit() : Number
		{
			return this._ceaseLimit;
		}
		
		protected function updateNode(node:Node, K1146K:int, count:int, alpha:Number) : void
		{
			if (updateNodeFunction != null)
			{
				updateNodeFunction(node, K1146K, count, alpha);
			}
		}
		
		public function set updateLayoutRectOnResized(value:Boolean) : void
		{
			this._updateLayoutRectOnResized = value;
		}
		
		public function set timerDelay(value:Number) : void
		{
			this._timer.delay = value;
		}
		
		private function uninstallListeners() : void
		{
			this.elementBox.removeDataBoxChangeListener(this.handleDataBoxChange);
			this._network.removeSelectionChangeListener(this.handleSelectionChange);
			this._network.removeEventListener(ResizeEvent.RESIZE, this.handleResize);
			this._network.removeEventListener(MouseEvent.ROLL_OUT, this.handleRollOut);
			this._network.removeEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove);
			this._network.removeEventListener(MouseEvent.MOUSE_OVER, this.handleMouseOver);
			this._network.removePropertyChangeListener(this.handleNetworkPropertyChange);
			this._timer.removeEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		public function reload() : void
		{
			var _loc_7:Node = null;
			var _loc_8:Object = null;
			K1201K = false;
			K1200K = null;
			logicalPoint = null;
			K1199K = false;
			this.layoutNodesArray = new Array();
//			var _datas:Vector.<IData> = this._network.elementBox.getDatas();
			var _datas:* = this._network.elementBox.getDatas();
			var _loc_2:int = _datas.length;
			var _loc_3:int = 0;
			while (_loc_3 < _loc_2)
			{
				
				_loc_7 = _datas[_loc_3] as Node;
				if (_loc_7 != null)
				{
					if (this.isLayoutable(_loc_7))
					{
						_loc_8 = new Object();
						_loc_8.node = _loc_7;
						layoutNodesArray.push(_loc_8);
					}
				}
				_loc_3 = _loc_3 + 1;
			}
			this.reloadFunction1(0, 0, 0);
			this.isActive = false;
			this.K1186K = 1;
			this.K1187K = 1;
			var _loc_4:Number = 0;
			var _loc_5:Number = 0;
			var _loc_6:* = layoutNodesArray.length;
			_loc_3 = 1;
			while (_loc_3 < (_loc_6 + 1))
			{
				
				_loc_4 = Math.acos(-1 + (2 * _loc_3 - 1) / _loc_6);
				_loc_5 = Math.sqrt(_loc_6 * Math.PI) * _loc_4;
				layoutNodesArray[(_loc_3 - 1)].cx = K1171K * Math.cos(_loc_5) * Math.sin(_loc_4);
				layoutNodesArray[(_loc_3 - 1)].cy = K1171K * Math.sin(_loc_5) * Math.sin(_loc_4);
				layoutNodesArray[(_loc_3 - 1)].cz = K1171K * Math.cos(_loc_4);
				_loc_3 = _loc_3 + 1;
			}
		}
		
		private function tick() : void
		{
			var _loc_1:Number = NaN;
			var _loc_2:Number = NaN;
			var _loc_3:Boolean = false;
			var _loc_4:Number = NaN;
			var _loc_5:Number = NaN;
			var _loc_6:* = undefined;
			var _loc_7:Number = NaN;
			var _loc_8:Number = NaN;
			var _loc_9:Number = NaN;
			var _loc_10:Number = NaN;
			var _loc_11:Number = NaN;
			var _loc_12:Number = NaN;
			var _loc_13:Number = NaN;
			var _loc_14:Number = NaN;
			var _loc_15:Number = NaN;
			var _loc_16:Number = NaN;
			var _loc_17:Number = NaN;
			var _loc_18:Number = NaN;
			if (K1201K)
			{
				return;
			}
			if (K1199K)
			{
				if (K1200K != null)
				{
					_loc_3 = isAtCenter(K1200K.node, K1200K.perspective, K1200K.cx, K1200K.cy, K1200K.cz);
					if (_loc_3)
					{
						K1201K = true;
						K1199K = false;
						K1200K = null;
						return;
					}
				}
			}
			if (!K1201K)
			{
				if (!isActive)
				{
				}
			}
			if (K1199K)
			{
			}
				if (logicalPoint != null)
				{
					if (!this.elliptical)
					{
						_loc_1 = (K1170K - logicalPoint.y) / this.K1171K * this._moveSpeed;
						_loc_2 = (logicalPoint.x - K1169K) / this.K1171K * this._moveSpeed;
					}
					else
					{
						_loc_1 = (K1170K - logicalPoint.y) / (this.K1172K.height / 2) * this._moveSpeed;
						_loc_2 = (logicalPoint.x - K1169K) / (this.K1172K.width / 2) * this._moveSpeed;
					}
				}
				else
				{
					_loc_1 = K1186K * this._ceaseRate;
					_loc_2 = K1187K * this._ceaseRate;
				}
		
				K1186K = _loc_1;
				K1187K = _loc_2;
			
//			trace("Math.abs(_loc_1):"+Math.abs(_loc_1)+",_ceaseLimit:"+_ceaseLimit)
			if (Math.abs(_loc_1) <= this._ceaseLimit)
			{}
//				trace("Math.abs(_loc_2):"+Math.abs(_loc_2)+",_ceaseLimit:"+_ceaseLimit)
				if (Math.abs(_loc_2) > this._ceaseLimit)
				{
					_loc_4 = 0;
					reloadFunction1(_loc_1, _loc_2, _loc_4);
					_loc_5 = 0;
					while (_loc_5 < layoutNodesArray.length)
					{
						
						_loc_6 = layoutNodesArray[_loc_5];
						_loc_7 = layoutNodesArray[_loc_5].cx;
						_loc_8 = layoutNodesArray[_loc_5].cy * K1178K + layoutNodesArray[_loc_5].cz * (-K1177K);
						_loc_9 = layoutNodesArray[_loc_5].cy * K1177K + layoutNodesArray[_loc_5].cz * K1178K;
						_loc_10 = _loc_7 * K1180K + _loc_9 * K1179K;
						_loc_11 = _loc_8;
						_loc_12 = _loc_7 * (-K1179K) + _loc_9 * K1180K;
						_loc_13 = _loc_10 * K1182K + _loc_11 * (-K1181K);
						_loc_14 = _loc_10 * K1181K + _loc_11 * K1182K;
						_loc_15 = _loc_12;
						layoutNodesArray[_loc_5].cx = _loc_13;
						layoutNodesArray[_loc_5].cy = _loc_14;
						layoutNodesArray[_loc_5].cz = _loc_15;
						_loc_16 = this.K1171K * 2;
						_loc_16 = _loc_16 / (_loc_16 + _loc_15);
						layoutNodesArray[_loc_5].perspective = _loc_16;
						layoutNodesArray[_loc_5].alpha = (this.K1171K - _loc_15) / (this.K1171K * 2);
						_loc_17 = K1189K * _loc_13 * _loc_16 - K1189K * 2 + K1169K;
						_loc_18 = _loc_14 * _loc_16 * K1190K + K1170K;
						layoutNodesArray[_loc_5].node.setCenterLocation(_loc_17, _loc_18);
						_loc_5 = _loc_5 + 1;
					}
					this.sortOnNodes();
				}
			
		}
		
		public function set ceaseRate(value:Number) : void
		{
			this._ceaseRate = value;
		}
		
		protected function handleDataBoxChange(event:DataBoxChangeEvent) : void
		{
			if (!this.isReloadOnDataBoxChanged)
			{
				return;
			}
			if (event.kind == DataBoxChangeEvent.CLEAR)
			{
				this.reload();
			}
		}
		
		protected function isAtCenter(node:Node, K1159K:Number, K1164K:Number, cy:Number, cz:Number) : Boolean
		{
			if (moveSpeed <= 0)
			{
				return true;
			}
			var _loc_6:* = 16 / moveSpeed;
			if (_loc_6 > 20)
			{
				_loc_6 = 20;
			}
			else if (_loc_6 < 2)
			{
				_loc_6 = 2;
			}
			return (-cz) / Math.sqrt(K1164K * K1164K + cy * cy) > _loc_6;
		}
		
		public function get running() : Boolean
		{
			return _timer.running;
		}
		
		public function set updateNodeFunction(value:Function) : void
		{
			this._updateNodeFunction = value;
		}
		
		protected function handleMouseOver(event:MouseEvent) : void
		{
			if (!K1199K)
			{
				this.setLogicalPoint(event);
			}
			if (this.mouseOverFunction == null)
			{
				this.isActive = true;
			}
			else
			{
				this.isActive = mouseOverFunction(event);
			}
		}
		
		public function set ceaseLimit(value:Number) : void
		{
			this._ceaseLimit = value;
		}
		
		protected function handleMouseMove(event:MouseEvent) : void
		{
			if (!K1199K)
			{
				this.setLogicalPoint(event);
			}
			if (this.mouseMoveFunction == null)
			{
				this.isActive = true;
			}
			else
			{
				this.isActive = mouseMoveFunction(event);
			}
		}
		
		public function updateLayoutRect(isReload:Boolean = false) : void
		{
			var _loc_3:Number = NaN;
			var _loc_4:int = 0;
			var _loc_2:* = this.K1171K;
			this.K1172K = this.layoutRect;
			if (K1172K.width <= 2)
			{
				K1172K.width = 2;
			}
			if (K1172K.height <= 2)
			{
				K1172K.height = 2;
			}
			this.K1171K = Math.min(K1172K.width / 2, K1172K.height / 2);
			if (elliptical)
			{
				this.K1189K = K1172K.width / 2 / this.K1171K;
				this.K1190K = K1172K.height / 2 / this.K1171K;
			}
			else
			{
				this.K1189K = 1;
				this.K1190K = 1;
			}
			this.K1169K = K1172K.x + K1172K.width / 2;
			this.K1170K = K1172K.y + K1172K.height / 2;
			if (isReload)
			{
				this.reload();
			}
			else
			{
				this.K1186K = 1;
				this.K1187K = 1;
				_loc_3 = layoutNodesArray.length;
				_loc_4 = 1;
				while (_loc_4 < (_loc_3 + 1))
				{
					
					layoutNodesArray[(_loc_4 - 1)].cx = layoutNodesArray[(_loc_4 - 1)].cx * (this.K1171K / _loc_2);
					layoutNodesArray[(_loc_4 - 1)].cy = layoutNodesArray[(_loc_4 - 1)].cy * (this.K1171K / _loc_2);
					layoutNodesArray[(_loc_4 - 1)].cz = layoutNodesArray[(_loc_4 - 1)].cz * (this.K1171K / _loc_2);
					_loc_4 = _loc_4 + 1;
				}
				if (K1201K)
				{
					K1168K(0, 0, 0);
				}
				else
				{
					this.tick();
				}
			}
			this.layoutStageWidth = this._network.width;
			this.layoutStageHeight = this._network.height;
		}
		
		private function reloadFunction1(a:Number, b:Number, c:Number) : void
		{
			var _loc_4:* = Math.PI / 180;
			K1177K = Math.sin(a * _loc_4);
			K1178K = Math.cos(a * _loc_4);
			K1179K = Math.sin(b * _loc_4);
			K1180K = Math.cos(b * _loc_4);
			K1181K = Math.sin(c * _loc_4);
			K1182K = Math.cos(c * _loc_4);
		}
		
		private function installListeners() : void
		{
			this.elementBox = this._network.elementBox;
			this.elementBox.addDataBoxChangeListener(this.handleDataBoxChange);
			this._network.addSelectionChangeListener(this.handleSelectionChange);
			this._network.addEventListener(ResizeEvent.RESIZE, this.handleResize);
			this._network.addEventListener(MouseEvent.ROLL_OUT, this.handleRollOut);
			this._network.addEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove);
			this._network.addEventListener(MouseEvent.MOUSE_OVER, this.handleMouseOver);
			this._network.addPropertyChangeListener(this.handleNetworkPropertyChange);
			this._timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		public function set moveSpeed(value:Number) : void
		{
			this._moveSpeed = value;
		}
		
		public function get moveSpeed() : Number
		{
			return this._moveSpeed;
		}
		
		public function centerNode(node:Node) : void
		{
			var _loc_2:int = 0;
			var _loc_3:* = undefined;
			if (node != null)
			{
				if (isLayoutable(node))
				{
					if (K1200K != null)
					{
						if (node == K1200K.node)
						{
						}
						if (K1201K)
						{
							return;
						}
						_loc_2 = 0;
						while (_loc_2 < layoutNodesArray.length)
						{
							
							_loc_3 = layoutNodesArray[_loc_2];
							if (_loc_3)
							{
								if (node == _loc_3.node)
								{
									K1199K = true;
									K1201K = false;
									isActive = true;
									this.K1200K = _loc_3;
									logicalPoint = createControlPoint(K1200K.node);
									break;
								}
							}
							_loc_2 = _loc_2 + 1;
						}
					}
				}
				else
				{
					K1199K = false;
					K1201K = false;
					isActive = false;
					logicalPoint = null;
				}
			}
			return;
		}
		
		protected function handleResize(event:ResizeEvent) : void
		{
			if (!this._updateLayoutRectOnResized)
			{
				return;
			}
			if (Math.abs(this._network.width - this.layoutStageWidth) <= 2)
			{
				return;
			}
			if (Math.abs(this._network.height - this.layoutStageHeight) <= 2)
			{
				return;
			}
			this.updateLayoutRect();
		}
		
	}
}
