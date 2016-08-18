package com.laifeng.view.input.ime
{
	import com.adobe.json.JSONParseError;
	import com.laifeng.controls.LFExtenrnalInterface;
	import com.laifeng.view.input.BInputEvent;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class IMEPanel extends Sprite
	{
		
		private const W:int = 400;
		private const H:int = 60;
		
		//------显示------
		private var hzViewVect:Vector.<HanziView>;
		private var bg:Shape;
		private var tf:TextField;
		private var caret:Shape;
		
		//------数据------
		/**插入符号，线*/
		private var _caretPos:int;
		/**当前显示的汉字条目数目*/
		private var _currHZViewNum:int;
		/**当前选中的汉字条目索引*/
		private var _currHZViewIdx:int = -1;
		/**上边一行的文本框的汉字文本*/
		private var _hanziText:String = "";
		/**上边一行的文本框的拼音文本*/
		private var _pinyinText:String = "";
		
		/**每次请求的汉字的个数*/
		private const REQ_HANZI_COUNT:int = 20;
		/**汉字的当前页，目前5个为一页，从0开始*/
		private var currPage:int = 0;
		/**是否还有汉字可以请求(全部请求完后为false)*/
		private var hasHanziReq:Boolean = true;
		/**汉字的数组*/
		private var hzDataArr:Array;
		
		
		public function IMEPanel()
		{
			super();
			
			bg = new Shape();
			bg.graphics.lineStyle(1, 0x999999);
			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRoundRect(0,0,W,H,10);
			bg.graphics.moveTo(0, H/2);
			bg.graphics.lineTo(W, H/2);
			bg.graphics.endFill();
			this.addChild(bg);
			
			var format:TextFormat = new TextFormat();
			format.size = 16
			format.color = 0x0099FF;
			format.bold = true;
			format.letterSpacing = 1;
			tf = new TextField();
			tf.type = TextFieldType.DYNAMIC;
			//tf.type = TextFieldType.INPUT;
			//tf.restrict = "";
			tf.multiline = false;
			tf.wordWrap = false;
			tf.defaultTextFormat = format;
			this.addChild(tf);
			tf.width = W;
			tf.height = H;
			tf.x = 10;
			tf.y = 5;
			tf.mouseEnabled = false;
			
			caret = new Shape();
			caret.graphics.lineStyle(1,0xFF6633);
			caret.graphics.moveTo(0,0);
			caret.graphics.lineTo(0,16);
			caret.graphics.endFill();
			this.addChild(caret);
			caret.x = tf.x + 3;
			caret.y = tf.y + 2;
			
			hzViewVect = new Vector.<HanziView>();
			for ( var i:int=0; i<5; i++ )
			{
				var hz:HanziView = new HanziView();
				hz.index = i;
				hzViewVect.push(hz);
				this.addChild(hz);
				hz.x = 6 + i*10;
				hz.y = 35;
				
				hz.addEventListener(MouseEvent.CLICK, onClickHanzi);
			}
			
			caretPos = 0;
			hzDataArr = new Array();
			
			//this.mouseChildren = false;
		}
		
		//--------------------------------------------------------------------
		// 对外接口与操作响应
		//--------------------------------------------------------------------

		public function hide():void
		{
			var len:int = hzViewVect.length;
			for ( var i:int=0; i<len; i++ )
			{
				hzViewVect[i].visible = false;
			}
			tf.text = "";
			_pinyinText = "";
			_hanziText = "";
			caretPos = 0;
			_currHZViewIdx = -1;
			this.visible = false;
		}
		
		public function nextPage():void
		{
			if (currPage < int((hzDataArr.length-1)/5) )
			{
				++currPage;
				showCurrPage();
			}
			else if (hasHanziReq)
			{
				++currPage;
				loadHanZi(hzDataArr.length, hzDataArr.length+REQ_HANZI_COUNT);
			}
			
		}
		
		public function prewPage():void
		{
			if (currPage > 0)
				--currPage;
			showCurrPage();
		}
		
		public function addOneChar(char:String):void
		{
			if (caretPos < _hanziText.length)
				return;
			if (tf.text.length >= 30)//不能无限制的输入
				return;
			tf.text = insertText(tf.text, char, caretPos);
			_pinyinText = insertText(_pinyinText, char, caretPos-_hanziText.length);
			loadHanZi();
			++caretPos;
			whenTextMayLonger();
		}
		private function insertText(oText:String, iText:String, pos:int):String
		{
			return oText.substr(0, pos) + iText + oText.substr(pos);
		}
		
		public function deleteOneChar():void
		{
			tf.text = deleteText(tf.text, 1, caretPos-1);
			if (caretPos <= _hanziText.length)
			{
				_hanziText = deleteText(_hanziText, 1, caretPos-1);
			}
			else
			{
				_pinyinText = deleteText(_pinyinText, 1, caretPos-_hanziText.length-1);
			}
			afterDelete();
			--caretPos;
		}
		
		private function afterDelete():void
		{
			if (pinyinText != "")
			{
				loadHanZi();
			}
			else
			{
				if (tf.text == "")
				{
					hide();
					this.dispatchEvent(new BInputEvent(BInputEvent.IME_TEXT_NONE));
				}
				else
				{
					var vo:HanziVO = new HanziVO();
					vo.text = hanziText;
					vo.letterNum = 0;
					refreshHanziViews([vo]);
				}
			}
		}
		
		public function deleteOneChar2():void
		{
			tf.text = deleteText(tf.text, 1, caretPos);
			if (caretPos < _hanziText.length)
			{
				_hanziText = deleteText(_hanziText, 1, caretPos);
			}
			else
			{
				_pinyinText = deleteText(_pinyinText, 1, caretPos-_hanziText.length);
			}
			afterDelete();
		}
		
		private function deleteText(oText:String, num:int, pos:int):String
		{
			return oText.substr(0, pos) + oText.substr(pos+num);
		}
		
		public function selectHanzi(index:int):String
		{
			if (index >= 0 && index < _currHZViewNum )
			{
				if (_pinyinText.length > hzViewVect[index].useLetterNum)
				{
					_hanziText += hzViewVect[index].text;
					_pinyinText = _pinyinText.substr(hzViewVect[index].useLetterNum);
					tf.text = _hanziText + _pinyinText;
					whenTextMayLonger();
					caretPos = tf.text.length;
					loadHanZi();
					return "";
				}
				else
				{
					if (_pinyinText != "")
						_hanziText += hzViewVect[index].text;
					//_pinyinText = _pinyinText.substr(hanziVect[index].useLetterNum); //应是空的才合理
					return _hanziText;
				}
			}
			return "";
		}
		
		private function onClickHanzi(evt:MouseEvent):void
		{
			var hanzi:HanziView = evt.target as HanziView;
			this.dispatchEvent(new BInputEvent(BInputEvent.CLCIK_IME_HANZI, hanzi.index));
		}
		
		private function whenTextMayLonger():void
		{
			tf.width = tf.textWidth + 10;
			if (tf.x + tf.width > bg.x + bg.width)
			{
				bg.width = tf.width;
				this.dispatchEvent(new BInputEvent(BInputEvent.IME_WIDTH_LONGER));
			}
		}
		
		//--------------------------------------------------------------------
		// 加载与显示
		//--------------------------------------------------------------------

		private function loadHanZi(begin:int = 0, end:int = 20):void
		{
			if (begin == 0)
				currPage = 0;
			hasHanziReq = true;
			
			var url:String = "http://olime.baidu.com/py?input=" + _pinyinText + 
				"&inputtype=py&bg=" + begin + "&ed=" + end + "&result=hanzi&resultcoding=unicode&ch_en=0&clientinfo=web&version=1";
			//BIExternalInterface.instace.getThesaurusRequest(url);
			LFExtenrnalInterface.get.reqThesaurus(url);
		}
		
		public function parseHanziJson(jsonObj:Object):void
		{
			try
			{
				if (currPage == 0)
					hzDataArr.splice(0,hzDataArr.length);
				var tmpArr:Array = jsonObj.result[0];
				if (tmpArr != null)
				{
					var len:int = tmpArr.length;
					if (len < REQ_HANZI_COUNT)
						hasHanziReq = false;
					for (var i:int=0; i<len; ++i)
					{
						var vo:HanziVO = new HanziVO();
						if (tmpArr[i] is Array && tmpArr[i].length >= 2)
						{
							vo.text = tmpArr[i][0];
							vo.letterNum = int(tmpArr[i][1]);
							hzDataArr.push(vo);
						}
						//trace(tmpArr[i][0]);
					}
				}
				
				showCurrPage();
			} 
			catch(error:JSONParseError) 
			{
				trace("error:::::::"+error.text)
			}
		}
		
		private function showCurrPage():void
		{
			var sIdx:int = currPage*5;
			var eIdx:int = sIdx + 5;
			if (eIdx > hzDataArr.length)
				eIdx = hzDataArr.length;
			var tmpArr:Array = hzDataArr.slice(sIdx,eIdx);
			refreshHanziViews(tmpArr);
		}
		
		private function refreshHanziViews(dataArr:Array):void
		{
			_currHZViewNum = dataArr.length;
			if (_currHZViewNum > 0)
			{
				this.visible = true;
				var len:int = hzViewVect.length;
				var tmpX:int = 6;
				for ( var i:int=0; i<len; i++ )
				{
					if (i < _currHZViewNum)
					{
						hzViewVect[i].visible = true;
						hzViewVect[i].setData(dataArr[i]);
						hzViewVect[i].x = tmpX;
						tmpX += hzViewVect[i].width + 10;
					}
					else
					{
						hzViewVect[i].setData(null);
						hzViewVect[i].visible = false;
					}
				}
				var lastBG:int = bg.width;
				bg.width = Math.max(tmpX + 10, tf.x + tf.width);
				if (bg.width > lastBG)
				{
					this.dispatchEvent(new BInputEvent(BInputEvent.IME_WIDTH_LONGER));
				}
				currHZViewIdx = 0;
			}
		}
		
		//--------------------------------------------------------------------
		// 读写器
		//--------------------------------------------------------------------
		
		public function get caretPos():int
		{
			return _caretPos;
		}
		
		public function set caretPos(value:int):void
		{
			_caretPos = value;
			
			if (_caretPos > tf.length)
				_caretPos = tf.length;
			if (caretPos < 0)
				_caretPos = 0;
			
			if (_caretPos > 0)
			{
				var rect:Rectangle = tf.getCharBoundaries(_caretPos-1);
				caret.x = tf.x + rect.x + rect.width;
			}
			else
			{
				caret.x = tf.x;
			}
		}
		
		public function get pinyinText():String
		{
			return _pinyinText;
		}
		
		public function get hanziText():String
		{
			return _hanziText;
		}
		
		public function get text():String
		{
			return tf.text;
		}
		
		override public function set visible(value:Boolean):void
		{
			if (value != this.visible)
			{
				super.visible = value;
				dispatchEvent(new BInputEvent(BInputEvent.IME_VISIBLE_CHANGED));
			}
		}

		public function get currHZViewIdx():int
		{
			return _currHZViewIdx;
		}
		
		public function set currHZViewIdx(value:int):void
		{
			if (_currHZViewIdx != value)
			{
				_currHZViewIdx = value;
				if (_currHZViewIdx < 0)
				{
					if (currPage == 0)
					{
						_currHZViewIdx = 0;
						setSelectHZView();
					}
					else
					{
						prewPage();
						_currHZViewIdx = 4;
						setSelectHZView();
					}
				}
				else if (_currHZViewIdx > _currHZViewNum-1)
				{
					if (hasHanziReq == false && currPage == int((hzDataArr.length-1)/5))
					{
						_currHZViewIdx = _currHZViewNum - 1;
						setSelectHZView();
					}
					else
					{
						nextPage();//由于选下一页的时候自动_currHZViewIdx设置成0，所以不做其他处理
					}
				}
				else
				{
					setSelectHZView();
				}
			}
		}
		private function setSelectHZView():void
		{
			for ( var i:int=0; i<5; i++ )
			{
				if (i == _currHZViewIdx)
					hzViewVect[i].selected = true;
				else
					hzViewVect[i].selected = false;
			}
		}

	}
}