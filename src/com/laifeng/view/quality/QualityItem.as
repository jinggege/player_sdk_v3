package com.laifeng.view.quality
{
	import com.laifeng.utils.Util;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * 清晰度选择项
	 */
	public class QualityItem extends Sprite
	{
		
		public var index:int = 0;
		
		public function QualityItem()
		{
			super();
			
			_tf = new FL_textfild();
			this.addChild(_tf);
			_tf.label.width = 50;
			_tf.label.height = 24;
			_tf.selectable = false;
			this.mouseChildren = false;
			this.buttonMode      = true;
			_tf.y = 2;
			
		}
		
		public function set label(value:String):void{
			_tf.label.text = value;
		}
		
		public function get label():String{
			return _tf.label.text;
		}
		
		
		public function set selected(value:Boolean):void{
			_selected = value;
		}
		
		public function get selected():Boolean{
			return _selected;
		}
		
		
		
		public function set bgColor(value:uint):void{
			this.graphics.clear();
			this.graphics.beginFill(value);
			this.graphics.drawRect(0,0,_tf.width,_tf.height);
			this.graphics.endFill();
		}
		
		
		
		private var _tf:FL_textfild;
		
		
		
		private var _tfFormat:TextFormat;
		private  var _selected:Boolean = false;
		
		
	}
}