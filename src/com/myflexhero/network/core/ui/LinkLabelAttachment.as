package com.myflexhero.network.core.ui
{
	import com.myflexhero.network.Link;
	import com.myflexhero.network.core.IElement;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.text.TextField;

	public class LinkLabelAttachment extends LabelAttachment
	{
		private var linkAttachment:LinkAttachment;
		public function LinkLabelAttachment(element:IElement,linkAttachment:LinkAttachment)
		{
			super(element);
			this.linkAttachment = linkAttachment;
//			bmp = new Bitmap(null,"auto",true);
		}
		
//		public var bmp:Bitmap;
//		private var myBitmapData:BitmapData;
		override protected function setLabelPosition():void{
			var link:Link = element as Link;
			if(!linkAttachment||!(link.fromNode&&link.toNode))
				return;
			
//			var divisorNum:Number;
//			if(linkAttachment.linkIndex==-1||linkAttachment._linksLen==1)
//				divisorNum = .5;
//			else 
//				divisorNum = (linkAttachment.linkIndex)/linkAttachment._linksLen;
//			var centerXValue:Number = Math.abs(linkAttachment.fromX-linkAttachment.toX)*divisorNum;
//			var centerYValue:Number = Math.abs(linkAttachment.fromY-linkAttachment.toY)*divisorNum;
//			var textFieldX:Number = linkAttachment.fromX>linkAttachment.toX?
//				linkAttachment.toX+centerXValue:
//				linkAttachment.fromX+centerXValue;
//			
//			var  textFieldY:Number = linkAttachment.fromY>linkAttachment.toY?
//				linkAttachment.toY+centerYValue:
//				linkAttachment.fromY+centerYValue;
			
			var xValue:Number = linkAttachment.textFieldX - _textField.width/2;
			var yValue:Number = linkAttachment.textFieldY - _textField.height/2;
			
			_textField.x = xValue;
			_textField.y = yValue;
			
//			
//			if(myBitmapData==null){
//				myBitmapData = new BitmapData(_textField.width, _textField.height,true,0);  
//				myBitmapData.draw(_textField,null,null,null,null,true);  
//				if(bmp.bitmapData==null)
//					bmp.bitmapData = myBitmapData;  
//			}
//			bmp.x = textFieldX;  
//			bmp.y = textFieldY;  
//			bmp.rotation = Math.atan(linkAttachment.labelMathTan)*180/Math.PI;
			
//			trace("linkAttachment.labelMathTan:"+linkAttachment.labelMathTan+",atan:"+Math.atan(linkAttachment.labelMathTan)+",*180:"+Math.atan(linkAttachment.labelMathTan)*180+",result:"+Math.atan(linkAttachment.labelMathTan)*180/Math.PI)
//			if(linkAttachment._linksLen>1){
//				for(var i:int=0;i<linkAttachment._linksLen;i++){
//					var ln:Link = linkAttachment._links[i];
//					var elementUI:LinkUI = linkAttachment.network.getElementUI(ln);
//					//是否相交
//					if(_textField.hitTestObject(elementUI.linkAttachment.content)){
//						
//					}
//					
//				}
//			}
		}
		override public function clear():void{
			super.clear();
//			if(myBitmapData){
//				myBitmapData.dispose();
//				myBitmapData = null;
//			}
//			if(bmp)
//				bmp.bitmapData = null;
		}
	}
}