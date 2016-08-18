package com.laifeng.view.log
{
	import com.laifeng.config.ListenerType;
	import com.laifeng.config.LiveConfig;
	import com.laifeng.interfaces.IChildUI;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	
	import lf.media.core.util.Console;
	import lf.media.core.util.EnterframeTimer;
	import lf.media.core.util.EnterframeTimerVO;
	
	public class LogP2pPeerPanel extends Sprite implements IChildUI
	{
		public function LogP2pPeerPanel()
		{
			super();
			//_tfNsInfo.selectable = false;
			_tfNsInfo.wordWrap = true;
			this.addChild(_tfNsInfo);
			
			this.addChild(_copyBg);
			_copyBg.addChild(_label);
			_label.width = 30;
			_label.height = 20;
			_label.selectable = false;
			_copyBg.mouseChildren = false;
			_label.textColor = 0xFF3333;
			_label.text = "复制";
			
			_copyBg.graphics.beginFill(0xCCCCCC);
			_copyBg.graphics.drawRect(0,0,30,20);
			_copyBg.graphics.endFill();
			
			_copyBg.buttonMode = true;
			
			_copyBg.addEventListener(MouseEvent.CLICK,copyHandler);
		}
		
		public function changeScreen(w:int,h:int):void
		{
			_tfNsInfo.width = w;
			_tfNsInfo.height = h - 20;
			_tfNsInfo.y = 20;
			
			_copyBg.x = w - _copyBg.width;
			_copyBg.y = h - _copyBg.height;
		}
		
		public function open():void
		{
			EnterframeTimer.get.remove(ListenerType.TIME_LOG_P2P_UPDATA);
			
			EnterframeTimer.get.addListener(new EnterframeTimerVO(
				ListenerType.TIME_LOG_P2P_UPDATA,
				updataInfo,
				1000
			));
			
			changeScreen(LiveConfig.get.defaultWidth,LiveConfig.get.defaultHeight);
		}
		
		
		private function updataInfo():void{
			//_tfNsInfo.htmlText = LiveConfig.get.streamVO.p2p == 1? LiveConfig.streamInfo.peerInfo:"";
		}
		
		
		
		private function copyHandler(event:MouseEvent):void{
			System.setClipboard(_tfNsInfo.text);
			Console.isDebug = true;
		}
		
		public function close():void
		{
			EnterframeTimer.get.remove(ListenerType.TIME_LOG_P2P_UPDATA);
		}
		
		
		
		private var _tfNsInfo:TextField = new TextField();
		private var _copyBg:Sprite = new Sprite();
		private var _label:TextField = new TextField();
		
		
		
	}
}