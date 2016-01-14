package com.myflexhero.network.core.ui
{
	import com.myflexhero.network.Consts;
	import com.myflexhero.network.Group;
	import com.myflexhero.network.Network;
	import com.myflexhero.network.Styles;
	import com.myflexhero.network.TrapezoidGroup;
	import com.myflexhero.network.Utils;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.utils.ColorUtil;
	/**
	 * 画平行四边形的UI包装类。如果为ParallelogramGroup元素，则画45度的角的梯形平行四边形，否则如果为TrapezoidGroup元素，则画75度的角平行四边形。
	 * @author Hedy
	 */
	public class QuadrilateralGroupUI extends GroupUI
	{
		public function QuadrilateralGroupUI(network:Network, group:Group)
		{
			super(network, group);
		}
		
		override protected function drawContent():void
		{
			if (this.group.expanded == false)
			{
				super.drawContent();
				return;
			}
			graphics.clear();
			var rect:Rectangle=this.bodyRect;
			
			var fill:Boolean=element.getStyle(Styles.GROUP_FILL) as Boolean;
			var fillColor:Number=this.getDyeColor(Styles.GROUP_FILL_COLOR);
			if (fill)
			{
				beginFill(graphics, fillColor, element.getStyle(Styles.GROUP_FILL_ALPHA), bodyRect.x, bodyRect.y, bodyRect.width, bodyRect.height, element.getStyle(Styles.GROUP_GRADIENT), element.getStyle(Styles.GROUP_GRADIENT_COLOR), element.getStyle(Styles.GROUP_GRADIENT_ALPHA));
			}
			var outlineWidth:Number=element.getStyle(Styles.GROUP_OUTLINE_WIDTH);
			if (outlineWidth >= 0)
			{
				graphics.lineStyle(element.getStyle(Styles.GROUP_OUTLINE_WIDTH), element.getStyle(Styles.GROUP_OUTLINE_COLOR), element.getStyle(Styles.GROUP_OUTLINE_ALPHA), element.getStyle(Styles.GROUP_PIXEL_HINTING), element.getStyle(Styles.GROUP_SCALE_MODE), element.getStyle(Styles.GROUP_CAPS_STYLE), element.getStyle(Styles.GROUP_JOINT_STYLE));
			}
			else
			{
				graphics.lineStyle();
			}
			var angle:Number=45;
			var deep:Number=10;
			if ((this.group as TrapezoidGroup))
			{
				angle=75;
			}
			var gap:Number=rect.height / Math.tan(Utils.toRadians(angle));
			var p1:Point=new Point(rect.x - gap, rect.y + rect.height);
			var p2:Point=new Point(rect.x + rect.width, rect.y + rect.height);
			var p3:Point=new Point(rect.x + rect.width + gap, rect.y);
			var p4:Point=new Point(rect.x, rect.y);
			if (this.group is TrapezoidGroup)
			{
				p2=new Point(rect.x + rect.width + gap, rect.y + rect.height);
				p3=new Point(rect.x + rect.width, rect.y);
			}
			graphics.moveTo(p1.x, p1.y);
			graphics.lineTo(p2.x, p2.y);
			graphics.lineTo(p3.x, p3.y);
			graphics.lineTo(p4.x, p4.y);
			graphics.endFill();
			
			
			graphics.beginFill(ColorUtil.adjustBrightness(fillColor, 10), element.getStyle(Styles.GROUP_FILL_ALPHA));
			graphics.moveTo(p1.x, p1.y);
			graphics.lineTo(p2.x, p2.y);
			graphics.lineTo(p2.x, p2.y + deep);
			graphics.lineTo(p1.x, p1.y + deep);
			graphics.endFill();
			if (!(this.group is TrapezoidGroup))
			{
				graphics.beginFill(ColorUtil.adjustBrightness(fillColor, -50), element.getStyle(Styles.GROUP_FILL_ALPHA));
				graphics.moveTo(p2.x, p2.y);
				graphics.lineTo(p3.x, p3.y);
				graphics.lineTo(p3.x, p3.y + deep);
				graphics.lineTo(p2.x, p2.y + deep);
				graphics.endFill();
			}
			
		}
		
		private function beginFill(g:Graphics, fillColor:Number, fillAlpha:Number=1, x:Number=0, y:Number=0, width:Number=0, height:Number=0, gradient:String=null, gradientColor:Number=0, gradientAlpha:Number=1):void
		{
			
			if (gradient == Consts.GRADIENT_NONE || gradient == null)
			{
				g.beginFill(fillColor, fillAlpha);
				return;
			}
			
			var focalPointRatio:Number=0;
			var gradientType:String=null;
			var colors:Array=[gradientColor, fillColor];
			var alphas:Array=[gradientAlpha, fillAlpha];
			var ratios:Array=[0, 255];
			var matrix:Matrix=new Matrix();
			var spreadMethod:String=SpreadMethod.PAD;
			
			if (gradient == Consts.GRADIENT_LINEAR_SOUTHWEST)
			{
				gradientType=GradientType.LINEAR;
				matrix.createGradientBox(width, height, -Math.PI / 4, x, y);
			}
			else if (gradient == Consts.GRADIENT_LINEAR_SOUTHEAST)
			{
				gradientType=GradientType.LINEAR;
				matrix.createGradientBox(width, height, -3 * Math.PI / 4, x, y);
			}
			else if (gradient == Consts.GRADIENT_LINEAR_NORTHWEST)
			{
				gradientType=GradientType.LINEAR;
				matrix.createGradientBox(width, height, Math.PI / 4, x, y);
			}
			else if (gradient == Consts.GRADIENT_LINEAR_NORTHEAST)
			{
				gradientType=GradientType.LINEAR;
				matrix.createGradientBox(width, height, 3 * Math.PI / 4, x, y);
			}
			else if (gradient == Consts.GRADIENT_LINEAR_NORTH)
			{
				gradientType=GradientType.LINEAR;
				matrix.createGradientBox(width, height, Math.PI / 2, x, y);
			}
			else if (gradient == Consts.GRADIENT_LINEAR_SOUTH)
			{
				gradientType=GradientType.LINEAR;
				matrix.createGradientBox(width, height, -Math.PI / 2, x, y);
			}
			else if (gradient == Consts.GRADIENT_LINEAR_WEST)
			{
				gradientType=GradientType.LINEAR;
				matrix.createGradientBox(width, height, 0, x, y);
			}
			else if (gradient == Consts.GRADIENT_LINEAR_EAST)
			{
				gradientType=GradientType.LINEAR;
				matrix.createGradientBox(width, height, Math.PI, x, y);
			}
			else if (gradient == Consts.GRADIENT_RADIAL_CENTER)
			{
				gradientType=GradientType.RADIAL;
				matrix.createGradientBox(width, height, 0, x, y);
			}
			else if (gradient == Consts.GRADIENT_RADIAL_SOUTHWEST)
			{
				gradientType=GradientType.RADIAL;
				focalPointRatio=0.75;
				matrix.createGradientBox(width, height, 3 * Math.PI / 4, x, y);
			}
			else if (gradient == Consts.GRADIENT_RADIAL_SOUTHEAST)
			{
				gradientType=GradientType.RADIAL;
				focalPointRatio=0.75;
				matrix.createGradientBox(width, height, Math.PI / 4, x, y);
			}
			else if (gradient == Consts.GRADIENT_RADIAL_NORTHWEST)
			{
				gradientType=GradientType.RADIAL;
				focalPointRatio=0.75;
				matrix.createGradientBox(width, height, -3 * Math.PI / 4, x, y);
			}
			else if (gradient == Consts.GRADIENT_RADIAL_NORTHEAST)
			{
				gradientType=GradientType.RADIAL;
				focalPointRatio=0.75;
				matrix.createGradientBox(width, height, -Math.PI / 4, x, y);
			}
			else if (gradient == Consts.GRADIENT_RADIAL_NORTH)
			{
				gradientType=GradientType.RADIAL;
				focalPointRatio=0.75;
				matrix.createGradientBox(width, height, -Math.PI / 2, x, y);
			}
			else if (gradient == Consts.GRADIENT_RADIAL_SOUTH)
			{
				gradientType=GradientType.RADIAL;
				focalPointRatio=0.75;
				matrix.createGradientBox(width, height, Math.PI / 2, x, y);
			}
			else if (gradient == Consts.GRADIENT_RADIAL_WEST)
			{
				gradientType=GradientType.RADIAL;
				focalPointRatio=0.75;
				matrix.createGradientBox(width, height, Math.PI, x, y);
			}
			else if (gradient == Consts.GRADIENT_RADIAL_EAST)
			{
				gradientType=GradientType.RADIAL;
				focalPointRatio=0.75;
				matrix.createGradientBox(width, height, 0, x, y);
			}
			else if (gradient == Consts.GRADIENT_SPREAD_HORIZONTAL)
			{
				gradientType=GradientType.LINEAR;
				matrix.createGradientBox(width, height, 0, x, y);
				colors=[fillColor, gradientColor, fillColor];
				alphas=[fillAlpha, gradientAlpha, fillAlpha];
				ratios=[0, 127, 255];
			}
			else if (gradient == Consts.GRADIENT_SPREAD_VERTICAL)
			{
				gradientType=GradientType.LINEAR;
				matrix.createGradientBox(width, height, Math.PI / 2, x, y);
				colors=[fillColor, gradientColor, fillColor];
				alphas=[fillAlpha, gradientAlpha, fillAlpha];
				ratios=[0, 127, 255];
			}
			else if (gradient == Consts.GRADIENT_SPREAD_DIAGONAL)
			{
				gradientType=GradientType.LINEAR;
				matrix.createGradientBox(width, height, -Math.atan(width / height), x, y);
				colors=[fillColor, gradientColor, fillColor];
				alphas=[fillAlpha, gradientAlpha, fillAlpha];
				ratios=[0, 127, 255];
			}
			else if (gradient == Consts.GRADIENT_SPREAD_ANTIDIAGONAL)
			{
				gradientType=GradientType.LINEAR;
				matrix.createGradientBox(width, height, Math.atan(width / height), x, y);
				colors=[fillColor, gradientColor, fillColor];
				alphas=[fillAlpha, gradientAlpha, fillAlpha];
				ratios=[0, 127, 255];
			}
			else if (gradient == Consts.GRADIENT_SPREAD_NORTH)
			{
				gradientType=GradientType.LINEAR;
				matrix.createGradientBox(width, height / 2, Math.PI / 2, x, y + height / 4);
				spreadMethod=SpreadMethod.REFLECT;
			}
			else if (gradient == Consts.GRADIENT_SPREAD_SOUTH)
			{
				gradientType=GradientType.LINEAR;
				matrix.createGradientBox(width, height / 2, Math.PI / 2, x, y + 3 * height / 4);
				spreadMethod=SpreadMethod.REFLECT;
			}
			else if (gradient == Consts.GRADIENT_SPREAD_WEST)
			{
				gradientType=GradientType.LINEAR;
				matrix.createGradientBox(width / 2, height, 0, x + width / 4, y);
				spreadMethod=SpreadMethod.REFLECT;
			}
			else if (gradient == Consts.GRADIENT_SPREAD_EAST)
			{
				gradientType=GradientType.LINEAR;
				matrix.createGradientBox(width / 2, height, 0, x + 3 * width / 4, y);
				spreadMethod=SpreadMethod.REFLECT;
			}
			
			g.beginGradientFill(gradientType, colors, alphas, ratios, matrix, spreadMethod, InterpolationMethod.RGB, focalPointRatio);
		}
		
	}
}