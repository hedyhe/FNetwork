package com.myflexhero.network.core.util
{
	/**
	 * 画图工具包
	 */
	public class GraphicsDrawUtils extends Object
	{
		{
			private var K853K:Number = 0;
			private var K895K:Object;
			private var K893K:Number = 0;
			public var target:Object;
			private var K852K:Number = 0;
			private var K894K:Number = 0;
			private var K892K:Boolean = true;
			public var _curveaccuracy:Number = 6;
			
			public function GraphicsDrawUtils(target:Object, K852K:Number, K853K:Number)
			{
				this.target = target;
				this.setDash(K852K, K853K);
				this.K892K = true;
				this.K893K = 0;
				this.K895K = {x:0, y:0};
				return;
			}
			
			private function lineLength(K637K:Number, K862K:Number, K874K:Number, K875K:Number) : Number
			{
				var _loc_5:* = K874K - K637K;
				var _loc_6:* = K875K - K862K;
				return Math.sqrt(_loc_5 * _loc_5 + _loc_6 * _loc_6);
			}
			
			public function beginFill(K869K:Number, alpha:Number) : void
			{
				this.target.beginFill(K869K, alpha);
				return;
			}
			
			public function clear() : void
			{
				this.target.clear();
				return;
			}
			
			public function lineTo(x:Number, y:Number) : void
			{
				var _loc_10:Number = NaN;
				var _loc_11:Number = NaN;
				var _loc_12:Number = NaN;
				var _loc_13:Number = NaN;
				var _loc_14:int = 0;
				var _loc_3:* = x - this.K895K.x;
				var _loc_4:* = y - this.K895K.y;
				var _loc_5:* = Math.atan2(_loc_4, _loc_3);
				var _loc_6:* = Math.cos(_loc_5);
				var _loc_7:* = Math.sin(_loc_5);
				var _loc_8:* = this.lineLength(this.K895K.x, this.K895K.y, x, y);
				if (this.K893K)
				{
					if (this.K893K > _loc_8)
					{
						if (this.K892K)
						{
							this.K889K(x, y);
						}
						else
						{
							this.K888K(x, y);
						}
						this.K893K = this.K893K - _loc_8;
						return;
					}
					if (this.K892K)
					{
						this.K889K(this.K895K.x + _loc_6 * this.K893K, this.K895K.y + _loc_7 * this.K893K);
					}
					else
					{
						this.K888K(this.K895K.x + _loc_6 * this.K893K, this.K895K.y + _loc_7 * this.K893K);
					}
					_loc_8 = _loc_8 - this.K893K;
					this.K893K = 0;
					this.K892K = !this.K892K;
					if (!_loc_8)
					{
						return;
					}
				}
				var _loc_9:* = Math.floor(_loc_8 / this.K894K);
				if (_loc_9)
				{
					_loc_10 = _loc_6 * this.K852K;
					_loc_11 = _loc_7 * this.K852K;
					_loc_12 = _loc_6 * this.K853K;
					_loc_13 = _loc_7 * this.K853K;
					_loc_14 = 0;
					while (_loc_14 < _loc_9)
					{
						
						if (this.K892K)
						{
							this.K889K(this.K895K.x + _loc_10, this.K895K.y + _loc_11);
							this.K888K(this.K895K.x + _loc_12, this.K895K.y + _loc_13);
						}
						else
						{
							this.K888K(this.K895K.x + _loc_12, this.K895K.y + _loc_13);
							this.K889K(this.K895K.x + _loc_10, this.K895K.y + _loc_11);
						}
						_loc_14 = _loc_14 + 1;
					}
					_loc_8 = _loc_8 - this.K894K * _loc_9;
				}
				if (this.K892K)
				{
					if (_loc_8 > this.K852K)
					{
						this.K889K(this.K895K.x + _loc_6 * this.K852K, this.K895K.y + _loc_7 * this.K852K);
						this.K888K(x, y);
						this.K893K = this.K853K - (_loc_8 - this.K852K);
						this.K892K = false;
					}
					else
					{
						this.K889K(x, y);
						if (_loc_8 == this.K852K)
						{
							this.K893K = 0;
							this.K892K = !this.K892K;
						}
						else
						{
							this.K893K = this.K852K - _loc_8;
							this.K888K(x, y);
						}
					}
				}
				else if (_loc_8 > this.K853K)
				{
					this.K888K(this.K895K.x + _loc_6 * this.K853K, this.K895K.y + _loc_7 * this.K853K);
					this.K889K(x, y);
					this.K893K = this.K852K - (_loc_8 - this.K853K);
					this.K892K = true;
				}
				else
				{
					this.K888K(x, y);
					if (_loc_8 == this.K853K)
					{
						this.K893K = 0;
						this.K892K = !this.K892K;
					}
					else
					{
						this.K893K = this.K853K - _loc_8;
					}
				}
				return;
			}
			
			public function setDash(K852K:Number, K853K:Number) : void
			{
				this.K852K = K852K;
				this.K853K = K853K;
				this.K894K = this.K852K + this.K853K;
				return;
			}
			
			public function getDash() : Array
			{
				return [this.K852K, this.K853K];
			}
			
			public function curveTo(K860K:Number, cy:Number, x:Number, y:Number) : void
			{
				var _loc_10:Array = null;
				var _loc_15:int = 0;
				var _loc_5:* = this.K895K.x;
				var _loc_6:* = this.K895K.y;
				var _loc_7:* = this.K876K(_loc_5, _loc_6, K860K, cy, x, y);
				var _loc_8:Number = 0;
				var _loc_9:Number = 0;
				if (this.K893K)
				{
					if (this.K893K > _loc_7)
					{
						if (this.K892K)
						{
							this.K890K(K860K, cy, x, y);
						}
						else
						{
							this.K888K(x, y);
						}
						this.K893K = this.K893K - _loc_7;
						return;
					}
					_loc_8 = this.K893K / _loc_7;
					_loc_10 = this.K884K(_loc_5, _loc_6, K860K, cy, x, y, _loc_8);
					if (this.K892K)
					{
						this.K890K(_loc_10[2], _loc_10[3], _loc_10[4], _loc_10[5]);
					}
					else
					{
						this.K888K(_loc_10[4], _loc_10[5]);
					}
					this.K893K = 0;
					this.K892K = !this.K892K;
					if (!_loc_7)
					{
						return;
					}
				}
				var _loc_11:* = _loc_7 - _loc_7 * _loc_8;
				var _loc_12:* = Math.floor(_loc_11 / this.K894K);
				var _loc_13:* = this.K852K / _loc_7;
				var _loc_14:* = this.K853K / _loc_7;
				if (_loc_12)
				{
					_loc_15 = 0;
					while (_loc_15 < _loc_12)
					{
						
						if (this.K892K)
						{
							_loc_9 = _loc_8 + _loc_13;
							_loc_10 = this.K882K(_loc_5, _loc_6, K860K, cy, x, y, _loc_8, _loc_9);
							this.K890K(_loc_10[2], _loc_10[3], _loc_10[4], _loc_10[5]);
							_loc_8 = _loc_9;
							_loc_9 = _loc_8 + _loc_14;
							_loc_10 = this.K882K(_loc_5, _loc_6, K860K, cy, x, y, _loc_8, _loc_9);
							this.K888K(_loc_10[4], _loc_10[5]);
						}
						else
						{
							_loc_9 = _loc_8 + _loc_14;
							_loc_10 = this.K882K(_loc_5, _loc_6, K860K, cy, x, y, _loc_8, _loc_9);
							this.K888K(_loc_10[4], _loc_10[5]);
							_loc_8 = _loc_9;
							_loc_9 = _loc_8 + _loc_13;
							_loc_10 = this.K882K(_loc_5, _loc_6, K860K, cy, x, y, _loc_8, _loc_9);
							this.K890K(_loc_10[2], _loc_10[3], _loc_10[4], _loc_10[5]);
						}
						_loc_8 = _loc_9;
						_loc_15 = _loc_15 + 1;
					}
				}
				_loc_11 = _loc_7 - _loc_7 * _loc_8;
				if (this.K892K)
				{
					if (_loc_11 > this.K852K)
					{
						_loc_9 = _loc_8 + _loc_13;
						_loc_10 = this.K882K(_loc_5, _loc_6, K860K, cy, x, y, _loc_8, _loc_9);
						this.K890K(_loc_10[2], _loc_10[3], _loc_10[4], _loc_10[5]);
						this.K888K(x, y);
						this.K893K = this.K853K - (_loc_11 - this.K852K);
						this.K892K = false;
					}
					else
					{
						_loc_10 = this.K887K(_loc_5, _loc_6, K860K, cy, x, y, _loc_8);
						this.K890K(_loc_10[2], _loc_10[3], _loc_10[4], _loc_10[5]);
						if (_loc_7 == this.K852K)
						{
							this.K893K = 0;
							this.K892K = !this.K892K;
						}
						else
						{
							this.K893K = this.K852K - _loc_11;
							this.K888K(x, y);
						}
					}
				}
				else if (_loc_11 > this.K853K)
				{
					_loc_9 = _loc_8 + _loc_14;
					_loc_10 = this.K882K(_loc_5, _loc_6, K860K, cy, x, y, _loc_8, _loc_9);
					this.K888K(_loc_10[4], _loc_10[5]);
					_loc_10 = this.K887K(_loc_5, _loc_6, K860K, cy, x, y, _loc_9);
					this.K890K(_loc_10[2], _loc_10[3], _loc_10[4], _loc_10[5]);
					this.K893K = this.K852K - (_loc_11 - this.K853K);
					this.K892K = true;
				}
				else
				{
					this.K888K(x, y);
					if (_loc_11 == this.K853K)
					{
						this.K893K = 0;
						this.K892K = !this.K892K;
					}
					else
					{
						this.K893K = this.K853K - _loc_11;
					}
				}
				return;
			}
			
			public function beginGradientFill(K871K:String, K738K:Array, K872K:Array, K873K:Array, K771K:Object) : void
			{
				this.target.beginGradientFill(K871K, K738K, K872K, K873K, K771K);
				return;
			}
			
			public function lineStyle(K868K:Number, K869K:Number, alpha:Number) : void
			{
				this.target.lineStyle(K868K, K869K, alpha);
				return;
			}
			
			private function K888K(x:Number, y:Number) : void
			{
				this.K895K = {x:x, y:y};
				this.target.moveTo(x, y);
				return;
			}
			
			private function K876K(K637K:Number, K862K:Number, K860K:Number, cy:Number, K874K:Number, K875K:Number, K877K:Number = -1) : Number
			{
				var _loc_11:Number = NaN;
				var _loc_12:Number = NaN;
				var _loc_13:Number = NaN;
				var _loc_14:Number = NaN;
				var _loc_15:Number = NaN;
				var _loc_16:Number = NaN;
				var _loc_17:Number = NaN;
				var _loc_8:Number = 0;
				var _loc_9:* = K637K;
				var _loc_10:* = K862K;
				var _loc_18:* = K877K > 0 ? (K877K) : (this._curveaccuracy);
				var _loc_19:Number = 1;
				while (_loc_19 <= _loc_18)
				{
					
					_loc_13 = _loc_19 / _loc_18;
					_loc_14 = 1 - _loc_13;
					_loc_15 = _loc_14 * _loc_14;
					_loc_16 = 2 * _loc_13 * _loc_14;
					_loc_17 = _loc_13 * _loc_13;
					_loc_11 = _loc_15 * K637K + _loc_16 * K860K + _loc_17 * K874K;
					_loc_12 = _loc_15 * K862K + _loc_16 * cy + _loc_17 * K875K;
					_loc_8 = _loc_8 + this.lineLength(_loc_9, _loc_10, _loc_11, _loc_12);
					_loc_9 = _loc_11;
					_loc_10 = _loc_12;
					_loc_19 = _loc_19 + 1;
				}
				return _loc_8;
			}
			
			private function K882K(K637K:Number, K862K:Number, K860K:Number, cy:Number, K874K:Number, K875K:Number, K883K:Number, t2:Number) : Array
			{
				if (K883K == 0)
				{
					return this.K884K(K637K, K862K, K860K, cy, K874K, K875K, t2);
				}
				if (t2 == 1)
				{
					return this.K887K(K637K, K862K, K860K, cy, K874K, K875K, K883K);
				}
				var _loc_9:* = this.K884K(K637K, K862K, K860K, cy, K874K, K875K, t2);
				_loc_9.push(K883K / t2);
				return this.K887K.apply(this, _loc_9);
			}
			
			private function K890K(K860K:Number, cy:Number, x:Number, y:Number) : void
			{
				if (K860K == x)
				{
				}
				if (cy == y)
				{
				}
				if (x == this.K895K.x)
				{
				}
				if (y == this.K895K.y)
				{
					return;
				}
				this.K895K = {x:x, y:y};
				this.target.curveTo(K860K, cy, x, y);
				return;
			}
			
			public function moveTo(x:Number, y:Number) : void
			{
				this.K888K(x, y);
				return;
			}
			
			private function K884K(K637K:Number, K862K:Number, K860K:Number, cy:Number, K874K:Number, K875K:Number, t:Number) : Array
			{
				var _loc_8:Number = NaN;
				var _loc_9:Number = NaN;
				if (t != 1)
				{
					_loc_8 = K860K + (K874K - K860K) * t;
					_loc_9 = cy + (K875K - cy) * t;
					K860K = K637K + (K860K - K637K) * t;
					cy = K862K + (cy - K862K) * t;
					K874K = K860K + (_loc_8 - K860K) * t;
					K875K = cy + (_loc_9 - cy) * t;
				}
				return [K637K, K862K, K860K, cy, K874K, K875K];
			}
			
			private function K889K(x:Number, y:Number) : void
			{
				if (x == this.K895K.x)
				{
				}
				if (y == this.K895K.y)
				{
					return;
				}
				this.K895K = {x:x, y:y};
				this.target.lineTo(x, y);
				return;
			}
			
			public function endFill() : void
			{
				this.target.endFill();
				return;
			}
			
			private function K887K(K637K:Number, K862K:Number, K860K:Number, cy:Number, K874K:Number, K875K:Number, t:Number) : Array
			{
				var _loc_8:Number = NaN;
				var _loc_9:Number = NaN;
				if (t != 1)
				{
					_loc_8 = K637K + (K860K - K637K) * t;
					_loc_9 = K862K + (cy - K862K) * t;
					K860K = K860K + (K874K - K860K) * t;
					cy = cy + (K875K - cy) * t;
					K637K = _loc_8 + (K860K - _loc_8) * t;
					K862K = _loc_9 + (cy - _loc_9) * t;
				}
				return [K637K, K862K, K860K, cy, K874K, K875K];
			}
			
		}
	}

}