package com.laifeng.view.log
{
	import com.laifeng.config.ListenerType;
	import com.laifeng.config.LiveConfig;
	import com.laifeng.interfaces.IChildUI;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import lf.media.core.util.EnterframeTimer;
	import lf.media.core.util.EnterframeTimerVO;
	
	public class LogVideoPanel extends Sprite implements IChildUI
	{
		public function LogVideoPanel()
		{
			super();
			
			_tfNsInfo.selectable = false;
			_tfNsInfo.wordWrap = true;
			this.addChild(_tfNsInfo);
			addChild(_statusBuffer);
			_statusBuffer.y = 190;
		}
		
		public function changeScreen(w:int,h:int):void
		{
			_tfNsInfo.width = w;
			_tfNsInfo.height = h - 20;
			_tfNsInfo.y = 20;
		}
		
		public function open():void
		{
			EnterframeTimer.get.remove(ListenerType.TIME_LOG_VIEW_UPDATA);
			
			EnterframeTimer.get.addListener(new EnterframeTimerVO(
				ListenerType.TIME_LOG_VIEW_UPDATA,
				updataInfo,
				1000
			));
			
			changeScreen(LiveConfig.get.defaultWidth,LiveConfig.get.defaultHeight);
		}
		
		private function updataInfo():void{
			
			if(LiveConfig.get.isP2p== 0){
				_tfNsInfo.htmlText = LiveConfig.get.streamLogData.videoMsg;
			}else{
				_tfNsInfo.htmlText = "";
			}
			
			_statusBuffer.setBuffer(LiveConfig.get.streamLogData.bufferTime,
							LiveConfig.get.streamLogData.bufferLength
			);
			
		}
		
		
		
		public function close():void
		{
			EnterframeTimer.get.remove(ListenerType.TIME_LOG_VIEW_UPDATA);
			_statusBuffer.clear();
		}
		
		private var _nsHtml:String = "";
		private var _tfNsInfo:TextField = new TextField();
		private var _statusBuffer:GrBuffer = new GrBuffer();
		
		
	}
}