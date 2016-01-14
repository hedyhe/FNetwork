package com.myflexhero.network
{
    import com.myflexhero.network.core.IData;
    import com.myflexhero.network.core.ui.GroupUI;
    import com.myflexhero.network.core.util.ElementUtil;
    
    import flash.geom.*;

	/**
	 * Group组件将一些Node节点(及其子类)看作是一个内部组，
	 * 并绘画出一个椭圆(通过指定<b>Styles.GROUP_SHAPE</b>样式可使用常量中以<b>Consts.SHAPE_</b>开头的形状)的边界，
	 * 该边界的宽和高值由内部子类的最小、最大x、y值决定。
	 * <p>
	 * 如果内部子类的最小和最大的x、y值发生了改变，GroupUI将重绘其边界。
	 * </p>
	 * 
	 * <br><br>数据元素的继承结构如下所示:
	 * <pre>
	 * Data(数据基类)
	 * 	|Element(元素基类)
	 *		|Node(节点类)
	 * 			|Follower(具有跟随功能的类)
	 *				|SubNetwork(具有显示多层次子类关系的类)
	 *				|AbstractPipe(具有内部显示不同形状的抽象类)
	 *					|RoundPipe(圆管,内部可显示父子关系的圆孔)
	 *					|SquarePipe(矩形管道,内部可显示不同大小的矩形)
	 *				|<b>Group</b>(内部作为一个整体，具有统一的边界外观)
	 *				|Grid(网格，可设置任意行、列)
	 *					|KPICard(可表示KPI的网格)
	 *		|Link(链接类，表示节点之类的关系)
	 * </pre>
	 * @author Hedy
	 */
    public class Group extends Follower
    {
        private var expandLocked:Boolean = false;
        private var locationLocked:Boolean = false;
        private var updateLocationLocked:Boolean = false;

        public function Group(id:Object = null)
        {
            super(id);
            this.icon = Defaults.ICON_GROUP;
            this.image = Defaults.IMAGE_GROUP;
            return;
        }
		
		override public function serializeXML(serializer:XMLSerializer, data:IData) : void
		{
			super.serializeXML(serializer, data);
			this.serializeProperty(serializer, "expanded", data);
		}
		
        public function set expanded(expanded:Boolean) : void
        {
            if (this.expandLocked == expanded)
            {
                return;
            }
            var _loc_2:* = this.expandLocked;
            this.expandLocked = expanded;
            this.dispatchPropertyChangeEvent("expanded", _loc_2, this.expandLocked);
            return;
        }

        private function addCustomChild(data:IData,index:int=-1):Boolean{
			if(data==null)
				return false;
			if(_children==null)
				_children = new Vector.<IData>();
			
			var _i:int = _children.indexOf(data);
			if(_i!=-1)
				return false;

			if(index==-1)
				_children.push(data);
			else{
				var _oldValue:IData = _children[index];
				_children[children.length] = _oldValue;
				_children[index] = data;
			}

			this.dispatchPropertyChangeEvent("addChild", null, data);
			return true;
        }
		
		/**
		 * 添加受控制的子类到Group内部。该子类不会设置parent值为当前Group。<br>
		 * 双方的关系仅在Group中维护,子类并不知情。
		 */
		override public function addChild(data:IData,index:int=-1):Boolean{
			var val:Boolean = addCustomChild(data, index);
			this.updateLocationFromChildren();
			return val; 
		}
		
		/**
		 * 删除Group内部指定的子类引用。
		 */
        override public function removeChild(data:IData):Boolean{
			var val:Boolean =  super.removeChild(data);
            this.updateLocationFromChildren();
            return val;
        }

		/**
		 * 设置Group内部子类的左侧顶点子类的位置，所有子类将根据该子类的坐标进行相对平移。
		 */
		override public function setLocation(x:Number,y:Number) : void
        {
            if (this.locationLocked)
            {
                return;
            }
            if (isNaN(x)||isNaN(y))
            {
                throw new Error("x or y can not be null");
            }
            if (!this.updateLocationLocked)
            {
                this.locationLocked = true;
                ElementUtil.moveElements(this.children, x - this.x, y - this.y);
                this.locationLocked = false;
            }
			super.setLocation(x,y);
            return;
        }

        public function updateLocationFromChildren() : void
        {
            var _loc_3:IData = null;
            if (!this.locationLocked)
            {
	            var _rectangle:Rectangle = null;
	            var _loc_2:int = 0;
	            while (_loc_2 < this.numChildren)
	            {
	                
	                _loc_3 = this.children[_loc_2];
	                if (_loc_3 is Node)
	                {
	                    if (_rectangle == null)
	                    {
	                        _rectangle = Node(_loc_3).rect;
	                    }
	                    else
	                    {
	                        _rectangle = _rectangle.union(Node(_loc_3).rect);
	                    }
	                }
	                _loc_2 = _loc_2 + 1;
	            }
	            if (_rectangle != null)
	            {
	                this.updateLocationLocked = true;
	                this.setLocation(_rectangle.x + _rectangle.width / 2 - this.width / 2, _rectangle.y + _rectangle.height / 2 - this.height / 2);
	                this.updateLocationLocked = false;
	            }
			}
        }

        override public function get elementUIClass() : Class
        {
            return GroupUI;
        }

        public function get expanded() : Boolean
        {
            return expandLocked;
        }

        public function reverseExpanded() : void
        {
            this.expanded = !this.expanded;
            return;
        }
    }
}