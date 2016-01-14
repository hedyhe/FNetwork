package com.myflexhero.network
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	
	/**
	 * 系统常量，用于外观样式及布局支持。
	 */
	public class Consts
	{
		public function Consts()
		{
		}
		
		public static const BEVEL_TYPE_OUTER:String = BitmapFilterType.OUTER;
		public static const BEVEL_TYPE_INNER:String = BitmapFilterType.INNER;
		public static const BEVEL_TYPE_FULL:String = BitmapFilterType.FULL;
		
		public static const CAPS_STYLE_SQUARE:String = CapsStyle.SQUARE;
		public static const CAPS_STYLE_NONE:String = CapsStyle.NONE;
		public static const CAPS_STYLE_ROUND:String = CapsStyle.ROUND;
		
		public static const CONTENT_TYPE_DEFAULT:String = "default";
		public static const CONTENT_TYPE_NONE:String = "none";
		public static const CONTENT_TYPE_VECTOR_DEFAULT:String = "vector.default";
		public static const CONTENT_TYPE_VECTOR:String = "vector";
		public static const CONTENT_TYPE_DEFAULT_VECTOR:String = "default.vector";
		
		public static const COLOR_WHITE:Number = 16777215;
		public static const COLOR_DEFAULT:uint = 2652072;
		public static const COLOR_GRAY:Number = 12632256;
		public static const COLOR_IVORY:Number = 16776958;
		public static const COLOR_DARK:Number = 5987163;
		public static const COLOR_RED:Number = 0xff0000;
		public static const COLOR_GREEN:Number = 0x00ff00;
		public static const COLOR_BLUE:Number = 0x0000ff;
		public static const COLOR_YELLOW:Number = 0xffff00;
		public static const COLOR_BLACK:Number = 0;
		
		public static const DIRECTION_NORTH:String = "north";
		public static const DIRECTION_SOUTH_EAST:String = "southeast";
		public static const DIRECTION_SOUTH:String = "south";
		public static const DIRECTION_EAST:String = "east";
		public static const DIRECTION_NORTH_WEST:String = "northwest";
		public static const DIRECTION_SOUTH_WEST:String = "southwest";
		public static const DIRECTION_WEST:String = "west";
		public static const DIRECTION_NORTH_EAST:String = "northeast";
		
		public static const EMPTY_SIZE:Size = new Size();
		
		public static const EVENT_IMAGE_LOAD:String = "imageLoad";
		public static const EVENT_HIERARCHY_CHANGE:String = "hierarchyChange";
		public static const EVENT_DATABOX_CHANGE:String = "dataBoxChange";
		public static const EVENT_SELECTION_CHANGE:String = "selectionChange";
		public static const EVENT_INDEX_CHANGE:String = "indexChange";
		public static const EVENT_PROPERTY_CHANGE:String = "propertyChange";
		public static const EVENT_DATA_PROPERTY_CHANGE:String = "dataPropertyChange";
		public static const EVENT_INTERACTION:String = "interaction";
		public static const EVENT_AlARMSEVERITY_CHANGE:String = "alarmSeverityChange";
		
		
		public static const GRADIENT_NONE:String = "none";
		public static const GRADIENT_LINEAR_SOUTHWEST:String = "linear.southwest";
		public static const GRADIENT_LINEAR_NORTHWEST:String = "linear.northwest";
		public static const GRADIENT_LINEAR_SOUTHEAST:String = "linear.southeast";
		public static const GRADIENT_LINEAR_NORTHEAST:String = "linear.northeast";
		public static const GRADIENT_LINEAR_NORTH:String = "linear.north";
		public static const GRADIENT_LINEAR_SOUTH:String = "linear.south";
		public static const GRADIENT_LINEAR_WEST:String = "linear.west";
		public static const GRADIENT_LINEAR_EAST:String = "linear.east";
		public static const GRADIENT_RADIAL_CENTER:String = "radial.center";
		public static const GRADIENT_RADIAL_SOUTHWEST:String = "radial.southwest";
		public static const GRADIENT_RADIAL_SOUTHEAST:String = "radial.southeast";
		public static const GRADIENT_RADIAL_NORTHWEST:String = "radial.northwest";
		public static const GRADIENT_RADIAL_NORTHEAST:String = "radial.northeast";
		public static const GRADIENT_RADIAL_NORTH:String = "radial.north";
		public static const GRADIENT_RADIAL_SOUTH:String = "radial.south";
		public static const GRADIENT_RADIAL_WEST:String = "radial.west";
		public static const GRADIENT_RADIAL_EAST:String = "radial.east";
		public static const GRADIENT_SPREAD_HORIZONTAL:String = "spread.horizontal";
		public static const GRADIENT_SPREAD_VERTICAL:String = "spread.vertical";
		public static const GRADIENT_SPREAD_DIAGONAL:String = "spread.diagonal";
		public static const GRADIENT_SPREAD_ANTIDIAGONAL:String = "spread.antidiagonal";
		public static const GRADIENT_SPREAD_NORTH:String = "spread.north";
		public static const GRADIENT_SPREAD_SOUTH:String = "spread.south";
		public static const GRADIENT_SPREAD_WEST:String = "spread.west";
		public static const GRADIENT_SPREAD_EAST:String = "spread.east";
		
		public static const INNER_STYLE_SHAPE:String = "shape";
		public static const INNER_STYLE_NONE:String = "none";
		public static const INNER_STYLE_DYE:String = "dye";
		
		public static const ITERATE_MODE_ROOTS:String = "roots";
		public static const ITERATE_MODE_FORWARD:String = "forward";
		public static const ITERATE_MODE_REVERSE:String = "reverse";
		
		public static const LAYOUT_SPRING:String = "spring";
		public static const LAYOUT_BOTTOMTOP:String = "bottomtop";
		public static const LAYOUT_TOPBOTTOM:String = "topbottom";
		public static const LAYOUT_RIGHTLEFT:String = "rightleft";
		public static const LAYOUT_LEFTRIGHT:String = "leftright";
		public static const LAYOUT_ROUND:String = "round";
		//		public static const LINK_TYPE_FLEXIONAL_VERTICAL:String = "flexional.vertical";
		//		public static const LINK_TYPE_EXTEND_RIGHT:String = "extend.right";
		//		public static const LINK_TYPE_VERTICAL_HORIZONTAL:String = "orthogonal.V.H";
		//		public static const LINK_TYPE_HORIZONTAL_VERTICAL:String = "orthogonal.H.V";
		//		public static const LINK_TYPE_ORTHOGONAL_HORIZONTAL:String = "orthogonal.horizontal";
		//		public static const LINK_TYPE_FLEXIONAL:String = "flexional";
		public static const LINK_TYPE_PARALLEL:String = "parallel";
		public static const LINK_TYPE_ORTHOGONAL:String = "orthogonal";
		//		public static const LINK_TYPE_TRIANGLE:String = "triangle";
		//		public static const LINK_LOOPED_TYPE_RECTANGLE:String = "rectangle";
		//		public static const LINK_CORNER_BEVEL:String = "bevel";
		//		public static const LINK_CORNER_NONE:String = "none";
		//		public static const LINK_TYPE_ARC:String = "arc";
		//		public static const LINK_TYPE_EXTEND_LEFT:String = "extend.left";
		//		public static const LINK_TYPE_EXTEND_TOP:String = "extend.top";
		//		public static const LINK_TYPE_ORTHOGONAL_VERTICAL:String = "orthogonal.vertical";
		//		public static const LINK_TYPE_EXTEND_BOTTOM:String = "extend.bottom";
		//		public static const LINK_CORNER_ROUND:String = "round";
		//		public static const LINK_TYPE_FLEXIONAL_HORIZONTAL:String = "flexional.horizontal";
		//		public static const LINK_LOOPED_TYPE_ARC:String = "arc";
		
		public static const JOINT_STYLE_MITER:String = JointStyle.MITER;
		public static const JOINT_STYLE_ROUND:String = JointStyle.ROUND;
		public static const JOINT_STYLE_BEVEL:String = JointStyle.BEVEL;
		
		public static const MAP_FILTER_FISHEYE:String = "fisheye";
		public static const MAP_FILTER_MAGNIFY:String = "magnify";
		public static const MAP_FILTER_IMAGE:String = "image";
		
		public static const ORIENTATION_LEFT:String = "left";
		public static const ORIENTATION_TOP:String = "top";
		public static const ORIENTATION_RIGHT:String = "right";
		public static const ORIENTATION_BOTTOM:String = "bottom";
		
		public static const POSITION_TOPLEFT_TOPLEFT:String = "topleft.topleft";
		public static const POSITION_TOPLEFT_TOPRIGHT:String = "topleft.topright";
		public static const POSITION_TOP_TOP:String = "top.top";
		public static const POSITION_TOPRIGHT_TOPLEFT:String = "topright.topleft";
		public static const POSITION_TOPRIGHT_TOPRIGHT:String = "topright.topright";
		public static const POSITION_TOPLEFT:String = "topleft";
		public static const POSITION_TOP:String = "top";
		public static const POSITION_TOPRIGHT:String = "topright";
		public static const POSITION_TOPLEFT_BOTTOMLEFT:String = "topleft.bottomleft";
		public static const POSITION_TOPLEFT_BOTTOMRIGHT:String = "topleft.bottomright";
		public static const POSITION_TOP_BOTTOM:String = "top.bottom";
		public static const POSITION_TOPRIGHT_BOTTOMLEFT:String = "topright.bottomleft";
		public static const POSITION_TOPRIGHT_BOTTOMRIGHT:String = "topright.bottomright";
		
		public static const POSITION_LEFT_LEFT:String = "left.left";
		public static const POSITION_LEFT:String = "left";
		public static const POSITION_LEFT_RIGHT:String = "left.right";
		public static const POSITION_CENTER:String = "center";
		
		public static const POSITION_RIGHT_LEFT:String = "right.left";
		public static const POSITION_RIGHT:String = "right";
		public static const POSITION_RIGHT_RIGHT:String = "right.right";
		
		public static const POSITION_BOTTOMLEFT_TOPLEFT:String = "bottomleft.topleft";
		public static const POSITION_BOTTOMLEFT_TOPRIGHT:String = "bottomleft.topright";
		public static const POSITION_BOTTOM_TOP:String = "bottom.top";
		public static const POSITION_BOTTOMRIGHT_TOPLEFT:String = "bottomright.topleft";
		public static const POSITION_BOTTOMRIGHT_TOPRIGHT:String = "bottomright.topright";
		public static const POSITION_BOTTOMLEFT:String = "bottomleft";
		public static const POSITION_BOTTOM:String = "bottom";
		public static const POSITION_BOTTOMRIGHT:String = "bottomright";
		public static const POSITION_BOTTOMLEFT_BOTTOMLEFT:String = "bottomleft.bottomleft";
		public static const POSITION_BOTTOMLEFT_BOTTOMRIGHT:String = "bottomleft.bottomright";
		public static const POSITION_BOTTOM_BOTTOM:String = "bottom.bottom";
		public static const POSITION_BOTTOMRIGHT_BOTTOMLEFT:String = "bottomright.bottomleft";
		public static const POSITION_BOTTOMRIGHT_BOTTOMRIGHT:String = "bottomright.bottomright";
		
		////////////////
		public static const POSITION_FROM:String = "from";
		public static const POSITION_TO:String = "to";
		public static const POSITION_HOTSPOT:String = "hotspot";
		
		//修改后的		
		/**
		public static const POSITION_CENTER:String = "center";
		public static const POSITION_TOP:String ="top";
		public static const POSITION_TOP_LEFT:String ="top.left";
		public static const POSITION_TOP_LEFT_LEFT:String ="top.left.left";
		public static const POSITION_TOP_RIGHT:String ="top.right";
		public static const POSITION_TOP_RIGHT_RIGHT:String ="top.right.right";
		public static const POSITION_TOPTOP:String ="toptop";
		public static const POSITION_TOPTOP_LEFT:String ="toptop.left";
		public static const POSITION_TOPTOP_LEFT_LEFT:String ="toptop.left.left";
		public static const POSITION_TOPTOP_RIGHT:String ="toptop.right";
		public static const POSITION_TOPTOP_RIGHT_RIGHT:String ="toptop.right.right";
		public static const POSITION_LEFT:String ="left";
		public static const POSITION_LEFT_TOP:String ="left.top";
		public static const POSITION_LEFT_TOP_TOP:String ="left.top.top";
		public static const POSITION_LEFT_BOTTOM:String ="left.bottom";
		public static const POSITION_LEFT_BOTTOM_BOTTOM:String ="left.bottom.bottom";
		public static const POSITION_LEFTLEFT:String ="leftleft";
		public static const POSITION_LEFTLEFT_TOP:String ="leftleft.top";
		public static const POSITION_LEFTLEFT_TOP_TOP:String ="leftleft.top.top";
		public static const POSITION_LEFTLEFT_BOTTOM:String ="leftleft.bottom";
		public static const POSITION_LEFTLEFT_BOTTOM_BOTTOM:String ="leftleft.bottom.bottom";
		
		public static const POSITION_RIGHT:String ="right";
		public static const POSITION_RIGHT_TOP:String ="right.top";
		public static const POSITION_RIGHT_TOP_TOP:String ="right.top.top";
		public static const POSITION_RIGHT_BOTTOM:String ="right.bottom";
		public static const POSITION_RIGHT_BOTTOM_BOTTOM:String ="right.bottom.bottom";
		public static const POSITION_RIGHTRIGHT:String ="rightright";
		public static const POSITION_RIGHTRIGHT_TOP:String ="rightright.top";
		public static const POSITION_RIGHTRIGHT_TOP_TOP:String ="rightright.top.top";
		public static const POSITION_RIGHTRIGHT_BOTTOM:String ="rightright.bottom";
		public static const POSITION_RIGHTRIGHT_BOTTOM_BOTTOM:String ="rightright.bottom.bottom";
		
		public static const POSITION_BOTTOM:String ="bottom";
		public static const POSITION_BOTTOM_LEFT:String ="bottom.left";
		public static const POSITION_BOTTOM_LEFT_LEFT:String ="bottom.left.left";
		public static const POSITION_BOTTOM_RIGHT:String ="bottom.right";
		public static const POSITION_BOTTOM_RIGHT_RIGHT:String ="bottom.right.right";
		public static const POSITION_BOTTOMBOTTOM:String ="bottombottom";
		public static const POSITION_BOTTOMBOTTOM_LEFT:String ="bottombottom.left";
		public static const POSITION_BOTTOMBOTTOM_LEFT_LEFT:String ="bottombottom.left.left";
		public static const POSITION_BOTTOMBOTTOM_RIGHT:String ="bottombottom.right";
		public static const POSITION_BOTTOMBOTTOM_RIGHT_RIGHT:String ="bottombottom.right.right";
		**/
		
		
		public static const PREFIX_STYLE:String = "S:";
		public static const PREFIX_CLIENT:String = "C:";
		
		public static const PRIORITY_BELOW_LOW:int = -10;
		public static const PRIORITY_ABOVE_NORMAL:int = 5;
		public static const PRIORITY_HIGH:int = 10;
		public static const PRIORITY_BELOW_NORMAL:int = -5;
		public static const PRIORITY_NORMAL:int = 0;
		
		public static const PROPERTY_TYPE_ACCESSOR:String = "accessor";
		public static const PROPERTY_TYPE_STYLE:String = "style";
		public static const PROPERTY_TYPE_CLIENT:String = "client";
		
		public static const QUALITY_LOW:int = BitmapFilterQuality.LOW;
		public static const QUALITY_HIGH:int = BitmapFilterQuality.HIGH;
		public static const QUALITY_MEDIUM:int = BitmapFilterQuality.MEDIUM;
		
		public static const TYPE_BOOLEAN:String = "boolean";
		public static const TYPE_STRING:String = "string";
		public static const TYPE_POINT:String = "point";
		public static const TYPE_ARRAY_NUMBER:String = "array.number";
		public static const TYPE_UINT:String = "uint";
		public static const TYPE_INT:String = "int";
		public static const TYPE_DATA:String = "data";
		public static const TYPE_ARRAY_STRING:String = "array.string";
		public static const TYPE_RECTANGLE:String = "rectangle";
		public static const TYPE_COLLECTION_POINT:String = "collection.point";
		public static const TYPE_ALARMSTATE:String = "alarmState";
		public static const TYPE_COLLECTION_STRING:String = "collection.string"
		public static const TYPE_NUMBER:String = "number";
		
		public static const SCALE_MODE_NORMAL:String = LineScaleMode.NORMAL;
		public static const SCALE_MODE_VERTICAL:String = LineScaleMode.VERTICAL;
		public static const SCALE_MODE_HORIZONTAL:String = LineScaleMode.HORIZONTAL;
		public static const SCALE_MODE_NONE:String = LineScaleMode.NONE;
		
		public static const SCOPE_VIEWSIZE:String = "viewsize";
		public static const SCOPE_VIEWPORT:String = "viewport";
		public static const SCOPE_ROOTCANVAS:String = "rootcanvas";
		
		public static const SEGMENT_MOVETO:String = "moveTo";
		public static const SEGMENT_QUADTO:String = "quadTo";
		public static const SEGMENT_LINETO:String = "lineTo";
		
		public static const SHAPE_RECTANGLE:String = "rectangle";
		public static const SHAPE_OVAL:String = "oval";
		public static const SHAPE_ROUNDRECT:String = "roundrect";
		public static const SHAPE_STAR:String = "star";
		public static const SHAPE_TRIANGLE:String = "triangle";
		public static const SHAPE_CIRCLE:String = "circle";
		public static const SHAPE_HEXAGON:String = "hexagon";
		public static const SHAPE_PENTAGON:String = "pentagon";
		public static const SHAPE_DIAMOND:String = "diamond";
		
		//		public static const STRETCH_TILE:String = "tile";
		//		public static const STRETCH_SOUTHWEST:String = "south.west";
		//		public static const STRETCH_CENTER_UNIFORM:String = "center.uniform";
		//		public static const STRETCH_NORTH_UNIFORM:String = "north.uniform";
		//		public static const STRETCH_EAST:String = "east";
		//		public static const STRETCH_SOUTH_UNIFORM:String = "south.uniform";
		//		public static const STRETCH_NORTHEAST:String = "north.east";
		//		public static const STRETCH_NORTHWEST_UNIFORM:String = "north.west.uniform";
		//		public static const STRETCH_NORTHEAST_UNIFORM:String = "north.east.uniform";
		//		public static const STRETCH_WEST_UNIFORM:String = "west.uniform";
		//		public static const STRETCH_UNIFORM:String = "uniform";
		//		public static const STRETCH_SOUTHEAST:String = "south.east";
		//		public static const STRETCH_SOUTHWEST_UNIFORM:String = "south.west.uniform";
		//		public static const STRETCH_EAST_UNIFORM:String = "east.uniform";
		//		public static const STRETCH_FILL:String = "fill";
		//		public static const STRETCH_SOUTHEAST_UNIFORM:String = "south.east.uniform";
		//		public static const STRETCH_WEST:String = "west";
		//		public static const STRETCH_CENTER:String = "center";
		//		public static const STRETCH_NORTH:String = "north";
		//		public static const STRETCH_NORTHWEST:String = "north.west";
		//		public static const STRETCH_UNIFORM_TO_FILL:String = "uniform.to.fill";
		//		public static const STRETCH_SOUTH:String = "south";
		public static const EVENT_TREE_INTERACTION:String = "treeInteraction";
	}
}