package com.myflexhero.network.core.layout
{
	import com.myflexhero.network.Consts;
	import com.myflexhero.network.Network;
	import com.myflexhero.network.Node;
	import com.myflexhero.network.Size;
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.core.IElementUI;
	import com.myflexhero.network.core.ui.NodeUI;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.core.mx_internal;

	use namespace mx_internal;
	/**
	 * 树形布局.拥有以下四种布局方向。
	 * <ul>
	 * 	<li>Consts.LAYOUT_TOPBOTTOM</li>
	 * 	<li>Consts.LAYOUT_BOTTOMTOP</li>
	 * 	<li>Consts.LAYOUT_LEFTRIGHT</li>
	 * 	<li>Consts.LAYOUT_RIGHTLEFT</li>
	 * </ul>
	 * 可以使用的参数有:orientation、depthSpace、 leftGap、 topGap、siblingSpace。
	 * <br>
	 * 仍需修改以支持多个顶级节点群。
	 * @author Hedy<br>
	 * 550561954#qq.com 
	 * @see com.myflexhero.network.core.layout.SpringLayout
	 */
	public class TreeLayout extends CustomLayout
	{
		//***************************************************************************************
		//
		//   参数
		//
		//***************************************************************************************
		/**
		 * 布局方向。
		 * 拥有以下四种布局方向。
		 * <ul>
		 * 	<li>Consts.LAYOUT_TOPBOTTOM</li>
		 * 	<li>Consts.LAYOUT_BOTTOMTOP</li>
		 * 	<li>Consts.LAYOUT_LEFTRIGHT</li>
		 * 	<li>Consts.LAYOUT_RIGHTLEFT</li>
		 * </ul>
		 */
		public var orientation:String;
		/**
		 * 上下级之间的间隔距离
		 */
		private var _depthSpace:Number = 40;
		/**
		 * 最左侧节点距离容器左侧的距离，默认为6。
		 */
		public var leftGap:Number =6 ;
		/**
		 * 最上侧节点距离显示容器顶部的距离，默认为6。
		 */
		public var topGap:Number =6;
		/**
		 * 不同顶级节点群之间的间隔，即第一个节点群的最后一个元素(叶节点)和第二个节点群的首个元素(根节点)。默认为10像素。
		 */
		public var topNodesPadding:Number = 10;
		/**
		 * 兄弟节点的距离
		 */
		private var _siblingSpace:Number  = 20;
//		/**
//		 * 子节点之间的间隔(有孩子)---暂未使用
//		 */
//		private var _subtreeSpace :Number;
		
		/**
		 * 每一级都要设置(以Number的方式保存值).<br>
		 * _nodeStartPosition = 下一个邻居节点的x值=当前节点x+_nodeRectangleWidth(相对于从顶部到底部的方向来说)
		 */
		private var _nodeStartPosition:Dictionary;
		/**
		 * 兄弟节点的总数(包括自己)
		 */
		private var _siblingNodesCount:Number;
		/**
		 *  保存每一层最大节点的高度及宽度(以Size对象的方式保存值) ，需要修改以支持多个顶级节点群
		 */
		private var _depthMaxRectangle:Dictionary;
		/**
		 * 当前tree所拥有的最大层数，需要修改以支持多个顶级节点群
		 */
		private var _maxDepth:int;
		/**
		 * y轴坐标轴最大值的点,供拥有2个及以上的顶级节点时作为界面的判断依据
		 */
		private var _bottomYMost:Number;
		/**
		 * x轴坐标轴最大值的点,供拥有2个及以上的顶级节点时作为界面的判断依据
		 */
		private var _rightXMost:Number;
		//***************************************************************************************
		//
		//   构造
		//
		//***************************************************************************************
		public function TreeLayout(network:Network)
		{
			super(network);
		}
		
		//***************************************************************************************
		//
		//   Override
		//
		//***************************************************************************************
		override public function doLayout():void{
			refreshLayout();
		}
		
		override public function refreshLayout():void{
			if(nodes==null||nodes.length==0)
				return;
			super.refreshLayout();
			initNodeCoordinate();
		}
		
		override public function initNodeCoordinate():void{
			if(displayingNodes==null)
				return;
			var _lastDepthWidth:Number = 0;
			var _lastDepthHeight:Number = 0;
			var topNodeCount:int = 0;
			_bottomYMost = 0;
			_rightXMost = 0;
			/* 迭代顶级节点 */
			for(var i:int=0;i<displayingNodes.length;i++){
				if(((currentCompareNode==null||isAppendMode)&&displayingNodes[i].parent==null)//currentCompareNode为空，或当前为append模式，则显示所有顶级节点
					 ||
					 (!isAppendMode)&&currentCompareNode&&((currentCompareNode.parent!=null&&displayingNodes[i]==currentCompareNode.parent)//有上级节点，则上级节点作为顶级节点(非append模式)
										  ||
											(currentCompareNode.parent==null&&displayingNodes[i].parent==null)//双击的为顶级节点，则显示所有顶级节点(非append模式)
										 )
				   ){
					topNodeCount++;
					//有多个顶级节点时，添加节点群之间的间隔
					if(topNodeCount>1){
						switch(orientation){
							case Consts.LAYOUT_TOPBOTTOM:
								_lastDepthHeight = _depthMaxRectangle[_maxDepth].height;
								break;
							case Consts.LAYOUT_BOTTOMTOP:
								_lastDepthHeight = _depthMaxRectangle[0].height;
								break;
							case Consts.LAYOUT_LEFTRIGHT:
								_lastDepthWidth = _depthMaxRectangle[_maxDepth].width;
								break;
							case Consts.LAYOUT_RIGHTLEFT:
								_lastDepthWidth = _depthMaxRectangle[0].width;
								break;
						}
					}
					
					/* 为下面的参数每一次都重新设置初值 */
					if(_depthMaxRectangle==null)
						_depthMaxRectangle = new Dictionary();
					else
						for(var key:String in _depthMaxRectangle)
							delete _depthMaxRectangle[key];
					
					if(_nodeStartPosition==null)
						_nodeStartPosition = new Dictionary();
					else
						for(key in _nodeStartPosition)
							delete _nodeStartPosition[key];
					_maxDepth = 0;
					_siblingNodesCount = 0;
					
					/* 每一次重新开始设置isFirst=true */
					_isFirst = true;
					
					//首先调整一次，仅仅设置当前层的_maxDepth值。
					adjustMaxDepth(displayingNodes[i] as Node,
						1,
						true,
						0,
						new Point(_rightXMost+_lastDepthWidth,_bottomYMost+_lastDepthHeight));
					
					/* 迭代生成坐标,mostPoint值第一次传入0,0 */
					adjustCoordinate(displayingNodes[i] as Node,
									1,
									true,
									true,
									0,
									new Point(_rightXMost+_lastDepthWidth,_bottomYMost+_lastDepthHeight));
					
					
					/* 额外为上级节点高亮 */
					if(currentCompareNode&&currentCompareNode.parent!=null){
						/* 也高亮 */
						var _ui:IElementUI = _network.getElementUI(currentCompareNode.parent);
						/* 为空则可能是已经删除 */
						if(_ui!=null){
							_ui.setHighLightLevel(2);
							_ui.refreshHighLight();
						}
					}
				}
			}
			//不自动缩放
//			_network.zoomShowAll();
//			trace(_network.width+","+_network.scroller.width+","+_network.rootGroup.width+","+_network.getNodeLayoutGroup().width+","+_network.attachmentGroup.width+","+_network.backgroundGroup.width+","+_network.customGroup.width+","+Node.maxPoint.x)
		}
		
		//***************************************************************************************
		//
		//   计算布局
		//
		//***************************************************************************************
		private var _isFirst:Boolean;
		
		private function setDepthSecondNodePosition(n:Node,
													currentDepth:int,
													nodeRectangleSize:Size):void{
			if(orientation==Consts.LAYOUT_TOPBOTTOM||orientation==Consts.LAYOUT_BOTTOMTOP){
					n.x = _nodeStartPosition[currentDepth];
					_nodeStartPosition[currentDepth] = n.x+nodeRectangleSize.width;
			}else{
					n.y = _nodeStartPosition[currentDepth];
					_nodeStartPosition[currentDepth] = n.y+nodeRectangleSize.height;
			}
		}
		
		/**
		 * 计算每一层最大的高度和宽度，只在第一次进入该层时计算。
		 */
		private function setDepthMaxRectangle(n:Node,currentDepth:int,
											  isFirstNodeInCurrentDepth:Boolean=true):void{
			/* 每一层的最大height、width,用于depth的值计算 */
			var maxRectangle:Size = new Size(0,0);
//			trace("currentDepth:"+currentDepth)
			if(isFirstNodeInCurrentDepth){
				/* 进入下一层之前，先计算出当前节点及所有邻居节点的最大高度和高度 */
				/* 只计算一次，在n=0时  */
				if(n.parent){
					for(var i:int=0;i<n.parent.numChildren;i++){
						if(isNotDiplayingNode(n.parent.children[i] as Node))
							continue;
						var _sibling:Node = n.parent.children[i] as Node;
						if(_sibling.nodeHeight>maxRectangle.height)
							maxRectangle.height = _sibling.nodeHeight;
						if(_sibling.nodeWidth>maxRectangle.width)
							maxRectangle.width = _sibling.nodeWidth;
					}
//					trace("_depthMaxRectangle["+currentDepth+"]"+",width:"+maxRectangle.width+",height:"+maxRectangle.height)
				}
					/* n.parent==null,当前为顶级节点  */
				else if(currentDepth==0){
					maxRectangle.height = n.nodeHeight;
					maxRectangle.width = n.nodeWidth;
//					trace("_depthMaxRectangle[000]"+",width:"+maxRectangle.width+",height:"+maxRectangle.height)
				}
				_depthMaxRectangle[currentDepth] = maxRectangle;
			}
		}
		
		/**
		 * 设置节点的x和y坐标(上下布局)
		 * @param n 当前节点
		 * @param isFirstNodeInCurrentDepth 当前节点在当前层中是否为第一个节点
		 * @param currentDepth 当前层的深度
		 * @param nodeRectangleSize 每个节点的图片宽度(或高度)+间隔，用于设置_nodeStartPosition
		 * @param mostPoint 所有节点中最大x值和y值的point(x和y值的节点可能属于不同节点).
		 */
		private function setNodePositionForUpAndDown(n:Node,
													 isFirstNodeInCurrentDepth:Boolean,
													 isFirstChildInCurrentParent:Boolean,
													 currentDepth:int,
													 nodeRectangleSize:Size,
													 mostPoint:Point):void{
			var isFirst_loc:Boolean = false;
			/*************************************************** 设置X值 *****************************************/
			/* 首次进入设置节点x值 */
			if(_isFirst){
				var _nodeUI:NodeUI = _network.getElementUI(n) as NodeUI;
				n.x = leftGap+(n.nodeWidth>n.imageWidth?
					n.nodeWidth-n.imageWidth:0);
				
				/* 保存_nodeStartPosition */
				_nodeStartPosition[currentDepth] = n.x+nodeRectangleSize.width;
				_isFirst = false;
				isFirst_loc = true;
			}
				
			if(!isFirst_loc){
				/* 当前可见的子节点 */
				var visibledChildrenNum:int =0;
				var visibledChildren:Vector.<Node>;
				for(var i:int=0;i<n.numChildren;i++){
					if(isNotDiplayingNode(n.children[i]  as Node))
						continue;
					/* 需至少确保有一个孩子可见 */
					if(n.children[i].visible){
						visibledChildrenNum++;
						if(visibledChildren==null)
							visibledChildren = new Vector.<Node>;
						visibledChildren.push(n.children[i])
					}
					
				}
				/*
				 * 第一次设置当前层最左侧节点的值 或者 当前节点有孩子(用于显示限制的节点)
				 */
				if(isFirstNodeInCurrentDepth||isFirstChildInCurrentParent||visibledChildrenNum>0){
					/* 
						这里属于迭代之后返回的上级父亲节点计算,currentDepth!=_maxDepth意味着当前不是最后一层树
						有孩子,则n.x值=所有孩子的中心点x 
					*/
					if(visibledChildrenNum>0&&currentDepth!=_maxDepth){
						var visableChildCount:int = 0;
						var leftMostChild:Node;
						var rightMostChild:Node;
						for(i=0;i<visibledChildrenNum;i++){
							/* 需至少确保有一个孩子可见 */
							if(leftMostChild==null)
								leftMostChild = visibledChildren[i] as Node;
							rightMostChild = visibledChildren[i] as Node;
						}
						/* 只有一个孩子（或只有一个孩子visible=true）,则和该孩子直接对齐(x轴) */
						if(visibledChildrenNum==1){
							/* 父子节点的图片宽度可能不一样 可能是父亲节点的大于子节点，则父亲节点略微左边对齐 */
							if(n.nodeWidth>leftMostChild.nodeWidth)
								n.x = leftMostChild.x-(n.nodeWidth-leftMostChild.nodeWidth)/2;
							else if(n.nodeWidth<leftMostChild.nodeWidth)
								n.x = leftMostChild.x+(leftMostChild.nodeWidth-n.nodeWidth)/2;
							else 
								n.x = leftMostChild.x;
						}
						/* 否则，有多个孩子，则和孩子们的中心点对齐 
						 * n.x = 最左边的孩子到最右边的孩子的距离/2=最后的结果-父亲节点离中心点的偏移量
						 */
						else{
							n.x = leftMostChild.x+Math.abs(leftMostChild.x-(rightMostChild.x+rightMostChild.nodeWidth))/2-n.nodeWidth/2;
						}
						
						//如果当前孩子节点的中心点小于[当前层]的x值，则使用[当前层]的x值
						if(n.x<_nodeStartPosition[currentDepth])
							n.x = _nodeStartPosition[currentDepth];
					}
						// 
						//          *
						// 		   
						//       *     *
						// 
						//    *     *      *(上级点)
						// 
						//                 *(当前点)
						// 
						// 
						//  使用上级节点作为中心点 
					else if(n.parent&&(isFirstNodeInCurrentDepth||isFirstChildInCurrentParent)){
						/* 
						1 未设置当前的_nodeStartPosition值，则使用上级节点作为中心点，
						2 默认x值=父亲节点的x值(前面第一次设置了)-((_nodeRectangleWidth*_siblingNodesCount+_siblingSpace*(_siblingNodesCount-1))/2)，且x>=1.
						*/
						var x_loc:Number = Node(n.parent).x-(nodeRectangleSize.width*_siblingNodesCount+_siblingSpace*(_siblingNodesCount-1))/2;
						if(isNaN(_nodeStartPosition[currentDepth]))
							n.x = x_loc;
						else
							n.x = Math.max(x_loc,_nodeStartPosition[currentDepth]);
					}
					/* 保存下个节点X值 */
					_nodeStartPosition[currentDepth] = n.x + nodeRectangleSize.width;
				}
			}
			/*************************************************** 设置Y值 *****************************************/
			
			/* y值更改之前调用 */
			//			n.isLock = false;
			var _currentNodeHeightDistance:Number = 0;
			var _currentNodeWidthDistance:Number = 0;

			/*  设置节点的y值 */
			if(orientation==Consts.LAYOUT_TOPBOTTOM)
				for(i=0;i<currentDepth;i++){
//					trace("currentDepth:"+currentDepth+",_depthMaxRectangle["+i+"]:"+_depthMaxRectangle[i])
					_currentNodeHeightDistance+= depthSpace+_depthMaxRectangle[i].height;
				}
			else{
				//当前_maxDepth可能不是最终的最大值，所以需要重新再设置一次
				for(i=0;i<_maxDepth-currentDepth;i++){
//					trace("_depthMaxRectangle[i]:"+_depthMaxRectangle[i])
					//这里有一个bug
					if(_depthMaxRectangle[i]==null){
						_depthMaxRectangle[i] = _depthMaxRectangle[0];
					}
					_currentNodeHeightDistance+= depthSpace+_depthMaxRectangle[i].height;
				}
			}
			n.y = topGap+_currentNodeHeightDistance+mostPoint.y;
		}
		
		/**
		 * 设置节点的x和y坐标(左右布局)
		 * @param n 当前节点
		 * @param isFirstNodeInCurrentDepth 当前节点在当前层中是否为第一个节点
		 * @param currentDepth 当前层的深度
		 * @param nodeRectangleSize 每个节点的图片宽度(或高度)+间隔，用于设置_nodeStartPosition
		 * @param mostPoint 所有节点中最大x值和y值的point(x和y值的节点可能属于不同节点).
		 */
		private function setNodePositionForRightAndLeft(n:Node,
														isFirstNodeInCurrentDepth:Boolean,
														isFirstChildInCurrentParent:Boolean,
														currentDepth:int,
														nodeRectangleSize:Size,
														mostPoint:Point):void{
			var isFirst_loc:Boolean = false;
			/*************************************************** 设置该树的第一次X值 *****************************************/
			/* 首次进入设置节点x值 */
			if(_isFirst){
				var _nodeUI:NodeUI = _network.getElementUI(n) as NodeUI;
				n.y = topGap;
				/* 保存_nodeStartPosition */
				_nodeStartPosition[currentDepth] = n.y+nodeRectangleSize.height;
				_isFirst = false;
				isFirst_loc = true;
			}
			
			
			if(!isFirst_loc){
				/* 当前可见的子节点 */
				var visibledChildrenNum:int =0;
				var visibledChildren:Vector.<Node>;
				for(var i:int=0;i<n.numChildren;i++){
					if(isNotDiplayingNode(n.children[i]  as Node))
						continue;
					/* 需至少确保有一个孩子可见 */
					if(n.children[i].visible){
						visibledChildrenNum++;
						if(visibledChildren==null)
							visibledChildren = new Vector.<Node>;
						visibledChildren.push(n.children[i])
					}
					
				}
				/*
				* 第一次设置当前层最左侧节点的值 或者 当前节点有孩子(用于显示限制的节点)
				*/
				if(isFirstNodeInCurrentDepth||isFirstChildInCurrentParent||visibledChildrenNum>0){
					if(visibledChildrenNum>0&&currentDepth!=_maxDepth){
						var visableChildCount:int = 0;
						var leftMostChild:Node;
						var rightMostChild:Node;
						for(i=0;i<visibledChildrenNum;i++){
							/* 需至少确保有一个孩子可见 */
							if(leftMostChild==null)
								leftMostChild = visibledChildren[i] as Node;
							rightMostChild = visibledChildren[i] as Node;
						}
						/* 只有一个孩子（或只有一个孩子可见）,和孩子直接对齐 */
						if(visibledChildrenNum==1){
							/* 父子节点的图片宽度可能不一样 可能是父亲节点的大于子节点，则父亲节点略微左边对齐 */
							if(n.nodeHeight>leftMostChild.nodeHeight)
								n.y = leftMostChild.y-(n.nodeHeight-leftMostChild.nodeHeight)/2;
							else if(n.nodeHeight<leftMostChild.nodeHeight)
								n.y = leftMostChild.y+(leftMostChild.nodeHeight-n.nodeHeight)/2;
							else 
								n.y = leftMostChild.y;
						}
						else{
							n.y = rightMostChild.y-Math.abs(leftMostChild.y+leftMostChild.nodeHeight-rightMostChild.y)/2-n.nodeHeight/2;
						}
						
						//如果当前孩子节点的中心点小于[当前层]的x值，则使用[当前层]的x值
						if(n.y<_nodeStartPosition[currentDepth])
							n.x = _nodeStartPosition[currentDepth];
					}
					else if(n.parent&&(isFirstNodeInCurrentDepth||isFirstChildInCurrentParent)){
						/* 
						1 未设置当前的_nodeStartPosition值，则使用上级节点作为中心点，
						2 x值=父亲节点的x值(前面第一次设置了)-((_nodeRectangleWidth*_siblingNodesCount+_siblingSpace*(_siblingNodesCount-1))/2)，且x>=1.
						*/
						var y_loc:Number = Node(n.parent).y-(nodeRectangleSize.height*_siblingNodesCount+_siblingSpace*(_siblingNodesCount-1))/2;
						if(isNaN(_nodeStartPosition[currentDepth]))
							n.y = y_loc;
						else
							n.y = Math.max(y_loc,_nodeStartPosition[currentDepth]);
					}
					_nodeStartPosition[currentDepth] = n.y + nodeRectangleSize.height;
				}
				
			}
			
			/*************************************************** 设置x值 *****************************************/
			/* y值更改之前调用 */
			//			n.isLock = false;
			var _currentNodeWidthDistance:Number = 0;
			
			if(orientation==Consts.LAYOUT_LEFTRIGHT){
				for(i=0;i<currentDepth;i++)
					_currentNodeWidthDistance+= depthSpace+_depthMaxRectangle[i].width;
				/* 顶级节点,直接赋值 */
				if(currentDepth==0){
					n.x = mostPoint.x+(n.nodeWidth>n.nodeWidth?
							n.nodeWidth-n.nodeWidth:0);
					return;
				}
			}
			else{
				for(i=0;i<_maxDepth-currentDepth;i++){
					//这里有一个bug
					if(_depthMaxRectangle[i]==null)
						_depthMaxRectangle[i] = _depthMaxRectangle[0];
					_currentNodeWidthDistance+= depthSpace+_depthMaxRectangle[i].width;
				}
				if(currentDepth==_maxDepth){
					n.x = mostPoint.x+(n.nodeWidth>n.nodeWidth?
						n.nodeWidth-n.nodeWidth:0);
					return;
				}
			}
			n.x = _currentNodeWidthDistance+mostPoint.x;
//			/*  设置节点的y值 */
//			if(orientation==Consts.LAYOUT_LEFTRIGHT)
//				for(i=0;i<currentDepth;i++){
//					_currentNodeWidthDistance+= depthSpace+_depthMaxRectangle[i].width;
//				}
//			else
//				for(i=0;i<_maxDepth-currentDepth;i++)
//					_currentNodeWidthDistance+= depthSpace+_depthMaxRectangle[i].width;
//			
//			n.x = topGap+_currentNodeWidthDistance+mostPoint.x;
		}
		
		/**
		 * 设置节点的坐标值，该方法作为计算布局的入口方法.
		 * @param n 当前节点
		 * @param siblingNodesCount 每一级的邻居节点总数,如果为顶级节点，则传入1.
		 * @param isFirstNodeInCurrentDepth 当前节点在当前层中是否为第一个节点
		 * @param isFirstChildInCurrentParent 当前节点在父亲节点中是否为第一个孩子
		 * @param currentDepth 当前层的深度
		 * @param mostPoint 当前顶级节点所属的tree中的所有节点最大x值和y值的point(x和y值的节点可能属于不同节点).
		 */
		private function adjustCoordinate(n:Node,
									   siblingNodesCount:int,
									   isFirstNodeInCurrentDepth:Boolean,
									   isFirstChildInCurrentParent:Boolean,
									   currentDepth:int,
									   mostPoint:Point):void{
//			if(n.label=="55"){
//				var c:int =3;
//			}
//			if(n.label=="192.168.2.2"){
//				var b:int =3;
//			}
//			if(n.label=="192.168.2.12"){
//				var a:int =3;
//			}
//			
//			trace("a当前node-->"+n.label+",	深度:"+currentDepth)
			/* 不限制显示，且已经超过限制层数了 */
			if(limit>0&&currentDepth>limit)
				return;
			
			/* 设置每一层的最大高宽 */
			setDepthMaxRectangle(n,currentDepth,isFirstNodeInCurrentDepth);
			
			/* 每个节点的图片宽度(或高度)+间隔，用于设置_nodeStartPosition */
			var nodeRectangleSize:Size = new Size(n.nodeWidth + _siblingSpace,n.nodeHeight + _siblingSpace)
				
			/* 当前节点不是当前层的第一个节点，直接设置X,且保持_nodeStartPosition */
			if(n.parent&&!isFirstNodeInCurrentDepth)
				setDepthSecondNodePosition(n,currentDepth,nodeRectangleSize);
			
			/* 
			 * 当前节点为currentCompareNode(双击的节点)的邻居节点，则跳过不显示(只显示其父亲节点) 
			 * 直接取_network.limit,因为上面initNodeCoordinate()方法可能已经更改过了 
			 * 放置于setDepthMaxRectangle()方法之后调用，
			 * 否则isFirstNodeInCurrentDepth=true时,
			 * 且当前节点(鼠标点击的节点)的邻居节点的的当前层最大宽度和高度无法设置.
			 */
			if(limit!=0&&
				currentCompareNode&&
				n.parent&&
				n.parent.children.indexOf(currentCompareNode)!=-1&&
				n!=currentCompareNode)
				return;

			var isOrientationUpOrDown:Boolean = (orientation==Consts.LAYOUT_TOPBOTTOM||orientation==Consts.LAYOUT_BOTTOMTOP);
			/* 拥有孩子且并没有超出限制*/
			if(n.numChildren>0&&(currentDepth<limit||limit==0)){
				/* 初始化当前节点坐标(即子集的parent)，供子集设置坐标时作为判断 */
				var tc:Number = _nodeStartPosition[currentDepth];
				var tcurrent:int = currentDepth;
				while(isNaN(tc)){
					if(tcurrent==0)
						break;
					tcurrent--;
					tc = _nodeStartPosition[tcurrent];
				}
				
				var ts:int = n.parent?n.parent.numChildren:0;
				
				//如果tc变量不为空，则设置当前节点坐标为相对于上级节点的坐标
				if(!isNaN(tc)){
					if(isOrientationUpOrDown)
						n.x = tc-(nodeRectangleSize.width*ts+_siblingSpace*(ts-1))/2;
					else
						n.y = tc-(nodeRectangleSize.height*ts+_siblingSpace*(ts-1))/2;
				}else{
					tc = 10;
					if(isOrientationUpOrDown)
						n.x = tc;
					else
						n.y = tc;
				}
				
					
				var child:*;
				var children:Vector.<IData> = new Vector.<IData>;
				/* 计算兄弟节点 */
				for(var i:int=0;i<n.numChildren;i++){
					if(isNotDiplayingNode(n.children[i] as Node))
						continue;
					children.push(n.children[i]);
				}
				
				/* 迭代子集,一直到最后一层树开始 */
				for(i=0;i<children.length;i++){
					adjustCoordinate(children[i] as Node,
									children.length,
									_nodeStartPosition[currentDepth+1]==null,
									i==0,
									currentDepth+1,
									mostPoint);
				}
				
			}
			n.isLock = false;
			n.visible = true;
			
			_siblingNodesCount = n.parent?n.parent.numChildren:0;
			/* 设置x、y */
			if(isOrientationUpOrDown)
				setNodePositionForUpAndDown(n,isFirstNodeInCurrentDepth,isFirstChildInCurrentParent,currentDepth,nodeRectangleSize,mostPoint);
			else
				setNodePositionForRightAndLeft(n,isFirstNodeInCurrentDepth,isFirstChildInCurrentParent,currentDepth,nodeRectangleSize,mostPoint);
			
			
			/* 保存x最值,加上默认节点群的间隔 */
			if(n.x+topNodesPadding>_rightXMost)
				_rightXMost = n.x+topNodesPadding;
			
			/* 保存y最值,加上默认节点群的间隔 */
			if(n.y+topNodesPadding>_bottomYMost)
				_bottomYMost = n.y+topNodesPadding;
			
			var ui:IElementUI = _network.getElementUI(n);
			
			/*最后一层节点(currentDepth+1>limit)不设置高亮*/
			/* 如果当前显示的最低级节点拥有子节点 */
			if(ui&&_topNodes)
				ui.setHighLightLevel(n.numChildren>0&&(currentDepth==_maxDepth)?
					3:0);
//			trace(n.label+"		x:"+n.x+"y:"+n.y)
			/* 派发事件重绘视图 */
			n.dispatchPropertyChangeEvent("xy", n.oldPoint.x, n.x);
		}
		
		
		/**
		 * 调整当前节点群的最大层数
		 * @param n 当前节点
		 * @param siblingNodesCount 每一级的邻居节点总数,如果为顶级节点，则传入1.
		 * @param isFirstNodeInCurrentDepth 当前节点在当前层中是否为第一个节点
		 * @param currentDepth 当前层的深度
		 * @param mostPoint 当前顶级节点所属的tree中的所有节点最大x值和y值的point(x和y值的节点可能属于不同节点).
		 */
		private function adjustMaxDepth(n:Node,
									   siblingNodesCount:int,
									   isFirstNodeInCurrentDepth:Boolean,
									   currentDepth:int,
									   mostPoint:Point):void{
			/* 不限制显示，且已经超过限制层数了 */
			if(limit>0&&currentDepth>limit)
				return;
			
			/* 保存最大层数 */
			if(currentDepth>_maxDepth)
				_maxDepth = currentDepth;
			
			/* 拥有孩子且并没有超出限制*/
			if(n.numChildren>0&&(currentDepth<limit||limit==0)){
				var child:*;
				var children:Vector.<IData> = new Vector.<IData>;
				/* 计算兄弟节点 */
				for(var i:int=0;i<n.numChildren;i++){
					if(isNotDiplayingNode(n.children[i] as Node))
						continue;
					children.push(n.children[i]);
				}
				
				/* 迭代子集,一直到最后一层树开始 */
				for(i=0;i<children.length;i++){
					adjustMaxDepth(children[i] as Node,
						children.length,
						_nodeStartPosition[currentDepth+1]==null,
						currentDepth+1,
						mostPoint);
				}
				
			}
		}
		

		override public function clear():void{
			super.clear();
			//这里注释掉清空，暂时忘了.
			if(_depthMaxRectangle)
				for(var key:String in _depthMaxRectangle)
					delete _depthMaxRectangle[key];
			if(_nodeStartPosition)
				for(key in _nodeStartPosition)
					delete _nodeStartPosition[key];
			_clearAll = false;
		}
		
		
		private function isNotDiplayingNode(n:Node):Boolean{
			return displayingNodes.indexOf(n)==-1;
		}
		
		/**
		 * 兄弟节点的间隔，默认为20.
		 */
		public function get siblingSpace():Number
		{
			return _siblingSpace;
		}
		
		/**
		 * 兄弟节点的间隔，默认为20.
		 */
		public function set siblingSpace(value:Number):void
		{
			_siblingSpace = value;
			initNodeCoordinate();
		}
		
		
		/**
		 * 上下级之间的间隔距离
		 */
		public function get depthSpace():Number
		{
			return _depthSpace;
		}
		
		/**
		 * 上下级之间的间隔距离，默认为40.
		 */
		public function set depthSpace(value:Number):void
		{
			_depthSpace = value;
			initNodeCoordinate();
		}
	}
}