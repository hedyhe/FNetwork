package com.myflexhero.network
{
	import com.myflexhero.network.core.IData;
	import com.myflexhero.network.core.util.ElementUtil;
	import com.myflexhero.network.event.ElementPropertyChangeEvent;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	

	/**
	 * 继承自Node类，通过设置host属性，使其拥有了跟随功能。
	 * 
	 * <br><br>数据元素的继承结构如下所示:
	 * <pre>
	 * Data(数据基类)
	 * 	|Element(元素基类)
	 *		|Node(节点类)
	 * 			|<b>Follower</b>(具有跟随功能的类)
	 *				|SubNetwork(具有显示多层次子类关系的类)
	 *				|AbstractPipe(具有内部显示不同形状的抽象类)
	 *					|RoundPipe(圆管,内部可显示父子关系的圆孔)
	 *					|SquarePipe(矩形管道,内部可显示不同大小的矩形)
	 *				|Group(内部作为一个整体，具有统一的边界外观)
	 *				|Grid(网格，可设置任意行、列)
	 *					|KPICard(可表示KPI的网格)
	 *		|Link(链接类，表示节点之类的关系)
	 * </pre>
	 * @author Hedy
	 */
	public class Follower extends Node
	{
		private var _isUpdateLock:Boolean = false;
		private var _isLocationLock:Boolean = false;
		private var _host:Node = null;
		protected static const IS_INTERESTED_HOST_GRID_PROPERTY:Object = {"x":true,
																			"y":true,
																			"location":true,
																			"width":true,
																			"height":true,
																			"S:grid.row.count":true,
																			"S:grid.column.count":true,
																			"S:grid.row.percents":true,
																			"S:grid.column.percents":true,
																			"S:grid.border":true,
																			"S:grid.border.left":true,
																			"S:grid.border.right":true,
																			"S:grid.border.top":true,
																			"S:grid.border.bottom":true,
																			"S:grid.padding":true,
																			"S:grid.padding.left":true,
																			"S:grid.padding.right":true,
																			"S:grid.padding.top":true,
																			"S:grid.padding.bottom":true};
		protected static const IS_INTERESTED_FOLLOWER_STYLE:Object = {"follower.row.index":true,
																		"follower.column.index":true,
																		"follower.row.span":true,
																		"follower.column.span":true,
																		"follower.padding":true,
																		"follower.padding.left":true,
																		"follower.padding.right":true,
																		"follower.padding.top":true,
																		"follower.padding.bottom":true};
		
		public function Follower(id:Object = null)
		{
			super(id);
			return;
		}
		
		override public function serializeXML(serializer:XMLSerializer, newInstance:IData) : void
		{
			super.serializeXML(serializer, newInstance);
			this.serializeProperty(serializer, "host", newInstance);
		}
		
		override protected function onStyleChanged(property:String,oldValue:Object, newValue:Object) : void
		{
			super.onStyleChanged(property,oldValue,newValue);
			if (IS_INTERESTED_FOLLOWER_STYLE[property])
				this.updateFollower(null);
		}
		
		public function updateFollower(event:ElementPropertyChangeEvent) : void
		{
			if (!this._isUpdateLock)
			{
//				if (SystemLicense.isDeserializingXML)
//				{
//					return;
//				}
			this._isUpdateLock = true;
			this.updateFollowerImpl(event);
			this._isUpdateLock = false;
			}
			return;
		}
		
		public function get host() : Node
		{
			return this._host;
		}
		
		override public function setLocation(x:Number,y:Number) : void
		{
			if (this._isLocationLock)
			{
				return;
			}
			this._isLocationLock = true;
			super.setLocation(x,y);
			this._isLocationLock = false;
		}
		
		protected function onHostChanged(oldHost:Node,newHost:Node) : void
		{
			this.updateFollower(null);
		}
		
		protected function updateFollowerImpl(event:ElementPropertyChangeEvent) : void
		{
			var _oldPoint:Point = null;
			var _newPoint:Point = null;
			var _location:Point = null;
			var _followerRowIndex:Number = NaN;
			var _followerColumnIndex:Number = NaN;
			var _cellRect1:Rectangle = null;
			var _followerRowSpan:Number = NaN;
			var _followerColumnSpan:Number = NaN;
			var _cellRect2:Rectangle = null;
			var host:Grid = this._host as Grid;
			if (host == null)
			{
				if (event != null)
				{
					_location = this.location;
					if (event.property == "location")
					{
						_oldPoint = Point(event.oldValue);
						_newPoint = Point(event.newValue);
						this.setLocation(_location.x + (_newPoint.x - _oldPoint.x),_location.y + (_newPoint.y - _oldPoint.y));
					}
					else if(event.property == "x"){
						this.setLocation(_location.x + (event.newValue as Number)- (event.oldValue  as Number),_location.y);
					}
					else if(event.property == "y"){
						this.setLocation(_location.x, _location.y+ (event.newValue  as Number) - (event.oldValue as Number));
					}
				}
			}
			else
			{
				if (event==null||IS_INTERESTED_HOST_GRID_PROPERTY[event.property])
				{
					_followerRowIndex = this.getStyle(Styles.FOLLOWER_ROW_INDEX);
					_followerColumnIndex = this.getStyle(Styles.FOLLOWER_COLUMN_INDEX);
					_cellRect1 = host.getCellRect(_followerRowIndex,_followerColumnIndex);
					if (_cellRect1 == null)
					{
						return;
					}
					_followerRowSpan = this.getStyle(Styles.FOLLOWER_ROW_SPAN);
					_followerColumnSpan = this.getStyle(Styles.FOLLOWER_COLUMN_SPAN);
					
					_cellRect2 = host.getCellRect(_followerRowIndex + _followerRowSpan - 1,_followerColumnIndex + _followerColumnSpan - 1);
					if (_cellRect2 != null&&_cellRect1!=_cellRect2)
					{
						_cellRect1 = _cellRect1.union(_cellRect2);
					}
					ElementUtil.addPadding(_cellRect1,this,Styles.FOLLOWER_PADDING);
					this.setLocation(_cellRect1.x,_cellRect1.y);
					this.width = _cellRect1.width;
					this.height = _cellRect1.height;
				}
			}
			return;
		}
		
		public function isHostOn(node:Node) : Boolean
		{
			if (node == null)
			{
				return false;
			}
			var _dictionary:* = new Dictionary();
			var _host:* = this._host;
			do
			{
				
				if (_host == node)
				{
					return true;
				}
				_dictionary[_host] = _host;
				if (_host is Follower)
				{
					_host = Follower(_host).host;
				}
				else
				{
					_host = null;
				}
//				if (_host != null)
//				{
//					if (_host != this)
//					{
//					}
//				}
			}while (_dictionary[_host] == null)
			return false;
		}
		
		public function isLoopedHostOn(follower:Follower) : Boolean
		{
			if (follower == null)
			{
				return false;
			}
			if (this.isHostOn(follower))
			{
				this.isHostOn(follower);
			}
			return follower.isHostOn(this);
		}
		
		protected function handleHostPropertyChange(event:ElementPropertyChangeEvent) : void
		{
			this.updateFollower(event);
		}
		
		/**
		 * 设置跟随的父数据对象。父数据对象移动后，子数据对象将相应根据移动。
		 */
		public function set host(n:Node) : void
		{
			if (n == this)
			{
				return;
			}
			if (this._host == n)
			{
				return;
			}
			var _host_loc:Node  = this._host;
			if (_host_loc != null)
			{
				_host_loc.removeFollower(this);
				_host_loc.removePropertyChangeListener(handleHostPropertyChange);
			}
			this._host = n;
			if (this._host != null)
			{
				this._host.addFollower(this);
				this._host.addPropertyChangeListener(handleHostPropertyChange);
			}
			this.dispatchPropertyChangeEvent("host",_host_loc,n);
			this.onHostChanged(_host_loc,n);
			return;
		}
		
	}
}