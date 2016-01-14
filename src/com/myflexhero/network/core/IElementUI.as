package com.myflexhero.network.core
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;

	public interface IElementUI extends IDataUI,IEventDispatcher
	{
		/**
		 * 返回当前element
		 */
		function get element():*;
		/**
		 * 是否允许多选时高亮
		 */
		function set isMultiSelectHighLightEnable(value:Boolean):void;
		/**
		 * 尝试开始设置绘制图像所需的主要属性
		 */
		function drawBody():void;
		
		/**
		 * 更新组件属性
		 */
		function updateProperties():void;
		/**
		 * 更新Label属性
		 */
		function updateLabelAttachmentProperties():void;
		/**
		 * 更新Label外观
		 */
		function refreshLabelAttachment():void;
		/**
		 * 设置高亮层度，默认为0(不显示),1为最高,level数值越低，高亮filter效果越明显.
		 */
		function setHighLightLevel(level:int):void;
		
		/**
		 * 开始执行高亮
		 */
		function refreshHighLight():void;
		
		/**
		 * 清空组件引用及内部数据
		 */
		function dispose():void;
		/**
		 * 判断是否击中了图形对象
		 */
		function isHitByDisplayObject(displayObject:DisplayObject, intersectMode:Boolean = false, accuracy:Number = 1) : Boolean;
		/**
		 * 判断是否击中了对象
		 */
		function isHit(target:*, tolerance:int, intersectMode:Boolean, accuracy:Number = 1) : Boolean;
	}
}