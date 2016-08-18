package com.laifeng.view.barrage
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import lf.media.core.util.Util;
	
	public class BarrageItemHorn extends Sprite implements IBarrage
	{
		private const speedX:int = -2;
		private const ROW_HEIGHT:int = 35;
		
		public function BarrageItemHorn()
		{
			super();
			
			this.mouseChildren = false;
			this.buttonMode      = true;
			_tf.selectable = false;
			
			addChild(_icon);
			_icon.y = 8;
			_icon.smoothing = true;
			
			addChild(_tf);
			
			_tf.x = 30;
			
			this.addEventListener(MouseEvent.MOUSE_OVER,pauseHandler);
			this.addEventListener(MouseEvent.ROLL_OUT,recoveHandler);
		}
		
		public function setInfo(info:Object):void
		{
			_label = info["info"]["n"]+"："+info["info"]["m"];
			
			var name:String = "<font size='22' color='#FFFFFF' face='微软雅黑,Microsoft YaHei,Arial'>";
			name += info["info"]["n"]+"：";
			name += "</font>";
			
			var msg:String = "<font size='22' color='#f9bf41' face='微软雅黑,Microsoft YaHei,Arial'>";
			msg+= info["info"]["m"];
			msg+="</font>";
			
			
			_tf.htmlText = name+msg;
			
			_tf.width =Util.getTfWidth(_tf)+10;
			
			_tf.height = ROW_HEIGHT;
			
			
			var isMe:Boolean = info["meId"]==info["info"]["i"]
			selfStyle(isMe);
			
			//_tf.border = true;
			//_tf.borderColor = 0xFF0000;
			
			this._status = BarrageConfig.B_STATUS_RUNNING
			
			_tf.filters = [new GlowFilter(0x000000,1,2,2)];
			
		}
		
		
		public function setIcon(bmd:BitmapData):void{
			_icon.bitmapData = bmd;
		}
		
		
		public function set setFontSize(size:int):void{
			
		}
		
		
		public function set setFontColor(color:String):void{
			
		}
		
		public function get BarrageType():int
		{
			return BarrageConfig.BARRAGE_TYPE_2;
		}
		
		
		public function setXY(offX:int,offY:int):void{
			this.x = offX;
			this.y = offY;
			
			_xy.x = this.x;
			_xy.y = this.y;
		}
		
		public function get xy():Point{
			
			_xy.x = this.x;
			_xy.y = this.y;
			return this._xy;
		}
		
		
		public function get w():int{
			return this.width;
		}
		
		
		public function get h():int{
			return this.height;
		}
		
		
		public function updata():void
		{
			
			if(status == BarrageConfig.B_STATUS_PAUSE) return;
			if(this.x + this.width <=0) {
				_status = BarrageConfig.B_STATUS_DEAD
				return;
			}
				this.x += speedX;
		}
		
		
		public function set status(value:String):void{
			_status = value;
		}
		
		public function get status():String
		{
			return _status;
		}
		
		
		
		private function pauseHandler(event:MouseEvent):void{
			_status = BarrageConfig.B_STATUS_PAUSE;
		}
		
		
		private function recoveHandler(event:MouseEvent):void{
			_status = BarrageConfig.B_STATUS_RUNNING;
			_pauseTime = 0;
		}
		
		/**已暂停时间  单位:秒 */
		public function get pauseTime():int{
			return _pauseTime;
		}
		
		public function set pauseTime(value:int):void{
			_pauseTime = value;
		}
		
		public function get isUp():Boolean
		{
			return _isUp;
		}
		
		public function set isUp(value:Boolean):void
		{
			_isUp = value;
		}
		
		
		
		public function destroy():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER,pauseHandler);
			this.removeEventListener(MouseEvent.ROLL_OUT,recoveHandler);
			
			this.removeChild(_tf);
			_tf.filters = null;
			_tf = null;
			_status = BarrageConfig.B_STATUS_DEAD;
			
			if(_icon.bitmapData != null){
				_icon.bitmapData.dispose();
				_icon.bitmapData = null;
			}
			
			if(this.contains(_icon)){
				this.removeChild(_icon);
				_icon = null;
			}
			
			if(this.parent != null){
				this.parent.removeChild(this);
			}
			
		}
		
		
		
		private function selfStyle(isMy:Boolean):void{
			if(!isMy){return};
			this.graphics.clear();
			this.graphics.lineStyle(1.5,0xFF3300);
			this.graphics.beginFill(0x000000,0.2);
			this.graphics.drawRoundRect(-4,5,this.w+5,this.h-5,30,30);
			this.graphics.endFill();
		}
		
		
		private var _label:String = "";
		private var _tf:TextField = new TextField();

		private var _row:int = 0;
		private var _w:int = 0;
		private var _h:int = 0;
		private var _distribution:Object;
		
		private var _xy:Point = new Point();
		private var _wh:Point = new Point();
		
		private var _icon:Bitmap = new Bitmap();
		
		private var _status:String = BarrageConfig.B_STATUS_DEAD;
		private var _pauseTime:int = 0;
		private var _isUp:Boolean = false;
		
		
	}
}