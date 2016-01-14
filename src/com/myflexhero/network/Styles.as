package com.myflexhero.network
{
	import com.myflexhero.network.core.util.SerializationSettings;

	/**
	 * CSS样式控制类,请根据对应的样式关键字前缀进行样式设置查询。部分属性目前并不支持。
	 * @author Hedy
	 */
    final public class Styles extends Object
    {
		//***************************************************************************************
		//
		//   ALARM
		//
		//***************************************************************************************
		public static const ALARM_SHADOW_ANGLE:String = "alarm.shadow.angle";
		public static const ALARM_CORNER_RADIUS:String = "alarm.corner.radius";
		public static const ALARM_POSITION:String = "alarm.position";
		public static const ALARM_BOLD:String = "alarm.bold";
		public static const ALARM_ITALIC:String = "alarm.italic";
		public static const ALARM_PADDING:String = "alarm.padding";
		public static const ALARM_FILL_ALPHA:String = "alarm.fill.alpha";
		public static const ALARM_PADDING_RIGHT:String = "alarm.padding.right";
		public static const ALARM_SHADOW_COLOR:String = "alarm.shadow.color";
		public static const ALARM_PADDING_LEFT:String = "alarm.padding.left";
		public static const ALARM_XOFFSET:String = "alarm.xoffset";
		public static const ALARM_OUTLINE_COLOR:String = "alarm.outline.color";
		public static const ALARM_SHADOW_ALPHA:String = "alarm.shadow.alpha";
		public static const ALARM_GRADIENT_COLOR:String = "alarm.gradient.color";
		public static const ALARM_OUTLINE_ALPHA:String = "alarm.outline.alpha";
		public static const ALARM_FONT:String = "alarm.font";
		public static const ALARM_UNDERLINE:String = "alarm.underline";
		public static const ALARM_YOFFSET:String = "alarm.yoffset";
		public static const ALARM_SHADOW_DISTANCE:String = "alarm.shadow.distance";
		public static const ALARM_CONTENT_XSCALE:String = "alarm.content.xscale";
		public static const ALARM_DIRECTION:String = "alarm.direction";
		public static const ALARM_CONTENT_YSCALE:String = "alarm.content.yscale";
		public static const ALARM_PADDING_TOP:String = "alarm.padding.top";
		public static const ALARM_POINTER_LENGTH:String = "alarm.pointer.length";
		public static const ALARM_GRADIENT_ALPHA:String = "alarm.gradient.alpha";
		public static const ALARM_POINTER_WIDTH:String = "alarm.pointer.width";
		public static const ALARM_COLOR:String = "alarm.color";
		public static const ALARM_HTML:String = "alarm.html";
		public static const ALARM_SIZE:String = "alarm.size";
		public static const ALARM_GRADIENT:String = "alarm.gradient";
		public static const ALARM_OUTLINE_WIDTH:String = "alarm.outline.width";
		public static const ALARM_PADDING_BOTTOM:String = "alarm.padding.bottom";
		public static const ALARM_ALPHA:String = "alarm.alpha";
		public static const ALARM_EMBED:String = "alarm.embed";
		//***************************************************************************************
		//
		//   ARROW
		//
		//***************************************************************************************
		public static const ARROW_TO_COLOR:String = "arrow.to.color";
		public static const ARROW_FROM_FILL:String = "arrow.from.fill";
		public static const ARROW_TO_SHAPE:String = "arrow.to.shape";
		public static const ARROW_FROM_COLOR:String = "arrow.from.color";
		public static const ARROW_FROM_WIDTH:String = "arrow.from.width";
		public static const ARROW_FROM_OUTLINE_ALPHA:String = "arrow.from.outline.alpha";
		public static const ARROW_FROM_YOFFSET:String = "arrow.from.yoffset";
		public static const ARROW_TO_WIDTH:String = "arrow.to.width";
		public static const ARROW_FROM:String = "arrow.from";
		public static const ARROW_TO_YOFFSET:String = "arrow.to.yoffset";
		public static const ARROW_TO:String = "arrow.to";
		public static const ARROW_TO_HEIGHT:String = "arrow.to.height";
		public static const ARROW_FROM_SHAPE:String = "arrow.from.shape";
		public static const ARROW_TO_ALPHA:String = "arrow.to.alpha";
		public static const ARROW_TO_OUTLINE_WIDTH:String = "arrow.to.outline.width";
		public static const ARROW_TO_FILL:String = "arrow.to.fill";
		public static const ARROW_FROM_ALPHA:String = "arrow.from.alpha";
		public static const ARROW_TO_AT_EDGE:String = "arrow.to.at.edge";
		public static const ARROW_TO_OUTLINE_PATTERN:String = "arrow.to.outline.pattern";
		public static const ARROW_TO_XOFFSET:String = "arrow.to.xoffset";
		public static const ARROW_FROM_AT_EDGE:String = "arrow.from.at.edge";
		public static const ARROW_FROM_OUTLINE_WIDTH:String = "arrow.from.outline.width";
		public static const ARROW_TO_OUTLINE_COLOR:String = "arrow.to.outline.color";
		public static const ARROW_FROM_XOFFSET:String = "arrow.from.xoffset";
		public static const ARROW_FROM_HEIGHT:String = "arrow.from.height";
		public static const ARROW_FROM_OUTLINE_PATTERN:String = "arrow.from.outline.pattern";
		public static const ARROW_FROM_OUTLINE_COLOR:String = "arrow.from.outline.color";
		public static const ARROW_TO_OUTLINE_ALPHA:String = "arrow.to.outline.alpha";
		//***************************************************************************************
		//
		//   BACKGROUND
		//
		//***************************************************************************************
		public static const BACKGROUND_IMAGE_SCALE_MODE:String = "background.image.scale.mode";
		public static const BACKGROUND_IMAGE_OUTLINE_COLOR:String = "background.image.outline.color";
		public static const BACKGROUND_VECTOR_PADDING_BOTTOM:String = "background.vector.padding.bottom";
		public static const BACKGROUND_VECTOR_FILL_ALPHA:String = "background.vector.fill.alpha";
		public static const BACKGROUND_VECTOR_SCALE_MODE:String = "background.vector.scale.mode";
		public static const BACKGROUND_VECTOR_OUTLINE_ALPHA:String = "background.vector.outline.alpha";
		public static const BACKGROUND_IMAGE_PADDING_RIGHT:String = "background.image.padding.right";
		public static const BACKGROUND_IMAGE_PADDING:String = "background.image.padding";
		public static const BACKGROUND_VECTOR_PIXEL_HINTING:String = "background.vector.pixel.hinting";
		public static const BACKGROUND_IMAGE_OUTLINE_ALPHA:String = "background.image.outline.alpha";
		public static const BACKGROUND_VECTOR_CAPS_STYLE:String = "background.vector.caps.style";
		public static const BACKGROUND_IMAGE_PIXEL_HINTING:String = "background.image.pixel.hinting";
		public static const BACKGROUND_IMAGE_STRETCH:String = "background.image.stretch";
		public static const BACKGROUND_IMAGE_PADDING_LEFT:String = "background.image.padding.left";
		public static const BACKGROUND_IMAGE:String = "background.image";
		public static const BACKGROUND_VECTOR_GRADIENT:String = "background.vector.gradient";
		public static const BACKGROUND_IMAGE_CAPS_STYLE:String = "background.image.caps.style";
		public static const BACKGROUND_VECTOR_JOINT_STYLE:String = "background.vector.joint.style";
		public static const BACKGROUND_VECTOR_GRADIENT_COLOR:String = "background.vector.gradient.color";
		public static const BACKGROUND_IMAGE_JOINT_STYLE:String = "background.image.joint.style";
		public static const BACKGROUND_VECTOR_SCOPE:String = "background.vector.scope";
		public static const BACKGROUND_TYPE:String = "background.type";
		public static const BACKGROUND_VECTOR_PADDING:String = "background.vector.padding";
		public static const BACKGROUND_IMAGE_PADDING_BOTTOM:String = "background.image.padding.bottom";
		public static const BACKGROUND_VECTOR_PADDING_LEFT:String = "background.vector.padding.left";
		public static const BACKGROUND_VECTOR_DEEP:String = "background.vector.deep";
		public static const BACKGROUND_VECTOR_SHAPE:String = "background.vector.shape";
		public static const BACKGROUND_VECTOR_FILL_COLOR:String = "background.vector.fill.color";
		public static const BACKGROUND_VECTOR_FILL:String = "background.vector.fill";
		public static const BACKGROUND_VECTOR_GRADIENT_ALPHA:String = "background.vector.gradient.alpha";
		public static const BACKGROUND_VECTOR_PADDING_TOP:String = "background.vector.padding.top";
		public static const BACKGROUND_IMAGE_SHAPE:String = "background.image.shape";
		public static const BACKGROUND_IMAGE_PADDING_TOP:String = "background.image.padding.top";
		public static const BACKGROUND_IMAGE_OUTLINE_WIDTH:String = "background.image.outline.width";
		public static const BACKGROUND_IMAGE_SCOPE:String = "background.image.scope";
		public static const BACKGROUND_VECTOR_PADDING_RIGHT:String = "background.vector.padding.right";
		public static const BACKGROUND_VECTOR_OUTLINE_WIDTH:String = "background.vector.outline.width";
		public static const BACKGROUND_VECTOR_OUTLINE_COLOR:String = "background.vector.outline.color";
		//***************************************************************************************
		//
		//   FOLLOWER
		//
		//***************************************************************************************
		public static const FOLLOWER_COLUMN_SPAN:String = "follower.column.span";
		public static const FOLLOWER_PADDING_BOTTOM:String = "follower.padding.bottom";
		public static const FOLLOWER_PADDING:String = "follower.padding";
		public static const FOLLOWER_ROW_SPAN:String = "follower.row.span";
		public static const FOLLOWER_PADDING_RIGHT:String = "follower.padding.right";
		public static const FOLLOWER_PADDING_LEFT:String = "follower.padding.left";
		public static const FOLLOWER_ROW_INDEX:String = "follower.row.index";
		public static const FOLLOWER_PADDING_TOP:String = "follower.padding.top";
		public static const FOLLOWER_COLUMN_INDEX:String = "follower.column.index";
		//***************************************************************************************
		//
		//   GROUP
		//
		//***************************************************************************************
		public static const GROUP_FILL_COLOR:String = "group.fill.color";
		public static const GROUP_JOINT_STYLE:String = "group.joint.style";
		public static const GROUP_PADDING_BOTTOM:String = "group.padding.bottom";
		public static const GROUP_FILL_ALPHA:String = "group.fill.alpha";
		public static const GROUP_OUTLINE_WIDTH:String = "group.outline.width";
		public static const GROUP_SCALE_MODE:String = "group.scale.mode";
		public static const GROUP_PADDING_RIGHT:String = "group.padding.right";
		public static const GROUP_PADDING_TOP:String = "group.padding.top";
		public static const GROUP_DEEP:String = "group.deep";
		public static const GROUP_OUTLINE_COLOR:String = "group.outline.color";
		public static const GROUP_GRADIENT_COLOR:String = "group.gradient.color";
		public static const GROUP_FILL:String = "group.fill";
		public static const GROUP_CAPS_STYLE:String = "group.caps.style";
		public static const GROUP_OUTLINE_ALPHA:String = "group.outline.alpha";
		public static const GROUP_GRADIENT:String = "group.gradient";
		public static const GROUP_PIXEL_HINTING:String = "group.pixel.hinting";
		public static const GROUP_GRADIENT_ALPHA:String = "group.gradient.alpha";
		public static const GROUP_PADDING_LEFT:String = "group.padding.left";
		public static const GROUP_SHAPE:String = "group.shape";
		public static const GROUP_PADDING:String = "group.padding";
		//***************************************************************************************
		//
		//   GRID
		//
		//***************************************************************************************
		public static const GRID_PADDING_LEFT:String = "grid.padding.left";
		public static const GRID_CELL_DEEP:String = "grid.cell.deep";
		public static const GRID_FILL_ALPHA:String = "grid.fill.alpha";
		public static const GRID_FILL:String = "grid.fill";
		public static const GRID_PADDING_RIGHT:String = "grid.padding.right";
		/**
		 * 网格的边框大小，默认为1像素。
		 */
		public static const GRID_BORDER:String = "grid.border";
		public static const GRID_PADDING_BOTTOM:String = "grid.padding.bottom";
		public static const GRID_BORDER_TOP:String = "grid.border.top";
		public static const GRID_ROW_PERCENTS:String = "grid.row.percents";
		public static const GRID_FILL_COLOR:String = "grid.fill.color";
		public static const GRID_BORDER_BOTTOM:String = "grid.border.bottom";
		public static const GRID_PADDING_TOP:String = "grid.padding.top";
		/**
		 * 网格的行数,默认数量为1。
		 */
		public static const GRID_ROW_COUNT:String = "grid.row.count";
		/**
		 * 网格的列数,默认数量为1。
		 */
		public static const GRID_COLUMN_COUNT:String = "grid.column.count";
		/**
		 * 网格与网格之间的间隔空隙，默认为1像素。
		 */
		public static const GRID_PADDING:String = "grid.padding";
		/**
		 * 网格背景容器的边缘纵深特效偏移量。默认为1像素。为正则向外偏移纵深效果，为负则向内偏移纵深效果。
		 */
		public static const GRID_DEEP:String = "grid.deep";
		public static const GRID_COLUMN_PERCENTS:String = "grid.column.percents";
		public static const GRID_BORDER_LEFT:String = "grid.border.left";
		public static const GRID_BORDER_RIGHT:String = "grid.border.right";
		
		//***************************************************************************************
		//
		//   ICONS
		//
		//***************************************************************************************
		public static const ICONS_POSITION:String = "icons.position";
		public static const ICONS_NAMES:String = "icons.names";
		public static const ICONS_YGAP:String = "icons.ygap";
		public static const ICONS_YOFFSET:String = "icons.yoffset";
		public static const ICONS_XGAP:String = "icons.xgap";
		public static const ICONS_COLORS:String = "icons.colors";
		public static const ICONS_XOFFSET:String = "icons.xoffset";
		public static const ICONS_ORIENTATION:String = "icons.orientation";
		//***************************************************************************************
		//
		//   IMAGE
		//
		//***************************************************************************************
		public static const IMAGE_PADDING_LEFT:String = "image.padding.left";
		public static const IMAGE_JOINT_STYLE:String = "image.joint.style";
		public static const IMAGE_CAPS_STYLE:String = "image.caps.style";
		public static const IMAGE_OUTLINE_ALPHA:String = "image.outline.alpha";
		public static const IMAGE_PIXEL_HINTING:String = "image.pixel.hinting";
		public static const IMAGE_STRETCH:String = "image.stretch";
		public static const IMAGE_PADDING_BOTTOM:String = "image.padding.bottom";
		public static const IMAGE_PADDING_TOP:String = "image.padding.top";
		public static const IMAGE_OUTLINE_WIDTH:String = "image.outline.width";
		public static const IMAGE_PADDING_RIGHT:String = "image.padding.right";
		public static const IMAGE_OUTLINE_COLOR:String = "image.outline.color";
		public static const IMAGE_SCALE_MODE:String = "image.scale.mode";
		public static const IMAGE_PADDING:String = "image.padding";
		public static const IMAGE_SHAPE:String = "image.shape";
		//***************************************************************************************
		//
		//   INNER
		//
		//***************************************************************************************
		public static const INNER_PADDING:String = "inner.padding";
		public static const INNER_PADDING_TOP:String = "inner.padding.top";
		public static const INNER_PADDING_BOTTOM:String = "inner.padding.bottom";
		public static const INNER_GRADIENT:String = "inner.gradient";
		public static const INNER_SHAPE:String = "inner.shape";
		public static const INNER_OUTLINE_ALPHA:String = "inner.outline.alpha";
		public static const INNER_BACK:String = "inner.back";
		public static const INNER_ALPHA:String = "inner.alpha";
		public static const INNER_GRADIENT_COLOR:String = "inner.gradient.color";
		public static const INNER_PADDING_LEFT:String = "inner.padding.left";
		public static const INNER_GRADIENT_ALPHA:String = "inner.gradient.alpha";
		public static const INNER_OUTLINE_WIDTH:String = "inner.outline.width";
		public static const INNER_PADDING_RIGHT:String = "inner.padding.right";
		public static const INNER_STYLE:String = "inner.style";
		public static const INNER_OUTLINE_COLOR:String = "inner.outline.color";
		public static const INNER_COLOR:String = "inner.color";
		//***************************************************************************************
		//
		//   LABEL
		//
		//***************************************************************************************
		public static const LABEL_POINTER_WIDTH:String = "label.pointer.width";
		public static const LABEL_SELECTED_COLOR:String = "label.selected.color";
		public static const LABEL_PADDING_BOTTOM:String = "label.padding.bottom";
		public static const LABEL_UNDERLINE:String = "label.underline";
		public static const LABEL_GRADIENT:String = "label.gradient";
		public static const LABEL_XOFFSET:String = "label.xoffset";
		public static const LABEL_BOLD:String = "label.bold";
		public static const LABEL_OUTLINE_WIDTH:String = "label.outline.width";
		public static const LABEL_PADDING:String = "label.padding";
		public static const LABEL_EMBED:String = "label.embed";
		public static const LABEL_PADDING_RIGHT:String = "label.padding.right";
		public static const LABEL_COLOR:String = "label.color";
		public static const LABEL_POSITION:String = "label.position";
		public static const LABEL_OUTLINE_COLOR:String = "label.outline.color";
		public static const LABEL_FONT:String = "label.font";
		public static const LABEL_PADDING_TOP:String = "label.padding.top";
		public static const LABEL_GRADIENT_COLOR:String = "label.gradient.color";
		public static const LABEL_YOFFSET:String = "label.yoffset";
		public static const LABEL_FILL_COLOR:String = "label.fill.color";
		public static const LABEL_CONTENT_YSCALE:String = "label.content.yscale";
		public static const LABEL_FILL:String = "label.fill";
		public static const LABEL_ALPHA:String = "label.alpha";
		public static const LABEL_POINTER_LENGTH:String = "label.pointer.length";
		public static const LABEL_PADDING_LEFT:String = "label.padding.left";
		public static const LABEL_CONTENT_XSCALE:String = "label.content.xscale";
		public static const LABEL_CORNER_RADIUS:String = "label.corner.radius";
		public static const LABEL_GRADIENT_ALPHA:String = "label.gradient.alpha";
		public static const LABEL_OUTLINE_ALPHA:String = "label.outline.alpha";
		public static const LABEL_FILL_ALPHA:String = "label.fill.alpha";
		public static const LABEL_HTML:String = "label.html";
		public static const LABEL_SIZE:String = "label.size";
		public static const LABEL_DIRECTION:String = "label.direction";
		public static const LABEL_ITALIC:String = "label.italic";
		//***************************************************************************************
		//
		//   LINK
		//
		//***************************************************************************************
		public static const LINK_HANDLER_SIZE:String = "link.handler.size";
		public static const LINK_HANDLER_FILL_ALPHA:String = "link.handler.fill.alpha";
		public static const LINK_SPLIT_BY_PERCENT:String = "link.split.by.percent";
		public static const LINK_BUNDLE_ENABLE:String = "link.bundle.enable";
		public static const LINK_HANDLER_XOFFSET:String = "link.handler.xoffset";
		/**
		 * JointStyle 类的值，指定用于拐角的连接外观的类型。有效值为：JointStyle.BEVEL、JointStyle.MITER 和 JointStyle.ROUND。如果未指示值，则 Flash 使用圆角连接。 <br><br>
		 * 例如，以下图示显示了不同的 joints 设置。对于每种设置，插图显示了一条粗细为 30 的带拐角的蓝色线条（应用 jointStyle 的线条），以及重叠于其上的粗细为 1 的带拐角的黑色线条（未应用 jointStyle 的线条）： <br><br>
		 * 注意：对于设置为 JointStyle.MITER 的 joints，您可以使用 miterLimit 参数限制尖角的长度。
		 */
		public static const LINK_JOINT_STYLE:String = "link.joint.style";
		/**
		 * 表示线条颜色的 Alpha 值的数字；有效值为 0 到 1。
		 * 如果未指明值，则默认值为 1（纯色）。如果值小于 0，则默认值为 0。如果值大于 1，则默认值为 1。
		 */
		public static const LINK_ALPHA:String = "link.alpha";
		/**
		 * 用于指定要使用哪种缩放模式的 LineScaleMode 类的值： 
		 * <ul>
		 * <li><b>LineScaleMode.NORMAL</b> - 在缩放对象时总是缩放线条的粗细（默认值）。</li> 
		 * <li><b>LineScaleMode.NONE</b> - 从不缩放线条粗细。 </li>
		 * <li><b>LineScaleMode.VERTICAL</b> - 如果仅 垂直缩放对象，则不缩放线条粗细。例如，考虑下面的圆形，它们是用一个像素的线条绘制的，每个圆的 scaleMode 参数都被设置为 LineScaleMode.VERTICAL。左边的圆仅在垂直方向上缩放，而右边的圆则同时在垂直和水平方向上缩放：</li> 
		 * <li><b>LineScaleMode.HORIZONTAL</b> - 如果仅 水平缩放对象，则不缩放线条粗细。例如，考虑下面的圆形，它们是用一个像素的线条绘制的，每个圆的 scaleMode 参数都被设置为 LineScaleMode.HORIZONTAL。左边的圆仅在水平方向上缩放，而右边的圆则同时在垂直和水平方向上缩放：</li> 
		 * </ul>
		 **/
		public static const LINK_SCALE_MODE:String = "link.scale.mode";
		/**
		 * 当设置的Styles.LINK_TYPE属性值为Consts.LINK_TYPE_ORTHOGONAL时，作为判断是水平直线和垂直直线的最小差距间隔比，默认宽高比为1.5.
		 */
		public static const LINK_ORTHOGONAL_DISTANCE_RATIO:String = "link.orthogonal.distance.ratio";
		/**
		 * 当设置的Styles.LINK_TYPE属性值为Consts.LINK_TYPE_ORTHOGONAL时,link连线的直角弯曲像素，默认为20像素.
		 */
		public static const LINK_ORTHOGONAL_CORNER:String = "link.orthogonal.corner";
		/**
		 * link的一端距离fromNode(或toNode)中心点的距离。默认为20.
		 */
		public static const LINK_BUNDLE_OFFSET:String = "link.bundle.offset";
		public static const LINK_HANDLER_DIRECTION:String = "link.handler.direction";
		public static const LINK_HANDLER_ITALIC:String = "link.handler.italic";
		/**
		 * 线条的十六进制颜色值（例如，红色为 0xFF0000，蓝色为 0x0000FF 等）。
		 * 如果未指明值，则默认值为 2652072(蓝色)。可选。
		 */
		public static const LINK_COLOR:String = "link.color";
		/**
		 * 是否在link上显示方向箭头,布尔类型,默认为true。
		 */
		public static const LINK_SHOW_ARROW:String = "link.show.arrow";
		/**
		 * link上显示的箭头颜色,uint类型,默认数值为2652072(蓝色).
		 */
		public static const LINK_ARROW_COLOR:String = "link.arrow.color";
		public static const LINK_FROM_YOFFSET:String = "link.from.yoffset";
		public static const LINK_HANDLER_UNDERLINE:String = "link.handler.underline";
		public static const LINK_HANDLER_GRADIENT_ALPHA:String = "link.handler.gradient.alpha";
		public static const LINK_HANDLER_POINTER_LENGTH:String = "link.handler.pointer.length";
		public static const LINK_TO_POSITION:String = "link.to.position";
		public static const LINK_HANDLER_EMBED:String = "link.handler.embed";
		public static const LINK_CORNER_XRADIUS:String = "link.xradius";
		public static const LINK_TO_AT_EDGE:String = "link.to.at.edge";
		public static const LINK_HANDLER_GRADIENT:String = "link.handler.gradient";
		public static const LINK_HANDLER_COLOR:String = "link.handler.color";
		public static const LINK_TO_XOFFSET:String = "link.to.xoffset";
		public static const LINK_HANDLER_BOLD:String = "link.handler.bold";
		/**
		 * LINK_BUNDLE_GAP属性只作为和右侧Node之间的间隔使用。这样的话，最右侧的Node不需要计算LINK_BUNDLE_GAP值。<br>
		 * 默认值为12。
		 */
		public static const LINK_BUNDLE_GAP:String = "link.bundle.gap";
		public static const LINK_FROM_AT_EDGE:String = "link.from.at.edge";
		public static const LINK_HANDLER_CORNER_RADIUS:String = "link.handler.corner.radius";
		public static const LINK_LOOPED_TYPE:String = "link.looped.type";
		public static const LINK_SPLIT_VALUE:String = "link.split.value";
		public static const LINK_EXTEND:String = "link.extend";
		public static const LINK_FROM_XOFFSET:String = "link.from.xoffset";
		/**
		 * 用于指定是否提示笔触采用完整像素的布尔值。
		 * 它同时影响曲线锚点的位置以及线条笔触大小本身。
		 * 在 pixelHinting 设置为 true 的情况下，线条宽度会调整到完整像素宽度。
		 * 在 pixelHinting 设置为 false 的情况下，对于曲线和直线可能会出现脱节。<br><br>
		 * 例如，下面的插图显示了 Flash Player 或 Adobe AIR 如何呈现两个相同的圆角矩形，不
		 * 同之处是 lineStyle() 方法中使用的 pixelHinting 参数的设置不同（图像已放大 200% 以强调差异）： <br><br>
		 * 如果未提供值，则线条不使用像素提示。
		 */
		public static const LINK_PIXEL_HINTING:String = "link.pixel.hinting";
		public static const LINK_HANDLER_YOFFSET:String = "link.handler.yoffset";
		public static const LINK_BUNDLE_ID:String = "link.bundle.id";
		/**
		 * 用于指定线条末端处端点类型的 CapsStyle 类的值。有效值为：CapsStyle.NONE、CapsStyle.ROUND 和 CapsStyle.SQUARE。如果未指示值，则 Flash 使用圆头端点。 <br><br>
		 * 例如，以下图示显示了不同的 capsStyle 设置。对于每种设置，插图显示了一条粗细为 30 的蓝色线条（应用 capsStyle 的线条），以及重叠于其上的粗细为 1 的黑色线条（未应用 capsStyle 的线条）： 
		 */
		public static const LINK_CAPS_STYLE:String = "link.caps.style";
		public static const LINK_LOOPED_GAP:String = "link.looped.gap";
		/**
		 * Link连接虚线，值类型为Array数组，且length必须等于2.<br>
		 * 示例:<code>link.setStyle(Styles.LINK_PATTERN,[15,6])</code>,其中15意味着每一段虚线的长度为15像素，6意味着每段虚线间隔6像素。
		 */
		public static const LINK_PATTERN:String = "link.pattern";
		public static const LINK_HANDLER_POSITION:String = "link.handler.position";
		public static const LINK_SPLIT_PERCENT:String = "link.split.percent";
		/**
		 * link连接线的类型,可选为默认为普通直线(<code>Consts.LINK_TYPE_PARALLEL</code>类型）。
		 */
		public static const LINK_TYPE:String = "link.type";
		public static const LINK_CONTROL_POINT:String = "link.control.point";
		public static const LINK_HANDLER_FONT:String = "link.handler.font";
		public static const LINK_HANDLER_GRADIENT_COLOR:String = "link.handler.gradient.color";
		/**
		 * 一个整数，以磅为单位表示线条的粗细；有效值为 0 到 255。
		 * 如果未指定数字，或者未定义该参数，则不绘制线条。
		 * 如果传递的值小于 0，则默认值为 0。
		 * 值 0 表示极细的粗细；最大粗细为 255。如果传递的值大于 255，则默认值为 255。
		 */
		public static const LINK_WIDTH:String = "link.width";
		public static const LINK_CORNER_YRADIUS:String = "link.yradius";
		public static const LINK_BUNDLE_EXPANDED:String = "link.bundle.expanded";
		public static const LINK_HANDLER_FILL:String = "link.handler.fill";
		public static const LINK_TO_YOFFSET:String = "link.to.yoffset";
		public static const LINK_LOOPED_DIRECTION:String = "link.looped.direction";
		public static const LINK_HANDLER_FILL_COLOR:String = "link.handler.fill.color";
		public static const LINK_HANDLER_POINTER_WIDTH:String = "link.handler.pointer.width";
		public static const LINK_CORNER:String = "link.corner";
		public static const LINK_FROM_POSITION:String = "link.from.position";
		public static const LINK_BUNDLE_INDEPENDENT:String = "link.bundle.independent";
		//***************************************************************************************
		//
		//   OUTER
		//
		//***************************************************************************************
		public static const OUTER_STYLE:String = "outer.style";
		public static const OUTER_QUALITY:String = "outer.quality";
		public static const OUTER_WIDTH:String = "outer.width";
		public static const OUTER_INNER:String = "outer.inner";
		public static const OUTER_HIDEOBJECT:String = "outer.hideobject";
		public static const OUTER_SCALE_MODE:String = "outer.scale.mode";
		public static const OUTER_PADDING_TOP:String = "outer.padding.top";
		public static const OUTER_COLOR:String = "outer.color";
		public static const OUTER_SHAPE:String = "outer.shape";
		public static const OUTER_PADDING_RIGHT:String = "outer.padding.right";
		public static const OUTER_DISTANCE:String = "outer.distance";
		public static const OUTER_ANGLE:String = "outer.angle";
		public static const OUTER_PADDING:String = "outer.padding";
		public static const OUTER_ALPHA:String = "outer.alpha";
		public static const OUTER_PADDING_LEFT:String = "outer.padding.left";
		public static const OUTER_CAPS_STYLE:String = "outer.caps.style";
		public static const OUTER_KNOCKOUT:String = "outer.knockout";
		public static const OUTER_PIXEL_HINTING:String = "outer.pixel.hinting";
		public static const OUTER_PADDING_BOTTOM:String = "outer.padding.bottom";
		public static const OUTER_JOINT_STYLE:String = "outer.joint.style";
		public static const OUTER_STRENGTH:String = "outer.strength";
		public static const OUTER_BLURX:String = "outer.blurx";
		public static const OUTER_BLURY:String = "outer.blury";
		//***************************************************************************************
		//
		//   SELECT
		//
		//***************************************************************************************
		public static const SELECT_ANGLE:String = "select.angle";
		public static const SELECT_DISTANCE:String = "select.distance";
		public static const SELECT_PADDING_BOTTOM:String = "select.padding.bottom";
		public static const SELECT_ALPHA:String = "select.alpha";
		public static const SELECT_QUALITY:String = "select.quality";
		public static const SELECT_PIXEL_HINTING:String = "select.pixel.hinting";
		public static const SELECT_PADDING_TOP:String = "select.padding.top";
		public static const SELECT_KNOCKOUT:String = "select.knockout";
		public static const SELECT_PADDING_LEFT:String = "select.padding.left";
		public static const SELECT_HIDEOBJECT:String = "select.hideobject";
		public static const SELECT_SCALE_MODE:String = "select.scale.mode";
		public static const SELECT_BLURY:String = "select.blury";
		public static const SELECT_BLURX:String = "select.blurx";
		public static const SELECT_STRENGTH:String = "select.strength";
		public static const SELECT_STYLE:String = "select.style";
		public static const SELECT_WIDTH:String = "select.width";
		public static const SELECT_INNER:String = "select.inner";
		public static const SELECT_CAPS_STYLE:String = "select.caps.style";
		public static const SELECT_PADDING_RIGHT:String = "select.padding.right";
		/**
		 * node或link的选中边框发光颜色，默认值为Consts.COLOR_DARK。
		 */
		public static const SELECT_COLOR:String = "select.color";
		public static const SELECT_JOINT_STYLE:String = "select.joint.style";
		public static const SELECT_PADDING:String = "select.padding";
		public static const SELECT_SHAPE:String = "select.shape";
		/**
		 * 闪烁效果的高亮颜色
		 */
		public static const HIGH_LIGHT_COLOR:String = "high.light.color";
		/**
		 * 闪烁效果的第二种高亮颜色
		 */
		public static const SECOND_HIGH_LIGHT_COLOR:String = "second.high.light.color";
		/**
		 * 多选时闪烁效果的高亮颜色
		 */
		public static const MULTISELECT_COLOR:String = "selected.color";
		//***************************************************************************************
		//
		//   VECTOR
		//
		//***************************************************************************************
		public static const VECTOR_CAPS_STYLE:String = "vector.caps.style";
		public static const VECTOR_GRADIENT_RECT:String = "vector.gradient.rect";
		public static const VECTOR_GRADIENT_COLOR:String = "vector.gradient.color";
		public static const VECTOR_JOINT_STYLE:String = "vector.joint.style";
		public static const VECTOR_PADDING:String = "vector.padding";
		public static const VECTOR_PADDING_LEFT:String = "vector.padding.left";
		public static const VECTOR_OUTLINE_WIDTH:String = "vector.outline.width";
		/**
		 * 当前Styles.CONTENT_TYPE样式值为以下之一时:
		 * <ul>
		 * <li>Consts.CONTENT_TYPE_VECTOR</li>
		 * <li>Consts.CONTENT_TYPE_DEFAULT_VECTOR</li>
		 * <li>Consts.CONTENT_TYPE_VECTOR_DEFAULT</li>
		 * </ul>将显示指定VECTOR_SHAPE图形形状。<br>
		 * VECTOR_SHAPE属性值有以下几种：
		 * <ul>
		 * <li>Consts.SHAPE_RECTANGLE</li>
		 * <li>Consts.SHAPE_OVAL</li>
		 * <li>Consts.SHAPE_ROUNDRECT</li>
		 * <li>Consts.SHAPE_STAR</li>
		 * <li>Consts.SHAPE_TRIANGLE</li>
		 * <li>Consts.SHAPE_CIRCLE</li>
		 * <li>Consts.SHAPE_HEXAGON</li>
		 * <li>Consts.SHAPE_PENTAGON</li>
		 * <li>Consts.SHAPE_DIAMOND</li>
		 * </ul>
		 */
		public static const VECTOR_SHAPE:String = "vector.shape";
		public static const VECTOR_GRADIENT_ALPHA:String = "vector.gradient.alpha";
		public static const VECTOR_FILL_COLOR:String = "vector.fill.color";
		public static const VECTOR_PADDING_RIGHT:String = "vector.padding.right";
		public static const VECTOR_DEEP:String = "vector.deep";
		public static const VECTOR_PADDING_TOP:String = "vector.padding.top";
		public static const VECTOR_OUTLINE_COLOR:String = "vector.outline.color";
		/**
		 * Vector图形绘制时是否填充图形，默认为true。
		 */
		public static const VECTOR_FILL:String = "vector.fill";
		public static const VECTOR_FILL_ALPHA:String = "vector.fill.alpha";
		public static const VECTOR_SCALE_MODE:String = "vector.scale.mode";
		public static const VECTOR_ROUNDRECT_RADIUS:String = "vector.roundrect.radius";
		public static const VECTOR_PADDING_BOTTOM:String = "vector.padding.bottom";
		public static const VECTOR_OUTLINE_ALPHA:String = "vector.outline.alpha";
		public static const VECTOR_GRADIENT:String = "vector.gradient";
		public static const VECTOR_PIXEL_HINTING:String = "vector.pixel.hinting";
		public static const VECTOR_OUTLINE_PATTERN:String = "vector.outline.pattern";
		//***************************************************************************************
		//
		//   TREE
		//
		//***************************************************************************************
        public static const TREE_ALARM_XOFFSET:String = "tree.alarm.xoffset";
        public static const TREE_MESSAGE:String = "tree.message";
		public static const TREE_MESSAGE_GRADIENT_ALPHA:String = "tree.message.gradient.alpha";
		public static const TREE_ICON_HEIGHT:String = "tree.icon.height";
		public static const TREE_ICONS_GAP:String = "tree.icons.gap";
        public static const TREE_ALARM_GRADIENT:String = "tree.alarm.gradient";
        public static const TREE_MESSAGE_ITALIC:String = "tree.message.italic";
		public static const TREE_ICON_PADDING:String = "tree.icon.padding";
		public static const TREE_MESSAGE_SCALE_MODE:String = "tree.message.scale.mode";
		public static const TREE_MESSAGE_PERCENT:String = "tree.message.percent";
		public static const TREE_ALARM_GRADIENT_ALPHA:String = "tree.alarm.gradient.alpha";
		public static const TREE_MESSAGE_YPADDING:String = "tree.message.ypadding";
		public static const TREE_MESSAGE_FONT:String = "tree.message.font";
		public static const TREE_ALARM_SHAPE:String = "tree.alarm.shape";
		public static const TREE_MESSAGE_FILL_ALPHA:String = "tree.message.fill.alpha";
		public static const TREE_MESSAGE_DEEP:String = "tree.message.deep";
		public static const TREE_LAYOUT_GAP:String = "tree.layout.gap";
		public static const TREE_MESSAGE_BACKGROUND_COLOR:String = "tree.message.background.color";
		public static const TREE_MESSAGE_PIXEL_HINTING:String = "tree.message.pixel.hinting";
		public static const TREE_MESSAGE_BOLD:String = "tree.message.bold";
		public static const TREE_LABEL:String = "tree.label";
		public static const TREE_LABEL_COLOR:String = "tree.label.color";
		public static const TREE_LABEL_BORDER:String = "tree.label.border";
		public static const TREE_MESSAGE_GRADIENT:String = "tree.message.gradient";
		public static const TREE_ALARM_OUTLINE_ALPHA:String = "tree.alarm.outline.alpha";
		public static const TREE_ALARM_WIDTH:String = "tree.alarm.width";
		public static const TREE_MESSAGE_JOINT_STYLE:String = "tree.message.joint.style";
		public static const TREE_MESSAGE_FILL_COLOR:String = "tree.message.fill.color";
		public static const TREE_ALARM_GRADIENT_COLOR:String = "tree.alarm.gradient.color";
		public static const TREE_MESSAGE_CAPS_STYLE:String = "tree.message.caps.style";
		public static const TREE_LABEL_BOLD:String = "tree.label.bold";
		public static const TREE_MESSAGE_SIZE:String = "tree.message.size";
		public static const TREE_LABEL_UNDERLINE:String = "tree.label.underline";
		public static const TREE_MESSAGE_WIDTH:String = "tree.message.width";
		public static const TREE_MESSAGE_XPADDING:String = "tree.message.xpadding";
		public static const TREE_MESSAGE_OUTLINE_COLOR:String = "tree.message.outline.color";
		public static const TREE_ALARM_FILL_ALPHA:String = "tree.alarm.fill.alpha";
		public static const TREE_ALARM_OUTLINE_COLOR:String = "tree.alarm.outline.color";
		public static const TREE_ICONS_COLORS:String = "tree.icons.colors";
		public static const TREE_MESSAGE_EMBED:String = "tree.message.embed";
		public static const TREE_OUTER_STYLE:String = "tree.outer.style";
		public static const TREE_OUTER_WIDTH:String = "tree.outer.width";
		public static const TREE_ALARM_HEIGHT:String = "tree.alarm.height";
		public static const TREE_MESSAGE_COLOR:String = "tree.message.color";
		public static const TREE_LABEL_FONT:String = "tree.label.font";
		public static const TREE_LABEL_EMBED:String = "tree.label.embed";
		public static const TREE_ICONS_NAMES:String = "tree.icons.names";
		public static const TREE_MESSAGE_OUTLINE_ALPHA:String = "tree.message.outline.alpha";
		public static const TREE_MESSAGE_BACKGROUND_ALPHA:String = "tree.message.background.alpha";
		public static const TREE_LABEL_SIZE:String = "tree.label.size";
		public static const TREE_ALARM_FILL_COLOR:String = "tree.alarm.fill.color";
		public static const TREE_LAYOUT:String = "tree.layout";
        public static const TREE_MESSAGE_UNDERLINE:String = "tree.message.underline";
        public static const TREE_ALARM_POSITION:String = "tree.alarm.position";
        public static const TREE_MESSAGE_OUTLINE_WIDTH:String = "tree.message.outline.width";
        public static const TREE_ALARM_YOFFSET:String = "tree.alarm.yoffset";
        public static const TREE_ALARM_OUTLINE_WIDTH:String = "tree.alarm.outline.width";
		public static const TREE_MESSAGE_SHAPE:String = "tree.message.shape";
		public static const TREE_MESSAGE_GRADIENT_COLOR:String = "tree.message.gradient.color";
		public static const TREE_LABEL_ITALIC:String = "tree.label.italic";
        public static const TREE_ICON_WIDTH:String = "tree.icon.width";
		
		//***************************************************************************************
		//
		//   OTHERS
		//
		//***************************************************************************************
		/**
		 * 节点类型，可能的值为:
		 * <ul>
		 * <li>Consts.CONTENT_TYPE_VECTOR 根据Styles.VECTOR_SHAPE样式值绘画指定的Vector图形。</li>
		 * <li>Consts.CONTENT_TYPE_NONE 暂未完成，目前不作任何处理。</li>
		 * <li>Consts.CONTENT_TYPE_DEFAULT_VECTOR 意味着先绘画Vector图形(Styles.VECTOR_SHAPE样式属性值指定)后绘画image指定的图片。</li>
		 * <li>Consts.CONTENT_TYPE_VECTOR_DEFAULT 意味着先绘画image指定的图片后先绘画Vector图形(Styles.VECTOR_SHAPE样式属性值指定)后。</li>
		 * </ul>
		 * 默认为Consts.CONTENT_TYPE_DEFAULT。
		 */
		public static const CONTENT_TYPE:String = "content.type";
        public static const SHAPENODE_PATTERN:String = "shapenode.pattern";
        public static const SHAPENODE_CLOSED:String = "shapenode.closed";
        public static const SHAPELINK_TYPE:String = "shapelink.type";
        public static const WHOLE_ALPHA:String = "whole.alpha";
        public static const BUS_STYLE:String = "bus.style";
        public static const NETWORK_LABEL:String = "network.label";
		
        private static const inited:Boolean = initStyles();

		private static var  styleMap:Object;
		
        public function Styles()
        {
        }

        private static function registerProperty(property:String, newValue:Object, type:String = null, cdata:Boolean = false) : void
        {
            register(property, newValue, type, cdata, false);
            return;
        }

		/**
		 * 获取默认的样式属性
		 */
        public static function getStyle(property:String):*
        {
            return styleMap[property];
        }

		/**
		 * 设置默认的样式属性。
		 */
        public static function setStyle(property:String, newValue:Object) : void
        {
			if(styleMap ==null){
				styleMap = new Object();
			}
            if (property == null)
            {
                throw new Error("setStyle() property参数不能为空");
            }
            if (newValue == null)
            {
                delete styleMap[property];
            }
            else
            {
                styleMap[property] = newValue;
            }
            return;
        }

        public static function register(property:String, newValue:Object, type:String = null, cdata:Boolean = false, overrideExist:Boolean = true) : void
        {
            if (property == null)
            {
                throw new Error("register() property参数不能为空");
            }
            if (type == null)
            {
                if (newValue is Number)
                {
                    type = Consts.TYPE_NUMBER;
                }
                else if (newValue is String)
                {
                    type = Consts.TYPE_STRING;
                }
                else if (newValue is Boolean)
                {
                    type = Consts.TYPE_BOOLEAN;
                }
                else
                {
                    throw new Error("can not resolve type for \'" + property + "\' style property");
                }
            }
            setStyle(property, newValue);
            SerializationSettings.registerGlobalStyle(property, type, cdata, overrideExist);
            return;
        }

		/**
		 * 初始化默认样式
		 */
        public static function initStyles() : Boolean
        {
            SerializationSettings.registerGlobalProperty("id", Consts.TYPE_STRING, false, false);
            SerializationSettings.registerGlobalProperty("name", Consts.TYPE_STRING, true, false);
			SerializationSettings.registerGlobalProperty("label", Consts.TYPE_STRING, true, false);
            SerializationSettings.registerGlobalProperty("icon", Consts.TYPE_STRING, false, false);
            SerializationSettings.registerGlobalProperty("toolTip", Consts.TYPE_STRING, true, false);
            SerializationSettings.registerGlobalProperty("parent", Consts.TYPE_DATA, false, false);
            SerializationSettings.registerGlobalProperty("layerID", Consts.TYPE_STRING, false, false);
            SerializationSettings.registerGlobalProperty("alarmState", Consts.TYPE_ALARMSTATE, false, false);
            SerializationSettings.registerGlobalProperty("image", Consts.TYPE_STRING, false, false);
            SerializationSettings.registerGlobalProperty("location", Consts.TYPE_POINT, false, false);
            SerializationSettings.registerGlobalProperty("width", Consts.TYPE_NUMBER, false, false);
            SerializationSettings.registerGlobalProperty("height", Consts.TYPE_NUMBER, false, false);
            SerializationSettings.registerGlobalProperty("expanded", Consts.TYPE_BOOLEAN, false, false);
            SerializationSettings.registerGlobalProperty("host", Consts.TYPE_DATA, false, false);
            SerializationSettings.registerGlobalProperty("fromNode", Consts.TYPE_DATA, false, false);
            SerializationSettings.registerGlobalProperty("toNode", Consts.TYPE_DATA, false, false);
            SerializationSettings.registerGlobalProperty("points", Consts.TYPE_COLLECTION_POINT, false, false);
            SerializationSettings.registerGlobalProperty("segments", Consts.TYPE_COLLECTION_STRING, false, false);
            registerProperty(NETWORK_LABEL, null, Consts.TYPE_STRING, true);
//            registerProperty(TREE_LAYOUT, Consts.TREE_LAYOUT_LABEL_ICONS_MESSAGE);
//            registerProperty(TREE_LAYOUT_GAP, 2);
//            registerProperty(TREE_ICON_PADDING, 1);
//            registerProperty(TREE_ICON_WIDTH, 18);
//            registerProperty(TREE_ICON_HEIGHT, 18);
//            registerProperty(TREE_OUTER_WIDTH, 2);
//            registerProperty(TREE_OUTER_STYLE, Consts.OUTER_STYLE_BORDER);
//            registerProperty(TREE_ICONS_NAMES, null, Consts.TYPE_ARRAY_STRING);
//            registerProperty(TREE_ICONS_COLORS, null, Consts.TYPE_ARRAY_NUMBER);
//            registerProperty(TREE_ICONS_GAP, 1);
//            registerProperty(TREE_ALARM_SHAPE, Consts.SHAPE_CIRCLE);
//            registerProperty(TREE_ALARM_WIDTH, 8);
//            registerProperty(TREE_ALARM_HEIGHT, 8);
//            registerProperty(TREE_ALARM_POSITION, Consts.POSITION_BOTTOMLEFT_TOPRIGHT);
//            registerProperty(TREE_ALARM_XOFFSET, 0);
//            registerProperty(TREE_ALARM_YOFFSET, 0);
//            registerProperty(TREE_ALARM_FILL_COLOR, null, Consts.TYPE_NUMBER);
//            registerProperty(TREE_ALARM_FILL_ALPHA, 1);
//            registerProperty(TREE_ALARM_OUTLINE_COLOR, Consts.COLOR_WHITE);
//            registerProperty(TREE_ALARM_OUTLINE_ALPHA, 0.7);
//            registerProperty(TREE_ALARM_OUTLINE_WIDTH, -1);
//            registerProperty(TREE_ALARM_GRADIENT, Consts.GRADIENT_RADIAL_NORTHEAST);
//            registerProperty(TREE_ALARM_GRADIENT_COLOR, Consts.COLOR_WHITE);
//            registerProperty(TREE_ALARM_GRADIENT_ALPHA, 1);
//            registerProperty(TREE_LABEL, null, Consts.TYPE_STRING, true);
//            registerProperty(TREE_LABEL_SIZE, null, Consts.TYPE_NUMBER);
//            registerProperty(TREE_LABEL_COLOR, null, Consts.TYPE_NUMBER);
//            registerProperty(TREE_LABEL_FONT, Defaults.FONT_FAMILY, Consts.TYPE_STRING);
//            registerProperty(TREE_LABEL_EMBED, Defaults.FONT_EMBED);
//            registerProperty(TREE_LABEL_ITALIC, false);
//            registerProperty(TREE_LABEL_BOLD, false);
//            registerProperty(TREE_LABEL_UNDERLINE, false);
//            registerProperty(TREE_LABEL_BORDER, false);
//            registerProperty(TREE_MESSAGE, null, Consts.TYPE_STRING, true);
//            registerProperty(TREE_MESSAGE_COLOR, null, Consts.TYPE_NUMBER);
//            registerProperty(TREE_MESSAGE_SIZE, null, Consts.TYPE_NUMBER);
//            registerProperty(TREE_MESSAGE_FONT, Defaults.FONT_FAMILY, Consts.TYPE_STRING);
//            registerProperty(TREE_MESSAGE_EMBED, Defaults.FONT_EMBED);
//            registerProperty(TREE_MESSAGE_ITALIC, false);
//            registerProperty(TREE_MESSAGE_BOLD, false);
//            registerProperty(TREE_MESSAGE_UNDERLINE, false);
//            registerProperty(TREE_MESSAGE_SHAPE, Consts.SHAPE_ROUNDRECT);
//            registerProperty(TREE_MESSAGE_FILL_ALPHA, 1);
//            registerProperty(TREE_MESSAGE_FILL_COLOR, 16776960);
//            registerProperty(TREE_MESSAGE_OUTLINE_WIDTH, -1);
//            registerProperty(TREE_MESSAGE_OUTLINE_COLOR, Consts.COLOR_BLACK);
//            registerProperty(TREE_MESSAGE_OUTLINE_ALPHA, 1);
//            registerProperty(TREE_MESSAGE_DEEP, 0);
//            registerProperty(TREE_MESSAGE_JOINT_STYLE, Defaults.JOINT_STYLE);
//            registerProperty(TREE_MESSAGE_CAPS_STYLE, Defaults.CAPS_STYLE);
//            registerProperty(TREE_MESSAGE_SCALE_MODE, Defaults.SCALE_MODE);
//            registerProperty(TREE_MESSAGE_PIXEL_HINTING, Defaults.PIXEL_HINTING);
//            registerProperty(TREE_MESSAGE_GRADIENT, Consts.GRADIENT_SPREAD_NORTH);
//            registerProperty(TREE_MESSAGE_GRADIENT_COLOR, Consts.COLOR_WHITE);
//            registerProperty(TREE_MESSAGE_GRADIENT_ALPHA, 1);
//            registerProperty(TREE_MESSAGE_XPADDING, 2);
//            registerProperty(TREE_MESSAGE_YPADDING, 0);
//            registerProperty(TREE_MESSAGE_PERCENT, 1);
//            registerProperty(TREE_MESSAGE_WIDTH, null, Consts.TYPE_NUMBER);
//            registerProperty(TREE_MESSAGE_BACKGROUND_COLOR, null, Consts.TYPE_NUMBER);
//            registerProperty(TREE_MESSAGE_BACKGROUND_ALPHA, 1);
            registerProperty(WHOLE_ALPHA, 1);
            registerProperty(CONTENT_TYPE, Consts.CONTENT_TYPE_DEFAULT);
//            registerProperty(BACKGROUND_TYPE, Consts.BACKGROUND_TYPE_NONE);
            registerProperty(BACKGROUND_IMAGE, null, Consts.TYPE_STRING);
            registerProperty(BACKGROUND_IMAGE_SCOPE, Consts.SCOPE_VIEWSIZE);
//            registerProperty(BACKGROUND_IMAGE_STRETCH, Consts.STRETCH_NORTHWEST);
            registerProperty(BACKGROUND_IMAGE_PADDING, 0);
            registerProperty(BACKGROUND_IMAGE_PADDING_LEFT, 0);
            registerProperty(BACKGROUND_IMAGE_PADDING_RIGHT, 0);
            registerProperty(BACKGROUND_IMAGE_PADDING_TOP, 0);
            registerProperty(BACKGROUND_IMAGE_PADDING_BOTTOM, 0);
            registerProperty(BACKGROUND_IMAGE_SHAPE, Consts.SHAPE_RECTANGLE);
            registerProperty(BACKGROUND_IMAGE_OUTLINE_WIDTH, -1);
            registerProperty(BACKGROUND_IMAGE_OUTLINE_COLOR, Consts.COLOR_BLACK);
            registerProperty(BACKGROUND_IMAGE_OUTLINE_ALPHA, 1);
            registerProperty(BACKGROUND_IMAGE_CAPS_STYLE, Defaults.CAPS_STYLE);
            registerProperty(BACKGROUND_IMAGE_JOINT_STYLE, Defaults.JOINT_STYLE);
            registerProperty(BACKGROUND_IMAGE_SCALE_MODE, Defaults.SCALE_MODE);
            registerProperty(BACKGROUND_IMAGE_PIXEL_HINTING, Defaults.PIXEL_HINTING);
            registerProperty(BACKGROUND_VECTOR_FILL, true);
            registerProperty(BACKGROUND_VECTOR_FILL_COLOR, 13421823);
            registerProperty(BACKGROUND_VECTOR_FILL_ALPHA, 1);
            registerProperty(BACKGROUND_VECTOR_SCOPE, Consts.SCOPE_VIEWSIZE);
            registerProperty(BACKGROUND_VECTOR_SHAPE, Consts.SHAPE_RECTANGLE);
            registerProperty(BACKGROUND_VECTOR_OUTLINE_WIDTH, -1);
            registerProperty(BACKGROUND_VECTOR_OUTLINE_COLOR, Consts.COLOR_DARK);
            registerProperty(BACKGROUND_VECTOR_OUTLINE_ALPHA, 1);
            registerProperty(BACKGROUND_VECTOR_DEEP, 0);
            registerProperty(BACKGROUND_VECTOR_CAPS_STYLE, Defaults.CAPS_STYLE);
            registerProperty(BACKGROUND_VECTOR_JOINT_STYLE, Defaults.JOINT_STYLE);
            registerProperty(BACKGROUND_VECTOR_SCALE_MODE, Defaults.SCALE_MODE);
            registerProperty(BACKGROUND_VECTOR_PIXEL_HINTING, Defaults.PIXEL_HINTING);
            registerProperty(BACKGROUND_VECTOR_GRADIENT, Consts.GRADIENT_NONE);
            registerProperty(BACKGROUND_VECTOR_GRADIENT_COLOR, Consts.COLOR_WHITE);
            registerProperty(BACKGROUND_VECTOR_GRADIENT_ALPHA, 1);
            registerProperty(BACKGROUND_VECTOR_PADDING, 0);
            registerProperty(BACKGROUND_VECTOR_PADDING_LEFT, 0);
            registerProperty(BACKGROUND_VECTOR_PADDING_RIGHT, 0);
            registerProperty(BACKGROUND_VECTOR_PADDING_TOP, 0);
            registerProperty(BACKGROUND_VECTOR_PADDING_BOTTOM, 0);
//            registerProperty(IMAGE_STRETCH, Consts.STRETCH_UNIFORM);
            registerProperty(IMAGE_PADDING, 0);
            registerProperty(IMAGE_PADDING_LEFT, 0);
            registerProperty(IMAGE_PADDING_RIGHT, 0);
            registerProperty(IMAGE_PADDING_TOP, 0);
            registerProperty(IMAGE_PADDING_BOTTOM, 0);
            registerProperty(IMAGE_SHAPE, Consts.SHAPE_RECTANGLE);
            registerProperty(IMAGE_OUTLINE_WIDTH, -1);
            registerProperty(IMAGE_OUTLINE_COLOR, Consts.COLOR_BLACK);
            registerProperty(IMAGE_OUTLINE_ALPHA, 1);
            registerProperty(IMAGE_CAPS_STYLE, Defaults.CAPS_STYLE);
            registerProperty(IMAGE_JOINT_STYLE, Defaults.JOINT_STYLE);
            registerProperty(IMAGE_SCALE_MODE, Defaults.SCALE_MODE);
            registerProperty(IMAGE_PIXEL_HINTING, Defaults.PIXEL_HINTING);
//            registerProperty(SELECT_STYLE, Consts.SELECT_STYLE_SHADOW);
            registerProperty(SELECT_COLOR, Consts.COLOR_DARK);
			registerProperty(HIGH_LIGHT_COLOR, Consts.COLOR_RED);
			registerProperty(SECOND_HIGH_LIGHT_COLOR, Consts.COLOR_YELLOW);
			registerProperty(MULTISELECT_COLOR, Consts.COLOR_DARK);
            registerProperty(SELECT_ALPHA, 0.7);
            registerProperty(SELECT_DISTANCE, 4);
            registerProperty(SELECT_ANGLE, 45);
            registerProperty(SELECT_QUALITY, Consts.QUALITY_HIGH);
            registerProperty(SELECT_INNER, false);
            registerProperty(SELECT_KNOCKOUT, false);
            registerProperty(SELECT_STRENGTH, 1);
            registerProperty(SELECT_BLURX, 4);
            registerProperty(SELECT_BLURY, 4);
            registerProperty(SELECT_HIDEOBJECT, false);
            registerProperty(SELECT_SHAPE, Consts.SHAPE_RECTANGLE);
            registerProperty(SELECT_PADDING, -1);
            registerProperty(SELECT_PADDING_LEFT, 0);
            registerProperty(SELECT_PADDING_RIGHT, 0);
            registerProperty(SELECT_PADDING_TOP, 0);
            registerProperty(SELECT_PADDING_BOTTOM, 0);
            registerProperty(SELECT_WIDTH, 2);
            registerProperty(SELECT_SCALE_MODE, Defaults.SCALE_MODE);
            registerProperty(SELECT_PIXEL_HINTING, Defaults.PIXEL_HINTING);
            registerProperty(SELECT_JOINT_STYLE, Defaults.JOINT_STYLE);
            registerProperty(SELECT_CAPS_STYLE, Defaults.CAPS_STYLE);
            registerProperty(INNER_STYLE, Consts.INNER_STYLE_DYE);
            registerProperty(INNER_COLOR, null, Consts.TYPE_NUMBER);
            registerProperty(INNER_ALPHA, 1);
            registerProperty(INNER_SHAPE, Consts.SHAPE_RECTANGLE);
            registerProperty(INNER_OUTLINE_COLOR, Consts.COLOR_GRAY);
            registerProperty(INNER_OUTLINE_ALPHA, 1);
            registerProperty(INNER_OUTLINE_WIDTH, 1);
            registerProperty(INNER_GRADIENT, Consts.GRADIENT_NONE);
            registerProperty(INNER_GRADIENT_COLOR, Consts.COLOR_WHITE);
            registerProperty(INNER_GRADIENT_ALPHA, 1);
            registerProperty(INNER_BACK, true);
            registerProperty(INNER_PADDING, -2);
            registerProperty(INNER_PADDING_LEFT, 0);
            registerProperty(INNER_PADDING_RIGHT, 0);
            registerProperty(INNER_PADDING_TOP, 0);
            registerProperty(INNER_PADDING_BOTTOM, 0);
//            registerProperty(OUTER_STYLE, Consts.OUTER_STYLE_BORDER);
            registerProperty(OUTER_COLOR, null, Consts.TYPE_NUMBER);
            registerProperty(OUTER_ALPHA, 1);
            registerProperty(OUTER_DISTANCE, 4);
            registerProperty(OUTER_ANGLE, 45);
            registerProperty(OUTER_QUALITY, Consts.QUALITY_HIGH);
            registerProperty(OUTER_INNER, false);
            registerProperty(OUTER_KNOCKOUT, false);
            registerProperty(OUTER_STRENGTH, 2);
            registerProperty(OUTER_BLURX, 6);
            registerProperty(OUTER_BLURY, 6);
            registerProperty(OUTER_HIDEOBJECT, false);
            registerProperty(OUTER_SHAPE, Consts.SHAPE_RECTANGLE);
            registerProperty(OUTER_WIDTH, 2);
            registerProperty(OUTER_SCALE_MODE, Defaults.SCALE_MODE);
            registerProperty(OUTER_PIXEL_HINTING, Defaults.PIXEL_HINTING);
            registerProperty(OUTER_JOINT_STYLE, Defaults.JOINT_STYLE);
            registerProperty(OUTER_CAPS_STYLE, Defaults.CAPS_STYLE);
            registerProperty(OUTER_PADDING, -1);
            registerProperty(OUTER_PADDING_LEFT, 0);
            registerProperty(OUTER_PADDING_RIGHT, 0);
            registerProperty(OUTER_PADDING_TOP, 0);
            registerProperty(OUTER_PADDING_BOTTOM, 0);
            registerProperty(ICONS_NAMES, null, Consts.TYPE_ARRAY_STRING);
            registerProperty(ICONS_COLORS, null, Consts.TYPE_ARRAY_NUMBER);
            registerProperty(ICONS_POSITION, Consts.POSITION_TOPLEFT_BOTTOMRIGHT);
            registerProperty(ICONS_ORIENTATION, Consts.ORIENTATION_RIGHT);
            registerProperty(ICONS_XOFFSET, 0);
            registerProperty(ICONS_YOFFSET, 0);
            registerProperty(ICONS_XGAP, 1);
            registerProperty(ICONS_YGAP, 1);
            registerProperty(LABEL_ALPHA, 1);
			registerProperty(LABEL_SELECTED_COLOR,0xff0000,Consts.TYPE_NUMBER);
            registerProperty(LABEL_HTML, false);
            registerProperty(LABEL_SIZE, Defaults.FONT_SIZE);
            registerProperty(LABEL_COLOR, 0x000000, Consts.TYPE_NUMBER);
            registerProperty(LABEL_FONT, Defaults.FONT_FAMILY, Consts.TYPE_STRING);
            registerProperty(LABEL_EMBED, Defaults.FONT_EMBED);
            registerProperty(LABEL_ITALIC, false);
            registerProperty(LABEL_BOLD, false);
            registerProperty(LABEL_UNDERLINE, false);
            registerProperty(LABEL_CORNER_RADIUS, 0);
            registerProperty(LABEL_POINTER_LENGTH, 0);
            registerProperty(LABEL_POINTER_WIDTH, Defaults.ATTACHMENT_POINTER_WIDTH);
            registerProperty(LABEL_POSITION, Consts.POSITION_BOTTOM_BOTTOM);
//            registerProperty(LABEL_DIRECTION, Consts.ATTACHMENT_DIRECTION_BELOW);
            registerProperty(LABEL_XOFFSET, Defaults.ATTACHMENT_XOFFSET);
            registerProperty(LABEL_YOFFSET, Defaults.ATTACHMENT_YOFFSET);
            registerProperty(LABEL_PADDING, Defaults.ATTACHMENT_PADDING);
            registerProperty(LABEL_PADDING_LEFT, Defaults.ATTACHMENT_PADDING_LEFT);
            registerProperty(LABEL_PADDING_RIGHT, Defaults.ATTACHMENT_PADDING_RIGHT);
            registerProperty(LABEL_PADDING_TOP, Defaults.ATTACHMENT_PADDING_TOP);
            registerProperty(LABEL_PADDING_BOTTOM, Defaults.ATTACHMENT_PADDING_BOTTOM);
            registerProperty(LABEL_FILL, false);
            registerProperty(LABEL_FILL_COLOR, Consts.COLOR_GRAY);
            registerProperty(LABEL_FILL_ALPHA, 0.5);
            registerProperty(LABEL_GRADIENT, null, Consts.TYPE_STRING);
            registerProperty(LABEL_GRADIENT_COLOR, Consts.COLOR_WHITE);
            registerProperty(LABEL_GRADIENT_ALPHA, 0.5);
            registerProperty(LABEL_CONTENT_XSCALE, 1);
            registerProperty(LABEL_CONTENT_YSCALE, 1);
            registerProperty(LABEL_OUTLINE_WIDTH, Defaults.ATTACHMENT_OUTLINE_WIDTH);
            registerProperty(LABEL_OUTLINE_COLOR, Defaults.ATTACHMENT_OUTLINE_COLOR);
            registerProperty(LABEL_OUTLINE_ALPHA, Defaults.ATTACHMENT_OUTLINE_ALPHA);
            registerProperty(ALARM_ALPHA, 1);
            registerProperty(ALARM_HTML, false);
            registerProperty(ALARM_SIZE, Defaults.FONT_SIZE);
            registerProperty(ALARM_COLOR, null, Consts.TYPE_NUMBER);
            registerProperty(ALARM_FONT, Defaults.FONT_FAMILY, Consts.TYPE_STRING);
            registerProperty(ALARM_EMBED, Defaults.FONT_EMBED);
            registerProperty(ALARM_ITALIC, false);
            registerProperty(ALARM_BOLD, false);
            registerProperty(ALARM_UNDERLINE, false);
            registerProperty(ALARM_CORNER_RADIUS, Defaults.ATTACHMENT_CORNER_RADIUS);
            registerProperty(ALARM_POINTER_LENGTH, Defaults.ATTACHMENT_POINTER_LENGTH);
            registerProperty(ALARM_POINTER_WIDTH, Defaults.ATTACHMENT_POINTER_WIDTH);
            registerProperty(ALARM_POSITION, Consts.POSITION_HOTSPOT);
//            registerProperty(ALARM_DIRECTION, Consts.ATTACHMENT_DIRECTION_ABOVE_RIGHT);
            registerProperty(ALARM_XOFFSET, Defaults.ATTACHMENT_XOFFSET);
            registerProperty(ALARM_YOFFSET, Defaults.ATTACHMENT_YOFFSET);
            registerProperty(ALARM_PADDING, Defaults.ATTACHMENT_PADDING);
            registerProperty(ALARM_PADDING_LEFT, Defaults.ATTACHMENT_PADDING_LEFT);
            registerProperty(ALARM_PADDING_RIGHT, Defaults.ATTACHMENT_PADDING_RIGHT);
            registerProperty(ALARM_PADDING_TOP, Defaults.ATTACHMENT_PADDING_TOP);
            registerProperty(ALARM_PADDING_BOTTOM, Defaults.ATTACHMENT_PADDING_BOTTOM);
            registerProperty(ALARM_FILL_ALPHA, 1);
            registerProperty(ALARM_GRADIENT, Consts.GRADIENT_RADIAL_SOUTH);
            registerProperty(ALARM_GRADIENT_COLOR, Consts.COLOR_WHITE);
            registerProperty(ALARM_GRADIENT_ALPHA, 1);
            registerProperty(ALARM_CONTENT_XSCALE, 1);
            registerProperty(ALARM_CONTENT_YSCALE, 1);
            registerProperty(ALARM_OUTLINE_WIDTH, Defaults.ATTACHMENT_OUTLINE_WIDTH);
            registerProperty(ALARM_OUTLINE_COLOR, Defaults.ATTACHMENT_OUTLINE_COLOR);
            registerProperty(ALARM_OUTLINE_ALPHA, Defaults.ATTACHMENT_OUTLINE_ALPHA);
            registerProperty(ALARM_SHADOW_ALPHA, 0.4);
            registerProperty(ALARM_SHADOW_COLOR, 0);
            registerProperty(ALARM_SHADOW_DISTANCE, 4);
            registerProperty(ALARM_SHADOW_ANGLE, 45);
            registerProperty(VECTOR_SHAPE, Consts.SHAPE_RECTANGLE);
            registerProperty(VECTOR_FILL, true);
            registerProperty(VECTOR_FILL_ALPHA, 1);
            registerProperty(VECTOR_FILL_COLOR, 13421823);
            registerProperty(VECTOR_OUTLINE_WIDTH, -1);
            registerProperty(VECTOR_OUTLINE_PATTERN, null, Consts.TYPE_ARRAY_NUMBER);
            registerProperty(VECTOR_OUTLINE_COLOR, Consts.COLOR_DARK);
            registerProperty(VECTOR_OUTLINE_ALPHA, 1);
            registerProperty(VECTOR_DEEP, 0);
            registerProperty(VECTOR_CAPS_STYLE, Defaults.CAPS_STYLE);
            registerProperty(VECTOR_JOINT_STYLE, Defaults.JOINT_STYLE);
            registerProperty(VECTOR_SCALE_MODE, Defaults.SCALE_MODE);
            registerProperty(VECTOR_PIXEL_HINTING, Defaults.PIXEL_HINTING);
            registerProperty(VECTOR_GRADIENT, Consts.GRADIENT_NONE);
            registerProperty(VECTOR_GRADIENT_COLOR, Consts.COLOR_WHITE);
            registerProperty(VECTOR_GRADIENT_ALPHA, 1);
            registerProperty(VECTOR_GRADIENT_RECT, null, Consts.TYPE_RECTANGLE);
            registerProperty(VECTOR_PADDING, 0);
            registerProperty(VECTOR_PADDING_LEFT, 0);
            registerProperty(VECTOR_PADDING_RIGHT, 0);
            registerProperty(VECTOR_PADDING_TOP, 0);
            registerProperty(VECTOR_PADDING_BOTTOM, 0);
            registerProperty(VECTOR_ROUNDRECT_RADIUS, -1);
            registerProperty(LINK_CAPS_STYLE, Defaults.CAPS_STYLE);
            registerProperty(LINK_JOINT_STYLE, Defaults.JOINT_STYLE);
            registerProperty(LINK_SCALE_MODE, Defaults.SCALE_MODE);
			registerProperty(LINK_ORTHOGONAL_DISTANCE_RATIO, 1.5);
			registerProperty(LINK_ORTHOGONAL_CORNER, 20);
            registerProperty(LINK_PIXEL_HINTING, Defaults.PIXEL_HINTING);
            registerProperty(LINK_TYPE, Consts.LINK_TYPE_PARALLEL);
            registerProperty(LINK_PATTERN, null, Consts.TYPE_ARRAY_NUMBER);
            registerProperty(LINK_EXTEND, 20);
            registerProperty(LINK_SPLIT_PERCENT, 0.5);
            registerProperty(LINK_SPLIT_VALUE, 15);
            registerProperty(LINK_BUNDLE_ID, 0, Consts.TYPE_INT);
            registerProperty(LINK_BUNDLE_ENABLE, true);
            registerProperty(LINK_BUNDLE_EXPANDED, true);
            registerProperty(LINK_BUNDLE_INDEPENDENT, false);
            registerProperty(LINK_BUNDLE_OFFSET, 20);
            registerProperty(LINK_BUNDLE_GAP, 12);
            registerProperty(LINK_LOOPED_GAP, 6);
            registerProperty(LINK_LOOPED_DIRECTION, Consts.DIRECTION_NORTH_WEST);
//            registerProperty(LINK_LOOPED_TYPE, Consts.LINK_LOOPED_TYPE_ARC);
            registerProperty(LINK_COLOR, Consts.COLOR_DEFAULT);
			
			registerProperty(LINK_ARROW_COLOR, Consts.COLOR_DEFAULT);
			registerProperty(LINK_SHOW_ARROW,true);
			
            registerProperty(LINK_WIDTH, 3);
            registerProperty(LINK_ALPHA, 1);
            registerProperty(LINK_FROM_POSITION, Consts.POSITION_CENTER);
            registerProperty(LINK_FROM_XOFFSET, 0);
            registerProperty(LINK_FROM_YOFFSET, 0);
            registerProperty(LINK_TO_POSITION, Consts.POSITION_CENTER);
            registerProperty(LINK_TO_XOFFSET, 0);
            registerProperty(LINK_TO_YOFFSET, 0);
            registerProperty(LINK_SPLIT_BY_PERCENT, false);
            registerProperty(LINK_CONTROL_POINT, null, Consts.TYPE_POINT);
            registerProperty(LINK_HANDLER_FONT, Defaults.FONT_FAMILY, Consts.TYPE_STRING);
            registerProperty(LINK_HANDLER_EMBED, Defaults.FONT_EMBED);
            registerProperty(LINK_HANDLER_COLOR, null, Consts.TYPE_NUMBER);
            registerProperty(LINK_HANDLER_SIZE, Defaults.FONT_SIZE);
            registerProperty(LINK_HANDLER_ITALIC, false);
            registerProperty(LINK_HANDLER_BOLD, false);
            registerProperty(LINK_HANDLER_UNDERLINE, false);
            registerProperty(LINK_HANDLER_POSITION, Consts.POSITION_TOPLEFT_TOPLEFT);
            registerProperty(LINK_HANDLER_XOFFSET, 0);
            registerProperty(LINK_HANDLER_YOFFSET, 0);
            registerProperty(LINK_HANDLER_CORNER_RADIUS, 0);
            registerProperty(LINK_HANDLER_POINTER_LENGTH, 0);
            registerProperty(LINK_HANDLER_POINTER_WIDTH, Defaults.ATTACHMENT_POINTER_WIDTH);
//            registerProperty(LINK_HANDLER_DIRECTION, Consts.ATTACHMENT_DIRECTION_BELOW);
            registerProperty(LINK_HANDLER_FILL, false);
            registerProperty(LINK_HANDLER_FILL_COLOR, Consts.COLOR_GRAY);
            registerProperty(LINK_HANDLER_FILL_ALPHA, 1);
            registerProperty(LINK_HANDLER_GRADIENT, null, Consts.TYPE_STRING);
            registerProperty(LINK_HANDLER_GRADIENT_COLOR, Consts.COLOR_WHITE);
            registerProperty(LINK_HANDLER_GRADIENT_ALPHA, 1);
            registerProperty(LINK_CORNER_XRADIUS, 8);
            registerProperty(LINK_CORNER_YRADIUS, 8);
//            registerProperty(LINK_CORNER, Consts.LINK_CORNER_ROUND);
            registerProperty(LINK_FROM_AT_EDGE, true);
            registerProperty(LINK_TO_AT_EDGE, true);
            registerProperty(ARROW_FROM, false);
            registerProperty(ARROW_FROM_FILL, true);
//            registerProperty(ARROW_FROM_SHAPE, Consts.ARROW_STANDARD);
            registerProperty(ARROW_FROM_COLOR, 0, Consts.TYPE_INT);
            registerProperty(ARROW_FROM_ALPHA, 1, Consts.TYPE_NUMBER);
            registerProperty(ARROW_FROM_XOFFSET, 0);
            registerProperty(ARROW_FROM_YOFFSET, 0);
            registerProperty(ARROW_FROM_WIDTH, 12);
            registerProperty(ARROW_FROM_HEIGHT, 9);
            registerProperty(ARROW_FROM_OUTLINE_COLOR, 0, Consts.TYPE_INT);
            registerProperty(ARROW_FROM_OUTLINE_ALPHA, 1, Consts.TYPE_NUMBER);
            registerProperty(ARROW_FROM_OUTLINE_WIDTH, -1);
            registerProperty(ARROW_FROM_OUTLINE_PATTERN, null, Consts.TYPE_ARRAY_NUMBER);
            registerProperty(ARROW_FROM_AT_EDGE, true);
            registerProperty(ARROW_TO, false);
            registerProperty(ARROW_TO_FILL, true);
//            registerProperty(ARROW_TO_SHAPE, Consts.ARROW_STANDARD);
            registerProperty(ARROW_TO_COLOR, 0, Consts.TYPE_INT);
            registerProperty(ARROW_TO_ALPHA, 1, Consts.TYPE_NUMBER);
            registerProperty(ARROW_TO_XOFFSET, 0);
            registerProperty(ARROW_TO_YOFFSET, 0);
            registerProperty(ARROW_TO_WIDTH, 12);
            registerProperty(ARROW_TO_HEIGHT, 9);
            registerProperty(ARROW_TO_OUTLINE_COLOR, 0, Consts.TYPE_INT);
            registerProperty(ARROW_TO_OUTLINE_ALPHA, 1, Consts.TYPE_NUMBER);
            registerProperty(ARROW_TO_OUTLINE_WIDTH, -1);
            registerProperty(ARROW_TO_OUTLINE_PATTERN, null, Consts.TYPE_ARRAY_NUMBER);
            registerProperty(ARROW_TO_AT_EDGE, true);
            registerProperty(GROUP_SHAPE, Consts.SHAPE_RECTANGLE);
            registerProperty(GROUP_FILL, true);
            registerProperty(GROUP_FILL_ALPHA, 1);
            registerProperty(GROUP_FILL_COLOR, 13421823);
            registerProperty(GROUP_OUTLINE_WIDTH, 1);
            registerProperty(GROUP_OUTLINE_COLOR, Consts.COLOR_DARK);
            registerProperty(GROUP_OUTLINE_ALPHA, 1);
            registerProperty(GROUP_DEEP, 0);
            registerProperty(GROUP_CAPS_STYLE, Defaults.CAPS_STYLE);
            registerProperty(GROUP_JOINT_STYLE, Defaults.JOINT_STYLE);
            registerProperty(GROUP_SCALE_MODE, Defaults.SCALE_MODE);
            registerProperty(GROUP_PIXEL_HINTING, Defaults.PIXEL_HINTING);
            registerProperty(GROUP_GRADIENT, null, Consts.TYPE_STRING);
            registerProperty(GROUP_GRADIENT_COLOR, Consts.COLOR_WHITE);
            registerProperty(GROUP_GRADIENT_ALPHA, 1);
            registerProperty(GROUP_PADDING, -3);
            registerProperty(GROUP_PADDING_LEFT, 0);
            registerProperty(GROUP_PADDING_RIGHT, 0);
            registerProperty(GROUP_PADDING_TOP, 0);
            registerProperty(GROUP_PADDING_BOTTOM, 0);
            registerProperty(FOLLOWER_ROW_INDEX, 0);
            registerProperty(FOLLOWER_COLUMN_INDEX, 0);
            registerProperty(FOLLOWER_ROW_SPAN, 1);
            registerProperty(FOLLOWER_COLUMN_SPAN, 1);
            registerProperty(FOLLOWER_PADDING, 0);
            registerProperty(FOLLOWER_PADDING_LEFT, 0);
            registerProperty(FOLLOWER_PADDING_RIGHT, 0);
            registerProperty(FOLLOWER_PADDING_TOP, 0);
            registerProperty(FOLLOWER_PADDING_BOTTOM, 0);
            registerProperty(GRID_ROW_COUNT, 1);
            registerProperty(GRID_COLUMN_COUNT, 1);
            registerProperty(GRID_ROW_PERCENTS, null, Consts.TYPE_ARRAY_NUMBER);
            registerProperty(GRID_COLUMN_PERCENTS, null, Consts.TYPE_ARRAY_NUMBER);
            registerProperty(GRID_BORDER, 1);
            registerProperty(GRID_BORDER_LEFT, 0);
            registerProperty(GRID_BORDER_RIGHT, 0);
            registerProperty(GRID_BORDER_TOP, 0);
            registerProperty(GRID_BORDER_BOTTOM, 0);
            registerProperty(GRID_PADDING, 1);
            registerProperty(GRID_PADDING_LEFT, 0);
            registerProperty(GRID_PADDING_RIGHT, 0);
            registerProperty(GRID_PADDING_TOP, 0);
            registerProperty(GRID_PADDING_BOTTOM, 0);
            registerProperty(GRID_FILL, true);
            registerProperty(GRID_FILL_COLOR, Consts.COLOR_GRAY);
            registerProperty(GRID_FILL_ALPHA, 1);
            registerProperty(GRID_DEEP, 1);
            registerProperty(GRID_CELL_DEEP, -1);
            registerProperty(SHAPENODE_PATTERN, null, Consts.TYPE_ARRAY_NUMBER);
            registerProperty(SHAPENODE_CLOSED, false);
//            registerProperty(BUS_STYLE, Consts.BUS_STYLE_NEARBY);
//            registerProperty(SHAPELINK_TYPE, Consts.SHAPELINK_TYPE_LINETO);
            return true;
        }

    }
}
