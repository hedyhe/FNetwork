package com.myflexhero.network.core
{
	public interface IClient
	{
		
		function IClient();
		
		function getClient(clientProp:String):*;
		
		function setClient(clientProp:String, newValue:*) : void;
		
		function get clientProperties() : Array;
		
	}
}