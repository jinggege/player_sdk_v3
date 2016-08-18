package com.laifeng.view.quality
{
	import com.laifeng.config.NoticeKey;
	import com.laifeng.controls.DMLive;
	import com.laifeng.controls.Notification;
	import com.laifeng.event.MEvent;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import lf.media.core.util.Console;
	
	/**
	 *  清晰度选择列表
	 * creat by jgg
	 */

	public class QualityPanel extends  Sprite 
	{
		
		public var STATUS_CLOSE:String = "close";
		public var STATUS_OPEN:String  = "open";
		
		public var status:String = "close" // status= open  /close
		
		public function QualityPanel()
		{
			super();
			init();
		}
		
		
		private function init():void{
			
			_bg.graphics.beginFill(0x000000);
			_bg.graphics.drawRect(0,0,50,25);
			//_bg.graphics.drawRoundRect(0,0,50,25,10,10);
			_bg.graphics.endFill();
			addChild(_bg);
			_bg.visible = false;
			
			_titleItem = new QualityLabel();
			addChild(_titleItem);
			
			_itemVec = new Vector.<QualityItem>();
			
		}
		
		
		public function initList(dmPlay:DMLive):void{
			
			_dmPlay = dmPlay;
			
			var currTitle:String = _dmPlay.getTitleByIndex(_dmPlay.defaultQulityIndex);
			_titleItem.label         = currTitle;
			_titleItem.currentIndex = _dmPlay.defaultQulityIndex;
			
			if(_itemVec.length==0){
				_titleItem.addEventListener(MouseEvent.CLICK,operateQualityHandler);
			}else{
				clearItemList();
			}
			
			var obj:Object;
			var item:QualityItem;
			for(var i:int=0; i<_dmPlay.psUrlList.length; i++){
				obj = _dmPlay.psUrlList[i];
				item = new QualityItem();
				item.index = obj["definition"];
				_layerList.addChild(item);
				item.y = i*item.height+5;
				item.label = obj["title"];
				_itemVec.push(item);
				
				item.addEventListener(MouseEvent.CLICK,clickItemHandler);
				item.addEventListener(MouseEvent.MOUSE_OVER,mouseoverHandler);
				item.addEventListener(MouseEvent.MOUSE_OUT,mouseoutHandler);
			}//end for
			
			
			selectItem(_titleItem.currentIndex);
		}
		
		
		private function operateQualityHandler(event:MouseEvent):void{
				if(contains(_layerList)){
					removeChild(_layerList);
					_bg.visible = false;
				}else{
					addChild(_layerList);
					_layerList.y = _layerList.height*-1;
					_bg.visible = true;
				}
			
				_layerList.y = _layerList.height*-1 - 5;
				_bg.height = _layerList.height;
				_bg.y = -1 *_bg.height;
				
				status = STATUS_OPEN;
		}
		
		
		private function clickItemHandler(event:MouseEvent):void{
			var item:QualityItem = event.target as QualityItem;
			if(item == null) return;
			
			if(_titleItem.currentIndex != item.index){
				var currTitle:String = _dmPlay.getTitleByIndex(item.index);
				_titleItem.label = currTitle;
				_titleItem.currentIndex = item.index;
				_dmPlay.defaultQulityIndex = item.index;
				selectItem(item.index);
				Notification.get.notify(new MEvent(NoticeKey.N_QUALITY_CHANGED,{index:item.index}));
			}
				
				if(this.contains(_layerList)){
					this.removeChild(_layerList);
				}
			
			_bg.visible = false;
		}
		
		
		private function mouseoverHandler(event:MouseEvent):void{
			
			var item:QualityItem = event.target as QualityItem;
			if(item){
				if(!item.selected){
					item.bgColor = 0x6699cc;
				}
			}
		}
		
		private function mouseoutHandler(event:MouseEvent):void{
			
			var item:QualityItem = event.target as QualityItem;
			if(item){
				if(!item.selected){
					item.bgColor = 0x000000;
				}
			}
			
		}
		
		
		
		/**
		 * 选中状态
		 */
		private function selectItem(index:int):void{
			
			Console.log("select index=",index);
			
			for(var i:int = 0; i<_itemVec.length; i++){
				
				if(_itemVec[i].index == index){
					_itemVec[i].bgColor = 0x3399FF;
					_itemVec[i].selected = true;
				}else{
					_itemVec[i].bgColor = 0x000000;
					_itemVec[i].selected = false;
				}
				
			}
		}
		
		
		/**
		 * 隐藏弹出的列表项
		 */
		public function hideList():void{
			status = STATUS_CLOSE;
			if(contains(_layerList)){
				removeChild(_layerList);
				_bg.visible = false;
			}
		}
		
		
		private function clearItemList():void{
			var obj:Object;
			var item:QualityItem;
			for(var i:int=0; i<_itemVec.length; i++){
				item = _itemVec[i];
				_layerList.removeChild(item);
				_itemVec.splice(i,1);
				item.removeEventListener(MouseEvent.CLICK,clickItemHandler);
				item.removeEventListener(MouseEvent.MOUSE_OVER,mouseoverHandler);
				item.removeEventListener(MouseEvent.MOUSE_OUT,mouseoutHandler);
				item = null;
			}//end for
			status = STATUS_CLOSE;
		}
		
		
		
		private var _bg:Shape = new Shape();
		private var _titleItem:QualityLabel;
		private var _itemVec:Vector.<QualityItem>;
		private var _layerList:Sprite = new Sprite();
		private var _dmPlay:DMLive;
		
		
		
	}
}