package com.myflexhero.network
{
	import com.myflexhero.network.core.IElement;
	import com.myflexhero.network.core.ILayer;

	public class LayerBox extends DataBox
	{
		private var _layer:ILayer = null;
		private var _elementBox:ElementBox = null;
		
		public function LayerBox(elementBox:ElementBox)
		{
			this._elementBox = elementBox;
			this._layer = new Layer(Defaults.LAYER_DEFAULT_ID, Defaults.LAYER_DEFAULT_NAME);
			this.add(this._layer);
		}
		
		public function getLayerByElement(element:IElement) : ILayer
		{
			if (element == null)
			{
				return null;
			}
			var layer:* = this.getLayerByID(element.layerID);
			if (layer == null)
			{
				return this._layer;
			}
			return layer;
		}
		
		public function getLayerByID(layerID:Object) : ILayer
		{
			return this.getDataByID(layerID) as ILayer;
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