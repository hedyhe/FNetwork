package com.myflexhero.network
{
	import com.myflexhero.network.core.ILayer;

	public class LinkBox extends DataBox
	{
		private var _elementBox:ElementBox;
		private var _layer:ILayer = null;
		public function LinkBox(elementBox:ElementBox)
		{
			super("LinkBox");
			if (elementBox == null)
			{
				throw new Error("elementBox不能为空.");
			}
			this._elementBox = elementBox;
			this._layer = new Layer("default", "default");
//			this.addDataBoxChangeListener(K19K, Consts.PRIORITY_ABOVE_NORMAL);
//			this.addDataPropertyChangeListener(K23K, Consts.PRIORITY_ABOVE_NORMAL);
		}
		
		public function get elementBox() : ElementBox
		{
			return _elementBox;
		}
		
		public function get defaultLayer() : ILayer
		{
			return this._layer;
		}
	}
}