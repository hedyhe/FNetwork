package com.myflexhero.network.core.layout
{
	import com.myflexhero.network.Consts;
	import com.myflexhero.network.DataBox;
	import com.myflexhero.network.Link;
	import com.myflexhero.network.Network;
	import com.myflexhero.network.Node;
	import com.myflexhero.network.core.ICustomLayout;
	import com.myflexhero.network.core.ILayoutManager;
	import com.myflexhero.network.event.DataBoxChangeEvent;
	
	import flash.utils.getTimer;
	
	import mx.core.mx_internal;

	use namespace mx_internal;
	
	/**
	 * 自动布局控制器.
	 * <ul>
	 * <li>通过调用doLayout方法传入布局类型，进行自动布局.</li>
	 * <li>如需刷新数据，请调用refreshLayoutData()方法.</li>
	 * <li>如需获取当前正在使用的布局器，请调用getCurrentLayout()方法.目前返回的布局类型为TreeLayout和SpringLayout.</li>
	 * </ul>
	 * @author Hedy
	 * @see TreeLayout
	 * @see SpringLayout
	 * 
	 */
	public class AutoLayout extends BasicLayout implements ILayoutManager
	{
		protected var _currentLayout:ICustomLayout=null;
		
		public function AutoLayout(network:Network)
		{
			super(network);
			addEventListener(DataBoxChangeEvent.CLEAR,handleElementBoxChange);
		}
		
		
		private var _layoutChanged:Boolean = false;
		/**
		 * 开始重新绘制界面布局
		 * @param layoutType 布局类型,请通过前缀为:“Consts.LAYOUT_类型名”进行查询.
		 */
		public function setLayout(layoutType:String=""):void{
			//是否设置默认值
			var e:Boolean = false;
			if(_currentLayout!=null){
				this.limit = _currentLayout.limit;
				this.isAppendMode = _currentLayout.isAppendMode;
				e = true;
				_currentLayout.clear();
			}
			
			
			switch(layoutType){
				case Consts.LAYOUT_SPRING:
					_currentLayout = new SpringLayout(_network);
					break;
				case Consts.LAYOUT_TOPBOTTOM:
					if(_currentLayout==null||!(_currentLayout is TreeLayout))
						_currentLayout = new TreeLayout(_network);
					TreeLayout(_currentLayout).orientation = Consts.LAYOUT_TOPBOTTOM;
					break;
				case Consts.LAYOUT_BOTTOMTOP:
					if(_currentLayout==null||!(_currentLayout is TreeLayout))
						_currentLayout = new TreeLayout(_network);
					TreeLayout(_currentLayout).orientation = Consts.LAYOUT_BOTTOMTOP;
					break;
				case Consts.LAYOUT_LEFTRIGHT:
					if(_currentLayout==null||!(_currentLayout is TreeLayout))
						_currentLayout = new TreeLayout(_network);
					TreeLayout(_currentLayout).orientation = Consts.LAYOUT_LEFTRIGHT;
					break;
				case Consts.LAYOUT_RIGHTLEFT:
					if(_currentLayout==null||!(_currentLayout is TreeLayout))
						_currentLayout = new TreeLayout(_network);
					TreeLayout(_currentLayout).orientation = Consts.LAYOUT_RIGHTLEFT;
					break;
				case Consts.LAYOUT_ROUND:
					_currentLayout = new RoundLayout(_network);
					break;
				default:_currentLayout = new SpringLayout(_network);
					break;
			}
			if(e){
				_currentLayout.limit = this.limit;
				_currentLayout.isAppendMode = this.isAppendMode;
				e = false;
			}
			if(radius!=-1&&!isNaN(radius))
				_radius = radius;
			setLayoutData();
			_network.setCurrentAutoLayout(_currentLayout);
			_layoutChanged = true;
		}
		
		/**
		 * 设置布局所需的元素
		 */
		protected function setLayoutData():void{
//			var startTime:int = getTimer();
			var linkDataBox:DataBox = _network.getDataBox(_network.getLinkLayoutGroup());
			if(linkDataBox.length>0){
				links = Vector.<Link>(linkDataBox.getDatas());
			}else
				links = Network.createVectorLinks();
			
			var nodeDataBox:DataBox = _network.getDataBox(_network.getNodeLayoutGroup());
			if(nodeDataBox.length>0)
				nodes = Vector.<Node>(nodeDataBox.getDatas());
			else
				nodes = Network.createVectorNodes();
			
			_currentLayout.links = links;
			_currentLayout.nodes = nodes;
			_currentLayout.radius = _radius;
			_currentLayout.offsetX = _offsetX;
//			var startTime1:int = getTimer();
//			trace("setLayoutData:"+(startTime1-startTime))
			_currentLayout.offsetY = _offsetY;
		}
		
		/**
		 *  是否清除全部
		 */
		protected var _clearAll:Boolean = false;
		public function set clearAll(value:Boolean):void{
			_clearAll = value;
		}
		
		public function refreshLayout():void{
			if(_clearAll){
				_currentLayout.clearAll = true;
				_currentLayout.clear();
				_clearAll = false;
			}
			
			_currentLayout.links = links;
			_currentLayout.nodes = nodes;
			
			if(_layoutChanged){
				_layoutChanged = false;
				_currentLayout.doLayout();
			}
			else
				_currentLayout.refreshLayout();
		}
		
		public function getCurrentLayout():ICustomLayout{
			return _currentLayout;
		}
		
		/**
		 * 监听数据容器ElementBox的事件处理函数，完成对应的UI包装类的设置，包括自动布局的数据更新。
		 */
		protected function handleElementBoxChange(event:DataBoxChangeEvent) : void
		{
					if(!(event.data  is Node))
						return;
					for(var i:int=0;i<event.datas.length;i++){
						/* 删除UI */
//						removeElementUI(event.datas[i]);
					}
		}
	}
}