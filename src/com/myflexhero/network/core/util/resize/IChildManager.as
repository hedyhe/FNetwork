package com.myflexhero.network.core.util.resize
{

	public interface IChildManager
	{
		function addChild( container:Object, child:Object ) : void;
		function removeChild( container:Object, child:Object ) : void;
	}
}