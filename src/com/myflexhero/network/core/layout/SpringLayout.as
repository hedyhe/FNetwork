package com.myflexhero.network.core.layout
{
	import com.myflexhero.network.Consts;
	import com.myflexhero.network.Link;
	import com.myflexhero.network.Network;
	import com.myflexhero.network.Node;
	import com.myflexhero.network.Styles;
	import com.myflexhero.network.core.ICustomLayout;
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.core.IElementUI;
	import com.myflexhero.network.core.ILayout;
	import com.myflexhero.network.core.layout.forcelayout.ForceDirectedLayout;
	import com.myflexhero.network.core.layout.forcelayout.IForceDirectedLayout;
	import com.myflexhero.network.core.layout.forcelayout.extend.GraphDataProvider;
	import com.myflexhero.network.core.ui.NodeUI;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import flashx.textLayout.container.ScrollPolicy;
	
	import mx.core.mx_internal;
	
	import spark.filters.GlowFilter;

	use namespace mx_internal;
	
	/**
	 * 弹力环形布局，调整因子主要有3个：<br>
	 * <ul>
	 * <li><b>repulsionFactor</b> 弹力因子,调整各个节点间的间隔,默认值为0.95,可自定义更改.</li>
	 * 
	 * <li><b>rigidity</b> 晃动因子，设置节点调整期间每次晃动的大小，值越大调整效果越快,默认值为1,暂不建议更改.</li>
	 * 
	 * <li><b>motionLimit</b> 调整因子，值越小调整时间越长，默认值为0.6,暂不建议更改.</li>
	 * </ul>
	 * <p>另外，通过设置布尔类型属性<b>autoFit</b>，我们可以为一个屏幕内可以完整显示的元素提供自动调整位置而不出现滚动条的布局优化。</p>
	 * @see SpringLayout.autoFit
	 * @see com.myflexhero.network.core.layout.TreeLayout
	 * @author Hedy<br>
	 * 550561954#QQ.com  
	 */
	public class SpringLayout extends CustomLayout implements IForceDirectedLayout
	{
		//***************************************************************************************
		//
		//   参数
		//
		//***************************************************************************************
		protected var _numLevels:Vector.<int>= new Vector.<int>();
		
		protected var forceDirectedLayout:ForceDirectedLayout;
		
		protected var _dataProvider:GraphDataProvider = null;
		
		public var defaultRepulsion: Number = 100;
		
		private var _repulsionFactor: Number = 1.2;
		
		/**
		 * 是否显示在一个屏幕内,如果为true，则会将超出右侧和底部的节点往上调整并移动。如果显示的节点过多，则可能部分节点在顶部并排显示影像布局显示效果。<br>
		 * 对于较小数量的元素(一个屏幕可以完整显示)，建议设置为true。否则，请设置为false。默认值为false。
		 */
		public var autoFit: Boolean = false;
		
		//***************************************************************************************
		//
		//   构造
		//
		//***************************************************************************************
		public function SpringLayout(network:Network)
		{
			super(network);
			
			/* 初始化数据提供器 */
			var dp:GraphDataProvider = new GraphDataProvider(this);
			_dataProvider = dp;
			forceDirectedLayout = new ForceDirectedLayout(_dataProvider);
			network.setMoveInteractionHandler(true);
		}

		/**
		 * 设置暂停还是继续.
		 * @param start 如果为true，则继续执行，否则暂停当前执行.
		 */
		public function changeStatus(start:Boolean):void{
			if(start){
				if(timer&&!timer.running)
					timer.start()
				return;
			}
			if(timer)
				timer.stop();
		}
		//***************************************************************************************
		//
		//    布局调整
		//
		//***************************************************************************************
		
		public function refreshScreen(): void {
			if(_dataProvider != null) {
				_dataProvider.layoutChanged = true;
				if((forceDirectedLayout != null) && _dataProvider.hasNodes/*graph.hasNodes*/) {
					forceDirectedLayout.resetDamper();
					forceDirectedLayout.adjusted = false;
					var nodesCount:int = _displayingNodes.length;
					if(nodesCount<=30)
						forceDirectedLayout.rigidity = 0.5;
					else if(nodesCount<=60)
						forceDirectedLayout.rigidity = 1;
					else if(nodesCount<=100)
						forceDirectedLayout.rigidity = 1.5;
					else
						forceDirectedLayout.rigidity = 2.5;
					if(timer == null){
						tick();
						if(showAllTimer!=null){
							showAllTimer.stop();
							showAllTimer = null;
						}
						showAllTimer = new Timer(5000,1);
						showAllTimer.addEventListener(TimerEvent.TIMER_COMPLETE, showAll);
						showAllTimer.start();
					}
				}
			}
		}
		
		/**
		 * 通过缩放显示比例来让所有节点都展示出来(调用network.zoomShowAll()方法)
		 */
		public function showAll(event:TimerEvent = null):void{
			if(_network==null)
				return;
			if(_network.getCurrentAutoLayout() is SpringLayout){
				_network.refreshNodesToLeftAndTop(_displayingNodes);
				_network.zoomShowAll();
			}
//			trace(_network.height+","+_network.scroller.height+","+_network.rootGroup.height+","+_network.getNodeLayoutGroup().height+","+_network.attachmentGroup.height+","+_network.backgroundGroup.height+","+_network.customGroup.height+","+Node.maxPoint.y)
		}
		
		public function stopDamper():void{
			if(timer!=null){
				forceDirectedLayout.stopDamper();
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, tick);
				timer=null;
				//需要确定目前认为SpringLayout
				if(_network.getCurrentAutoLayout() is SpringLayout){
					_network.refreshNodesToLeftAndTop(_displayingNodes);
					_network.zoomShowAll();
				}
			}
		}
		
		
		private var timer:Timer;
		private var showAllTimer:Timer;
		protected function startTimer():void {
			if(!timer){
				timer = new Timer(15,2);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, tick);
			}
			timer.start();
		}
		
		protected function tick(event:TimerEvent = null):void {
//			trace(forceDirectedLayout.adjusted+"tick...damper:"+forceDirectedLayout.damper+",damping:"+forceDirectedLayout.damping+",maxMotion:"+forceDirectedLayout.maxMotion+",motionLimit："+ForceDirectedLayout.motionLimit)
			
			if(autoFit) {
				autoFitTick();
			} else {
				//				trace("tick....")
				forceDirectedLayout.tick();
			}
			/* 每次调用完毕后再重绘容器边界 */
			drawEdges();
			
			/* 设置超过该时间段则停止调整 */
			if(forceDirectedLayout.adjusted)
				stopDamper();
			else
				startTimer();
		}
		
		/**
		 *  由于Node的isLocked=true,所有监听不到x、y派发的事件，这里需要单独派发xy事件给NodeUI，重绘界面.
		 */
		private function drawEdges(): void {
			/*选择_displayingNodes进行for循环比直接使用nodes可每次执行时间减少98%*/
			for each(var n:Node in  _displayingNodes) {
				if(n.x!=n.oldPoint.x||n.y!=n.oldPoint.y)
					n.dispatchPropertyChangeEvent("xy", n.oldPoint.x, n.x);
			}
		}
		
		/**
		 * 自动调整界面上的节点保持在一个界面中(在没有滚动条的情况下)
		 */
		private function autoFitTick():void {
			forceDirectedLayout.tick();
			
			// 找出当前所有节点的最大矩形
			var itemBounds: Rectangle = calcItemsBoundingRect();
			//trace("top: " + itemBounds.top + "left, : " + itemBounds.left + "bottom, : " + itemBounds.bottom + "right, : " + itemBounds.right);
			if(itemBounds != null) {
				//找出当前正在使用的空格距离
				var vCoverage: Number = (itemBounds.bottom - itemBounds.top) / stageHeight;
				var hCoverage: Number = (itemBounds.right - itemBounds.left) / stageWidth;
				var coverage: Number = Math.max(hCoverage, vCoverage);
				
				if((prevCoverage > 0) && (coverage > 0)) {
					//保持平均90%.
					var distance: Number = 0.9 - coverage;
					if (Math.abs(distance) > 0.03) {
						var deltaCoverage: Number = coverage - prevCoverage;

						var targetDelta: Number = distance * 0.2;
						if(targetDelta < -0.01) targetDelta = -0.01;
						if(targetDelta > 0.01) targetDelta = 0.01;
						
						if(deltaCoverage < targetDelta) {
							//并不要过快的展开，加大repulsion
							_repulsionFactor = _repulsionFactor + 0.01;
							// (不要太大!)
							if(_repulsionFactor > 1.2)
								_repulsionFactor = 1.2;
						} else {
							// 不要收缩过快,减少repulsion. 
							_repulsionFactor = _repulsionFactor - 0.01;
							// (不要太小!)
							if(_repulsionFactor < 0.05)
								_repulsionFactor = 0.05;
						}
						//trace("rep " + this._repulsionFactor + ", coverage " + coverage 
						//	+ ", delta " + deltaCoverage + ", target " + targetDelta);
					}
				}
				prevCoverage = coverage;
				
				if((itemBounds.left < 0) || (itemBounds.top < 0) || (itemBounds.bottom > stageHeight) || (itemBounds.right > stageWidth)) {
					// 一些节点不在界面的可视范围内.开始自动滚动屏幕调整.
					
					// 计算所有节点距离中心点的X轴多远
					var scrollX: int = (stageWidth / 2) - (itemBounds.x + (itemBounds.width / 2));
					// 每一次限制一点点
					if(scrollX < -1) scrollX = -1;
					if(scrollX > 1) scrollX = 1;
					
					// 同样的设置Y轴
					var scrollY: int = (stageHeight / 2) - (itemBounds.y + (itemBounds.height / 2));
					if(scrollY < -1) scrollY = -1;
					if(scrollY > 1) scrollY = 1;
					
					//scrolling
					if((scrollX != 0) || (scrollY != 0))
						Network.scroll(scrollX, scrollY,_displayingNodes);
				}
			}
			if(prevRepulsionFactor != _repulsionFactor) {
				prevRepulsionFactor = _repulsionFactor;
				dispatchEvent(new Event("repulsionFactorChanged"));
			}
		}
		private var prevCoverage: Number = 0;
		private var prevRepulsionFactor: Number = 0;
		
		/**
		 * 计算最大矩形
		 */
		private function calcItemsBoundingRect(): Rectangle {
			if(nodes.length == 0) return null;
			
			var result: Rectangle = new Rectangle(9999999, 9999999, -9999999, -9999999);
			for (var i: int = 1; i < nodes.length; i++) {
				var itemView: Object = nodes[i];
				if(itemView.x < result.left) result.left = itemView.x;
				if((itemView.x + itemView.width) > result.right) result.right = itemView.x + itemView.width;
				if(itemView.y < result.top) result.top = itemView.y;
				if((itemView.y + itemView.height) > result.bottom) result.bottom = itemView.y + itemView.height;
			}
			return result;
		}
		
		//***************************************************************************************
		//
		//    重载的方法
		//
		//***************************************************************************************
		override public function doLayout():void{
			/* 初始化节点坐标,先新建GraphDataProvider实例再调用该方法 */
			refreshLayout();
			
			/* 刷新界面 */
			refreshScreen();
		}
		 
		
		override protected function setSelectedNode(currentNode:Node=null):void{
			super.setSelectedNode(currentNode);
			_dataProvider.nodes = _displayingNodes;
			_dataProvider.edges = _displayingLinks;
			refreshScreen();
		}

		override public function refreshLayout():void{
			/* 没有数据，清空 */
			if(_network==null||nodes==null||nodes.length==0||links==null||links.length==0){
				if(_clearAll){
					clear();
					_clearAll = false;
				}
				return;
			}
			
			//重置最大、最小节点坐标。
			_network.reset();
			
			
			/* 先清空 */
			_topNodes.splice(0,_topNodes.length);
			for each(var n:Node in nodes){
				/* 获取所有一级节点 */
				if(!n.parent)
					_topNodes.push(n);
				
				/* 为limit0或为append模式则显示全部 */
				n.visible = (limit==0||isAppendMode);
				n.isLock = true;
				/* 小于1则需要设置节点到屏幕中央 */
				if(isNaN(n.x)||n.x<1)
					n.x = stageWidth/2;
				if(isNaN(n.y)||n.y<1) 
					n.y = stageHeight/2;
				    
				/* 便于优化，默认设置isLock=true */
				n.context = _dataProvider;
				n.isLock = false;
			}
			
			/* 初始化界面需要显示的节点 */
			setSelectedNode(currentCompareNode);
		} 
		
		override public function clear(): void {
			stopDamper();
			if(currentCompareNode)
				currentCompareNode = null;
			if(forceDirectedLayout){
				forceDirectedLayout.dataProvider = null;
				forceDirectedLayout = null;
			}
			if(_dataProvider){
				_dataProvider.clear();
				_dataProvider = null;
			}
			
			super.clear();
			
			if(_numLevels){
				_numLevels.splice(0,_numLevels.length);
				_numLevels = null;
			}
			if(_network)
				_network = null;
		}
		
		//***************************************************************************************
		//
		//    getter setter
		//
		//***************************************************************************************
		/**
		 *  How strongly do items push each other away.
		 *  
		 *  @default 0.75 
		 */
		public function set repulsionFactor(factor: Number): void {
			_repulsionFactor = factor;
			refreshScreen();
		}
		
		[Bindable(event="repulsionFactorChanged")]
		public function get repulsionFactor(): Number {
			return _repulsionFactor;
		}
		
		public function set motionThreshold(t: Number): void {
			ForceDirectedLayout.motionLimit = t;
			dispatchEvent(new Event("motionThresholdChange"));
		}
		
		/** 
		 * 当值低于此数值时停止布局计算。
		 * 这个值推荐的有效范围为0.001~2.0,值越高，则布局计算越快结束，这也意味着布局效果越差。
		 * 同样的，值越低，布局计算的事件越久，显示效果也越好。 
		 */
		[Bindable("motionThresholdChange")]
		public function get motionThreshold(): Number {
			return ForceDirectedLayout.motionLimit;
		}
	}
}