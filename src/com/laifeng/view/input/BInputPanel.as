package com.laifeng.view.input
{
	import com.laifeng.config.NoticeKey;
	import com.laifeng.config.UIKey;
	import com.laifeng.controls.LFExtenrnalInterface;
	import com.laifeng.controls.Notification;
	import com.laifeng.controls.UIManage;
	import com.laifeng.event.MEvent;
	import com.laifeng.interfaces.IUI;
	import com.laifeng.view.input.alert.BIAlert;
	import com.laifeng.view.input.ime.IMEPanel;
	import com.laifeng.view.input.main.BIHornPanel;
	import com.laifeng.view.input.main.BINormalPanel;
	import com.laifeng.view.input.main.IBIMainPanel;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	import lf.media.core.component.button.ButtonShape;
	
	public class BInputPanel extends Sprite implements IUI
	{
		
		//------显示------
		private var hornBtn:ButtonShape;
		private var foldBtn:ButtonShape;
		private var mainSpt:Sprite;
		
		private var normalPanel:BINormalPanel;
		private var hornPanel:BIHornPanel;
		private var currPanel:IBIMainPanel;
		
		private var unfoldBtn:ButtonShape;
		
		private var ime:IMEPanel;
		
		private var alert:BIAlert;
		
		private var loginTF:TextField;
		
		//------数据------
		/**是否在输入中*/
		private var isInputing:Boolean = false;
		
		private var _uiState:String = "";
		
		/**是否是只点击了shift键*/
		private var isShiftOnly:Boolean = true;
		private var isShiftDown:Boolean = false;
		
		public function BInputPanel()
		{
			super();
			
			mainSpt = new Sprite();
			
			foldBtn = new ButtonShape(new Skin2_btn_input_fold);
			mainSpt.addChild(foldBtn);
			
			normalPanel = new BINormalPanel();
			mainSpt.addChild(normalPanel);
			normalPanel.x = foldBtn.x + foldBtn.width;
			normalPanel.close();
			
			hornPanel = new BIHornPanel();
			mainSpt.addChild(hornPanel);
			hornPanel.x = normalPanel.x;
			hornPanel.y = normalPanel.y + normalPanel.height - hornPanel.height;
			hornPanel.close();
			
			hornBtn = new ButtonShape(new Skin2_btn_input_horn());
			mainSpt.addChild(hornBtn);
			hornBtn.x = normalPanel.x + normalPanel.width - hornBtn.width - 5;
			hornBtn.y = normalPanel.y + 5;
			
			this.addChild(mainSpt);
			
			unfoldBtn = new ButtonShape(new Skin2_btn_input_unfold());
			this.addChild(unfoldBtn);
			unfoldBtn.x = mainSpt.width - unfoldBtn.width;
			
			ime = new IMEPanel();
			this.addChild(ime);
			ime.x = 0;
			ime.y = normalPanel.y - 80;
			
			alert = new BIAlert();
			this.addChild(alert);
			alert.close();
			
			loginTF = new TextField();
			loginTF.textColor = 0xFFFFFF;
			loginTF.htmlText = "<font size='16'>马上<font color='#FFFD31'><a href='event:login'>登录</a></font>，来发弹幕~</font>";
			loginTF.width = 160;
			loginTF.selectable = false;
			mainSpt.addChild(loginTF);
			loginTF.visible = false;
			
			this.tabEnabled = false;
			this.tabChildren = false;
			
		}
		
		public function open():void
		{
			ime.hide();
			ime.addEventListener(BInputEvent.IME_VISIBLE_CHANGED, handleImeVisibleChanged);
			ime.addEventListener(BInputEvent.CLCIK_IME_HANZI, onClickImeHanzi);
			ime.addEventListener(BInputEvent.IME_TEXT_NONE, handleImeTextNone);
			ime.addEventListener(BInputEvent.IME_WIDTH_LONGER, handleImeWidthLonger);
			
			openNormalPanel();
			
			if (stage)
			{
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
			
			foldBtn.addEventListener(MouseEvent.CLICK, onClickFoldBtn);
			unfoldBtn.addEventListener(MouseEvent.CLICK, onClickUnfoldBtn);

			hornBtn.addEventListener(MouseEvent.CLICK, onClickHornBtn);
			loginTF.addEventListener(TextEvent.LINK, onClickLogin);
			
			Notification.get.addEventListener(NoticeKey.N_SEND_BARRAGE, handleSendChatSucc);
			Notification.get.addEventListener(NoticeKey.N_SENT_HORN_RESPONE, handleHornRespone);
			Notification.get.addEventListener(NoticeKey.N_SEND_CHAT_RESPONE, handleChatRespone);
			Notification.get.addEventListener(NoticeKey.N_THESAURUS_RESPONE, handleThesaurusRespone);
			
			normalPanel.reset();
			hornPanel.reset();
			alert.close();
			fold();
			this.visible = true;
			LFExtenrnalInterface.get.reqChatRate();
		}
		private function onAddedToStage():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		public function close():void
		{
			ime.hide();
			ime.removeEventListener(BInputEvent.IME_VISIBLE_CHANGED, handleImeVisibleChanged);
			ime.removeEventListener(BInputEvent.CLCIK_IME_HANZI, onClickImeHanzi);
			ime.removeEventListener(BInputEvent.IME_TEXT_NONE, handleImeTextNone);
			
			if (stage)
			{
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
			
			foldBtn.removeEventListener(MouseEvent.CLICK, onClickFoldBtn);
			unfoldBtn.removeEventListener(MouseEvent.CLICK, onClickUnfoldBtn);
			
			hornBtn.removeEventListener(MouseEvent.CLICK, onClickHornBtn);
			loginTF.removeEventListener(TextEvent.LINK, onClickLogin);
			
			
			Notification.get.removeEventListener(NoticeKey.N_SEND_BARRAGE, handleSendChatSucc);
			Notification.get.removeEventListener(NoticeKey.N_SENT_HORN_RESPONE, handleHornRespone);
			Notification.get.removeEventListener(NoticeKey.N_SEND_CHAT_RESPONE, handleChatRespone);
			Notification.get.removeEventListener(NoticeKey.N_THESAURUS_RESPONE, handleThesaurusRespone);
			
			closeCurrPanel();
			this.visible = false;
		}
		
		public function updata():void
		{
		}
		
		public function screenChange(w:int, h:int):void
		{
			this.x = w - mainWidth - 40;
			this.y = h - normalPanel.height - 120;
		}
		
		public function get level():int
		{
			return  UIKey.UI_LEVEL_2;
		}
		
		public function set uiState(value:String):void
		{
			_uiState = value;
		}
		
		public function get uiState():String
		{
			return _uiState;
		}
		
		public function destroy():void
		{
		}
		
		private function openNormalPanel():void
		{
			closeCurrPanel();
			currPanel = normalPanel;
			openCurrPanel();
			currPanel.langMark.setLanguage(hornPanel.langMark.langState);
			foldBtn.visible = true;
			loginTF.x = currPanel.input.x + 80;
			loginTF.y = currPanel.input.y;
			hornBtn.visible = true;
		}
		
		private function openHornPanel():void
		{
			closeCurrPanel();
			currPanel = hornPanel;
			openCurrPanel();
			currPanel.langMark.setLanguage(normalPanel.langMark.langState);
			foldBtn.visible = false;
			loginTF.x = currPanel.input.x + 100;
			loginTF.y = currPanel.input.y - 90;
			hornBtn.visible = false;
		}
		
		private function openCurrPanel():void
		{
			if (currPanel)
			{
				currPanel.open();
				currPanel.input.addEventListener(FocusEvent.FOCUS_IN, onInputFocusIn);
				currPanel.input.addEventListener(FocusEvent.FOCUS_OUT, onInputFocusOut);
				currPanel.langMark.addEventListener(MouseEvent.CLICK, onClickLangMark);
				currPanel.addEventListener(BInputEvent.ALERT_MESSAGE,  onAlertMesaage);
				currPanel.addEventListener(BInputEvent.CLOSE_HORN, onCloseHorn);
			}
		}
		
		private function closeCurrPanel():void
		{
			if (currPanel)
			{
				currPanel.input.removeEventListener(FocusEvent.FOCUS_IN, onInputFocusIn);
				currPanel.input.removeEventListener(FocusEvent.FOCUS_OUT, onInputFocusOut);
				currPanel.langMark.removeEventListener(MouseEvent.CLICK, onClickLangMark);
				currPanel.removeEventListener(BInputEvent.ALERT_MESSAGE,  onAlertMesaage);
				currPanel.removeEventListener(BInputEvent.CLOSE_HORN, onCloseHorn);
				currPanel.close();
			}
			closeAlert();
		}
		
		/**
		 * 展开
		 */		
		private function unfold():void
		{
			unfoldBtn.visible = false;
			mainSpt.visible = true;
		}
		
		/**
		 * 折叠
		 */
		private function fold():void
		{
			unfoldBtn.visible = true;
			mainSpt.visible = false;
		}
		
		//--------------------------------------------------------------------
		// 事件响应，交互
		//--------------------------------------------------------------------
		
		private function onInputFocusIn(evt:FocusEvent):void
		{
			currPanel.caret.hide();
			isInputing = true;
			currPanel.hidePlaceholders();
		}
		
		private function onInputFocusOut(evt:FocusEvent):void
		{
			isInputing = false;
			if (ime.visible == false)
				currPanel.showPlaceholders();
			else
				currPanel.hidePlaceholders();
		}
		
		private function onClickLangMark(evt:MouseEvent):void
		{
			changeLanguage();
		}

		private function onKeyDown(evt:KeyboardEvent):void
		{
			//trace(evt.charCode);
			if ( !this.visible || evt.altKey )
				return;
			//处理ctrl+v
			if ( evt.ctrlKey )
			{
//				if (evt.keyCode == Keyboard.V)
//				{
//					var copyStr:String = Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT) as String;
//					Console.log("copyStr:", copyStr);
//					if (copyStr && copyStr != "")
//						addInputText(copyStr);
//				}
//				else
				{
					return;
				}
			}
				
			
			if (isInputing == false && ime.visible == false)
				return;
			
			if (evt.keyCode == Keyboard.SHIFT)
				isShiftDown = true;
			if (isShiftDown && evt.keyCode != Keyboard.SHIFT)
				isShiftOnly = false;
			
			handleKeyCode(evt.keyCode, evt.shiftKey);
		}
		
		private function onKeyUp(evt:KeyboardEvent):void
		{
			if (isShiftOnly && evt.keyCode == Keyboard.SHIFT)
			{
				changeLanguage();
			}
			if (evt.keyCode == Keyboard.SHIFT )
			{
				isShiftOnly = true;
				isShiftDown = false;
			}
		}
		
		private function onClickImeHanzi(evt:BInputEvent):void
		{
			handleSelectHanzi(evt.data as int);
		}
		
		private function onClickFoldBtn(evt:MouseEvent):void
		{
			fold();
		}
		
		private function onClickUnfoldBtn(evt:MouseEvent):void
		{
			unfold();
		}
		
		private function onClickHornBtn(evt:MouseEvent):void
		{
			if (normalPanel.visible)
			{
				openHornPanel();
			}
			else
			{
				openNormalPanel();
			}
		}
		
		private function onCloseHorn(evt:BInputEvent):void
		{
			openNormalPanel();
		}
		
		private function onClickLogin(evt:TextEvent):void
		{
			trace("-------------login");
		}
		
		//--------------------------------------------------------------------
		// 具体的处理，逻辑部分
		//--------------------------------------------------------------------
		
		/**
		 * 修改当前语言模式
		 */		
		private function changeLanguage():void
		{
			setFocus(currPanel.input);
			if (currPanel.langMark.langState == LanguageMark.CH)
			{
				currPanel.langMark.setLanguage(LanguageMark.EN);
				addInputText(ime.text);
				ime.hide();
			}
			else
			{
				currPanel.langMark.setLanguage(LanguageMark.CH);
			}
		}
		
		/**
		 * 处理键盘值，根据不同的值，不同处理
		 * @param keyCode
		 * @param shiftKey
		 * 
		 */		
		private function handleKeyCode(keyCode:uint, shiftKey:Boolean):void
		{
			//trace(keyCode);
			if ( checkKeyCodeCanInput(keyCode) )
			{
				if  ((Keyboard.capsLock || shiftKey) && !(Keyboard.capsLock && shiftKey))
				{
					//只要是大写的那么无论当前语言是什么直接输入
					addInputText(getKeyString(keyCode, currPanel.langMark.langState, shiftKey));
				}
				else
				{
					if (currPanel.langMark.langState == LanguageMark.EN)
					{
						//如果是英文的直接输入小写的
						addInputText( getKeyString(keyCode, currPanel.langMark.langState, shiftKey).toLowerCase() );
					}
					else
					{
						if ( !(keyCode>=65 && keyCode<=90)  && ime.visible == false)
						{
							//当没有在输入的拼音时，并且输入的不是字母，直接显示
							addInputText( getKeyString(keyCode, currPanel.langMark.langState, shiftKey).toLowerCase() );
						}
						else
						{
							if (keyCode>=65 && keyCode<=90) //字母
							{
								ime.addOneChar( getKeyString(keyCode, currPanel.langMark.langState, shiftKey).toLowerCase() );
							}
							else if(keyCode>=49 && keyCode<=53 && ime.visible)  // 1--5
 							{
								handleSelectHanzi(keyCode-49);
							}
							else if (keyCode == Keyboard.EQUAL && ime.visible) //如果是+
							{
								ime.nextPage();
							}
							else if (keyCode == Keyboard.MINUS && ime.visible) //如果是-
							{
								ime.prewPage();
							}
							else if (keyCode == Keyboard.SPACE && ime.visible) //如果是空格
							{
								handleSelectHanzi(ime.currHZViewIdx);
							}
						}
					}
				}
			}
			else if (keyCode == Keyboard.ENTER || keyCode == Keyboard.NUMPAD_ENTER) //如果是回车(包括小键盘的)
			{
				if (ime.visible)
				{
					setFocus(currPanel.input);
					addInputText(ime.text);
					ime.hide();
				}
				else
				{
					//回车发请求
					currPanel.sendChatMsg(currPanel.input.text);
				}
			}
			else if (keyCode == Keyboard.BACKSPACE) //如果是后退键
			{
				if (ime.visible)
				{
					ime.deleteOneChar();
				}
				else
				{
					setTimeout(currPanel.countCharNum, 50);
				}
			}
			else if (keyCode == Keyboard.DELETE) //如果是删除键
			{
				if (ime.visible)
				{
					ime.deleteOneChar2();
				}
				else
				{
					setTimeout(currPanel.countCharNum, 50);
				}
			}
			else if (keyCode == Keyboard.UP) //如果是上箭头
			{
				if (ime.visible)
				{
					--ime.currHZViewIdx;
				}
			}
			else if (keyCode == Keyboard.DOWN) //如果是下箭头
			{
				if (ime.visible)
				{
					++ime.currHZViewIdx;
				}
			}
			else if (keyCode == Keyboard.LEFT) //如果是左箭头
			{
				if (ime.visible)
				{
					--ime.caretPos;
				}
			}
			else if (keyCode == Keyboard.RIGHT) //如果是右箭头
			{
				if (ime.visible)
				{
					++ime.caretPos;
				}
			}
			else if (keyCode == Keyboard.HOME) //如果是HOME键
			{
				if (ime.visible)
				{
					ime.caretPos = 0;
				}
			}
			else if (keyCode == Keyboard.END) //如果是END键
			{
				if (ime.visible)
				{
					ime.caretPos = ime.text.length;
				}
			}
		}
		
		/**
		 * 当选择了汉字时的处理
		 * @param idx
		 * 
		 */		
		private function handleSelectHanzi(idx:int):void
		{
			var hzText:String = ime.selectHanzi(idx);
			if (hzText != "")
			{
				setFocus(currPanel.input);
				addInputText(hzText);
				ime.hide();
			}
		}
		
		/**
		 * 检测是否是可输入的键盘值
		 * @param keyCode
		 * @return 
		 * 
		 */		
		private function checkKeyCodeCanInput(keyCode:uint):Boolean
		{
			// 判断是否是可以输入的字符
			if ( (keyCode>=65 && keyCode<=90) //A-Z
				|| (keyCode>=48 && keyCode<=57)  //0-9
				|| (keyCode>=96 && keyCode<=111 && keyCode!=108) //小键盘
				|| (keyCode>=186 && keyCode<=192)  || (keyCode>=219 && keyCode<=222) //标点符号
				||   keyCode == Keyboard.SPACE  ) //空格 
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 获得输入键盘值对应的文本，根据语言和是否按了shift键
		 * @param keyCode
		 * @param lang
		 * @param shiftKey
		 * @return 
		 * 
		 */		
		private function getKeyString(keyCode:uint, lang:uint, shiftKey:Boolean):String
		{
			if ( (keyCode>=48 && keyCode<=57) || (keyCode>=96 && keyCode<=111 && keyCode!=108) //数字和小键盘
				|| (keyCode>=186 && keyCode<=192)  || (keyCode>=219 && keyCode<=222) ) // 标点符号
			{
				return KeyCodeMap.getString(keyCode, lang, shiftKey);
			}
			return String.fromCharCode(keyCode);
		}
		
		/**
		 * 根据插入点的位置，输入框添加文本
		 * @param text
		 * 
		 */		
		private function addInputText(text:String):void
		{
			var idx:int = currPanel.input.caretIndex;
			var text1:String = currPanel.input.text.substr(0, idx);
			var text2:String = currPanel.input.text.substr(idx);
			currPanel.input.text = text1 + text + text2;
			currPanel.countCharNum();
			currPanel.input.setSelection(currPanel.input.caretIndex+text.length,currPanel.input.caretIndex+text.length);
		}
		
		/**
		 * 设置焦点，把设置焦点时可能会出现的黄框去掉
		 * @param interObj
		 * 
		 */		
		private function setFocus(interObj:InteractiveObject):void
		{
			if (stage != null)
			{
				stage.stageFocusRect = false;
				stage.focus = interObj;
			}
		}
		
		/**
		 * 获得插入点的位置
		 * 插入点是画出来的。文本框已经失去焦点，为了显示输入框当前插入的位置，特此处理
		 */		
		private function getCaretPoint():Point
		{
			var pos:int = currPanel.input.caretIndex;
			if (pos > currPanel.input.length)
				pos = currPanel.input.length;
			if (pos < 0)
				pos = 0;
			
			var caretX:int = currPanel.input.x + 2;
			var caretY:int = currPanel.input.y + 2;
			if (pos > 0)
			{
				var rect:Rectangle = currPanel.input.getCharBoundaries(pos-1);
				if (rect)
				{
					caretX = currPanel.input.x + rect.x + rect.width - currPanel.input.scrollH;
					var format:TextFormat = currPanel.input.getTextFormat();
					caretY = currPanel.input.y + rect.y - (currPanel.input.scrollV-1)*( format.leading + rect.height);
				}
				/*else
				{
					//如果上一个字符是回车
					if ( currPanel.input.text.charCodeAt(pos-1) == 13 )
					{
						var currLine:int = currPanel.input.getLineIndexOfChar(pos-1);
						caretX = currPanel.input.x + 2;
						caretY = currPanel.input.y +  (currLine - currPanel.input.scrollV + 1)*( format.leading + 19);
					}
				}*/
			}
			return new Point( caretX, caretY );
		}
		
		/**
		 * 输入提示的visible变化时的处理，当显示时，把焦点设置到输入提示上
		 * @param evt
		 * 
		 */		
		private function handleImeVisibleChanged(evt:BInputEvent):void
		{
			if (ime.visible == true)
			{
				setFocus(ime);
				setIMEXY();
				var caretPt:Point = getCaretPoint();
				currPanel.caret.x = caretPt.x;
				currPanel.caret.y = caretPt.y;
				currPanel.caret.show();
				
			}
		}
		
		/**
		 * 设置IME的位置
		 * 
		 */		
		private function setIMEXY():void
		{
			var caretPt:Point = getCaretPoint();
			var imeX:int = caretPt.x;
			if (imeX + ime.width > mainWidth)
			{
				imeX = mainWidth - ime.width; 
			}
			ime.x = imeX;
			ime.y = currPanel.imeY - ime.height +  caretPt.y;
		}
		
		/**
		 * IME上的文本是空时的处理（一般是删除导致的）
		 * @param evt
		 * 
		 */		
		private function handleImeTextNone(evt:BInputEvent):void
		{
			setTimeout(setFocus, 100, currPanel.input);//为了防止删除input上的文本，这里用了个延时。。
		}
		
		/**
		 * IME的宽度变长
		 * @param evt
		 * 
		 */		
		private function handleImeWidthLonger(evt:BInputEvent):void
		{
			setIMEXY();
		}
		
		/**
		 * 主显示的宽度
		 */		
		public function get mainWidth():int
		{
			return mainSpt.width;
		}
		
		/**
		 * 关闭警告信息
		 */		
		public function closeAlert():void
		{
			alert.close();
		}
		
		/**
		 * 显示警告信息
		 * @param evt
		 * 
		 */		
		public function onAlertMesaage(evt:BInputEvent):void
		{
			var btn1Func:Function = evt.data.btn1Func;
			if (btn1Func == null)
				btn1Func = closeAlert;
			alertMesaage(evt.data.type, evt.data.text, 
				evt.data.btn1Text, btn1Func, "取消", closeAlert);
		}
		
		private function alertMesaage(type:int, msg:String, btn1Text:String="", btn1Func:Function=null,
									  btn2Text:String="", btn2Func:Function=null):void
		{
			alert.showMessage(type, msg, btn1Text, btn1Func, btn2Text, btn2Func);
			
			alert.y = currPanel.topY - alert.realHeight;
			alert.x = currPanel.inputMiddleX - alert.width/2;
		}
		
		/**
		 * 处理登录状态
		 * @param isLogin
		 * 
		 */		
		private function handleLoginState(isLogin:Boolean):void
		{
			if (isLogin)
			{
				loginTF.visible = false;
				normalPanel.input.mouseEnabled = true;
				hornPanel.input.mouseEnabled = true;
			}
			else
			{
				normalPanel.input.mouseEnabled = false;
				hornPanel.input.mouseEnabled = false;
				loginTF.visible = true;
			}
		}
		
		//--------------------------------------------------------------------
		// JS 返回
		//--------------------------------------------------------------------
		
		private function handleSendChatSucc(evt:MEvent):void
		{
			var info:Object = evt.data;
			var isMe:Boolean = info["meId"]==info["info"]["i"];
			if (isMe)
				currPanel.sendChatSucc();
		}
		
		private function handleHornRespone(evt:MEvent):void
		{
			if (evt.data)
				handleBackErrorCode(evt.data.code, evt.data.msg);
		}
		
		private function handleChatRespone(evt:MEvent):void
		{
			if (evt.data)
				handleBackErrorCode(evt.data.code, evt.data.msg);
		}
		
		private function handleThesaurusRespone(evt:MEvent):void
		{
			handleHanziJson(evt.data);
		}
		
		public function handleHanziJson(jsonObj:Object):void
		{
			ime.parseHanziJson(jsonObj);
		}
		
		private function handleBackErrorCode(code:int, msg:String):void
		{
			/*
			code:代码["99":网络错误，"-2":未登录,"-3":星币不足,"-5":"提出频道","-10":"禁言","-17":"数量不足",
			"-20":"验证码","-23":"手机要绑定"] 
			*/
			switch(code)
			{
				case 99:
					alertMesaage(BIAlert.TYPE_BTN_0, "网络错误"); 
					break;
				case -2:
					//退出全屏
					UIManage.get.stage.displayState = StageDisplayState.NORMAL;
					break;
				case -3:
					alertMesaage(BIAlert.TYPE_BTN_2, "抱歉，你的星币不足哦！", "充值", gotoCharge, "取消", closeAlert); 
					break;
				case -5:
					alertMesaage(BIAlert.TYPE_BTN_0, "你已被提出频道"); 
					break;
				case -10:
					alertMesaage(BIAlert.TYPE_BTN_0, "你已被禁言"); 
					break;
				case -17:
					alertMesaage(BIAlert.TYPE_BTN_0, "数量不足"); 
					break;
				case -20:
					alertMesaage(BIAlert.TYPE_BTN_0, "验证码"); 
					break;
				case -23:
					alertMesaage(BIAlert.TYPE_BTN_0, "手机要绑定"); 
					break;
				case -1:
					if (msg != null && msg != "")
					{
						alertMesaage(BIAlert.TYPE_BTN_0, msg);
					}
					break;
			}
		}
		
		/**
		 * 跳入充值页面 
		 */		
		private function gotoCharge():void
		{
			
		}
		
		/*
		public function getThesaurusRequest(url:String):void
		{
			//ExternalInterface.call("_flash_fullscreen_ime", url);
			
			var urlLoader:URLLoader = new URLLoader();
			var urlReq:URLRequest = new URLRequest(url);
			urlLoader.load(urlReq);
			urlLoader.addEventListener(Event.COMPLETE, onLoadHanziComplete);
		}
		private function onLoadHanziComplete(evt:Event):void
		{
			var urlLoader:URLLoader = evt.target as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onLoadHanziComplete);
			getThesaurusRespone(urlLoader.data);
		}
		
		public function getThesaurusRespone(obj:Object):void
		{
			inputPanel.handleHanziJson(obj as String);
		}
		
		*/
		
	}
}