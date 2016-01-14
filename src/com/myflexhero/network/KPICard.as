package com.myflexhero.network
{
	import com.myflexhero.network.core.ui.KPICardUI;

	/**
	 * 可表示KPI的网格，继承自Grid，使用KPICardUI作为外观包装类。
	 * 
	 * <br><br>数据元素的继承结构如下所示:
	 * <pre>
	 * Data(数据基类)
	 * 	|Element(元素基类)
	 *		|Node(节点类)
	 * 			|Follower(具有跟随功能的类)
	 *				|SubNetwork(具有显示多层次子类关系的类)
	 *				|AbstractPipe(具有内部显示不同形状的抽象类)
	 *					|RoundPipe(圆管,内部可显示父子关系的圆孔)
	 *					|SquarePipe(矩形管道,内部可显示不同大小的矩形)
	 *				|Group(内部作为一个整体，具有统一的边界外观)
	 *				|Grid(网格，可设置任意行、列)
	 *					|<b>KPICard</b>(可表示KPI的网格)
	 *		|Link(链接类，表示节点之类的关系)
	 * </pre>
	 */
	public class KPICard extends Grid
	{
		
		public function KPICard(id:Object=null)
		{
			super(id);
		}

		override public function get elementUIClass():Class{
			return KPICardUI;
		}			
	}
}