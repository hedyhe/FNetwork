package com.myflexhero.network.core.util.resize
{
	import mx.core.IFactory;
	
	/**
	 * A simple factory class for Flex 4 based handles.
	 ***/
	public class Flex4HandleFactory implements IFactory
	{
		public function Flex4HandleFactory()
		{
		}
		
		public function newInstance():*
		{
			return new VisualElementHandle();
		}
	}
}