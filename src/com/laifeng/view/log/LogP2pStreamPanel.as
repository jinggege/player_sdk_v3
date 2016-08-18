package com.laifeng.view.log
{
	import com.laifeng.config.ListenerType;
	import com.laifeng.config.LiveConfig;
	import com.laifeng.interfaces.IChildUI;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import lf.media.core.util.EnterframeTimer;
	import lf.media.core.util.EnterframeTimerVO;
	
	public class LogP2pStreamPanel extends Sprite implements IChildUI
	{
		public function LogP2pStreamPanel()
		{
			super();
			//_tfNsInfo.selectable = false;
			_tfNsInfo.wordWrap = true;
			this.addChild(_tfNsInfo);
			
		}
		
		public function changeScreen(w:int,h:int):void
		{
			_tfNsInfo.width = w;
			_tfNsInfo.height = h - 20;
			_tfNsInfo.y = 20;
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
			//_tfNsInfo.htmlText = LiveConfig.get.streamVO.p2p == 1? LiveConfig.streamInfo.p2pMsg:"";
		}
		
		
		public function close():void
		{
			EnterframeTimer.get.remove(ListenerType.TIME_LOG_P2P_UPDATA);
		}
		
		private var _tfNsInfo:TextField = new TextField();
		
		
		
	}
}