package com.myflexhero.network
{
	/**
	 * [目前告警未完成]继承自DataBox数据容器基类,作为单一的数据容器，仅存储Alarm类型的数据元素。
	 * @see com.myflexhero.network.DataBox
	 * @see com.myflexhero.network.ElementBox
	 * @see com.myflexhero.network.LinkBox
	 * @author Hedy
	 */
	public class AlarmBox extends DataBox
	{
		private var _elementBox:ElementBox;
		public function AlarmBox(elementBox:ElementBox)
		{
			if (elementBox == null)
			{
				throw new Error("elementBox不能为空.");
			}
			this._elementBox = elementBox;
//			this.addDataBoxChangeListener(K19K, Consts.PRIORITY_ABOVE_NORMAL);
//			this.addDataPropertyChangeListener(K23K, Consts.PRIORITY_ABOVE_NORMAL);
		}
	}
}