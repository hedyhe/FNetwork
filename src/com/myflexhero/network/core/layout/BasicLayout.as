package com.myflexhero.network.core.layout
{
	import com.myflexhero.network.Link;
	import com.myflexhero.network.Network;
	import com.myflexhero.network.Node;
	import com.myflexhero.network.core.ILayout;
	import com.myflexhero.network.core.ILayoutData;
	
	import flash.events.EventDispatcher;

	/**
	 * 所有布局的基类，继承自EventDispatcher，使其可以派发事件
	 */
	public class BasicLayout extends EventDispatcher implements ILayout,ILayoutData
	{
		protected var _network:Network=null;
		private var _links:Vector.<Link> ;
		private var _nodes:Vector.<Node>;
		protected var _radius:Number;
		
		protected var _offsetX:Number;
		
		protected var _offsetY:Number;
		private var _currentCompareNode:Node;
		
		protected var _limit:int = 0;
		protected var _isAppendMode:Boolean = false;

		/**
		 * 初始化构造，传入Network类
		 */
		
		public function BasicLayout(network:Network)
		{
			this._network = network;
		}
		
		
		public function set links(value:Vector.<Link>):void
		{
			this._links = value;
		}

		public function set nodes(value:Vector.<Node>):void
		{
			this._nodes = value;
		}

		public function set radius(value:Number):void
		{
			this._radius = value;
		}

		public function get radius():Number
		{
			if(!isNaN(_radius)&&_radius>0)
				return _radius;
			return 110;
		}
		/**
		 * 最左侧的节点离左侧屏幕的X轴偏移量
		 */
		public function set offsetX(value:Number):void{
			this._offsetX = value;
		}
		
		/**
		 *  最左侧的节点离左侧屏幕的Y轴偏移量
		 */
		public function set offsetY(value:Number):void{
			this._offsetY = value;
		}

		public function get links():Vector.<Link>
		{
			return _links;
		}

		public function get nodes():Vector.<Node>
		{
			return _nodes;
		}

		public function get currentCompareNode():Node
		{
			return _currentCompareNode;
		}

		public function set currentCompareNode(value:Node):void
		{
			_currentCompareNode = value;
		}

		public function get limit():int
		{
			return _limit;
		}

		public function set limit(value:int):void
		{
			_limit = value;
		}
		
		public function get isAppendMode():Boolean
		{
			return _isAppendMode;
		}
		
		public function set isAppendMode(value:Boolean):void
		{
			_isAppendMode = value;
		}

	}
}