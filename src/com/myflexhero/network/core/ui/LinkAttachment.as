package com.myflexhero.network.core.ui
{
	import com.myflexhero.network.Consts;
	import com.myflexhero.network.Link;
	import com.myflexhero.network.Network;
	import com.myflexhero.network.Node;
	import com.myflexhero.network.Styles;
	import com.myflexhero.network.core.IElement;
	
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.geom.Point;
	
	import mx.core.mx_internal;
	use namespace mx_internal;
	/**
	 * 设置属性及画连接
	 * @author Hedy<br>
	 * 如发现Bug请报告至email: 550561954@qq.com 
	 */
	public class LinkAttachment extends Attachment
	{
		public var fromX:Number;
		public var toX:Number;
		public var fromY:Number;
		public var toY:Number;
		public var linkType:String;
		/**
		 * link两端分别距离fromNode或toNode中心点的距离,默认为20.
		 */
		public var offset:Number;
		public var thickness:Number;
		public var color:uint=0;
		public var alpha:Number=1.0;
		public var pixelHinting:Boolean=false;
		public var scaleMode:String="normal";
		public var caps:String=null;
		public var joints:String=null;
		
		public var isDashedLine:Boolean = false;
		/* 虚线长度 */
		public var dashedLineLength:Number;
		/* 虚线间隔 */
		public var dashedLineSpacing:Number;
		/**
		 * link之间的间隔.
		 */
		public var bundleGap:Number;
		public var data:Vector.<Number>;
		public var commands:Vector.<int>;
		
		
		/**
		 * 
		 * 是否有箭头
		 */
		public var showArrow:Boolean = true;
		/**
		 * 箭头大小
		 */
		public var arrowSize:uint = 7;
		/**
		 * 箭头颜色
		 */
		public var arrowColor:uint;
		
		/**
		 * 判断当前类的用途是作为何种类型的link工具类
		 */
		private var isCreateLinkProperties:Boolean = false;
		
		/**
		 * 当设置的Styles.LINK_TYPE属性值为Consts.LINK_TYPE_ORTHOGONAL时，作为判断是水平直角还是垂直直角的最小差距间隔像素大小，默认为20像素.
		 */
		private var orthogonalDistanceRatio:Number;
		/**
		 * 当设置的Styles.LINK_TYPE属性值为Consts.LINK_TYPE_ORTHOGONAL时,link连线的直角弯曲像素，默认为20像素.
		 */
		private var orthogonalCorner:Number;
		
		public var network:Network;
		/**
		 * 引用
		 */
		private var link:Link;
		/**
		 * element可为link，也可为node(fromNode,仅当界面创建link且只设置了fromNode时使用)
		 */
		public function LinkAttachment(element:IElement,network:Network)
		{
			super(element);
			link = element as Link;
			data = new Vector.<Number>();
			commands = new Vector.<int>();
			this.network = network;
		}
		
		public var _links:Vector.<Link>;
		public var _linksLen:int = 0;
		override public function updateProperties() : void
		{
			super.updateProperties();
			
			if(styleChanged){
				thickness =  element.getStyle(Styles.LINK_WIDTH);
				color = element.getStyle(Styles.LINK_COLOR);
				alpha = element.getStyle(Styles.LINK_ALPHA);
				pixelHinting = element.getStyle(Styles.LINK_PIXEL_HINTING);
				scaleMode = element.getStyle(Styles.LINK_SCALE_MODE);
				caps = element.getStyle(Styles.LINK_CAPS_STYLE);
				joints =element.getStyle(Styles.LINK_JOINT_STYLE);
				linkType = element.getStyle(Styles.LINK_TYPE);
				showArrow = element.getStyle(Styles.LINK_SHOW_ARROW);
				arrowColor = element.getStyle(Styles.LINK_ARROW_COLOR);
				orthogonalDistanceRatio = element.getStyle(Styles.LINK_ORTHOGONAL_DISTANCE_RATIO);
				orthogonalCorner = element.getStyle(Styles.LINK_ORTHOGONAL_CORNER);
				offset = element.getStyle(Styles.LINK_BUNDLE_OFFSET);
				var dashedLineStyle:Array = element.getStyle(Styles.LINK_PATTERN);
				if(dashedLineStyle!=null&&dashedLineStyle.length==2){
					dashedLineLength = dashedLineStyle[0];
					dashedLineSpacing = dashedLineStyle[1];
					isDashedLine = true;
				}
				bundleGap = element.getStyle(Styles.LINK_BUNDLE_GAP);
				styleChanged = false;
			}
			if(!isCreateLinkProperties){
				setLinkPosition();
				if(fromX<20||toX<20){
					if(network.minXPointNode){
						network.refreshNodesToLeftAndTop(network.elementBox.getDatas() as Vector.<Node>,false,network.minXPointNode.x+Math.abs(network.minXPointNode.x-Math.min(fromX,toX)));
					}
				}
			}
		}

		private var referenceLink:Link;
		public var labelMathTan:Number;
		public var textFieldX:Number,textFieldY:Number;
		protected function setLinkPosition():void{
			_links =  network.getLinkReference(link.fromNode,link.toNode);
			_linksLen =  _links.length;
			referenceLink = _linksLen>1?_links[0]:link;
			
			//起始中心点
			var _fromSourceCenterPoint:Point = referenceLink.fromNode.centerLocation;
			//终止中心点
			var _toSourceCenterPoint:Point =  referenceLink.toNode.centerLocation;
			
			//link两端距离fromNode(或toNode)中心点的水平偏移量(未减去style中offset的值)
			var parallelOffsetValue:Number = 0;
			
			//不是单条连接
			if(_linksLen>1){
				parallelOffsetValue = getParallelOffset();
			}
			
			//如果为中间的link，则偏移量为0
			if(isMid){
				parallelOffsetValue = 0;
			}
			
			//相距x轴差
			var _xDistance:Number = Math.abs(_fromSourceCenterPoint.x-_toSourceCenterPoint.x);
			var _yDistance:Number = Math.abs(_fromSourceCenterPoint.y-_toSourceCenterPoint.y);
			
			//两点(fromNode、toNode)之间的距离
			var distanceValue:Number = Math.sqrt(_xDistance*_xDistance+_yDistance*_yDistance);
			
			//当前link点的fromNode端sin值。
			var sinValue:Number,d:Number,e:Number;
			
			/*****  start Label位置计算 *******/
			var divisorNum:Number;
			if(linkIndex==-1||_linksLen==1)
				divisorNum = .5;
			else 
				divisorNum = (linkIndex)/_linksLen;
			var centerXValue:Number;
			var centerYValue:Number;
			/*****  end Label位置计算 *******/
			
			//X轴值相等
			if(referenceLink.fromNode.x == referenceLink.toNode.x){
				if(referenceLink.fromNode.y > referenceLink.toNode.y){
					fromX = _fromSourceCenterPoint.x+parallelOffsetValue;
					fromY = _fromSourceCenterPoint.y-offset;
					toX = _toSourceCenterPoint.x+parallelOffsetValue;
					toY = _toSourceCenterPoint.y+offset;
					centerYValue = Math.abs(fromY-toY)*divisorNum;
					textFieldY = toY+centerYValue;
				}else{
					fromX = _fromSourceCenterPoint.x+parallelOffsetValue;
					fromY = _fromSourceCenterPoint.y+offset;
					toX = _toSourceCenterPoint.x+parallelOffsetValue;
					toY = _toSourceCenterPoint.y-offset;
					centerYValue = Math.abs(fromY-toY)*divisorNum;
					textFieldY = fromY+centerYValue;
				}
				textFieldX = fromX;
//				labelMathTan = 1.633;
				return;
			}
			//Y轴值相等
			else if(referenceLink.fromNode.y == referenceLink.toNode.y){
				if(referenceLink.fromNode.x > referenceLink.toNode.x){
					fromX = _fromSourceCenterPoint.x-offset;
					fromY = _fromSourceCenterPoint.y+parallelOffsetValue;
					toX = _toSourceCenterPoint.x+offset;
					toY = _toSourceCenterPoint.y+parallelOffsetValue;
					centerXValue = Math.abs(fromX-toX)*divisorNum;
					textFieldX = toX+centerXValue;
				}else{
					fromX = _fromSourceCenterPoint.x+offset;
					fromY = _fromSourceCenterPoint.y+parallelOffsetValue;
					toX = _toSourceCenterPoint.x-offset;
					toY = _toSourceCenterPoint.y+parallelOffsetValue;
					centerXValue = Math.abs(fromX-toX)*divisorNum;
					textFieldX = fromX+centerXValue;
				}
				textFieldY = fromY;
				labelMathTan = 0;
				return;	
			}
			//X轴偏移量
			var offsetXValue:Number = 0;
			//Y轴偏移量
			var offsetYValue:Number = 0;
			
			/*
			 * 相对二者的中心点来说，fromNode处于第三象限，toNode处于第一象限.
			 * 默认fromNode的第一个Link从 左上角起。
			 * 
			 * 
			 *                              (toNode)
			 * 
			 * 
			 *     (fromNode) 
			 */
			if(referenceLink.fromNode.x < referenceLink.toNode.x&&referenceLink.fromNode.y > referenceLink.toNode.y){
				//取Y轴距离
				sinValue = _yDistance/distanceValue;
				d = Math.abs(sinValue*parallelOffsetValue);
				e = Math.sqrt(parallelOffsetValue*parallelOffsetValue-d*d);
				
				offsetYValue = sinValue*offset;
				offsetXValue = Math.sqrt(offset*offset-offsetYValue*offsetYValue);
				if(isLeft){
					fromX = _fromSourceCenterPoint.x-d+offsetXValue;
					fromY = _fromSourceCenterPoint.y-e-offsetYValue;
					toX = _toSourceCenterPoint.x-d-offsetXValue;
					toY = _toSourceCenterPoint.y-e+offsetYValue;
				}else{
					fromX = _fromSourceCenterPoint.x+d+offsetXValue;
					fromY = _fromSourceCenterPoint.y+e-offsetYValue;
					toX = _toSourceCenterPoint.x+d-offsetXValue;
					toY = _toSourceCenterPoint.y+e+offsetYValue;
				}
				
				centerXValue = Math.abs(fromX-toX)*divisorNum;
				centerYValue = Math.abs(fromY-toY)*divisorNum;
				textFieldX = fromX+centerXValue;
				textFieldY = fromY-centerYValue;
				
//				labelMathTan = -_yDistance/_xDistance;
				return;	
			}
			/*
			 * 相对二者的中心点来说，fromNode处于第二象限，toNode处于第四象限.
			 * 默认fromNode的第一个Link从 右上角起。
			 * 
			 *     (fromNode) 
			 *                              
			 * 
			 * 
			 *                              (toNode)
			 */
			else if(referenceLink.fromNode.x < referenceLink.toNode.x&&referenceLink.fromNode.y < referenceLink.toNode.y){
				//取X轴距离
				sinValue = _xDistance/distanceValue;
				d = Math.abs(sinValue*parallelOffsetValue);
				e = Math.sqrt(parallelOffsetValue*parallelOffsetValue-d*d);
				
				offsetXValue = sinValue*offset;
				offsetYValue = Math.sqrt(offset*offset-offsetXValue*offsetXValue);
				if(isLeft){
					fromX = _fromSourceCenterPoint.x+e+offsetXValue;
					fromY = _fromSourceCenterPoint.y-d+offsetYValue;
					toX = _toSourceCenterPoint.x+e-offsetXValue;
					toY = _toSourceCenterPoint.y-d-offsetYValue;
				}else{
					fromX = _fromSourceCenterPoint.x-e+offsetXValue;
					fromY = _fromSourceCenterPoint.y+d+offsetYValue;
					toX = _toSourceCenterPoint.x-e-offsetXValue;
					toY = _toSourceCenterPoint.y+d-offsetYValue;
				}
				
				centerXValue = Math.abs(fromX-toX)*divisorNum;
				centerYValue = Math.abs(fromY-toY)*divisorNum;
				textFieldX = fromX+centerXValue;
				textFieldY = fromY+centerYValue;
//				labelMathTan = _yDistance/_xDistance;
				return;	
			}
			/*
			 * 相对二者的中心点来说，fromNode处于第一象限，toNode处于第三象限.
			 * 默认fromNode的第一个Link从 右上角起。
			 * 
			 *                              (fromNode) 
			 *                              
			 * 
			 * 
			 *     (toNode)
			 */
			else if(referenceLink.fromNode.x > referenceLink.toNode.x&&referenceLink.fromNode.y < referenceLink.toNode.y){
				//取Y轴距离
				sinValue = _yDistance/distanceValue;
				d = Math.abs(sinValue*parallelOffsetValue);
				e = Math.sqrt(parallelOffsetValue*parallelOffsetValue-d*d);
				
				offsetYValue = sinValue*offset;
				offsetXValue = Math.sqrt(offset*offset-offsetYValue*offsetYValue);
				if(isLeft){
					fromX = _fromSourceCenterPoint.x+d-offsetXValue;
					fromY = _fromSourceCenterPoint.y+e+offsetYValue;
					toX = _toSourceCenterPoint.x+d+offsetXValue;
					toY = _toSourceCenterPoint.y+e-offsetYValue;
				}else{
					fromX = _fromSourceCenterPoint.x-d-offsetXValue;
					fromY = _fromSourceCenterPoint.y-e+offsetYValue;
					toX = _toSourceCenterPoint.x-d+offsetXValue;
					toY = _toSourceCenterPoint.y-e-offsetYValue;
				}
				
				centerXValue = Math.abs(fromX-toX)*divisorNum;
				centerYValue = Math.abs(fromY-toY)*divisorNum;
				textFieldX = fromX-centerXValue;
				textFieldY = fromY+centerYValue;
//				labelMathTan = -_yDistance/_xDistance;
				return;	
			}
			/*
			 * 相对二者的中心点来说，fromNode处于第四象限，toNode处于第二象限.
			 * 默认fromNode的第一个Link从 左下角起。
			 * 
			 *     (toNode) 
			 *                              
			 * 
			 * 
			 *                              (fromNode)
			 */
			else if(referenceLink.fromNode.x > referenceLink.toNode.x&&referenceLink.fromNode.y > referenceLink.toNode.y){
				//取X轴距离
				sinValue = _xDistance/distanceValue;
				d = Math.abs(sinValue*parallelOffsetValue);
				e = Math.sqrt(parallelOffsetValue*parallelOffsetValue-d*d);
				
				offsetXValue = sinValue*offset;
				offsetYValue = Math.sqrt(offset*offset-offsetXValue*offsetXValue);
				if(isLeft){
					fromX = _fromSourceCenterPoint.x-e-offsetXValue;
					fromY = _fromSourceCenterPoint.y+d-offsetYValue;
					toX = _toSourceCenterPoint.x-e+offsetXValue;
					toY = _toSourceCenterPoint.y+d+offsetYValue;
				}else{
					fromX = _fromSourceCenterPoint.x+e-offsetXValue;
					fromY = _fromSourceCenterPoint.y-d-offsetYValue;
					toX = _toSourceCenterPoint.x+e+offsetXValue;
					toY = _toSourceCenterPoint.y-d+offsetYValue;
				}
				centerXValue = Math.abs(fromX-toX)*divisorNum;
				centerYValue = Math.abs(fromY-toY)*divisorNum;
				textFieldX = fromX-centerXValue;
				textFieldY = fromY-centerYValue;
//				labelMathTan = _yDistance/_xDistance;
				return;	
			}
			
		}
		
		/**
		 * 是否在起始(或终点)中心点的左侧显示，作为x、y轴的增加还是减少的值。
		 */
		private var isLeft:Boolean = false;
		private var isMid:Boolean = false;
		
		/**
		 * 当前link属于links集合中的下标，用于link label的位置划分。
		 */
		public var linkIndex:int = -1;
		/**
		 * 计算同属同一段(fromNode一段或toNode一段)的各个Link之间(一对Node之间多个Link)属于当前Link和右侧的Link间隔和。 <br>
		 * LINK_BUNDLE_GAP属性只作为和右侧Node之间的间隔使用。这样的话，最右侧的Node不需要计算LINK_BUNDLE_GAP值。<br>
		 * 为了避免Node移动时监听的顺序问题，这样每个Link都单独计算一次间隔总和。
		 * @return int 返回link与左侧link直接的间隔。
		 */
		private function getParallelOffset():int{
			/**
			 * 供parallelValue相减的对比值。
			 */
			var comparativeValue:Number = 0;
			var parallelValue:Number = 0;//所有link的总宽
			var find:Boolean = false;
			isMid = false;
			isLeft = false;
			for(var i:int=0;i<_linksLen;i++){
				var ln:Link = _links[i];
				var linkBundleGap:Number = ln.getStyle(Styles.LINK_BUNDLE_GAP);
				if(ln==link){
					find = true;
					linkIndex = i;
					if((i+1)<=_linksLen/2)
						isLeft = true;
					if(((i+1)>_linksLen/2)&&
						((i+.5)==_linksLen/2))
						isMid = true;
				}
				
				var linkThickness:Number = ln.getStyle(Styles.LINK_WIDTH); 
				if(!find)
					comparativeValue+=(linkBundleGap+linkThickness);
				
				//最后一个不添加Gap
				if(i+1==_linksLen)
					parallelValue+=linkThickness;
				else
					parallelValue+=(linkBundleGap+linkThickness);
				
				
			}
			//总宽的一半减去对比值，等于当前link相对于fromNode中心点的偏移长度.
			return parallelValue/2-comparativeValue;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  鼠标点击动态创建link
		//
		//--------------------------------------------------------------------------
		/**
		 * 动态创建
		 */
		public function updateCreateLinkProperties():void{
			isCreateLinkProperties = true;
			updateProperties();
			var _node:Node = Node(element);
			fromX =  _node.centerLocation.x;
			fromY =  _node.centerLocation.y;
		}
		
		//--------------------------------------------------------------------------
		//
		//  绘制不同风格的Link外观
		//
		//--------------------------------------------------------------------------
		private var centerX:Number;
		private var centerY:Number;
		
		/**
		 * 开始绘制节点的连接。调用此方法需保证已经设置了fromX、fromY、toX、toY这4个坐标值。
		 */
		public function drawLink(g:Graphics):void{
			if(commands.length>0)
				commands.splice(0,commands.length);
			if(data.length>0)
				data.splice(0,data.length);
			var nodeXDistance:Number = Math.abs(fromX-toX)/2;
			var nodeYDistance:Number = Math.abs(fromY-toY)/2;
			centerX = fromX>toX?
				fromX-nodeXDistance:toX-nodeXDistance;
			centerY = fromY>toY?
				fromY-nodeYDistance:toY-nodeYDistance;
			
			switch(linkType){
				case "":
					drawParallelLine(g);
				case Consts.LINK_TYPE_PARALLEL:
					drawParallelLine(g);
					break;
				case Consts.LINK_TYPE_ORTHOGONAL:
					drawOrthogonalLine(g);
					break;
			}
		}
		
		//--------------------------------------------------------------------------
		//  根据LINK_PATTERN值，选择画普通虚线还是普通实线。
		//--------------------------------------------------------------------------
		/**
		 * 直线
		 */
		private function drawParallelLine(g:Graphics):void{
			/* 画虚线 */
			if(isDashedLine){
				LinkAttachment.dashLineToPattern(fromX,fromY,toX,toY,g,[dashedLineLength,dashedLineSpacing]);
				return;
			}
			
			/* 普通线 */
			g.moveTo(fromX,fromY);
			g.lineTo(toX,toY);
		}
		
		/**
		 * 画link连接的虚线
		 * @param x1 起始x
		 * @param y1 起始y
		 * @param x2 终止x
		 * @param y2 终止y
		 */
		public static function dashLineToPattern(x1:Number, y1:Number,x2:Number, y2:Number,g:Graphics,pattern:Array):void
		{
			
			var x:Number = x2 - x1;
			var y:Number = y2 - y1;
			var hyp:Number = Math.sqrt((x)*(x) + (y)*(y));
			
			var units:Number = hyp/(pattern[0]+pattern[1]);
			var dashSpaceRatio:Number = pattern[0]/(pattern[0]+pattern[1]);
			
			var dashX:Number = (x/units)*dashSpaceRatio;
			var spaceX:Number = (x/units)-dashX;
			var dashY:Number = (y/units)*dashSpaceRatio;
			var spaceY:Number = (y/units)-dashY;
			
			g.moveTo(x1, y1);
			
			while (hyp > 0)
			{
				x1 += dashX;
				y1 += dashY;
				hyp -= pattern[0];
				if (hyp < 0)
				{
					x1 = x2;
					y1 = y2;
				}
				
				g.lineTo(x1, y1);
				x1 += spaceX;
				y1 += spaceY;
				g.moveTo(x1, y1);
				hyp -= pattern[1];
			}
			
			g.moveTo(x2, y2);
		} 
		//--------------------------------------------------------------------------
		//  直角线  分水平和垂直方向
		//--------------------------------------------------------------------------
		/* 画箭头的本地变量 直角线专用 */
		mx_internal var centerX_loc:Number;
		mx_internal var centerY_loc:Number;
		mx_internal var fromX_loc:Number;
		mx_internal var fromY_loc:Number;
		/**
		 * 正交线。
		 * 起点的Y值大于终点的Y值 <br>
		 * 显示： <br>
		 *   &nbsp;&nbsp;isHorizontal=false时  (设起点坐标:x:100,y:100 终点坐标:x 200,y:200) <br>
		 *   &nbsp;&nbsp;起点-->下->左(起点X小于终点X)(或右,起点X大于终点X)->下-->终点 的直角连线
		 * <br><br>
		 *   &nbsp;&nbsp;isHorizontal=true时 (设起点坐标:x:100,y:100 终点坐标:x 200,y:200) <br>
		 *   &nbsp;&nbsp;起点-->右(起点X小于终点X)(或左,起点X大于终点X)-->下-->右-->终点 的直角连线 <br>
		 **/
		private function drawOrthogonalLine(g:Graphics):void{
			/* 水平距离 */
			var horizontalDistance:Number = Math.abs(fromX-toX);
			/* 垂直距离 */
			var verticalDistance:Number = Math.abs(fromY-toY);
			/* 
			 * 是否为水平直角(从起点开始，先画水平直线) 
			 * 默认宽高比为1.5
			 */
			var isHorizontal:Boolean = (horizontalDistance/verticalDistance)>orthogonalDistanceRatio;
			
			var corner:Number = horizontalDistance<orthogonalCorner?
									horizontalDistance:verticalDistance<orthogonalCorner?
										verticalDistance:orthogonalCorner;
			
			commands.push(GraphicsPathCommand.MOVE_TO);
			commands.push(GraphicsPathCommand.LINE_TO);
			commands.push(GraphicsPathCommand.CURVE_TO);
			commands.push(GraphicsPathCommand.LINE_TO);
			commands.push(GraphicsPathCommand.CURVE_TO);
			commands.push(GraphicsPathCommand.LINE_TO);
			
			if(fromY<toY){
				if(isHorizontal){
					doHorizontalOrthogonal(g,centerX,centerY,corner/2,fromX,fromY,toX,toY);
					if(showArrow){
						/* 画箭头 */
						fromX_loc = fromX>toX?
							centerX-corner/2:centerX+corner/2;
						fromY_loc = toY;
					}
				}
				else{
					doVerticalOrthogonal(g,centerX,centerY,corner/2,fromX,fromY,toX,toY);
					if(showArrow){
						/* 画箭头 */
						fromX_loc = toX;
						fromY_loc = centerY+corner/2;
					}
				}
			}
			else{
				if(isHorizontal){
					doHorizontalOrthogonal(g,centerX,centerY,corner/2,fromX,fromY,toX,toY);
					if(showArrow){
						/* 画箭头 */
						fromX_loc = fromX>toX?
							centerX-corner/2:centerX+corner/2
						fromY_loc = toY;
					}
				}
				else{
					doVerticalOrthogonal(g,centerX,centerY,corner/2,toX,toY,fromX,fromY);
					if(showArrow){
						/* 画箭头 */
						fromX_loc = toX;
						fromY_loc = centerY-corner/2;
					}
				}
			}
			
			
			g.drawPath(commands,data);
		}
		/**
		 * isHorizontal=false时<br>  (设起点坐标:x:100,y:100 终点坐标:x 200,y:200)
		 * 起点-->下->左(起点X小于终点X)(或右,起点X大于终点X)->下-->终点 的直角连线
		 */
		private function doHorizontalOrthogonal(g:Graphics,centerX:Number,centerY:Number,corner:Number,fromNodeX:Number,fromNodeY:Number,toNodeX:Number,toNodeY:Number):void{
			/* MOVE_TO */
			data.push(fromNodeX,fromNodeY);
			
			/* LINE_TO */
			if(fromNodeX<toNodeX)
				data.push(centerX-corner,fromNodeY);
			else
				data.push(centerX+corner,fromNodeY);
			
			/* CURVE_TO */
			data.push(centerX,fromNodeY);
			
			if(fromNodeX<toNodeX){
				if(fromNodeY<toNodeY){
					/* CURVE_TO */
					data.push(centerX,fromNodeY+corner);
					
					/* LINE_TO */
					data.push(centerX,toNodeY-corner);
				}else{
					/* CURVE_TO */
					data.push(centerX,fromNodeY-corner);
						
					/* LINE_TO */
					data.push(centerX,toNodeY+corner);
				}
			}else{
				if(fromNodeY<toNodeY){
					/* CURVE_TO */
					data.push(centerX,fromNodeY+corner);
					
					/* LINE_TO */
					data.push(centerX,toNodeY-corner);
				}else{
					/* CURVE_TO */
					data.push(centerX,fromNodeY-corner);
					
					/* LINE_TO */
					data.push(centerX,toNodeY+corner);
				}
			}
			
			/* CURVE_TO */
			data.push(centerX,toNodeY);
			
			/* CURVE_TO */
			if(fromNodeX<toNodeX)
				data.push(centerX+corner,toNodeY);
			else
				data.push(centerX-corner,toNodeY);
			
			/* LINE_TO */
			data.push(toNodeX,toNodeY);
		}
		/**
		 * isHorizontal=true时<br> (设起点坐标:x:100,y:100 终点坐标:x 200,y:200)
		 * 起点-->右(起点X小于终点X)(或左,起点X大于终点X)-->下-->右-->终点 的直角连线
		 */
		private function doVerticalOrthogonal(g:Graphics,centerX:Number,centerY:Number,corner:Number,fromNodeX:Number,fromNodeY:Number,toNodeX:Number,toNodeY:Number):void{
			/* MOVE_TO */
			data.push(fromNodeX,fromNodeY);
			
			/* LINE_TO */
			data.push(fromNodeX,centerY-corner);
			
			/* CURVE_TO */
			data.push(fromNodeX,centerY);
			if(fromNodeX<toNodeX){
				/* CURVE_TO */
				data.push(fromNodeX+corner,centerY);
				
				/* LINE_TO */
				data.push(toNodeX-corner,centerY);
				
			}else{
				/* CURVE_TO */
				data.push(fromNodeX-corner,centerY);
				
				/* LINE_TO */
				data.push(toNodeX+corner,centerY);
			}
			/* CURVE_TO */
			data.push(toNodeX,centerY);
			/* CURVE_TO */
			data.push(toNodeX,centerY+corner);
			/* LINE_TO */
			data.push(toNodeX,toNodeY);
		}
		
		
		/**
		 * drawArrow
		 */
		public function drawArrow(g:Graphics,fromX:Number,fromY:Number,toX:Number,toY:Number,arrowSize:Number,arrowColor:uint):void{
			var nodeXDistance:Number = Math.abs(fromX-toX)/2;
			var nodeYDistance:Number = Math.abs(fromY-toY)/2;
			
			var temX:Number = toX - fromX;
			var temY:Number = fromY - toY;
			/**
			 * 得到线的角度
			 */
			var angle:Number  = Math.atan2(temY,temX)*(180/Math.PI);
			
			var centerX:Number = toX - arrowSize * Math.cos(angle*(Math.PI/180));
			var centerY:Number = toY + arrowSize * Math.sin(angle*(Math.PI/180));
			
			var leftX:Number = centerX + arrowSize * Math.cos((angle+120)*(Math.PI/180));
			var leftY:Number = centerY - arrowSize * Math.sin((angle+120)*(Math.PI/180));
			var rightX:Number = centerX + arrowSize * Math.cos((angle+240)*(Math.PI/180));
			var rightY:Number = centerY - arrowSize * Math.sin((angle+240)*(Math.PI/180)); 
			g.beginFill(arrowColor,1);
			
			g.moveTo(toX,toY);
			
			g.lineTo(leftX,leftY);
			g.lineTo(centerX,centerY);
			
			g.lineTo(rightX,rightY);
			g.lineTo(toX,toY);
			
			g.endFill(); 
		}
	}
}