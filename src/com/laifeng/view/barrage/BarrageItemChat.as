package com.laifeng.view.barrage
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.setInterval;
	
	import lf.media.core.util.Util;
	
	public class BarrageItemChat extends Sprite implements IBarrage
	{
		private const ROW_HEIGHT:int = 35;
		private var speedX:Number = -2;
		
				
		public function BarrageItemChat()
		{
			super();
			
			this.mouseChildren = false;
			this.buttonMode = true;
			_tf.selectable = false;
			
			addChild(_tf);
			this.addEventListener(MouseEvent.MOUSE_OVER,pauseHandler);
			this.addEventListener(MouseEvent.ROLL_OUT,recoveHandler);
		}
		
		public function setInfo(info:Object):void
		{
			_label = info["info"]["m"];
		
			//如果是表情则过滤掉
//			var re:RegExp = /\[[\u4e00-\u9fa5]{1,4}\]/g;
//			_label = _label.replace(re, "");
			
			_tf.htmlText = formatHtmlStr(_fontSize,_fontColor)
			
			_tf.width =Util.getTfWidth(_tf)+10;
			_tf.height = ROW_HEIGHT;
			
			speedX += _tf.width * 0.003*-1;
			
			var isMe:Boolean = info["meId"]==info["info"]["i"]
			selfStyle(isMe);
			
			//_tf.border = true;
			//_tf.borderColor = 0xFF0000;
			_status = BarrageConfig.B_STATUS_RUNNING
			_tf.filters = [new GlowFilter(0x000000,1,2,2)];
			
		}
		
		
		public function set setFontSize(size:int):void{
			_fontSize = size;
			_tf.htmlText = formatHtmlStr(_fontSize,_fontColor)
		}
		
		
		public function set setFontColor(color:String):void{
			_fontColor = color;
			_tf.htmlText = formatHtmlStr(_fontSize,_fontColor)
		}
		

		
		private function selfStyle(isMy:Boolean):void{
			if(!isMy){return};
			this.graphics.clear();
			this.graphics.lineStyle(1.5,0xFF3300);
			this.graphics.beginFill(0x000000,0.2);
			this.graphics.drawRoundRect(-5,2,this.w+10,this.h-10,30,30);
			this.graphics.endFill();
			
		}
		
		
		
		public function get BarrageType():int
		{
			return  BarrageConfig.BARRAGE_TYPE_1;
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
				_status = BarrageConfig.B_STATUS_DEAD;
				return;
			}
			
			this.x += speedX;
		}
		
		
		
		private function formatHtmlStr(fontSize:int,fontColor:String):String{
			var html:String = "<font size='"+fontSize +"'  color='"+fontColor+"'"+"face='微软雅黑,Microsoft YaHei,Arial'>";
			html +=_label;
			html += "</font>";
			
			return html;
		}
		
		
		public function get status():String
		{
			return _status;
		}
		
		
		public function set status(value:String):void{
			_status = value;
		}
		
		
		
		private function pauseHandler(event:MouseEvent):void{
			_status = BarrageConfig.B_STATUS_PAUSE;
		}
		
		public function set pauseTime(value:int):void{
			_pauseTime = value;
		}
		
		
		private function recoveHandler(event:MouseEvent):void{
			_status = BarrageConfig.B_STATUS_RUNNING;
		}
		
		
		/**已暂停时间  单位:秒 */
		public function get pauseTime():int{
			return _pauseTime;
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
			
			if(_tf != null){
				if(this.contains(_tf)){
					this.removeChild(_tf);
				}
				
				_tf.filters = null;
			}
			
			_tf = null;
			_status = BarrageConfig.B_STATUS_DEAD;
			
			if(this.parent != null){
				this.parent.removeChild(this);
			}
			
		}

	
		
		private var _label:String = "";
		private var _tf:TextField = new TextField();
		
		private var _row:int = 0;
		private var _w:int = 0;
		private var _h:int = 0;
		private var _distribution:Object;
		
		private var _xy:Point = new Point();
		private var _wh:Point = new Point();
		
		private var _fontColor:String = "#FFFFFF";
		private var _fontSize:int = 18;
		
		private var _status:String = BarrageConfig.B_STATUS_DEAD;
		private var _pauseTime:int = 0;
		private var _isUp:Boolean = false;
		
		
		
	}
}