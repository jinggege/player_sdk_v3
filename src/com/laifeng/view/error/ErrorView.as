package com.laifeng.view.error
{
	import com.laifeng.config.LiveConfig;
	import com.laifeng.config.NoticeKey;
	import com.laifeng.config.UIKey;
	import com.laifeng.controls.LFExtenrnalInterface;
	import com.laifeng.controls.Notification;
	import com.laifeng.controls.UIManage;
	import com.laifeng.event.MEvent;
	import com.laifeng.interfaces.IUI;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import lf.media.core.data.ErrorCode;
	import lf.media.core.util.Console;

	public class ErrorView extends Sprite implements IUI
	{
		public function ErrorView()
		{
			_tf.selectable = false;
			
			_tf.text = "";
			_tf.textColor = 0xFFFFFF;
			
			_tf.width = LiveConfig.get.defaultWidth;
			_tf.height = 60;
			this.addChild(_tf);
			
			var tfFormat:TextFormat = new TextFormat();
			tfFormat.align = TextAlign.CENTER;
			tfFormat.size   = 20;
			tfFormat.bold  = true;
			
			_tf.defaultTextFormat = tfFormat;
			_tf.setTextFormat(tfFormat);
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			Notification.get.addEventListener(NoticeKey.N_ERROR_MSG,displayErrorHandler);
		}
		
		
		public function open():void{
			UIManage.get.closeUI(UIKey.UI_LOADING);
			if(this.stage != null){
				var cc:int = this.stage.stageWidth;
				screenChange(this.stage.stageWidth,this.stage.stageHeight);
			}
		}
		
		public function updata():void{
			this.x = (LiveConfig.get.defaultWidth - this.width)/2;
			this.y = (LiveConfig.get.defaultHeight - this.height)/2;
		}
		
		
		
		public function screenChange(w:int,h:int):void{
			
			_tf.x = (w-_tf.width)/2;
			_tf.y = (h-_tf.height)/2;
		}
		
		
		
		
		private function displayErrorHandler(event:MEvent):void{
			var errorStr:String = event.data as String;
			_tf.text = _title+"\n "+"异常代号: "+errorStr;
			LFExtenrnalInterface.get.callbackLiveStatus(errorStr,errorStr+":"+ErrorCode.getErrorMsg(errorStr));
			LFExtenrnalInterface.get.callbackLiveStop();
			UIManage.get.openUI(UIKey.UI_ERROR);
		}
		
		
		public function get level():int{
			return UIKey.UI_LEVEL_3;
		}
		
		
		public function set uiState(value:String):void{
			this._uiState = value;
		}
		
		public function get uiState():String{
			return this._uiState;
		}
		
		
		public function close():void{
		}
		
		
		public function destroy():void{
		
		}
		
		
		private var _tf:TextField = new TextField();
		private var _uiState:String = "";
		
		private var _title:String = "出现异常, 请刷新重试！";
		
		
		
		
	}
}