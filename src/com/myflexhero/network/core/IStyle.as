package com.myflexhero.network.core
{
	import mx.collections.ArrayCollection;
	
	public interface IStyle
	{
		
		public function IStyle();
		
		function getStyle(styleProp:String, returnDefaultIfNull:Boolean = true):*;
		
		function setStyle(property:String, newValue:*) : void;
		
		function get styleProperties() : ArrayCollection;
		
	}
}