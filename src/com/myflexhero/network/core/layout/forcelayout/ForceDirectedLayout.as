

package com.myflexhero.network.core.layout.forcelayout{

import avmplus.USE_ITRAITS;

import com.myflexhero.network.Link;
import com.myflexhero.network.Node;
import com.myflexhero.network.core.layout.forcelayout.IForEachNode;

import flash.utils.getTimer;

import mx.core.mx_internal;

use namespace mx_internal; 

/**
 * 弹簧布局,目前还不是十分完善(目前的节点上下级围成的圈看起来不是很圆,包括速率的问题).
 * @author Hedy<br>
 * 550561954#qq.com 
 */
public class ForceDirectedLayout implements IForEachEdge,IForEachNode,IForEachNodePair /*implements Runnable */ {

    public var damper: Number=0.0;     
    public var maxMotion: Number=0;    
    public var lastMaxMotion: Number=0;
    public var motionRatio: Number = 0; // 动作调整值,结果=lastMaxMotion/maxMotion-1
    public var damping: Boolean = true; //当damping=true, the damper值减少
	/**
	 * 最初默认为0.25
	 */
    public var rigidity: Number = 0.4;    // 晃动因子，越大结果越早呈现，但效果和精确度也越低。Rigidity 和damper有同样的功能。
    public var newRigidity: Number =  0.4;
	public var dataProvider: IDataProvider;
    public var dragNode: Node=null;
	public var maxMotionA: Array;

	/** 
	 * Constructor
    */
    public function ForceDirectedLayout( dataProvider: IDataProvider): void {
    	this.dataProvider = dataProvider;
    }

    public function setRigidity(r: Number): void {
        newRigidity = r;  //在relax()方法每次线程结束后对rigidity进行更新。
    }

    public function setDragNode(n: Node): void {
        dragNode = n;
    }

    //舒展连接(link)
    private function relaxEdges(): void {
         dataProvider.forAllEdges(this);
    }

    private function avoidLabels(): void {
         dataProvider.forAllNodePairs(this);
    }

    public function startDamper(): void {
        damping = true;
    }

    public function stopDamper(): void {
        damping = false;
        damper = 1.0;     //1.0 意味着进行调整
    }

    public function resetDamper(): void {  //reset amper, 但是并不保持调整
        damping = true;
        damper = 1.0;
//		maxMotion = 1.5; 
    }

    public function stopMotion(): void {  // 稳定界面上的节点 ，将damper设置到一个更低的值
        damping = true;
        if (damper>0.3) 
            damper = 0.3;
        else
            damper = 0;
    }

	/* 位置调整约束值，越低调整的时间越久,位置也越精确,默认值为0.3 */
	public static var motionLimit: Number = 0.4;
	
    public function damp(): void {
        if (damping) {
            if(motionRatio<=0.001) {  //这个很重要，当图表开始呈现时会较快的移动.
                //如果 max motion<0.2, 总是调整
                //如果此时damper 的值下降到 0.9, 且maxMotion is still>1,总是进行调整
                //damper任何时候都不能为负数
                if ((maxMotion<0.2 || (maxMotion>1 && damper<0.9)) && damper > 0.01) damper -= 0.01;
                //稍微强烈的调整
                else if (maxMotion<0.4 && damper > 0.003) damper -= 0.003;
                //如果max motion过高, 且刚刚开始调整,则进行轻微的调整
                else if(damper>0.0001) damper -=0.0001;
            }
        }
        if(maxMotion<motionLimit && damping) {
            damper=0;
        }
    }
	
    private function moveNodes(): void {
        lastMaxMotion = maxMotion;
        maxMotionA = new Array(); /* of Number */;
        maxMotionA[0]=0;

        dataProvider.forAllNodes(this);

        maxMotion=maxMotionA[0];
         if (maxMotion>0) motionRatio = lastMaxMotion/maxMotion-1; //减1加快移动
         else motionRatio = 0;                                     

        damp();
    }
	
	public var autoLayout:Boolean= false;
    private function relax(): void {
//		var startTime: int = getTimer();
//		trace("relax...");
    	dataProvider.forAllNodes(new Refresher());
		/* 设置为5则意味着一次timer运行时计算5次布局,也可以设置为1,界面将显示更及时。 */
        for (var i: int=0;i<5;i++) {
			//var startTime: int = getTimer();
			relaxEdges();
 			//var endTime: int = getTimer();
			//trace("relaxEdges: " + String(endTime - startTime) + " ms");
			
			//startTime = getTimer();
			avoidLabels();
			//endTime = getTimer();
			//trace("avoidLabels: " + String(endTime - startTime) + " ms");
			
			//startTime = getTimer();
			moveNodes();
			//endTime = getTimer();
			//trace("avoidLabels: " + String(endTime - startTime) + " ms");
        }
        if(rigidity!=newRigidity) rigidity= newRigidity; //update rigidity
		
		/* 注释掉 */
        //dataProvider.forAllNodes(new Committer());
// 		var endTime: int = getTimer();
//		trace("relax: " + String(endTime - startTime) + " ms");
	}

	public var adjusted:Boolean = false;
	public function tick(): void {
		if (!(damper<0.1 && damping && maxMotion<motionLimit)) {
//			var startTime: int = getTimer();
			relax();
//			var endTime:int = getTimer();
//			trace("tick done: " + String(endTime - startTime) + " ms");
		} else {
		   	//trace("don't relax");
			adjusted = true;
		}
	}
    
	public function forEachEdge(e: Link): void {
	    var vx: Number = e.toNode.x - e.fromNode.x;
	    var vy: Number = e.toNode.y - e.fromNode.y;
	    var len: Number = Math.sqrt(vx * vx + vy * vy);
	
	    var dx: Number=vx*rigidity;  //rigidity使节点连接(link)保持紧密
		if(isNaN(dx)) {
			dx = dx;
		}
	    var dy: Number=vy*rigidity;
		if(isNaN(dy)) {
			dy = dy;
		}
	
	    dx /=(e.getLength()*100);
		if(isNaN(dx)) {
			dx = dx;
		}
		var length: int = e.getLength();
		var div: int = length * 100;
	    var ddy: Number = dy;
		dy = dy / div;
	    ddy /=(e.getLength()*100);
		if(isNaN(dy)) {
			dy = dy;
		}
	
	    //连接(link)在各个节点中展示均匀，且保持弹性。
	    //if (e.getTo().justMadeLocal || !e.getFrom().justMadeLocal) { 总为true，因为justMadeLocal一直是false
	        e.toNode.dx = e.toNode.dx - dx*len;
	        e.toNode.dy = e.toNode.dy - dy*len;
	    //} else {
	    //    e.getTo().dx = e.getTo().dx - dx*len/10;
	    //    e.getTo().dy = e.getTo().dy - dy*len/10;
	    //}
	    //if (e.getFrom().justMadeLocal || !e.getTo().justMadeLocal) { // ditto
	        e.fromNode.dx = e.fromNode.dx + dx*len;
	        e.fromNode.dy = e.fromNode.dy + dy*len;
	    //} else {
	    //    e.getFrom().dx = e.getFrom().dx + dx*len/10;
	    //    e.getFrom().dy = e.getFrom().dy + dy*len/10;
	    //}
	}

	 public function forEachNode(n: Node): void {
	    var dx: Number = n.dx;
	    var dy: Number = n.dy;
	    dx*=damper;  //该damper值减慢速度，并在最后停止抖动。
	    dy*=damper; 
	               
	
	    n.dx = dx/2;   //减速，但是并不使其停止。在节点中保存动力，当节点过低时进行强迫调整。
	    n.dy = dy/2;   
	
	    var distMoved: Number = Math.sqrt(dx*dx+dy*dy); //节点实际移动了多少?
	
	     if (!n.fixed && !(n==dragNode)&&!n.isMouseDown ) {
	        n.x = n.x + Math.max(-30, Math.min(30, dx)); //每次移动距离不超过30
	        n.y = n.y + Math.max(-30, Math.min(30, dy)); //忘了这里是否重要，当节点距离过远时停止分开
	     }
	     maxMotionA[0]=Math.max(distMoved,maxMotionA[0]);
	}
	
	public function forEachNodePair(n1: Node, n2: Node): void {
		//trace(Object(n1).item.id + "," + String(n1.x) + "," + String(n1.y) + " ... " + Object(n2).item.id + "," + String(n2.x) + "," + String(n2.y));
	    var dx: Number=0;
	    var dy: Number=0;
	    var vx: Number = n1.x - n2.x;
	    var vy: Number = n1.y - n2.y;
	    var len: Number = vx * vx + vy * vy; //so it's length squared
	    if (len == 0) {
	        dx = Math.random(); //如果2个节点都在各自的右上角，进行随机分割
	        dy = Math.random();
	    } else if (len < 98000) { //默认是600*600, 这里设置的是节点的分开距离。不是很准确的计算，是节点的宽高比。
	        dx = vx / len;  // 如果对len取平方根，则会让节点们看起来更像一个圆形。
	        dy = vy / len;  // 这样设置刚刚开始可能看起来不错，不过并不保证后面的调整会打乱它。
	    }
	
	    var repSum: Number = n1.repulsion * n2.repulsion/100;
	    var factor: Number = repSum*rigidity;
	
	    //if(n1.justMadeLocal || !n2.justMadeLocal) { always true, because justMadeLocal is always false
	        n1.dx += dx*factor;
	        n1.dy += dy*factor;
	    //}
	    //else {
	    //    n1.dx = n1.dx + dx*repSum*rigidity/10;
	    //    n1.dy = n1.dy + dy*repSum*rigidity/10;
	    //}
	    //if (n2.justMadeLocal || !n1.justMadeLocal) { always true, because justMadeLocal is always false
	        n2.dx -= dx*factor;
	        n2.dy -= dy*factor;
	    //}
	    //else {
	    //    n2.dx = n2.dx - dx*repSum*rigidity/10;
	    //    n2.dy = n2.dy - dy*repSum*rigidity/10;
	    //}
	}
	}
}
import com.myflexhero.network.Node;
import com.myflexhero.network.core.layout.forcelayout.IForEachNode;

import mx.core.mx_internal;

use namespace mx_internal;
class Refresher implements IForEachNode {
	 public function forEachNode( n: Node ): void {
	 	n.refresh();
	 }
}

//这里暂时注释掉使用,因为x、y值已经提交了，通过SpringLayout中每次timer调用完毕后进行批量提交更新视图。
//class Committer implements IForEachNode {
//	 public function forEachNode( n: Node ): void {
//	 	n.commit();
//	 }
//}
