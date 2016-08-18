package com.laifeng.view.quality
{
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	public class QualityLabel extends Sprite
	{
		
		public var currentIndex:int = 0;
		
		
		public function QualityLabel()
		{
			super();
			
			addChild(_tf);
			_tf.label.width = 50;
			_tf.label.height = 24;
			
			
			_tfFormat = new TextFormat();
			_tfFormat.font = _myFont.fontName;
			
			_tf.label.defaultTextFormat = _tfFormat;
			_tf.label.setTextFormat(_tfFormat);
			
			_tf.selectable = false;
			this.mouseChildren = false;
			this.buttonMode = true;
			_tf.y = 5;
			
			drawRoundRect = 0x000000;
		}
		
		public function set label(value:String):void{
			_tf.label.text = value;
			_tf.y = (this.height - _tf.label.textHeight)/2 - 4; 
		}
		
		public function set bgColor(value:uint):void{
			graphics.clear();
			graphics.beginFill(value);
			graphics.drawRect(0,0,_tf.width,_tf.height);
			graphics.endFill();
		}
		
		
		public function set drawRoundRect(value:uint):void{
			
			graphics.clear();
			graphics.beginFill(value);
			graphics.drawRoundRect(0,0,50,24,10,10);
			graphics.endFill();
		}
		
		
		private var _tf:FL_textfild = new FL_textfild();
		private var _tfFormat:TextFormat;
		private var _myFont:LFFont = new LFFont();
		
		
		
	}
}