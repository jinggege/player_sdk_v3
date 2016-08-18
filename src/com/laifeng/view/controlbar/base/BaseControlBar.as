package com.laifeng.view.controlbar.base
{
	import com.laifeng.config.LiveConfig;
	import com.laifeng.config.NoticeKey;
	import com.laifeng.config.UIKey;
	import com.laifeng.controls.DMCenter;
	import com.laifeng.controls.LFExtenrnalInterface;
	import com.laifeng.controls.Notification;
	import com.laifeng.controls.UIManage;
	import com.laifeng.event.MEvent;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	
	import lf.media.core.component.slider.LfSlider;
	
	public class BaseControlBar extends Sprite implements IControlBar
	{
		
		protected const BAR_HEIGHT:int = 40;
		protected const SPACE:int = 20;
		
		
		
		public function BaseControlBar()
		{
			super();
			
			addChild(_bg);
			
			_btnPlayStatus = new BtnPlayStatus();
			addChild(_btnPlayStatus);
			_btnPlayStatus.status = _btnPlayStatus.STATUS_PLAY;
			
			_btnScreenStatus = new BtnScreenStatus();
			addChild(_btnScreenStatus);
			_btnScreenStatus.status = _btnScreenStatus.STATUS_NOMAL;
			
			_btnEffectStatus = new BtnEffectStatus();
			addChild(_btnEffectStatus);
			_btnEffectStatus.status = _btnEffectStatus.STATUS_ON;
			_btnEffectStatus.visible = false;
			
			_btnSoundStatus = new BtnSoundStatus();
			_btnSoundStatus.status = _btnSoundStatus.STATUS_OPEN;
			addChild(_btnSoundStatus);
			
			_btnBarrageStatus = new BtnBarrageStatus();
			_btnBarrageStatus.status = _btnBarrageStatus.STATUS_ON;
			addChild(_btnBarrageStatus);
			_btnBarrageStatus.visible = false;
			
			
			addChild(_qualityTitle);
			_qualityTitle.buttonMode = true;
			
			addChild(_slider);
			
			_btnEffectStatus.addEventListener(_btnEffectStatus.E_EFFECT_STATUS_CHANGE,changeEffectHandler);
			
			_btnScreenStatus.addEventListener(_btnScreenStatus.E_SCREEN_STATUS_CHANGE,changeScreenHandler);
			
			_btnPlayStatus.addEventListener(_btnPlayStatus.E_PLAY_STATUE_CHANGE,changePlayStatusHandler);
			
			_btnSoundStatus.addEventListener(_btnSoundStatus.E_SOUND_STATUS_CHANGE,changeSoundIconHandler);
			
			_btnBarrageStatus.addEventListener(_btnBarrageStatus.E_BARRAGE_STATUS_CHANGE,changeBarrageStatusHandler);
			
			_qualityTitle.addEventListener(MouseEvent.CLICK,controlQualityHandler);
			_qualityPanel.addEventListener(_qualityPanel.E_LFLABEL_CHANGE,qualitySwitchHandler);
			
			_slider.addEventListener(_slider.E_SLIDER_CHANGE,soundChangeHandler);
			
		}
		
		
		public function init(dmLive:DMCenter):void{
			
			_dmLive = dmLive;
			_qualityTitle.label = dmLive.currQualityLabel;
			_qualityPanel.setLabels(dmLive.getTitles());
			_qualityPanel.selectLabel(_qualityTitle.label);
			
			_qualityTitle.visible            = _dmLive.isShowQualitySwitch()
			_btnBarrageStatus.visible = LiveConfig.get.initOption.roomType==2;
			layout();
		}
		
		
		protected function layout():void{
			
			var preSpace:int = LiveConfig.get.initOption.showSwitchRoom? 80:10;
			
			_btnPlayStatus.x = preSpace;
			_btnPlayStatus.y = (BAR_HEIGHT - _btnPlayStatus.height)/2;
			
			_btnSoundStatus.x = _btnPlayStatus.x +_btnPlayStatus.width+ SPACE;
			_btnSoundStatus.y = (BAR_HEIGHT - _btnSoundStatus.height)/2;
			
			_slider.x = _btnSoundStatus.x + _btnSoundStatus.width+10;
			_slider.y = 20;
			_slider.value = LiveConfig.currentVolume;
			
			_btnScreenStatus.x = _slider.x+_slider.width+SPACE;
			_btnScreenStatus.y = (BAR_HEIGHT - _btnScreenStatus.height)/2;
			this._btnScreenStatus.visible = LiveConfig.get.initOption.allowFullscreen;
			
			_qualityTitle.x = _btnScreenStatus.x +_btnScreenStatus.width+SPACE;
			_qualityTitle.y = (BAR_HEIGHT - _qualityTitle.height)/2;
			
			_btnEffectStatus.x = _qualityTitle.x + _qualityTitle.width+SPACE;
			_btnEffectStatus.y = (BAR_HEIGHT - _btnEffectStatus.height)/2;
			
			_btnBarrageStatus.x = _btnEffectStatus.x + _btnEffectStatus.width+SPACE;
			_btnBarrageStatus.y = (BAR_HEIGHT - _btnBarrageStatus.height)/2;
			
		}
		
		
		
		public function resize(w:int,h:int):void{
			drawBg(w);
			if(UIManage.get.stage.displayState == StageDisplayState.NORMAL){
				_btnScreenStatus.status =_btnScreenStatus.STATUS_NOMAL;
			}
		}
		
		
		private function changePlayStatusHandler(event:Event):void{
			
			switch(_btnPlayStatus.status){
				case _btnPlayStatus.STATUS_PLAY:  //播放按钮
					_btnPlayStatus.status = _btnPlayStatus.STATUS_PAUSE;
					
					Notification.get.notify(new MEvent(NoticeKey.N_PLAY_PAUSE,NoticeKey.TYPE_VIDEO_STATUS_PAUSE));
					LiveConfig.currVideoStatus =NoticeKey.TYPE_VIDEO_STATUS_PAUSE;
					
					break;
				
				case _btnPlayStatus.STATUS_PAUSE: //播放按钮
					_btnPlayStatus.status = _btnPlayStatus.STATUS_PLAY;
					
					Notification.get.notify(new MEvent(NoticeKey.N_PLAY_PAUSE,NoticeKey.TYPE_VIDEO_STATUS_PLAYING));
					LiveConfig.currVideoStatus =NoticeKey.TYPE_VIDEO_STATUS_PLAYING;
					
					break;
			}
		}
		
		
		private function changeScreenHandler(event:Event):void{
			switch(_btnScreenStatus.status){
				case _btnScreenStatus.STATUS_FULL :
					_btnScreenStatus.status = _btnScreenStatus.STATUS_NOMAL;
					UIManage.get.stage.displayState = StageDisplayState.NORMAL;
					break;
				
				case _btnScreenStatus.STATUS_NOMAL :
					_btnScreenStatus.status = _btnScreenStatus.STATUS_FULL;
					if (LiveConfig.get.initOption.roomType == 2 &&
						checkVersion() && LiveConfig.isFullScreenInteractive  )
					{
						try{
							UIManage.get.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
						}catch(err:Error){
							UIManage.get.stage.displayState = StageDisplayState.FULL_SCREEN;
						}
						
						
					}
					else
					{
						UIManage.get.stage.displayState = StageDisplayState.FULL_SCREEN;
					}
					break;
			}
		}
		
		/**
		 * 检查flash版本是否大于11.3， 支持全屏交互
		 * @return 
		 * 
		 */		
		private function checkVersion():Boolean
		{
			var verstr:String = Capabilities.version;
			var verary:Array = verstr.split(/[,\ ]/);
			var major:Number = Number(verary[1]);
			var minor:Number = Number(verary[2]);
			
			if(major > 11)
				return true;
			
			if(major == 11 && minor >= 3)
				return true
			
			return false;
		}
		
		
		private function changeEffectHandler(event:Event):void{
			
			switch(_btnEffectStatus.status){
				case _btnEffectStatus.STATUS_OFF:
					_btnEffectStatus.status = _btnEffectStatus.STATUS_ON;
					LFExtenrnalInterface.get.controlEffect(1);
					UIManage.get.openUI(UIKey.UI_GIFT_SHOW);
					break;
				
				case _btnEffectStatus.STATUS_ON :
					_btnEffectStatus.status = _btnEffectStatus.STATUS_OFF;
					LFExtenrnalInterface.get.controlEffect(0);
					UIManage.get.closeUI(UIKey.UI_GIFT_SHOW);
					break;
			}
		}
		
		
		private function changeSoundIconHandler(event:Event):void{
			switch(_btnSoundStatus.status){
				case _btnSoundStatus.STATUS_CLOSE:
					_btnSoundStatus.status = _btnSoundStatus.STATUS_OPEN;
					_catchVolume = _slider.value;
					_catchVolume= _catchVolume==0? 0.5:_catchVolume;
					_slider.value = 0;
					
					Notification.get.notify(new MEvent(NoticeKey.N_CHANGE_VOLUME,0));
					break;
				
				case _btnSoundStatus.STATUS_OPEN :
					_btnSoundStatus.status = _btnSoundStatus.STATUS_CLOSE;
					_slider.value = _catchVolume;
					Notification.get.notify(new MEvent(NoticeKey.N_CHANGE_VOLUME,_catchVolume));
					break;
			}
		}
		
		
		
		public function setMuteStatus(type:int):void{
			if(type==0){
				_btnSoundStatus.status = _btnSoundStatus.STATUS_CLOSE;
			}else{
				_btnSoundStatus.status = _btnSoundStatus.STATUS_OPEN;
			}
			
			changeSoundIconHandler(null);
		}
		
		
		
		
		/**
		 * 弹幕开/关
		 */
		private function changeBarrageStatusHandler(event:Event):void{
			switch(_btnBarrageStatus.status){
				case _btnBarrageStatus.STATUS_OFF:
					_btnBarrageStatus.status = _btnBarrageStatus.STATUS_ON;
					
					LFExtenrnalInterface.get.setBarrageChatStatus(1);
					break;
				case _btnBarrageStatus.STATUS_ON :
					_btnBarrageStatus.status = _btnBarrageStatus.STATUS_OFF;
					LFExtenrnalInterface.get.setBarrageChatStatus(0);
					break;
			}
			
		}
		
		
		/**show  hide  quality panel*/
		private function controlQualityHandler(event:MouseEvent):void{
			
			if(_qualityPanel.isShow()){
				_qualityPanel.close();
			}else{
				_qualityPanel.open(this,_qualityTitle.x-5,_qualityTitle.y - _qualityPanel.height);
			}
		}
		
		
		/**清晰度切换 */
		private function qualitySwitchHandler(event:Event):void{
			_qualityTitle.label = _qualityPanel.currentLable;
			
			_dmLive.switchQuality(_qualityTitle.label);
			
			if(_qualityPanel.isShow()){
				_qualityPanel.close();
			}
			
		}
		
		
		private function soundChangeHandler(event:Event):void{
			
			if(_slider.value<=0){
				_btnSoundStatus.status = _btnSoundStatus.STATUS_OPEN;
			}else{
				_btnSoundStatus.status = _btnSoundStatus.STATUS_CLOSE;
			}
			Notification.get.notify(new MEvent(NoticeKey.N_CHANGE_VOLUME,_slider.value));
		}
		
		
		public function reset():void{
			_btnPlayStatus.status = _btnPlayStatus.STATUS_PAUSE;
			changePlayStatusHandler(null);
		}
		
		
		
		public function close():void{
			_qualityPanel.close();
		}
		
		
		
		private function drawBg(w:int = 500):void{
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x000000,0.7);
			_bg.graphics.drawRect(0,0,w,BAR_HEIGHT);
			_bg.graphics.endFill();
		}
		
		
		private var _bg:Shape = new Shape();
		
		protected var _btnPlayStatus    :BtnPlayStatus;
		protected var _btnScreenStatus:BtnScreenStatus;
		protected var _btnEffectStatus  :BtnEffectStatus;
		protected var _btnSoundStatus :BtnSoundStatus;
		protected var _btnBarrageStatus:BtnBarrageStatus;
		
		protected var _qualityTitle:QualityTitle     = new QualityTitle();
		protected var _qualityPanel:QualityPanel = new QualityPanel();
		
		protected var _slider:LfSlider = new LfSlider(80)
		private var _catchVolume:Number = 0;
		
		protected var _dmLive:DMCenter;
		
		
	}
}