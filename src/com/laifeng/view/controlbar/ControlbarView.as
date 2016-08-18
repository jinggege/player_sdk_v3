package com.laifeng.view.controlbar
{
	import com.laifeng.config.ListenerType;
	import com.laifeng.config.LiveConfig;
	import com.laifeng.config.ModuleKey;
	import com.laifeng.config.NoticeKey;
	import com.laifeng.config.UIKey;
	import com.laifeng.controls.DMCenter;
	import com.laifeng.controls.DataModule;
	import com.laifeng.controls.Notification;
	import com.laifeng.controls.UIManage;
	import com.laifeng.event.MEvent;
	import com.laifeng.interfaces.IUI;
	import com.laifeng.view.controlbar.base.IControlBar;
	import com.laifeng.view.controlbar.livehouse.CBLivehouse;
	import com.laifeng.view.controlbar.other.CBother;
	import com.laifeng.view.controlbar.showroom.CBshowroom;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import lf.media.core.util.EnterframeTimer;
	import lf.media.core.util.EnterframeTimerVO;
	
	public class ControlbarView extends Sprite implements IUI
	{
		
		private const MAX_H:int = 40;
		
		
		public function ControlbarView()
		{
			super();
			Notification.get.addEventListener(NoticeKey.N_LIVE_START_BY_JS,startLiveHandler);
			Notification.get.addEventListener(NoticeKey.N_MUTE,setMuteHandler);
		}
		
		public function open():void
		{
			
			if(_controlBar == null){
				switch(LiveConfig.get.initOption.appId){
					case 101:
						if(LiveConfig.get.initOption.roomType == 0){
							_controlBar = new CBshowroom();
						}else{
							_controlBar = new CBLivehouse();
						}
						break;
					
					default://其他平台 屏蔽来疯业务
						_controlBar = new CBother();
						break;
				}
			}
			
			
			addChild(DisplayObject(_controlBar));
			
			screenChange(_w,_h);
			
			_dmCenter = DataModule.get.getModule(ModuleKey.DM_LIVECORE) as DMCenter;
			_controlBar["init"](_dmCenter);
			
			EnterframeTimer.get.remove(ListenerType.TIME_SHOW_CONTROLBAR);
			EnterframeTimer.get.addListener(new EnterframeTimerVO(
				ListenerType.TIME_SHOW_CONTROLBAR,
				autoHideBarHandler,
				1000
			));
		}
		
		public function close():void
		{
			trace("off controlbar");
		}
		
		
		public function updata():void
		{
			
		}
		
		
		
		public function screenChange(w:int,h:int):void{
			_w = w;
			_h = h;
			
			if(_controlBar == null) return;
			_controlBar.resize(w,MAX_H);
			DisplayObject(_controlBar).x = 0;
			DisplayObject(_controlBar).y = h - MAX_H;
		}
		
		
	
		
		
		private function updataCloseTimeHandler(event:MouseEvent):void{
			LiveConfig.mouseInTime = getTimer();
		}
		
		
		private function autoHideBarHandler():void{
			
			if(getTimer() - LiveConfig.mouseInTime > 5000){
				EnterframeTimer.get.remove(ListenerType.TIME_SHOW_CONTROLBAR);
				UIManage.get.closeUI(UIKey.UI_CONTROLBAR);
				return;
			}
			
		}
		
		
		private function startLiveHandler(event:MEvent):void{
			if(_controlBar == null) return;
			_controlBar.reset();
		}
		
		
		private function setMuteHandler(event:MEvent):void{
			var type:int = int(event.data);
			
			if(_controlBar == null) return;
			_controlBar.setMuteStatus(type);
		}
		
		
		
		
		public function get level():int{
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
		
		private var _dmCenter:DMCenter;
		
		//======================================
		
		private var _controlBar:IControlBar = null;
		private var _w:int = 0;
		private var _h:int = 0;
		
		
		
		
	}
}