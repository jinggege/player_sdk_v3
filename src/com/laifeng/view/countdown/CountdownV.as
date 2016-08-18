package com.laifeng.view.countdown
{
	import com.adobe.json.JSON;
	import com.laifeng.config.LiveConfig;
	import com.laifeng.config.UIKey;
	import com.laifeng.controls.LFExtenrnalInterface;
	import com.laifeng.controls.UIManage;
	import com.laifeng.interfaces.IUI;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import lf.media.core.util.Console;
	
	public class CountdownV extends Sprite implements IUI
	{
		public function CountdownV()
		{
			super();
			_tf.width =300;
			_tf.height = 30;
			_tf.wordWrap = true;
			
			_nextTime.width = 300;
			_nextTime.height = 30;
			_nextTime.wordWrap = true;
			
			_nextTime.x = _tf.x = 10;
			
			_nextTime.y = 30;
			_tf.y = _nextTime.y+_nextTime.height-10;
			
			addChild(_nextTime);
			addChild(_tf);
		}
		
		public function open():void
		{

			_nextTime.text = "";
			_tf.text = "";
			
			_countDownTime.addEventListener(TimerEvent.TIMER,timeRunHandler);
			
			var nextTimeStr:String = LFExtenrnalInterface.get.getCountDown();
			var timeInfo:Object = null;
			
			try{
				timeInfo = JSON.decode(nextTimeStr);
				Console.log("time info =",timeInfo);
			}catch(e:Error){
				Console.log("time info string=",nextTimeStr);
				UIManage.get.closeUI(UIKey.UI_COUNTDOWN);
				return;
			}
			
			
			var startTime:Number = Number(timeInfo["sysTime"]);
			var endTime:Number = Number(timeInfo["endTime"]);
			
			
			var date:Date = new Date(endTime);
			var minutesStr:String = date.minutes>=10? date.minutes.toString() : "0"+date.minutes;
			var str:String = "下期直播时间  "+(date.month+1)+"月"+date.getDate()+"日"+"  "+date.hours+"："+minutesStr;
			
			var html:String = "";
			html = "<p align='left'> <font size='14' color='#FFFFFF' face='微软雅黑,Microsoft YaHei,Arial'>";
			html+=str;
			html+="</font></p>";
			
			_nextTime.htmlText = html;
			
			Console.log("systime="+timeInfo["sysTime"],"  endTime="+timeInfo["endTime"],"  time="+_systemTime);
			
			_systemTime = (endTime - startTime)/1000;
			
			if(_systemTime>0){
				if(!_countDownTime.running){
					_countDownTime.start();
				}
			}else{
				_countDownTime.stop();
				UIManage.get.closeUI(UIKey.UI_COUNTDOWN);
			}

		}
		
		private function timeRunHandler(event:TimerEvent):void{
			_systemTime--;
			
			if(_systemTime <=0){
				UIManage.get.closeUI(UIKey.UI_COUNTDOWN);
				_countDownTime.stop();
				return;
			}
			
			var html:String = "";
			html = "<p align='left'> <font size='20' color='#FFFFFF' face='微软雅黑,Microsoft YaHei,Arial'>";
			html+=formatTime(_systemTime);
			html+="</font></p>";
			_tf.htmlText = html;
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
		
		
		
		public function close():void
		{
			_countDownTime.stop();
			_countDownTime.removeEventListener(TimerEvent.TIMER,timeRunHandler);
		}
		
		public function updata():void
		{
		}
		
		public function screenChange(w:int, h:int):void
		{
		}
		
		public function get level():int
		{
			return UIKey.UI_LEVEL_3;
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
		
		
		
		private var _tf:TextField = new TextField();
		private var _countDownTime:Timer = new Timer(1000);
		private var _systemTime:Number = 0;
		private var _ds:Number = 86400;   //86400=24*60*60*1000
		private var _uiStatus:String = "";
		private var _nextTime:TextField = new TextField();
		
	}
}