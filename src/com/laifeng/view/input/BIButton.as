package com.laifeng.view.input
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	public class BIButton extends Sprite
	{
		
		private var bg1:Shape;//正常态的背景
		private var bg2:Shape;//over时的背景
		private var bg3:Shape;//unable时的背景
		private var tf:TextField;
		
		private var timer:Timer;
		private var btnLabel:String;
		
		public function BIButton(label:String, w:int=60, h:int=40,
								 nColor:uint=0xD6417C, oColor:uint=0xDA5489, uColor:uint=0x999999)
		{
			super();
			
			bg1 = new Shape();
			bg1.graphics.clear();
			bg1.graphics.beginFill(nColor);
			bg1.graphics.drawRoundRect(0,0,w,h,3,3);
			bg1.graphics.endFill();
			this.addChild(bg1);
			
			bg2 = new Shape();
			bg2.graphics.clear();
			bg2.graphics.beginFill(oColor);
			bg2.graphics.drawRoundRect(0,0,w,h,3,3);
			bg2.graphics.endFill();
			this.addChild(bg2);
			
			bg3 = new Shape();
			bg3.graphics.clear();
			bg3.graphics.beginFill(uColor);
			bg3.graphics.drawRoundRect(0,0,w,h,3,3);
			bg3.graphics.endFill();
			this.addChild(bg3);
			
			var format:TextFormat = new TextFormat();
			format.size = 14;
			format.color = 0xFFFFFF;
			format.align = TextFormatAlign.CENTER;
			format.bold = true;
			tf = new TextField();
			tf.defaultTextFormat = format;
			tf.text = btnLabel = label;
			this.addChild(tf);
			tf.width = w;
			tf.height = tf.textHeight + 4;
			tf.y = (h - tf.textHeight)/2;
			
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, onTimerRun);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);

			setOut();
			
			this.mouseChildren = false;
			this.buttonMode = true;
			
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
		}
		
		private function onMouseOut(evt:MouseEvent):void
		{
			setOut();
		}
		
		private function onMouseOver(evt:MouseEvent):void
		{
			setOver();
		}
		
		public function setOut():void
		{
			bg1.visible = true;
			bg2.visible = false;
			bg3.visible = false;
			
			tf.textColor = 0xeeeeee;
		}
		
		public function setOver():void
		{
			bg1.visible = false;
			bg2.visible = true;
			bg3.visible = false;
			
			tf.textColor = 0xffffff;
		}
		
		public function setLabel(text:String):void
		{
			tf.text = text;
			//tf.height = tf.textHeight + 4;
			//tf.y = (bg1.height - tf.textHeight)/2;
		}
		
		public function setLabelPosY(value:Number):void
		{
			tf.y = value;
		}
		
		public function setEnabled(value:Boolean):void
		{
			this.mouseEnabled = value;
			this.buttonMode = value;
			
			if (!value)
			{
				bg1.visible = false;
				bg2.visible = false;
				bg3.visible = true;
				
				this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			}
			else
			{
				setOut();
				this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
				this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			}
		}
		
		public function countDown(time:int):void
		{
			timer.reset();
			timer.repeatCount = time;
			setEnabled(false);
			timer.start();
			tf.text = time + "秒";
		}
		
		public function onTimerRun(evt:TimerEvent):void
		{
			tf.text = (timer.repeatCount - timer.currentCount) + "秒";
		}
		
		public function onTimerComplete(evt:TimerEvent):void
		{
			timer.stop();
			setEnabled(true);
			tf.text = btnLabel;
		}
		
		
	}
}