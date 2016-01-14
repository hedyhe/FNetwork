package com.myflexhero.network
{
	import com.myflexhero.network.core.ui.QuadrilateralGroupUI;

	/**
	 * 画45度的角的梯形平行四边形
	 */
	public class ParallelogramGroup extends Group
	{
		public function ParallelogramGroup(id:Object=null)
		{
			super(id);
		}

		override public function get elementUIClass():Class
		{
			return QuadrilateralGroupUI;
		}
	}
}