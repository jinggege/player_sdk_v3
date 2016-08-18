package com.laifeng.view.plugs.guide.livehouse
{
	import com.adobe.json.JSON;
	import com.laifeng.config.LiveConfig;
	import com.laifeng.config.UIKey;
	import com.laifeng.controls.LFExtenrnalInterface;
	import com.laifeng.controls.UIManage;
	import com.laifeng.interfaces.IPlugin;
	import com.laifeng.view.plugs.control.SimpleUrlLoader;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import lf.media.core.util.Console;
	
	/**
	 * 插件:正在直播的直播间推荐 只显示前三名 
	 */
	
	public class PlugGuideLivehouse extends Sprite implements IPlugin
	{
		
		public var id:int = 0;
		public const MAX_W:int = 440;
		
		private const nextIssueUrl:String = "http://v.laifeng.com/room/";
		
		
		public function PlugGuideLivehouse(id:int)
		{
			this.id = id;
			_itemList = new Vector.<GuideItemLivehouse>;
			creatItem();
			
			
			_tfNextMsg.width  = MAX_W
			_tfNextMsg.height = 30;
			addChild(_tfNextMsg);
			_tfNextMsg.selectable = false;
			
			_tfCountDown.width = MAX_W;
			_tfCountDown.height = 60;
			_tfCountDown.selectable = false;
			addChild(_tfCountDown);
			
			_tfCountDown.y = _tfNextMsg.y +30;
			
			
			this.addChild(_layerItem);
			_layerItem.y = _tfNextMsg.y+120;
			
			_countDownTime.addEventListener(TimerEvent.TIMER,timeRunHandler);
		}
		
		
		/**参数*/
		public function set param(value:Object):void{
			_param = value;
		}
		
		/**启动*/
		public function start(callback:Function):void{
			
			_callback = callback;
			
			var  sLoader2:SimpleUrlLoader = new SimpleUrlLoader(null,2);
			sLoader2.listener(getDataResult);
			
			var url:String = nextIssueUrl+LiveConfig.get.initOption.roomId+"/rec?rd="+int(Math.random() * 999);
			sLoader2.startLoad(url);
		}
		
		
		/**
		 * 获取数据结果
		 */
		private function getDataResult(data:Object):void
		{
			switch(data["type"]){
				case Event.COMPLETE :
					var content:Object = data["content"];	
					initList(content["data"]);
					initTitle(content["data"]);
					break;
			}
			
		}
		
		
		
		private function timeRunHandler(event:TimerEvent):void{
			_systemTime--;
			
			if(_systemTime <=0){
				UIManage.get.closeUI(UIKey.UI_PLUGS);
				_countDownTime.stop();
				return;
			}
			
			
			var html:String = "";
			html = "<p align='center'> <font size='45' color='#FFFFFF' face='微软雅黑,Microsoft YaHei,Arial'>";
			html+=formatTime(_systemTime);
			html+="</font></p>";
			_tfCountDown.htmlText = html;
		}
		
		
		
		
		/**结束  @param callback(结束回调)*/
		public function end():void{
		}
		
		/**
		 * 更新
		 */
		public function screenChange(w:int,h:int):void
		{
			this.x = (w - MAX_W)/2 ;
			this.y = (h-300)/2;
		}
		
		
		/**
		 * 从推荐列表中剔除当前直播间 防止在自己的直播间推荐自己
		 */
		private function removeAnchorInfoByRoomdId(arr:Array):void
		{
			var len:int = arr.length>=4?4:arr.length;
			for(var i:int=0; i<len;i++)
			{
				if(String(arr[i]["roomId"]) == LiveConfig.get.initOption.roomId)
				{
					arr.splice(i,1);
					return;
				}
			}
		}
		
		
		/**
		 * 创建ITEM
		 */
		private function creatItem():void
		{
			for(var i:int=0; i<3;i++)
			{
				_itemList.push(new GuideItemLivehouse());
			}
		}
		
		
		private function initList(jsonStr:String):void
		{
			
			if(_layerItem.numChildren){
				_layerItem.removeChild(_layerItem.getChildAt(0));
			}
			var data:Object = com.adobe.json.JSON.decode(jsonStr);
			
			if(int(data["response"]["code"]) == -1) return;
			
			var list:Array = data["response"]["data"]["data"];
			
			removeAnchorInfoByRoomdId(list);
			
			var len:int = list.length>3? 3:list.length;
			if(len == 0) return;
			
			var item:GuideItemLivehouse
			for(var i:int = 0; i<len; i++)
			{
				item = _itemList[i];
				_layerItem.addChild(item);
				item.setData(list[i]);
				item.x = i * 150;
			}
		}
		
		private function initTitle(jsonStr:String):void
		{
			var data:Object = com.adobe.json.JSON.decode(jsonStr);
			
			if(int(data["response"]["code"]) == -1) return;
			
			var nextTimeStr:String = LFExtenrnalInterface.get.getCountDown();
			var timeInfo:Object = null;
			
			try{
				timeInfo = JSON.decode(nextTimeStr);
				Console.log("time info =",timeInfo);
			}catch(e:Error){
				Console.log("time info string=",nextTimeStr);
				timeInfo = {};
				timeInfo["sysTime"] = 0;
				timeInfo["endTime"] = 0;
			}
			
			var startTime:Number = Number(timeInfo["sysTime"]);
			var endTime:Number = Number(timeInfo["endTime"]);
			
			var date:Date = new Date(endTime);
			
			var minutesStr:String = date.minutes>=10? date.minutes.toString() : "0"+date.minutes;
			
			var str:String = "下期直播时间  "+(date.month+1)+"月"+date.getDate()+"日"+"  "+date.hours+"："+minutesStr;
			var html:String = "<p align='center'> <font size='18' color='#CCCCCC' face='微软雅黑,Microsoft YaHei,Arial'>";
			html+=str;
			html+="</font></p>";
			
			_tfNextMsg.htmlText = html;
			
			
			
			_systemTime = (endTime - startTime)/1000;
			Console.log("systime="+timeInfo["sysTime"],"  endTime="+timeInfo["endTime"],"  time="+_systemTime);
				
				if(_systemTime>0){
					if(!_countDownTime.running){
						_countDownTime.start();
					}
				}else{
					str = "目前暂无直播";
					
					if(data["response"]["data"]["next"] != ""){
						str = data["response"]["data"]["next"]
					}
					
					
					html = "<p align='center'> <font size='18' color='#CCCCCC' face='微软雅黑,Microsoft YaHei,Arial'>";
					html+=str;
					html+="</font></p>";
					_tfNextMsg.htmlText = html;
					_tfCountDown.text ="";
					
					_countDownTime.stop();
				}
		}
		
		
		
		private function formatTime(timeNum:Number):String{
			
			var dS:Number = timeNum/_ds;
			var day:int = dS;
			var hourNum:Number = (dS - int(dS)) *_ds/3600  ;
			var hour:int = hourNum;
			
			var mNum:Number = (hourNum - hour) * 60;
			var m:int = mNum;
			
			var s:int = (mNum-m)*60;
			
			
			var dayStr:String   = day>=10? day.toString() : "0"+day;
			var hourStr:String = hour>=10? hour.toString() : "0"+hour;
			var mStr:String =m>=10? m.toString(): "0"+m;
			var sStr:String = s>=10? s.toString() : "0"+s;
			
			return dayStr+"："+hourStr+"："+mStr+"："+sStr;
		}
		
		
		private function numFixed(targetNum:Number,fix:int):Number{
			return Number(targetNum.toFixed(fix));
		}
		
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			trace('io error');
		}
		
		
		public function destroy():void
		{
		}
		
		
		private var _itemList:Vector.<GuideItemLivehouse>;
		private var _layerItem:Sprite = new Sprite();
		
		private var _param:Object;
		//回调
		private var _callback:Function;
		
		private var _tfNextMsg:TextField = new TextField();
		private var _tfCountDown:TextField = new TextField();
		
		private var _systemTime:Number = 0;
		
		private var _ds:Number = 86400;   //86400=24*60*60*1000
		
		private var _countDownTime:Timer = new Timer(1000);
		
		
		
		
	}
}