package com.myflexhero.network.core.animate
{
	import com.myflexhero.network.Node;
	import com.myflexhero.network.core.IData;
	
	import mx.core.UIComponent;
	
	import spark.effects.Scale;

	/**
	 * 放大缩小界面的工具类，供Network直接调用。可以自定义更改SCALE_BY值(默认为0.2,即每次放大缩小原始大小的1/5大小)和minScaleBy(所允许的最低缩小倍数,默认为0.01)。
	 * @author Hedy
	 */
	public class ScaleEffect
	{
		public var zoomInscale:Scale;
		public var zoomOutscale:Scale;
		public var zoomResetscale:Scale;
		private var zoomShowAllscale:Scale;
		/**
		 * 每次调用zoomIn()和zoomOut()方法时所放大或缩小的倍数，默认原始自身大小倍数为1，每次放大或缩小0.2大小。
		 */
		public var  SCALE_BY:Number = 0.2;
		/**
		 * 所允许的最低缩小倍数。默认最低缩小倍数为原始自身大小的0.01。
		 */
		public var minScaleBy:Number = 0.01;
		private var refreshFunction:Function;
		public function ScaleEffect(targets:Array,refreshFunction:Function)
		{
			zoomInscale = new Scale();
			zoomInscale.targets = targets;
			zoomOutscale = new Scale();
			zoomOutscale.targets = targets;
			zoomResetscale = new Scale();
			zoomResetscale.targets = targets;
			zoomShowAllscale = new Scale();
			zoomShowAllscale.targets = targets;
			zoomInscale.scaleXBy = SCALE_BY;
			zoomInscale.scaleYBy = SCALE_BY;
			zoomOutscale.scaleXBy = -SCALE_BY;
			zoomOutscale.scaleYBy = -SCALE_BY;
			zoomResetscale.scaleXTo = 1;
			zoomResetscale.scaleYTo = 1;
			
			this.refreshFunction = refreshFunction;
		}
		
		public function zoomShowAll(value:Number):void{
			zoomShowAllscale.scaleXTo = value;
			zoomShowAllscale.scaleYTo = value;
			zoomShowAllscale.play();
			resetXY();
			refreshBound();
		}
		
		public function zoomIn() : void
		{
			if(zoomOutscale.targets&&zoomOutscale.targets.length>0){
				var _target:UIComponent = zoomOutscale.targets[0];
				//允许的比例
				zoomOutscale.scaleXTo = zoomOutscale.scaleXTo+zoomOutscale.scaleXTo*SCALE_BY;
				zoomOutscale.scaleYTo =  zoomOutscale.scaleYTo+zoomOutscale.scaleYTo*SCALE_BY;
				zoomOutscale.scaleXBy = NaN;
				zoomOutscale.scaleYBy = NaN;
			}
			zoomInscale.play();
			refreshBound();
		}
		
		public function zoomOut() : void
		{
			if(zoomOutscale.targets&&zoomOutscale.targets.length>0){
				var _target:UIComponent = zoomOutscale.targets[0];
				if(_target.scaleX-SCALE_BY<=minScaleBy){
					//每次减少1/10
					zoomOutscale.scaleXTo = _target.scaleX-_target.scaleX/10;
					zoomOutscale.scaleYTo = _target.scaleY-_target.scaleY/10;
					zoomOutscale.scaleXBy = NaN;
					zoomOutscale.scaleYBy = NaN;
				}
				else{
					//允许的比例
					zoomOutscale.scaleXBy = -SCALE_BY;
					zoomOutscale.scaleYBy = -SCALE_BY;
					zoomOutscale.scaleXTo = NaN;
					zoomOutscale.scaleYTo = NaN;
				}
						
			}
			zoomOutscale.play();
			refreshBound();
		}
		
		public function zoomReset(animate:Boolean = false) : void
		{
			zoomResetscale.play();
			resetXY();
			refreshBound();
		}
		
		private function resetXY():void{
			//鼠标滚轮放大缩小后容器的x、y需归0.
			var _target:UIComponent = zoomResetscale.targets[0];
			_target.x = 0;
			_target.y = 0;
		}
		private function refreshBound():void{
			refreshFunction.call(null,
				function(data:IData):void{
					if(data is Node)
						data.dispatchPropertyChangeEvent("xy",null,null);
				});
		}
	}
}