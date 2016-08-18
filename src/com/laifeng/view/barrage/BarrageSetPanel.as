package com.laifeng.view.barrage
{
	/**********************************************************
	 * BarrageSetPanel
	 * 
	 * Author : mj
	 * Description:
	 *  		弹幕设置面板
	 ***********************************************************/
	
	import com.laifeng.config.LiveConfig;
	import com.laifeng.config.NoticeKey;
	import com.laifeng.controls.Notification;
	import com.laifeng.event.MEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public class BarrageSetPanel extends Sprite
	{
		
		public function BarrageSetPanel()
		{
			super();
			
			initSkin();
		}
		
		
		private function initSkin():void{
			/*
			_panel = new FL_skin_barrage_panel();
			addChild(_panel);
			
			for(var i:int=0; i<4; i++){
				_aphaList.push({label:_panel["tf"+i],  btn:_panel["btnApha"+i]})
				_aphaList[i]["btn"].addEventListener(MouseEvent.CLICK,setAphaHandelr);
				
				_aphaList[i]["btn"].buttonMode = true;
				_aphaList[i]["btn"].alpha = 0;
			}
			
			_layoutDic[LiveConfig.LAYOUT_TOP] = {btn:_panel["btnTop"], label:_panel["tfTop"]};
			_layoutDic[LiveConfig.LAYOUT_BOTTOM] = {btn:_panel["btnBottom"], label:_panel["tfBottom"]};
			_layoutDic[LiveConfig.LAYOUT_FULL] = {btn:_panel["btnFull"],label:_panel["tfFull"]};
			
			_panel["btnTop"].alpha = 0;
			_panel["btnTop"].addEventListener(MouseEvent.CLICK,setLayoutHandelr);
			_panel["btnBottom"].alpha = 0;
			_panel["btnBottom"].addEventListener(MouseEvent.CLICK,setLayoutHandelr);
			_panel["btnFull"].alpha = 0;
			_panel["btnFull"].addEventListener(MouseEvent.CLICK,setLayoutHandelr);
			
			_panel["btnTop"].buttonMode = _panel["btnBottom"].buttonMode = _panel["btnFull"].buttonMode = true;
			
			resetAlphaSet(0);
			resetLoyoutSet(_catchLayout);
			*/
		}
		
		
		private function setAphaHandelr(event:MouseEvent):void{
			var btnName:String = event.target.name;
			var aphaNum:Number = Number(btnName.substr(btnName.length-1,1));
			
			resetAlphaSet(aphaNum);
			aphaNum = aphaNum==0? 1:(1- (aphaNum*0.25));
			_catchApha = aphaNum;
			Notification.get.notify(new MEvent(NoticeKey.N_SET_BARRAGE_ALPHA,_catchApha));
		}
		
		
		private function setLayoutHandelr(event:MouseEvent):void{
				trace(event.target.name);
				switch(event.target.name){
					case  "btnTop" :
							_catchLayout = LiveConfig.LAYOUT_TOP;
						break;
					case  "btnBottom" :
							_catchLayout = LiveConfig.LAYOUT_BOTTOM;
						break;
					case  "btnFull" :
							_catchLayout = LiveConfig.LAYOUT_FULL;
						break;
			}
				resetLoyoutSet(_catchLayout);
				Notification.get.notify(new MEvent(NoticeKey.N_SET_BARRAGE_LAYOUT,_catchLayout));
		}
		
		
		
		private function resetAlphaSet(index:int):void{
			for(var i:int=0; i<4; i++){
				_aphaList[i]["label"].alpha = 0.5;
				_aphaList[i]["btn"].alpha = 0;
			}
			
			_aphaList[index]["label"].alpha = 1;
			_aphaList[index]["btn"].alpha = 0.2;
		}
		
		
		
		private function resetLoyoutSet(layout:String):void{
			for( var key:String in _layoutDic){
				_layoutDic[key]["label"].alpha = 0.5;
				_layoutDic[key]["btn"].alpha    = 0;
			}
			
			_layoutDic[layout]["label"].alpha = 1;
			_layoutDic[layout]["btn"].alpha = 0.2;
		}
		
		
		
		//private var _panel:FL_skin_barrage_panel;
		private var _aphaList:Array = [];
		private var _layoutDic:Dictionary = new Dictionary();
		private var _catchApha:Number = 1;
		private var _catchLayout:String  = LiveConfig.LAYOUT_TOP;
		private const COLOR_SELECTED:uint = 0xC9FF13;
		private const COLOR_NOMAL:uint      = 0xFFFFFF;
		
		
	}
}