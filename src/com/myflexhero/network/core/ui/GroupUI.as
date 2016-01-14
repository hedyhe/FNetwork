package com.myflexhero.network.core.ui
{
    import com.myflexhero.network.Consts;
    import com.myflexhero.network.Group;
    import com.myflexhero.network.Network;
    import com.myflexhero.network.Node;
    import com.myflexhero.network.Styles;
    import com.myflexhero.network.core.IData;
    import com.myflexhero.network.core.IElement;
    import com.myflexhero.network.core.IElementUI;
    import com.myflexhero.network.core.ui.NodeUI;
    import com.myflexhero.network.core.util.ElementUtil;
    import com.myflexhero.network.core.util.GraphicDrawHelper;
    import com.myflexhero.network.event.ElementPropertyChangeEvent;
    
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.setTimeout;
    
	/**
	 * Group组件的UI类。
	 * 
	 * @author Hedy
	 * @see com.myflexhero.network.Group
	 */
    public class GroupUI extends NodeUI
    {
        private var _rectangle:Rectangle = null;

        public function GroupUI(network:Network, group:IData)
        {
            super(network, group);
            return;
        }
		
		/**
		 * 设置UI类对应的唯一数据类Group，并监听Group所有内部子类的属性变化。
		 */
		override public function setElement(value:IData ) : void
		{	
			super.setElement(value);
			if(element)
				element.addEventListener(Consts.EVENT_DATA_PROPERTY_CHANGE, onPropertyChange );
			var _child:*;
			var _index:int;
			while (_index < value.numChildren)
			{
				
				_child = value.children[_index];
				if(_child)
					_child.addEventListener(Consts.EVENT_DATA_PROPERTY_CHANGE, onChildPropertyChange);
				_index = _index + 1;
			}
		}
		
		/**
		 * 通过重载bodyRect方法获取内部子类的最大、最小边界信息。
		 */
		override public function get bodyRect() : Rectangle
		{
			return createBodyRect();
		}
		
        protected function createBodyRect() : Rectangle
        {
            var childrenBodyRects:Vector.<Rectangle> = null;
            var groupShape:String = null;
            this._rectangle = null;
            if (group.expanded)
            {
                childrenBodyRects = bodyRects();
                if (childrenBodyRects.length != 0)
                {
                    groupShape = group.getStyle(Styles.GROUP_SHAPE);
                    if (groupShape == Consts.SHAPE_RECTANGLE)
                    {
                        this._rectangle = ElementUtil.getUnionRect(childrenBodyRects);
                    }
                    else if (groupShape == Consts.SHAPE_OVAL)
                    {
                        this._rectangle = ElementUtil.getOval(childrenBodyRects);
                    }
                    else if (groupShape == Consts.SHAPE_ROUNDRECT)
                    {
                        this._rectangle = ElementUtil.getRoundRect(childrenBodyRects);
                    }
                    else if (groupShape == Consts.SHAPE_STAR)
                    {
                        this._rectangle = ElementUtil.getUnionRect(childrenBodyRects);
                        this._rectangle.inflate(this._rectangle.width, this._rectangle.height);
                    }
                    else if (groupShape == Consts.SHAPE_TRIANGLE)
                    {
                        this._rectangle = ElementUtil.getUnionRect(childrenBodyRects);
                        this._rectangle.x = this._rectangle.x - this._rectangle.width / 2;
                        this._rectangle.width = this._rectangle.width * 2;
                        this._rectangle.y = this._rectangle.y - this._rectangle.height;
                        this._rectangle.height = this._rectangle.height * 2;
                    }
                    else if (groupShape == Consts.SHAPE_CIRCLE)
                    {
                        this._rectangle = ElementUtil.getCircle(childrenBodyRects);
                    }
                    else if (groupShape == Consts.SHAPE_HEXAGON)
                    {
                        this._rectangle = ElementUtil.getUnionRect(childrenBodyRects);
                        this._rectangle.x = this._rectangle.x - this._rectangle.width / 2;
                        this._rectangle.width = this._rectangle.width * 2;
                    }
                    else if (groupShape == Consts.SHAPE_PENTAGON)
                    {
                        this._rectangle = ElementUtil.getUnionRect(childrenBodyRects);
                        this._rectangle.x = this._rectangle.x - this._rectangle.width / 6;
                        this._rectangle.width = this._rectangle.width + this._rectangle.width / 3;
                        this._rectangle.y = this._rectangle.y - this._rectangle.height / 4;
                        this._rectangle.height = this._rectangle.height + this._rectangle.height / 4;
                    }
                    else if (groupShape == Consts.SHAPE_DIAMOND)
                    {
                        this._rectangle = ElementUtil.getUnionRect(childrenBodyRects);
                        this._rectangle.x = this._rectangle.x - this._rectangle.width / 2;
                        this._rectangle.width = this._rectangle.width + this._rectangle.width;
                        this._rectangle.y = this._rectangle.y - this._rectangle.height / 2;
                        this._rectangle.height = this._rectangle.height + this._rectangle.height;
                    }
                    else
                    {
                        throw new Error("Can not resolve group shape \'" + groupShape + "\'");
                    }
                    if (this._rectangle != null)
                    {
                        ElementUtil.addPadding(this._rectangle, element, Styles.GROUP_PADDING);
                        return this._rectangle;
                    }
                }
            }
            return super.bodyRect;
        }

        private function bodyRects() : Vector.<Rectangle>
        {
            var _index:int = 0;
            var _data:* = null;
            var _ui:IElementUI = null;
            var _rects:Vector.<Rectangle> = new Vector.<Rectangle>();
			_index = 0;
            while (_index < group.numChildren)
            {
                
				_data = group.children[_index];
                if (_data is Node)
                {
					_ui = network.getElementUI(_data);
                    if (_ui != null&&!_data.isSmallNode)
                    {
						_rects.push(NodeUI(_ui).bodyRect);
                    }
                }
				_index = _index + 1;
            }
            return _rects;
        }

		/**
		 * 重载drawContent方法，根据设置的样式属性绘画不同的形状及外观。
		 */
        override protected function drawContent() : void
        {
			if(!element.visible){
				return;
			}
            var groupDeep:Number = NaN;
            var _bodyRect:* = this.bodyRect;
            if (this._rectangle == null)
            {
                super.drawContent();
                return;
            }
			graphics.clear();
			
            var groupFill:* = element.getStyle(Styles.GROUP_FILL) as Boolean;
            var groupFillColor:* = this.getDyeColor(Styles.GROUP_FILL_COLOR);
            if (groupFill)
            {
                GraphicDrawHelper.beginFill(graphics, groupFillColor, element.getStyle(Styles.GROUP_FILL_ALPHA), _bodyRect.x, _bodyRect.y, _bodyRect.width, _bodyRect.height, element.getStyle(Styles.GROUP_GRADIENT), element.getStyle(Styles.GROUP_GRADIENT_COLOR), element.getStyle(Styles.GROUP_GRADIENT_ALPHA));
            }
            var groupOutlineWidth:* = element.getStyle(Styles.GROUP_OUTLINE_WIDTH);
            if (groupOutlineWidth >= 0)
            {
                graphics.lineStyle(element.getStyle(Styles.GROUP_OUTLINE_WIDTH), element.getStyle(Styles.GROUP_OUTLINE_COLOR), element.getStyle(Styles.GROUP_OUTLINE_ALPHA), element.getStyle(Styles.GROUP_PIXEL_HINTING), element.getStyle(Styles.GROUP_SCALE_MODE), element.getStyle(Styles.GROUP_CAPS_STYLE), element.getStyle(Styles.GROUP_JOINT_STYLE));
            }
            else
            {
                graphics.lineStyle();
            }
            var groupShape:* = element.getStyle(Styles.GROUP_SHAPE);
            GraphicDrawHelper.drawShape(graphics, groupShape, _bodyRect.x, _bodyRect.y, _bodyRect.width, _bodyRect.height);
            if (groupFill)
            {
                graphics.endFill();
                groupDeep = element.getStyle(Styles.GROUP_DEEP);
                if (groupDeep != 0)
                {
                    if (groupShape == Consts.SHAPE_RECTANGLE)
                    {
                        GraphicDrawHelper.draw3DRect(graphics, groupFillColor, groupDeep, _bodyRect.x, _bodyRect.y, _bodyRect.width, _bodyRect.height);
                    }
                }
            }
            return;
        }

		protected function onChildPropertyChange(event:ElementPropertyChangeEvent):void{
			graphics.clear();
			//所有子类的变化都将重绘，暂不考虑效率问题。
			switch(event.property)
			{
				//				case "x":
				//					drawContent();
				//					break;
				//				case "y":  
				//					drawContent();
				//					break;
				//				case "xy":  
				//					drawContent();
				//					break;
				//				case "width":
				//					drawContent(); 
				//					break;
				//				case "height":
				//					drawContent();
				//					break;
				default: drawContent();return;
			}
			
		}
		
		override protected function onPropertyChange(event:ElementPropertyChangeEvent):void{
			graphics.clear();
			switch(event.property)
			{
				case "addChild":
					((event.newValue) as Node).addEventListener(Consts.EVENT_DATA_PROPERTY_CHANGE, onChildPropertyChange);
					drawContent();
					break;
				case "removeChild":
					((event.newValue) as Node).removeEventListener(Consts.EVENT_DATA_PROPERTY_CHANGE, onChildPropertyChange);
					drawContent();
					break;
				default :
					drawContent();
					break;
			}
		}
        public function get group() : Group
        {
            return Group(element);
        }

    }
}
