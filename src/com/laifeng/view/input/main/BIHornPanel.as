package com.laifeng.view.input.main
{
	import com.laifeng.controls.LFExtenrnalInterface;
	import com.laifeng.view.input.BIButton;
	import com.laifeng.view.input.BICloseButton;
	import com.laifeng.view.input.BInputEvent;
	import com.laifeng.view.input.LanguageMark;
	import com.laifeng.view.input.LocationCaret;
	import com.laifeng.view.input.alert.BIAlert;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import lf.media.core.util.Tweener;
	import lf.media.core.util.Util;
	
	public class BIHornPanel extends Sprite implements IBIMainPanel
	{
		//------显示------
		private var _input:TextField;
		private var sendBtn:BIButton;
		private var _caret:LocationCaret;
		private var _langMark:LanguageMark;
		/**输入字数提示*/
		private var numTF:TextField;
		private var placeholdersTF:TextField;
		private var closeBtn:BICloseButton;
		
		private var containerSpt:Sprite;
		private var maskSpt:Sprite;
		
		private const MAX_CHAR:uint = 30;

		
		public function BIHornPanel()
		{
			super();
			
			containerSpt = new Sprite();
			this.addChild(containerSpt);
			
//			var bg1:Shape = new Shape();
//			bg1.graphics.beginFill(0x28282F,1);
//			bg1.graphics.drawRect(0,0,375,150);
//			bg1.graphics.endFill();
//			bg1.graphics.beginFill(0x28282F,1);
//			bg1.graphics.drawRect(0,100,420,50);
//			bg1.graphics.endFill();
//			containerSpt.addChild(bg1);
//			bg1.x = 0;
			
			var bg1:Shape = new Shape();
			bg1.graphics.beginFill(0x28282F,1);
			bg1.graphics.drawRect(0,0,420,150);
			bg1.graphics.endFill();
			bg1.graphics.beginFill(0x28282F,1);
			containerSpt.addChild(bg1);
			bg1.x = 0;
			
			var bg2:Shape = new Shape();
			bg2.graphics.beginFill(0x1B1B1F,1);
			bg2.graphics.drawRect(0,0,400,52);
			bg2.graphics.endFill();
			containerSpt.addChild(bg2);
			bg2.x = bg1.x + 12;
			bg2.y = bg1.y + 42;
			
			var hornBm:Bitmap = new Bitmap(new Skin2_bmp_input_horn() as BitmapData);
			containerSpt.addChild(hornBm);
			hornBm.x = bg2.x;
			hornBm.y = 12;
			
			var hornDescTF:TextField = new TextField();
			hornDescTF.htmlText = "<font size='14' color='#FFFFFF'>金喇叭</font>" +
				"<font size='12' color='#FFDD31'>（每条2000星币）<font>";
			hornDescTF.height = 30;
			hornDescTF.width = 150;
			containerSpt.addChild(hornDescTF);
			hornDescTF.x = hornBm.x + hornBm.width + 3;
			hornDescTF.y = hornBm.y + 3;
			
			var format:TextFormat = new TextFormat();
			format.size = 16;
			format.color = 0xFFFFFF;
			format.leading = 3;
			_input = new TextField();
			input.type = TextFieldType.INPUT;
			//input.type = TextFieldType.DYNAMIC;
			input.restrict = "";
			//input.multiline = true;
			input.wordWrap = true;
			input.defaultTextFormat = format;
			//input.background = true;
			//input.backgroundColor = 0xFF0000;
			containerSpt.addChild(input);
			input.text = "";
			input.width = bg2.width - 2;
			input.height = bg2.height;
			input.x = bg2.x + 2;
			input.y = bg2.y + 5;
			
			format = new TextFormat();
			format.size = 16;
			format.color = 0x999999;
			placeholdersTF = new TextField();
			placeholdersTF.defaultTextFormat = format;
			containerSpt.addChild(placeholdersTF);
			placeholdersTF.text = "请输入…"//"发送金喇叭，让土豪金文字多飞一会儿~";
			placeholdersTF.width = input.width;
			placeholdersTF.height = input.height;
			placeholdersTF.x = input.x;
			placeholdersTF.y = input.y;
			placeholdersTF.mouseEnabled = false;
			
			_caret = new LocationCaret();
			containerSpt.addChild(caret);
			caret.y = input.y + 2;
			caret.hide();
			
			numTF = new TextField();
			containerSpt.addChild(numTF);
			numTF.textColor = 0x999999;
			numTF.width = 125;
			numTF.height = 20;
			numTF.x = bg2.x;
			numTF.y = bg2.y + bg2.height + 10;
			numTF.mouseEnabled = numTF.selectable = false;
			
			sendBtn = new BIButton("发送", 60, 26);
			sendBtn.setLabelPosY(2);
			containerSpt.addChild(sendBtn);
			sendBtn.x = bg2.x + bg2.width - sendBtn.width;
			sendBtn.y = bg2.y + bg2.height + 12;
			
			_langMark = new LanguageMark(26,26);
			containerSpt.addChild(langMark);
			langMark.x = sendBtn.x - langMark.width - 10;
			langMark.y = sendBtn.y; 
			
			closeBtn = new BICloseButton();
			containerSpt.addChild(closeBtn);
			closeBtn.x = 420 - closeBtn.width - 5;
			closeBtn.y = 5;
			
			maskSpt = new Sprite();
			maskSpt.graphics.beginFill(0x0,0);
			maskSpt.graphics.drawRect(0,0,containerSpt.width,containerSpt.height);
			maskSpt.graphics.endFill();
			this.addChild(maskSpt);
			containerSpt.mask = maskSpt;
			
			countCharNum();
		}
		
		public function open():void
		{
			this.visible = true;
			containerSpt.y = maskSpt.height;
			Tweener.to(containerSpt, 0.3, {y:0});
			sendBtn.addEventListener(MouseEvent.CLICK, onClickSendBtn);
			closeBtn.addEventListener(MouseEvent.CLICK, onClickCloseBtn);
		}
		
		public function close():void
		{
			this.visible = false;
			sendBtn.removeEventListener(MouseEvent.CLICK, onClickSendBtn);
			closeBtn.removeEventListener(MouseEvent.CLICK, onClickCloseBtn);
		}
		
		public function reset():void
		{
			caret.x = input.x + 2;
			caret.y = input.y + 2;
			caret.hide();
			input.text = "";
			countCharNum();
		}
		
		private function onClickSendBtn(evt:MouseEvent):void
		{
			sendChatMsg(input.text);
		}
		
		public function sendChatMsg(msg:String):void
		{
			if (msg == "")
			{
				this.dispatchEvent(new BInputEvent(BInputEvent.ALERT_MESSAGE, {type:BIAlert.TYPE_BTN_0, text:"内容不能为空", btn1Text:"", btn1Func:null}));
				return;
			}
			var len:int = Util.getStringBytesLength(msg, "gb2312")/2;
			if (len > MAX_CHAR)
			{
				return;
			}
			LFExtenrnalInterface.get.sendHornToJs(msg);
		}
		
		public function sendChatSucc():void
		{
			reset();
		}
			
		public function countCharNum():void
		{
			var len:int = Util.getStringBytesLength(input.text, "gb2312")/2;
			if (len > MAX_CHAR)
			{
				numTF.text = "已超出" + (len - MAX_CHAR) + "个字";
				numTF.textColor = 0xF33B39;
			}
			else
			{
				numTF.text = "还可以输入" + (MAX_CHAR - len)  + "个字";
				numTF.textColor = 0x999999;
			}
		}
		
		protected function onClickCloseBtn(evt:MouseEvent):void
		{
			this.dispatchEvent(new BInputEvent(BInputEvent.CLOSE_HORN));
		}
		
		public function hidePlaceholders():void
		{
			placeholdersTF.visible = false;
		}
		
		public function showPlaceholders():void
		{
			if (input.text.length == 0)
				placeholdersTF.visible = true;
		}
		
		public function get input():TextField
		{
			return _input;
		}
		
		public function get caret():LocationCaret
		{
			return _caret;
		}
		
		public function get langMark():LanguageMark
		{
			return _langMark;
		}
				
		public function get topY():int
		{
			return this.y;
		}
		
		public function get imeY():int
		{
			return this.y;
		}
		
		public function get panelName():String
		{
			return "HORN_PANEL";
		}
		
		public function get inputMiddleX():int
		{
			return input.x + input.width/2 + 10;
		}
	}
}