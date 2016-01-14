package com.myflexhero.network
{
	import com.myflexhero.network.core.ILayer;

	public class Layer extends Data implements ILayer
	{
		private var _movable:Boolean = true;
		private var _editable:Boolean = true;
		
		public function Layer(id:Object, name:String = null)
		{
			super(id);
			this.label = name;
			return;
		}
		
		public function get movable() : Boolean
		{
			return this._movable;
		}
		
		public function set editable(editable:Boolean) : void
		{
			var _loc_2:* = this._editable;
			this._editable = editable;
			this.dispatchPropertyChangeEvent("editable", _loc_2, editable);
			return;
		}
		
		public function get editable() : Boolean
		{
			return this._editable;
		}
		
		public function set movable(movable:Boolean) : void
		{
			var _loc_2:* = this._movable;
			this._movable = movable;
			this.dispatchPropertyChangeEvent("movable", _loc_2, movable);
			return;
		}
	}
}