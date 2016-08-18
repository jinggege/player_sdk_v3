package com.laifeng.view.input.ime
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class HanziView extends Sprite
	{
		
		private var tf:TextField;
		private var _index:int;
		
		private var vo:HanziVO;
		
		public function HanziView()
		{
			super();
			
			var format:TextFormat = new TextFormat();
			format.size = 16;
			
			tf = new TextField();
			this.addChild(tf);
			tf.defaultTextFormat = format;
			tf.width = 30;
			tf.height = 22;
			
			this.mouseChildren = false;
			this.buttonMode = true;
		}
		
		public function setData(value:HanziVO):void
		{
			vo = value;
			if (vo != null)
			{
				tf.text = (_index+1) + ". " + vo.text;
				tf.width = tf.textWidth + 3;
			}
			else
			{
				tf.text = "";
				tf.width = 0;
			}
		}
		
		private function setColor(color:uint):void
		{
			tf.textColor = color;
		}
		
		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}
		
		public function set selected(value:Boolean):void
		{
			if (value)
				setColor(0x0099CC);//0xFF6633
			else
				setColor(0x333333);//0x0
		}

		public function get text():String
		{
			if (vo == null)
				return "";
			return vo.text;
		}
		
		public function get useLetterNum():int
		{
			if (vo == null)
				return 0;
			return vo.letterNum;
		}
		
	}
}