package com.laifeng.view.input.main
{
	import com.laifeng.controls.LFExtenrnalInterface;
	import com.laifeng.view.input.BIButton;
	import com.laifeng.view.input.BInputEvent;
	import com.laifeng.view.input.LanguageMark;
	import com.laifeng.view.input.LocationCaret;
	import com.laifeng.view.input.alert.BIAlert;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import lf.media.core.util.Util;
	
	
	public class BINormalPanel extends Sprite implements IBIMainPanel
	{
		//------显示------
		private var _input:TextField;
		private var sendBtn:BIButton;
		private var _caret:LocationCaret;
		private var _langMark:LanguageMark; 
		/**输入字数提示*/
		private var numTF:TextField;
		private var placeholdersTF:TextField;
		
		private var lastSendInfo:Object;
		private const MAX_CHAR:uint = 30;
		
		public function BINormalPanel()
		{
			super();
			
			var bg1:Shape = new Shape();
			bg1.graphics.beginFill(0x333739,0.8);
			bg1.graphics.drawRect(0,0,420,50);
			bg1.graphics.endFill();
			this.addChild(bg1);
			bg1.x = 0;
			
			var bg2:Shape = new Shape();
			bg2.graphics.beginFill(0x46464F,1);
			bg2.graphics.drawRect(0,0,275,40);
			bg2.graphics.endFill();
			this.addChild(bg2);
			bg2.x = bg1.x + 5;
			bg2.y = 5;
			
			var format:TextFormat = new TextFormat();
			format.size = 16;
			format.color = 0xFFFFFF;
			_input = new TextField();
			input.type = TextFieldType.INPUT;
			//input.type = TextFieldType.DYNAMIC;
			input.restrict = "";
			input.multiline = false;
			input.wordWrap = false;
			input.defaultTextFormat = format;
			//input.background = true;
			this.addChild(input);
			input.width = bg2.width - 25;
			input.height = 22;
			input.x = bg2.x + 2;
			input.y = bg2.y + 10;
			//input.background = true;
			
			format = new TextFormat();
			format.size = 16;
			format.color = 0x999999;
			placeholdersTF = new TextField();
			placeholdersTF.defaultTextFormat = format;
			this.addChild(placeholdersTF);
			placeholdersTF.text = "和大家聊会儿天？";
			placeholdersTF.width = input.width;
			placeholdersTF.height = input.height;
			placeholdersTF.x = input.x;
			placeholdersTF.y = input.y;
			placeholdersTF.mouseEnabled = false;
			
			format = new TextFormat();
			format.size = 14;
			numTF = new TextField();
			numTF.defaultTextFormat = format;
			this.addChild(numTF);
			numTF.text = MAX_CHAR.toString();
			numTF.textColor = 0x999999;
			numTF.width = 25;
			numTF.height = 20;
			numTF.x = bg2.x + bg2.width - 18;
			numTF.y = input.y + 2;
			numTF.mouseEnabled = numTF.selectable = false;
			
			_caret = new LocationCaret();
			this.addChild(caret);
			caret.y = input.y + 2;
			caret.hide();
			
			_langMark = new LanguageMark();
			this.addChild(langMark);
			langMark.x = bg2.x + bg2.width + 2;
			langMark.y = bg2.y;
			
			sendBtn = new BIButton("发送");
			this.addChild(sendBtn);
			sendBtn.x = langMark.x + langMark.width + 4;
			sendBtn.y = bg2.y;
			sendBtn.setLabelPosY(10);
			
			lastSendInfo = new Object;
			lastSendInfo.text = "";
			lastSendInfo.time = -99999;

		}
		
		public function open():void
		{
			this.visible = true;
			sendBtn.addEventListener(MouseEvent.CLICK, onClickSendBtn);
		}
		
		public function close():void
		{
			this.visible = false;
			sendBtn.removeEventListener(MouseEvent.CLICK, onClickSendBtn);
		}
		
		public function reset():void
		{
			caret.x = input.x + 2;
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
			var now:int = getTimer();
			if (msg == lastSendInfo.text && (now - lastSendInfo.time < 15000))
			{
				this.dispatchEvent(new BInputEvent(BInputEvent.ALERT_MESSAGE, {type:BIAlert.TYPE_BTN_0, text:"15秒内请勿重复发言", btn1Text:"", btn1Func:null}));
				return;
			}
			LFExtenrnalInterface.get.sendChatToJs(msg);
		}
		
		public function sendChatSucc():void
		{
			var now:int = getTimer();
			lastSendInfo.text = input.text;
			lastSendInfo.time = now;
			reset();
			var chatRage:int = LFExtenrnalInterface.get.getChatRate();
			if (chatRage > 0) 
				sendBtn.countDown(chatRage);
		}
		
		public function countCharNum():void
		{
			var len:int = Util.getStringBytesLength(input.text, "gb2312")/2;
			if (len > MAX_CHAR)
			{
				numTF.text = len - MAX_CHAR + "";
				numTF.textColor = 0xFF0000;
			}
			else
			{
				numTF.text = MAX_CHAR - len  + "";
				numTF.textColor = 0x999999;
			}
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
			return 0;
		}
		
		public function get imeY():int
		{
			return 0;
		}
		
		public function get panelName():String
		{
			return "NORMAL_PANEL";
		}
		
		public function get inputMiddleX():int
		{
			return input.x + input.width/2 + 20;
		}

	}
}