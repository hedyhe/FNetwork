package com.myflexhero.network
{
	import com.myflexhero.network.core.IDummy;

	/**
	 * 该类仅作为Grid的parent父类属性引用。创建该类并调用elementbox.add方法不会为其创建UI视图类。
	 * @author hedy
	 */
	public class Dummy extends Element implements IDummy
	{
		
		public function Dummy(id:Object = null)
		{
			super(id);
			return;
		}
	}
}

