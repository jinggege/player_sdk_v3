package com.laifeng.controls
{
	import com.laifeng.config.LiveConfig;
	import com.laifeng.config.NoticeKey;
	import com.laifeng.config.UIKey;
	import com.laifeng.event.MEvent;
	
	import flash.external.ExternalInterface;
	
	import lf.media.core.util.Console;
	
	/**********************************************************
	 * LFExtenrnalInterface
	 * 
	 * Author : mj
	 * Description:
	 *  		提供JS  AS 相互调用接口      系统内所有与 JS 交互必须统一
	 * 			用此处接口
	 ***********************************************************/

	public class LFExtenrnalInterface
	{
		//停播类型  0:正常停播   1：直播台特殊停播
		public var stopSkinType:int  = 0;
		
		public function LFExtenrnalInterface()
		{
			if(_instance != null){
				return;
			}
		}
		
		
		public function start():void{
			ExternalInterface.addCallback("debug",   this.debug);
			ExternalInterface.addCallback("startLive",  startLive);
			ExternalInterface.addCallback("stopLive",this.stopLive);
			ExternalInterface.addCallback("setChatInfo", this.setChatInfo);
			
			ExternalInterface.addCallback("exSetPlayerWH",   this.exSetPlayerWH);
			ExternalInterface.addCallback("exShowCtrBar",   this.exShowCtrBar);
			ExternalInterface.addCallback("exVolumeChange",   this.exVolumeChange);
			ExternalInterface.addCallback("getVolume",   this.getVolume);
			ExternalInterface.addCallback("exMute",   this.exMute);
			
			ExternalInterface.addCallback("setBarrageChatStatus",   this.setBarrageChatStatus);
			
			
			ExternalInterface.addCallback("sendChatRespone",   this.sendChatRespone);
			ExternalInterface.addCallback("sendHornRespone",   this.sendHornRespone);
			
			
			ExternalInterface.addCallback("setBarrageLayout",   this.setBarrageLayout);
			ExternalInterface.addCallback("setBarrageAlpha",   this.setBarrageAlpha);
			ExternalInterface.addCallback("setBarrageColor",   this.setBarrageColor);
			ExternalInterface.addCallback("setBarrageChatOff",   this.setBarrageChatOff);
			
			ExternalInterface.addCallback("setGiftInfo",this.setGiftInfo);
			
			ExternalInterface.addCallback("getThesaurusResponse",this.getThesaurusResponse);
			
		}
		
		
		private function startLive(option:Object):int{
			Console.log("startLive",option);
			Notification.get.notify(new MEvent(NoticeKey.N_LIVE_START_BY_JS,option));
			return 1;
		}
		
		/**
		 * 停播接口
		 * param: type:(0:正常停播     1：直播台等待状态.   默认为0)
		 */
		public function stopLive(type:int = 0):void{
			
			this.stopSkinType = type;
			Notification.get.notify(new MEvent(NoticeKey.N_LIVE_STOP_BY_JS,null));
			Console.log("stop type:",type);
		}
		
		
		public function callbackLiveStatus(code:String,msg:String):void{
			ExternalInterface.call(LiveConfig.get.jsNameSpace+"liveStatus",code,msg);
		}
		
		/**
		 * 通知JS 播放器已停止
		 */
		public function callbackLiveStop():void{
			ExternalInterface.call(LiveConfig.get.jsNameSpace+"stopLive");
		}
		
		
		
		
		
		/**
		 * JS控制播放器尺寸
		 */
		public function exSetPlayerWH(info:Object):void{
			var event:MEvent = new MEvent(NoticeKey.SET_WH_BY_JS,{width:info["width"],height:info["height"]});
			Notification.get.notify(event);
		}
		
		
		/**
		 * JS 控制是否显示control bar 0:隐藏    1:显示 
		 */
		public function exShowCtrBar(isShow:int = 1):void{
			var show:Boolean =Boolean(isShow);
			LiveConfig.get.rootRightData.isShowCtrBar = show;
			
			var event:MEvent = new MEvent(NoticeKey.CLOSE_UI,UIKey.UI_CONTROLBAR);
			Notification.get.notify(event);
		}
		
		/**
		 * JS 改变音量
		 */
		public function exVolumeChange(volume:Number):void{
			var event:MEvent = new MEvent(NoticeKey.N_CHANGE_VOLUME_EX,volume);
			Notification.get.notify(event);
		}
		
		/**
		 * JS 获取播放器音量
		 */
		public function getVolume():Number{
			return LiveConfig.currentVolume;
		}
		
		/**
		 * 是否静音
		 * @param : type:0/1  0:静音    1：取消静音
		 */
		public function exMute(type:int):void{
			var event:MEvent = new MEvent(NoticeKey.N_MUTE,type);
			Notification.get.notify(event);
		}
		
		
		/**
		 * 聊天信息
		 * @ param chatInfo = {type:xxxx,info:xxxxx}
		 * 	                  type: 1:聊天 2: 金喇叭
		 *                   msg：消息内容
		 */
		public function setChatInfo(chatInfo:Object):void{
			//todo  屏蔽弹幕功能
			Console.log("xx:",chatInfo);
			var event:MEvent = new MEvent(NoticeKey.N_SEND_BARRAGE,chatInfo);
			Notification.get.notify(event);
		}
		
		
		/**
		 * 设置弹幕布局
		 */
		public function setBarrageLayout(layout:String):void{
			
			Notification.get.notify(new MEvent(NoticeKey.N_SET_BARRAGE,
					{type:NoticeKey.N_SET_BARRAGE_LAYOUT,value:layout}) );
		}
		
		
		/**
		 * 关闭聊天弹幕
		 * 0:关闭   1：开启
		 */
		public function setBarrageChatStatus(status:int):void{
			Notification.get.notify(new MEvent(NoticeKey.N_SET_BARRAGE,
				{type:NoticeKey.N_SET_BARRAGE_STATUS,value:status}) );
		}
		
		/**
		 * 设置弹幕透明度
		 */
		public function setBarrageAlpha(alpha:Number):void{
			Notification.get.notify(new MEvent(NoticeKey.N_SET_BARRAGE,
				{type:NoticeKey.N_SET_BARRAGE_ALPHA,value:alpha}) );
			
		}
		
		/**
		 * 设置弹幕颜色
		 */
		public function setBarrageColor(color:String):void{
			Notification.get.notify(new MEvent(NoticeKey.N_SET_BARRAGE,
				{type:NoticeKey.N_SET_BARRAGE_COLOR,value:color}) );
		}
		
		/**
		 * 关闭聊天弹幕
		 */
		public function setBarrageChatOff():void{
			Notification.get.notify(new MEvent(NoticeKey.N_SET_BARRAGE,
				{type:NoticeKey.N_SET_BARRAGE_OFF,value:0}) );
		}
		
		
		
		/**
		 * 开  关  特效
		 * @param isOpen: 0:关闭  1:开启
		 * 
		 */
		public function controlEffect(isOpen:int = 0):void{
			Console.log("[开关特效]=",isOpen);
			ExternalInterface.call(jsNamespace+"giftEffectToggle",isOpen);
		}
		
		/**送礼信息展示*/
		public function setGiftInfo(giftInfo:Object):void{
			var event:MEvent = new MEvent(NoticeKey.N_SEND_GIFT_INFO,giftInfo);
			Notification.get.notify(event);
		}
		
		
		public function getCountDown():String{
			
			var timeStr:String = ExternalInterface.call(jsNamespace+"videoCountDown");
			return timeStr;
		}
		
		
		
		/**
		 * 发送聊天信息到 JS 
		 */
		public function sendChatToJs(msg:String):void{
			ExternalInterface.call(jsNamespace+"chat",msg);
		}
		
		
		public function sendChatRespone(info:Object):void{
			var event:MEvent = new MEvent(NoticeKey.N_SEND_CHAT_RESPONE,info);
			Notification.get.notify(event);
		}
		
		
		/**
		 * 发送金喇叭 信息到 JS 
		 */
		public function sendHornToJs(msg:String):void{
			ExternalInterface.call(jsNamespace+"horn",msg);
		}
		
		
		public function sendHornRespone(info:Object):void{
				var event:MEvent = new MEvent(NoticeKey.N_SENT_HORN_RESPONE,info);
				Notification.get.notify(event);
		}
		
		
		/**
		 * 请求词库
		 */
		public function reqThesaurus(url:String):void{
			ExternalInterface.call(jsNamespace+"getJSON",url);
		}
		
		
		/**
		 * 获取词库返回
		 */
		public function getThesaurusResponse(info:Object,flag:Object = null):void{
			var event:MEvent = new MEvent(NoticeKey.N_THESAURUS_RESPONE,info);
			Notification.get.notify(event);
		}
		
		
		/**聊天的发言间隔时间*/
		private var chatRate:int = -1;
		public function getChatRate():int
		{
			return chatRate;
		}
		public function reqChatRate():void
		{
			var params:Object = ExternalInterface.call(jsNamespace+"getParams");
			if (params)
				chatRate = int(params.chatRate);
		}
		
		
		private function get jsNamespace():String{
			return LiveConfig.get.jsNameSpace;
		}
		
		
		public static function get get():LFExtenrnalInterface{
			_instance = _instance == null? new LFExtenrnalInterface(): _instance;
			return _instance;
		}
		
		/**
		 * 是否debug
		 */
		public function debug(status:Boolean):void{
			Console.isDebug = status;
		}
		
		/**
		 * 切换其他房间
		 */
		public function switchRoom():void{
			ExternalInterface.call("_flash_change_room");
			Console.log("change room");
		}
		
		
		private static var _instance:LFExtenrnalInterface;
		
		
		
		
	}
}