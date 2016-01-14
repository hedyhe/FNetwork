package com.myflexhero.network
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import spark.components.Panel;
	import spark.skins.spark.PanelSkin;
	
	
	public class MovablePanel extends Panel
	{
		
		public function MovablePanel(){
			this.setStyle("skinClass",PanelSkin);
			this.setStyle("headerColors", [0xFFFFFF, 0x00FF00]);		
			this.setStyle("backgroundAlpha", 0.5);
		}
		
		override protected function createChildren():void{
			super.createChildren();       
			this.titleDisplay.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			this.titleDisplay.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp); 
		}			          
		
		private function handleMouseDown( evt:MouseEvent ):void
		{
			var limitdrag:Rectangle = new Rectangle(0, 0, this.parent.width-this.width, this.parent.height-this.height);
			this.startDrag(false, limitdrag);
		}	
		
		private function handleMouseUp( evt:MouseEvent ):void
		{
			this.stopDrag();
		}    		
	}
}