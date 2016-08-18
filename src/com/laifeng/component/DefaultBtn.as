package com.laifeng.component
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**********************************************************
	 * IChildUI
	 * 
	 * Author : mj
	 * Description:
	 *  		默认按钮
	 ***********************************************************/
	
	public class DefaultBtn extends Sprite
	{
		
		public function DefaultBtn(w:int,h:int)
		{
			super();
			
			_w = w;
			_h = h;
			
			_tf.wordWrap = false;
			
			var tff:TextFormat = new TextFormat();
			tff.font = "Microsoft YaHei";
			tff.size = 12;
			tff.align = TextFormatAlign.CENTER;
			tff.color = 0xFFFFFF;
			
			_tf.defaultTextFormat = tff;
			_tf.setTextFormat(tff);
			addChild(_tf);
			
			this.mouseChildren = false;
			this.buttonMode = true;
			
			graphicsBg();
		}
		
		public function set label(value:String):void{
			_tf.text = value;
		}
		
		
		
		public function setWH(w:int,h:int):void{
			
			graphicsBg();
		}
		
		
		private function graphicsBg():void{
			graphics.clear();
			graphics.beginFill(0x000000,0.8);
			graphics.drawRoundRect(0,0,_w,_h,10,10);
			graphics.endFill();
			
			_tf.width = _w;
			_tf.height =_h;
		}
		
		
		
		
		private var _w:int = 0;
		private var _h:int = 0;
		private var _tf:TextField = new TextField();
		
		
		
		
	}
}