package com.myflexhero.network.core
{
	import spark.components.Group;

	public interface IDataUI
	{
		/**
		 * 当前UI所属的布局层
		 */
		function get layoutGroup():Group;
		
		function set layoutGroup(value:Group):void;
		
		function get mouseOver():Boolean;
		
		function set mouseOver(value:Boolean):void;
		
		function get mouseOut():Boolean;
		
		function set mouseOut(value:Boolean):void;
		
		function get mouseUp():Boolean;
		
		function set mouseUp(value:Boolean):void;
		
		function get mouseDown():Boolean;
		
		function set mouseDown(value:Boolean):void;
		
		function get isSelected():Boolean;
		
		function set isSelected(value:Boolean):void;
		
		function get labelStyleChanged():Boolean;
		
		function set labelStyleChanged(value:Boolean):void;
	}
}