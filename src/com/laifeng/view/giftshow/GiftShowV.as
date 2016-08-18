package com.laifeng.view.giftshow
{
	import com.adobe.json.JSON;
	import com.laifeng.config.NoticeKey;
	import com.laifeng.config.UIKey;
	import com.laifeng.controls.Notification;
	import com.laifeng.controls.UIManage;
	import com.laifeng.event.MEvent;
	import com.laifeng.interfaces.IUI;
	
	import flash.display.Sprite;
	
	import lf.media.core.util.Console;
	
	public class GiftShowV extends Sprite implements IUI
	{
		
		public const MAX_H:int = 500;
		public const MAX_ROW:int = 3;
		public const GIFT_VIEW_PORT_H:int = 100;
		
		
		public function GiftShowV()
		{
			super();
			
			Notification.get.addEventListener(NoticeKey.N_SEND_GIFT_INFO,showGiftInfo);
			
			_list[0] = null;
			_list[1] = null;
			_list[2] = null;
			
			addChild(_itemLayer);
		}
		
		public function open():void
		{
		}
		
		
		private function showGiftInfo(event:MEvent):void{
				if(uiState == UIManage.UI_STATE_CLOSED){
					UIManage.get.openUI(UIKey.UI_GIFT_SHOW);
				}
				
				var giftInfo:Object = event.data;
				Console.log("gift info=",giftInfo);
				
				if(giftInfo == null) return;
				
				if(!giftInfo.hasOwnProperty("giftInfo")){
						return;
				}
				
				
				_waitList.push(giftInfo);
				addItem();
		}
		
		
		private function addItem():void{
			
			if(_waitList.length==0) return;
			if(_list.length>3) return;
			
			var item:GiftItem;
			for(var i:int = 0; i<_list.length; i++){
				if(_list[i] == null){
					item = new GiftItem(destroyItem);
					item.index = i;
					item.setGiftInfo(_waitList.shift());
					_list[i] = item;
					_itemLayer.addChild(item);
					item.move(item.width * -1, GIFT_VIEW_PORT_H - ( i * (item.height+5)));
					return;
				}
			}
			
		}
		
		
		private function destroyItem(index:int):void{
			var item:GiftItem = _list[index];
			if(item == null) return;
			item.destroy();
			_itemLayer.removeChild(item);
			_list[index] = null;
			
			addItem();
		}
		
		
		
		
		public function close():void
		{
		}
		
		public function updata():void
		{
		}
		
		public function screenChange(w:int, h:int):void
		{
			_w = w;
			_h = h;
			_itemLayer.y = _h - 80 - GIFT_VIEW_PORT_H;
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
		
		
		private var _uiStatus:String = "";
		private var _list:Vector.<GiftItem> = new Vector.<GiftItem>();
		private var _waitList:Array = [];
		private var _w:int = 0;
		private var _h:int = 0;
		private var _itemLayer:Sprite = new Sprite();
		
		
	}
}