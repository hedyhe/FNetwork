package com.myflexhero.network.core.ui
{
	import com.myflexhero.network.Link;
	import com.myflexhero.network.Node;
	import com.myflexhero.network.Size;
	import com.myflexhero.network.Styles;
	import com.myflexhero.network.core.IElement;
	import com.myflexhero.network.core.util.ElementUtil;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.core.mx_internal;

	use namespace mx_internal;
	public class LabelAttachment extends Attachment
	{
		protected var _textField:TextField;
		protected var _splitValue:int;
		public var labelChanged:Boolean = true;
		public var selected:Boolean = false;
		public function LabelAttachment(element:IElement)
		{
			super(element);
			_textField = new TextField();
			this._textField.autoSize = TextFieldAutoSize.CENTER;
			this._textField.mouseEnabled = false;
			content = _textField;
		}
		
		private var oldSelected:Boolean = false;
		override public function updateProperties() : void
		{
			super.updateProperties();
			
			if(labelChanged){
				var _label:String = element.label;
				_label = _label == null ? ("") : (_label);
				if (element.getStyle(Styles.LABEL_HTML))
				{
					_textField.htmlText = _label;
				}
				else
				{
					_textField.text = _label;
				}
				labelChanged = false;
			}
			if(styleChanged||(oldSelected!=selected)){
				_textField.embedFonts = element.getStyle(Styles.LABEL_EMBED);
				var _textFormat:TextFormat = new TextFormat();
				_textFormat.font = element.getStyle(Styles.LABEL_FONT);
				_textFormat.color = selected?element.getStyle(Styles.LABEL_SELECTED_COLOR):element.getStyle(Styles.LABEL_COLOR);
				_textFormat.size = selected?element.getStyle(Styles.LABEL_SIZE)+1:element.getStyle(Styles.LABEL_SIZE);
				_textFormat.italic = element.getStyle(Styles.LABEL_ITALIC);
				_textFormat.bold = selected?true:element.getStyle(Styles.LABEL_BOLD);
				_textFormat.underline = element.getStyle(Styles.LABEL_UNDERLINE);
				_textField.setTextFormat(_textFormat);
				_splitValue = element.getStyle(Styles.LINK_SPLIT_VALUE);
				styleChanged = false;
				oldSelected = selected;
			}
			setLabelPosition();
		}
		
		public var rectangle:Rectangle = new Rectangle();
		public var size:Size = new Size();
		protected function setLabelPosition():void{
			size.width = _textField.width;
			size.height = _textField.height;
			var tfPoint:Point = ElementUtil.getPosition(position,rectangle,size);
			_textField.x = tfPoint.x;
			_textField.y = tfPoint.y;
		}
		
		public function get position() : String
		{
			return element.getStyle(Styles.LABEL_POSITION);
		}
		
		public function clear():void{
			_textField = null;
			content = null;
			element = null;
		}
	}
}