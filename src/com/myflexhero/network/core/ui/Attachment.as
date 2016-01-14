package com.myflexhero.network.core.ui
{
	import com.myflexhero.network.core.IElement;
	
	import mx.core.UIComponent;

	public class Attachment
	{
		private var _element:IElement = null;
		
		private var _content:*;
		
		public var styleChanged:Boolean = true;
		
		public function Attachment(element:IElement)
		{
			_element = element;
		}
		
		public function set element(value:IElement):void{
			this._element = value;
		}
		
		public function get element() : IElement
		{
			return this._element;
		}
		
		public function get content():*{
			return _content;
		}
		
		public function set content(value:Object):void{
			this._content = value;
		}
		
		/**
		 * 更新视图CSS样式属性
		 */
		public function updateProperties() : void
		{
//			this.filters = _element.filters;
		}
	}
}