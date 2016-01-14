package com.myflexhero.network.core
{
	public interface IElement extends IData, IStyle
	{
		
		public function IElement();
		
//		function get alarmState() : AlarmState;
		
		function set layerID(layerID:Object) : void;
		
		function get layerID() : Object;
		
//		function isAdjustedToBottom() : Boolean;
		
//		function get elementUIClass() : Class;
		
	}
}