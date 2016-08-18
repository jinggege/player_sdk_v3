package com.laifeng.view.input.alert
{
	import com.laifeng.view.input.BIButton;
	import com.laifeng.view.input.BICloseButton;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class BIAlert extends Sprite
	{
		protected var bg:BIAlertBackground;
		protected var tf:TextField;
		
		protected var btn1:BIButton;
		protected var btn2:BIButton;
		
		protected var func1:Function;
		protected var func2:Function;
		
		protected var closeBtn:BICloseButton;
		protected var tsTF:TextField;
		
		protected var timeoutId:uint;
		
		public static const TYPE_BTN_0:int = 0;
		public static const TYPE_BTN_1:int = 1;
		public static const TYPE_BTN_2:int = 2;
		
		public function BIAlert()
		{
			super();
			
			bg = new BIAlertBackground();
			this.addChild(bg);
			
			tf = new TextField();
			var format:TextFormat = new TextFormat();
			format.size = 14;
			format.color = 0xFFFFFF;
			tf = new TextField();
			tf.defaultTextFormat = format;
			tf.width = 100;
			tf.height = 30;
			tf.wordWrap = false;
			tf.multiline = false;
			tf.mouseEnabled = false;
			this.addChild(tf);
			
			tsTF = new TextField();
			tsTF.text = "提示:";
			tsTF.width = 60;
			tsTF.height = 30;
			tsTF.defaultTextFormat = format;
			tsTF.textColor = 0xFFFD31;
			tsTF.mouseEnabled = false;
			this.addChild(tsTF);
			
			btn1 = new BIButton("确定", 60, 26);
			btn1.setLabelPosY(2);
			this.addChild(btn1);
			btn2 = new BIButton("取消", 60, 26, 0x818181, 0x999999);
			btn2.setLabelPosY(2);
			this.addChild(btn2);
			
			closeBtn = new BICloseButton();
			this.addChild(closeBtn);
		}
		
		
		/**
		 * 对外接口，显示警告信息
		 * @param type
		 * @param text
		 * @return 
		 * 
		 */		
		public function showMessage(type:int, text:String, 
									btn1Text:String="", btn1Func:Function=null,
									btn2Text:String="", btn2Func:Function=null):void
		{
			clearTimeout(timeoutId);
			switch(type)
			{
				case TYPE_BTN_0:
				{
					tf.text = text;
					tf.x = 8.5;
					tf.y = 6;
					tf.width = tf.textWidth + 5;
					bg.setWH( tf.width + 17, 35);
					btn1.visible = btn2.visible = false;
					closeBtn.visible = false;
					tsTF.visible = false;
					//两秒后自动消失
					timeoutId = setTimeout(close, 2000);
					break;
				}
				case TYPE_BTN_1:
				{
					tf.text = text;
					tf.x = 20;
					tf.y = 40;
					tf.width = tf.textWidth + 5;
					bg.setWH( Math.max(tf.width+40, 100), 112);
					btn1.visible = true;
					btn1.setLabel(btn1Text);
					btn1.x = (bg.width - btn1.width)/2;
					btn1.y = 70;
					func1 = btn1Func;
					btn1.addEventListener(MouseEvent.CLICK, onClickBtn1);
					btn2.visible = false;
					closeBtn.visible = true;
					closeBtn.x = bg.width - closeBtn.width - 5;
					closeBtn.y = 5;
					closeBtn.addEventListener(MouseEvent.CLICK, onClickCloseBtn);
					tsTF.visible = true;
					tsTF.x = 20;
					tsTF.y = 16;
					break;
				}
				case TYPE_BTN_2:
				{
					tf.text = text;
					tf.x = 20;
					tf.y = 20;
					tf.width = tf.textWidth + 5;
					bg.setWH( Math.max(tf.width+40, 200), 90);
					btn1.visible = true;
					btn1.setLabel(btn1Text);
					btn1.x = (bg.width - btn1.width)/2 - 45;
					btn1.y = 50;
					func1 = btn1Func;
					btn1.addEventListener(MouseEvent.CLICK, onClickBtn1);
					btn2.visible = true;
					btn2.setLabel(btn2Text);
					btn2.x = (bg.width - btn2.width)/2 + 45;
					btn2.y = btn1.y;
					func2 = btn2Func;
					btn2.addEventListener(MouseEvent.CLICK, onClickBtn2);
					closeBtn.visible = true;
					closeBtn.x = bg.width - closeBtn.width - 5;
					closeBtn.y = 5;
					closeBtn.addEventListener(MouseEvent.CLICK, onClickCloseBtn);
					tsTF.visible = false;
					break;
				}
			}
			this.visible = true;
		}
		
		public function close():void
		{
			btn1.removeEventListener(MouseEvent.CLICK, onClickBtn1);
			btn2.removeEventListener(MouseEvent.CLICK, onClickBtn2);
			closeBtn.removeEventListener(MouseEvent.CLICK, onClickCloseBtn);
			clearTimeout(timeoutId);
			
			this.visible = false;
		}
		
		protected function onClickBtn1(evt:MouseEvent):void
		{
			func1.call();
		}

		protected function onClickBtn2(evt:MouseEvent):void
		{
			func2.call();
		}
		
		protected function onClickCloseBtn(evt:MouseEvent):void
		{
			close();
		}
		
		
		
		public function get realHeight():int
		{
			return bg.height+bg.ARROWWH;
		}

	}
}


