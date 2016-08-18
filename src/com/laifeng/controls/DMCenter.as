package com.laifeng.controls
{
	import com.laifeng.config.LiveConfig;
	import com.laifeng.config.ModuleKey;
	import com.laifeng.config.NoticeKey;
	import com.laifeng.config.UIKey;
	import com.laifeng.event.MEvent;
	import com.laifeng.interfaces.IDataModule;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import lf.media.core.data.InitOption;
	import lf.media.core.data.LiveCoreDataV2;
	import lf.media.core.data.PlayOption;
	import lf.media.core.data.StatusConfig;
	import lf.media.core.data.StatusData;
	import lf.media.core.event.LfEvent;
	import lf.media.core.util.Console;
	
	public class DMCenter extends EventDispatcher implements IDataModule
	{
		public function DMCenter(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function start():void
		{
			Notification.get.addEventListener(NoticeKey.N_LIVE_START_BY_JS,beginLiveHandler);
			Notification.get.addEventListener(NoticeKey.N_LIVE_STOP_BY_JS,stopByJsHandler);
			_reportM = DataModule.get.getModule(ModuleKey.DM_REPORT) as DMReport;
		}
		
		
		
		public function initConfig(initInfo:Object):void{
			_initOption = new InitOption(initInfo);
			LiveConfig.get.initOption = _initOption;
			
			LiveConfig.get.defaultWidth = _initOption.playerWidth;
			LiveConfig.get.defaultHeight = _initOption.playerHeight;
			
			Console.log("init=>",_initOption);
		}
		
		
		private function beginLiveHandler(event:MEvent):void{
			
			Console.log("initoption=>",_initOption);
			var playInfo:Object              = event.data;
			Console.log("playoption=>",playInfo);
			
			var playOption:PlayOption = new PlayOption();
			if(playInfo.hasOwnProperty("alias")){
				playOption.alias = playInfo["alias"];
			}
			
			if(playInfo.hasOwnProperty("streamId")){
				playOption.streamId = playInfo["streamId"];
			}
			
			
			
			var dQuality:int =  int(playInfo["defaultQuality"])-1<=0? 0:int(playInfo["defaultQuality"])-1;
			playOption.defaultQuality = dQuality;
			
			if(playInfo.hasOwnProperty("titles")){
				playOption.titles = playInfo["titles"];
				_initOption.titles  = playInfo["titleList"];
			}
			
			playOption.token          = playInfo["token"].toString();
			playOption.sdkversion = _initOption["sdkVersion"];
			
			Notification.get.notify(new MEvent(NoticeKey.CLOSE_UI,UIKey.UI_VIDEO));
			Notification.get.notify(new MEvent(NoticeKey.CLOSE_UI,UIKey.UI_PLUGS));
			this.play(playOption);
			
		}
		
		
		
		private function stopByJsHandler(event:MEvent):void{
			LiveConfig.liveStatus = 1;
			Notification.get.notify(new MEvent(NoticeKey.N_COMMAND_STOP,null));
			Notification.get.notify(new MEvent(NoticeKey.OPEN_UI,UIKey.UI_PLUGS));
		}
		
		
		public function play(playOption:PlayOption):void{
			Notification.get.notify(new MEvent(NoticeKey.OPEN_UI,UIKey.UI_LOADING));
			clearLiveCoreData();
			
			if(_liveCoreDataP != null){
				clearLiveCoreData();
			}
			
			_liveCoreDataP = new LiveCoreDataV2();
			_liveCoreDataP.addEventListener(StatusConfig.STATUS_ERROR,errorHandler);
			_liveCoreDataP.addEventListener(StatusConfig.STATUS_GET_URL_SUCCESS,requestCompleteHandler);
			_liveCoreDataP.addEventListener(StatusConfig.STATUS_INIT_COMPLETE,getTitlesCompleteHandler);
			
			_liveCoreDataP.init(_initOption);
			playOption.sessionId = _initOption.sessionId;
			_liveCoreDataP.play(playOption);
		}
		
		
		private function requestCompleteHandler(event:LfEvent):void{
			var statusData:StatusData = event.data as StatusData;
			
			var reportS:Object    = {};
			
			Notification.get.notify(new MEvent(NoticeKey.OPEN_UI,UIKey.UI_VIDEO));
			reportS["tc"]   = _liveCoreDataP.requestTryCount;
			reportS["ct"]   =_liveCoreDataP.requestUseTime;
			_reportM.reportPlayurlSucceed(reportS);
			reportS = null;
			LiveConfig.get.streamLogData.bps = _liveCoreDataP.bps;
			LiveConfig.get.streamLogData.streamID = _liveCoreDataP.streamId;
			
		}
		
		
		private function getTitlesCompleteHandler(event:LfEvent):void{
			var statusData:StatusData = event.data as StatusData;
		}
		
		
		
		public function getStreamUrl():String{
			return _liveCoreDataP.getStreamUrl();
		}
		
		
		public function getTitles():Array{
			return _liveCoreDataP.getTitles();
		}
		
		
		
		public function getDefaultQualityTitle():String{
			return _liveCoreDataP.getCurrQualityTitle();
		}
		
		
		public function get currQualityLabel():String{
			return _liveCoreDataP.getCurrQualityTitle();
		}
		
		
		
		
		public function switchQuality(title:String):void{
			_liveCoreDataP.switchQuality(title);
		}
		
		
		public function isShowQualitySwitch():Boolean{
			var flag:Boolean = false;
			flag = getTitles().length>=2? true:false;
			return flag;
		}
		
		
		private function errorHandler(event:LfEvent):void{
			var statusData:StatusData = event.data as StatusData;
			
			var errInfo:Object = {};
			errInfo["reason"]     = statusData.desc;
			errInfo["tryCount"] = _liveCoreDataP.requestTryCount;
			errInfo["ct"]              = _liveCoreDataP.requestUseTime;
			errInfo["ec"]              = statusData.data.ec;
			_reportM.reportGetplaylistFail(errInfo);
			Notification.get.notify(new MEvent(NoticeKey.N_ERROR_MSG,statusData.data.ec.toString()));
		}
		
		/**
		 * 是否显示清晰度选择
		 */
		public function isShowQualitySelect():Boolean{
			return _liveCoreDataP.getPlayListLength()() >= 1;
		}
		
		
		public function getLiveCoreData():LiveCoreDataV2{
			return _liveCoreDataP;
		}
		
		
		
		private function clearLiveCoreData():void{
			if(_liveCoreDataP != null){
				_liveCoreDataP.destroy();
				_liveCoreDataP.removeEventListener(StatusConfig.STATUS_ERROR,errorHandler);
				_liveCoreDataP.removeEventListener(StatusConfig.STATUS_GET_URL_SUCCESS,requestCompleteHandler);
				_liveCoreDataP.removeEventListener(StatusConfig.STATUS_INIT_COMPLETE,getTitlesCompleteHandler);
			}
			_liveCoreDataP = null;
		}
		
		
		public function destroy():void
		{
			clearLiveCoreData();
		}
		
		
		private var _liveCoreDataP     :LiveCoreDataV2;
		private var _roomId                 :String = "";
		private var _reportM               :DMReport;
		private var _initOption            :InitOption;
		
		
	}
}