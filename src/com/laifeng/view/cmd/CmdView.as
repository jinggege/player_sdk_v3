package com.laifeng.view.cmd
{
	import com.laifeng.component.DefaultBtn;
	import com.laifeng.config.ListenerType;
	import com.laifeng.config.LiveConfig;
	import com.laifeng.config.UIKey;
	import com.laifeng.controls.LFExtenrnalInterface;
	import com.laifeng.controls.UIManage;
	import com.laifeng.interfaces.IUI;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import lf.media.core.util.Console;
	
	/**
	 * 
	 */
	public class CmdView extends Sprite implements IUI
	{
		public function CmdView()
		{
			super();
			
			_tfInput.type = TextFieldType.INPUT;
			_tfInput.width = 150;
			_tfInput.height = 30;
			_tfInput.wordWrap = false;
			
			graphics.beginFill(0x000000,0.5);
			graphics.drawRoundRect(0,0,300,70,10,10);
			graphics.endFill();
			
			_tfInput.x = (this.width - _tfInput.width)/2;
			_tfInput.y = (this.height - _tfInput.height)/2;
			_tfInput.border = true;
			_tfInput.borderColor = 0xCCCCCC;
			_tfInput.textColor = 0xFFFFFF;
			addChild(_tfInput);
			
			_excuteBtn = new DefaultBtn(25,20);
			_excuteBtn.addEventListener(MouseEvent.CLICK,excuteHandler);
			addChild(_excuteBtn);
			
			_excuteBtn.x = _tfInput.x + _tfInput.width+10;
			_excuteBtn.y = _tfInput.y + 5;
			_excuteBtn.label = "run";
			
			_closeBtn = new DefaultBtn(20,20);
			addChild(_closeBtn);
			_closeBtn.label = "X";
			_closeBtn.x = 2;
			_closeBtn.addEventListener(MouseEvent.CLICK,closeHandler);
			
			_tfInput.addEventListener(MouseEvent.CLICK,clickTfHandelr);
			
		}
		
		public function open():void
		{
			_tfInput.text = "";
			screenChange(LiveConfig.get.defaultWidth,LiveConfig.get.defaultHeight);
		}
		
		
		private function excuteHandler(event:MouseEvent):void{
			var cmdStr:String   = _tfInput.text;
			var cmdInfo:Object = _parseCmd.getCmdInfo(cmdStr);
			
			var cmdType:String = cmdInfo["cmdType"];
			var parme:Object     = cmdInfo["param"];
			
			switch(cmdType){
				case ListenerType.CMD_DEBUG :
						Console.isDebug = cmdInfo.param;
					break;
				case ListenerType.CMD_WH :
					LFExtenrnalInterface.get.exSetPlayerWH({width:parme.width,height:parme.height});
					break;
				case ListenerType.CMD_GETSTREAMID :
					//_tfInput.text = LiveConfig.get.streamVO.minorStreamId;
					break;
				case ListenerType.CMD_BROWER :
					//_tfInput.text = LiveConfig.configOption.userAgent;
					break;
				default:
					_tfInput.text = " command not found!";
					break;
			}
			
		}
		
		
		private function closeHandler(event:MouseEvent):void{
			UIManage.get.closeUI(UIKey.UI_CMD);
		}
		
		
		
		private function clickTfHandelr(event:MouseEvent):void{
			//_tfInput.text = "";
		}
		
		
		
		public function close():void
		{
		}
		
		public function updata():void
		{
		}
		
		public function screenChange(w:int, h:int):void
		{
			this.x = (w - this.width)/2;
			this.y = (h - this.height)/2;
		}
		
		public function get level():int
		{
			return UIKey.UI_LEVEL_3;
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
		
		
		private var _uiState:String = "";
		private var _tfInput:TextField = new TextField();
		private var _excuteBtn:DefaultBtn;
		private var _closeBtn:DefaultBtn;
		private var _parseCmd:ParseCmd = new ParseCmd();
		
		
	}
}





