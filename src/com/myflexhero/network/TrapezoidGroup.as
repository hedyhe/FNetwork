package com.myflexhero.network
{
	import com.myflexhero.network.core.ui.QuadrilateralGroupUI;
	
	/**
	 * 画75度的角平行四边形
	 */
	public class TrapezoidGroup extends Group
	{
		public function TrapezoidGroup(id:Object=null)
		{
			super(id);
		}
		override public function get elementUIClass():Class
		{
			return QuadrilateralGroupUI;
		}
	}
}