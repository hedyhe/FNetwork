package com.myflexhero.network
{

	/**
	 * SubNetwork具有显示多层次关系的能力。<br>
	 * 默认将显示SubNetwork的默认外观，
	 * 当双击该SubNetwork对象且其拥有子类时，
	 * 将显示所有下一级的子类(继续双击子类中属于SubNetwork类型的对象将继续显示下一级)，
	 * 并隐藏与当前SubNetwork类无关联的其他对象。
	 * 
	 * <br><br>数据元素的继承结构如下所示:
	 * <pre>
	 * Data(数据基类)
	 * 	|Element(元素基类)
	 *		|Node(节点类)
	 * 			|Follower(具有跟随功能的类)
	 *				|<b>SubNetwork</b>(具有显示多层次子类关系的类)
	 *				|AbstractPipe(具有内部显示不同形状的抽象类)
	 *					|RoundPipe(圆管,内部可显示父子关系的圆孔)
	 *					|SquarePipe(矩形管道,内部可显示不同大小的矩形)
	 *				|Group(内部作为一个整体，具有统一的边界外观)
	 *				|Grid(网格，可设置任意行、列)
	 *					|KPICard(可表示KPI的网格)
	 *		|Link(链接类，表示节点之类的关系)
	 * </pre>
	 */
    public class SubNetwork extends Follower
    {

        public function SubNetwork(id:Object = null)
        {
            super(id);
            this.icon = Defaults.ICON_SUBNETWORK;
            this.image = Defaults.IMAGE_SUBNETWORK;
            return;
        }
    }
}
