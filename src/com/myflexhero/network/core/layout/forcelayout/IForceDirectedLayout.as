package com.myflexhero.network.core.layout.forcelayout
{
	import com.myflexhero.network.core.ICustomLayout;
	/**
	 * @author Hedy
	 */
	public interface IForceDirectedLayout extends ICustomLayout
	{
		function set repulsionFactor(factor: Number): void;
		function get repulsionFactor(): Number;
		function set motionThreshold(t: Number): void;
		function get motionThreshold(): Number;
		
	}
}