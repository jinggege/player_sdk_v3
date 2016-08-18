package com.laifeng.view.controlbar.base
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class QualityTitle extends Sprite
	{
		
		private const font_size:int  =12;
		
		
		public function QualityTitle()
		{
			super();
			
			addChild(_bg);
			
			_bg.graphics.beginFill(0x353737);
			_bg.graphics.drawRoundRect(0,0,40,21,20,20);
			_bg.graphics.endFill();
			
			_tf.width = 30;
			_tf.height = 20;
			addChild(_tf);
			_tf.selectable = false;
			
			_tf.x = (this.width - _tf.width)/2;
			_tf.y = (this.height - _tf.height)/2-1;
			
			this.buttonMode = true;
			
			this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
		}
		
		public function set label(value:String):void{
			_label = value;
			
			_tf.htmlText = formatHtmlStr(font_size,_default_color);
		}
		
		
		public function get label():String{
			return _label;
		}
		
		
		
		private function overHandler(event:MouseEvent):void{
			_tf.htmlText = formatHtmlStr(font_size,_over_color);
		}
		
		private function outHandler(event:MouseEvent):void{
			_tf.htmlText = formatHtmlStr(font_size,_default_color);
		}
		
		
		private function formatHtmlStr(fontSize:int,fontColor:String):String{
			var html:String = "<p align='center'><font size='"+fontSize +"'  color='"+fontColor+"'"+"face='微软雅黑,Microsoft YaHei,Arial'>";
			html +=_label;
			html += "</font></p>";
			return html;
		}
		
		
		
		private var _bg:Sprite = new Sprite();
		private var _tf:TextField = new TextField();
		private var _label:String = "";
		
		private var _default_color:String = "#CCCCCC";
		private var _over_color:String = "#FFFFFF";
		
		
	}
}