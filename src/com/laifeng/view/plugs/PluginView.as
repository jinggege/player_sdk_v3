package com.laifeng.view.plugs
{
	import com.laifeng.config.LiveConfig;
	import com.laifeng.config.UIKey;
	import com.laifeng.controls.LFExtenrnalInterface;
	import com.laifeng.controls.UIManage;
	import com.laifeng.interfaces.IPlugin;
	import com.laifeng.interfaces.IUI;
	import com.laifeng.view.plugs.endbill.PlugEndbill;
	import com.laifeng.view.plugs.guide.livehouse.PlugGuideLivehouse;
	import com.laifeng.view.plugs.guide.showroom.PlugGuideShowroom;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	
	public class PluginView extends Sprite implements IUI
	{
		
		public function PluginView()
		{
			super();
			addChild(layer1);
			addChild(layer2);
			
			_waitNoticeDic["1"] = "表演嘉宾正在后台准备,别着急,再等等啦～";
			_waitNoticeDic["2"] = "暂时木有表演嘉宾!";
		}
		
		
		public function open():void
		{
			_tfWait.text = "";
			_defaultW = _defaultW==0?LiveConfig.get.defaultWidth:_defaultW;
			_defaultH = _defaultH==0?LiveConfig.get.defaultHeight:_defaultH;
			UIManage.get.openUI(UIKey.UI_BACKGROUND);
			UIManage.get.closeUI(UIKey.UI_ERROR);
			UIManage.get.closeUI(UIKey.UI_CONTROLBAR);
			UIManage.get.closeUI(UIKey.UI_LOADING);
			
			this.close();
			
			switch(LFExtenrnalInterface.get.stopSkinType){
				case 0:
					layer1.visible = true;
					layer2.visible  =false;
					if(_plugsDic[0] == null || _plugsDic[1]==null){
						if(LiveConfig.get.initOption.roomType==0){
							_plugsDic[0] = new PlugGuideShowroom(0);
						}else{
							_plugsDic[0] = new PlugGuideLivehouse(0);
						}
						_plugsDic[1] = new  PlugEndbill(1);
					}
					
					if(LiveConfig.liveStatus < 2){
						openPlug(LiveConfig.liveStatus);
					}
					break
				
				default :
					
					var noticeId:String = LFExtenrnalInterface.get.stopSkinType.toString();
					var noticeMsg:String = _waitNoticeDic[noticeId]==null? "无此停播类型":_waitNoticeDic[LFExtenrnalInterface.get.stopSkinType.toString()];
					
					layer1.visible = false;
					layer2.visible = true;
					var html:String = "";
					html = "<p align='center'> <font size='20' color='#FFFFFF' face='微软雅黑,Microsoft YaHei,Arial'>";
					html+=noticeMsg;
					html+="</font></p>";
					_tfWait.htmlText = html;
					_tfWait.width = _defaultW;
					_tfWait.y = (_defaultH - _tfWait.height)/2+10;
					_tfWait.selectable = false;
					_tfWait.multiline = true;
					layer2.addChild(_tfWait);
					break;
			}
		}
		
		
		
		public function close():void
		{
			//直播台停播
			if(layer2.contains(_tfWait)){
				layer2.removeChild(_tfWait);
				_tfWait.text = "";
			}
			layer1.visible = false;
			layer2.visible = false;
			
			closePlug(0);
			closePlug(1);
		}
		
		public function updata():void
		{
		}
		
		public function screenChange(w:int, h:int):void
		{
			_defaultW = w;
			_defaultH = h;
			
			_tfWait.width= _defaultW;
			_tfWait.y = (h - _tfWait.height)/2;
			
			if(_currPlug == null) return;
			_currPlug.screenChange(w,h);
			
		}
		
		private function callback(id:int):void{
			
			if(id==1){
				openPlug(0);
			}
		}
		
		
		private function openPlug(id:int):void{
			
			var plug:IPlugin = _plugsDic[id];
			plug.start(callback);
			layer1.addChild(plug as Sprite);
			_currPlug = plug;
			
			screenChange(_defaultW,_defaultH);
		}
		
		
		private function closePlug(id:int):void{
			var plug:IPlugin = _plugsDic[id];
			if(plug == null) return;
			if(layer1.contains(plug as Sprite)){
				plug.destroy();
				layer1.removeChild(plug as Sprite);
			}
		
		}
		
		
		
		public function get level():int
		{
			return UIKey.UI_LEVEL_3;
		}
		
		public function set uiState(value:String):void
		{
		}
		
		public function get uiState():String
		{
			return null;
		}
		
		public function destroy():void
		{
		}
		
		private var _nextIssueUrl:String = "";
		
		private var _plugsDic:Dictionary = new Dictionary();
		private var _currPlug:IPlugin;
		
		private var _defaultW:int = 0;
		private var _defaultH:int = 0;
		
		private var _tfWait:TextField = new TextField();
		private var _waitNoticeDic:Dictionary = new Dictionary();
		
		private var layer1:Sprite = new Sprite();
		private var layer2:Sprite = new Sprite();
		
		
		
	}
}