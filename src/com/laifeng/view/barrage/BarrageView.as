package com.laifeng.view.barrage
{
	/**********************************************************
	 * BarrageView
	 * 
	 * Author : mj
	 * Description:
	 *  		弹幕
	 ***********************************************************/
	
	import com.laifeng.config.LiveConfig;
	import com.laifeng.config.NoticeKey;
	import com.laifeng.config.UIKey;
	import com.laifeng.controls.Notification;
	import com.laifeng.controls.UIManage;
	import com.laifeng.event.MEvent;
	import com.laifeng.interfaces.IUI;
	
	import flash.display.Sprite;
	
	public class BarrageView extends Sprite implements IUI
	{
		public function BarrageView()
		{
			super();
			
			addChild(_barrageLayer);
			_barrageC = new BarrageControl(_barrageLayer);
		}
		
		public function open():void
		{
			_barrageC.start(LiveConfig.get.defaultWidth,LiveConfig.get.defaultHeight);
			_barrageC.resize(LiveConfig.get.defaultWidth,LiveConfig.get.defaultHeight);
			
			Notification.get.addEventListener(NoticeKey.N_SEND_BARRAGE,creatBarrageHandler);
			Notification.get.addEventListener(NoticeKey.N_SET_BARRAGE,setBarrageHandler);
		}
		
		
		
		public function updata():void
		{
		}
		
		
		
		
		private function creatBarrageHandler(mevent:MEvent):void{
			_barrageC.add(mevent.data);
		}
		
		
		
		public function screenChange(w:int, h:int):void
		{
			_barrageC.resize(w,h);
		}
		
		
		
		private function setBarrageHandler(event:MEvent):void{
			var info:Object = event.data;
			switch(info["type"]){
				case NoticeKey.N_SET_BARRAGE_ALPHA :
					_barrageC.setAlphaHandler(Number(info["value"]));
					break;
				case NoticeKey.N_SET_BARRAGE_COLOR :
					_barrageC.setColorHandler(info["value"].toString());
					break;
				case NoticeKey.N_SET_BARRAGE_LAYOUT :
					_barrageC.setLayoutHandler(info["value"].toString());
					break;
				case NoticeKey.N_SET_BARRAGE_STATUS :
					var bStatus:int = int(info["value"]);
					_barrageC.CHAT_STATUS = bStatus;
					if(bStatus == _barrageC.CHAT_STATUS_CLOSE){
						_barrageC.closeChat();
					}
					break;
				
			}
		
		}
		
		
		
		public function close():void
		{
			Notification.get.removeEventListener(NoticeKey.N_SEND_BARRAGE,creatBarrageHandler);
			Notification.get.removeEventListener(NoticeKey.N_SET_BARRAGE,setBarrageHandler);
			_barrageC.close();
		}
		
		
		public function get level():int
		{
			return  UIKey.UI_LEVEL_4;
		}
		
		public function set uiState(value:String):void
		{
			_uiStatus = value;
		}
		
		public function get uiState():String
		{
			return _uiStatus;
		}
		
		public function destroy():void
		{
		}
		
		
		private var _uiStatus:String = "";
		private var _barrageLayer:Sprite = new Sprite();
		private var _barrageC:BarrageControl;
		
		
	}
}