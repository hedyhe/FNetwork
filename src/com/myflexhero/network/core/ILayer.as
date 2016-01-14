package com.myflexhero.network.core
{
	public interface ILayer extends IData
	{
		
		public function ILayer();
		function get editable() : Boolean;
		
		function set editable(editable:Boolean) : void;
		
		function set movable(movable:Boolean) : void;
		
		function get movable() : Boolean;
	}
}