package com.laifeng.view.input
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class LanguageMark extends Sprite
	{
		
		public static const CH:int = 1;
		public static const EN:int = 2;
		
		private var tf:TextField;
		
		/**语言状态，中文:1, 英文:2*/
		public var langState:int;
		
		public function LanguageMark(w:int=24, h:int=40)
		{
			super();
			
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0x46464F);
			bg.graphics.drawRect(0,0,w,h);
			bg.graphics.endFill();
			this.addChild(bg);
			
			var format:TextFormat = new TextFormat();
			format.size = 14;
			format.align = TextFormatAlign.CENTER;
			format.color = 0x999999;
			format.bold = true;
			tf = new TextField();
			tf.defaultTextFormat = format;
			setLanguage(CH);
			this.addChild(tf);
			tf.width = w;
			tf.height = tf.textHeight+2;
			tf.y = (bg.height - tf.height)/2;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			this.mouseChildren = false;
			this.buttonMode = true;
			
			
		}
		
		private function onMouseOver(evt:MouseEvent):void
		{
			tf.textColor = 0xD6417C;
		}
		
		private function onMouseOut(evt:MouseEvent):void
		{
			tf.textColor = 0x999999;
		}
		
		public function setLanguage(state:int):void
		{
			langState = state; 
			if (langState == CH)
				tf.text = "中";
			else
				tf.text = "英";
		}
		
	}
}