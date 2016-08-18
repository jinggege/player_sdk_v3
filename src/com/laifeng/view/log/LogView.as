package com.laifeng.view.log
{
	import com.laifeng.component.YButton;
	import com.laifeng.config.LiveConfig;
	import com.laifeng.event.MEvent;
	import com.laifeng.config.NoticeKey;
	import com.laifeng.config.UIKey;
	import com.laifeng.controls.Notification;
	import com.laifeng.controls.UIManage;
	import com.laifeng.interfaces.IChildUI;
	import com.laifeng.interfaces.IUI;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	public class LogView extends Sprite implements IUI
	{
		
		public function LogView()
		{
			super();
			
			this.addChild(_bg);
			
			this.addChild(_btnClose);
			_btnClose.buttonMode = true;
			_btnClose.addEventListener(MouseEvent.CLICK,closeHandler);
			
			//this.addChild(_btnModel);
			_btnModel.addChild(_textChangeMode);
			_btnModel.mouseChildren = false;
			_btnModel.buttonMode = true;
			
			_textChangeMode.width = 90;
			_textChangeMode.height = 20;
			_textChangeMode.selectable = false;
			_textChangeMode.textColor = 0xFFFFFF;
			_textChangeMode.background = true;
			_textChangeMode.backgroundColor = 0xCCCCCC;
			_textChangeMode.x = LiveConfig.get.defaultWidth -  150;
			
			
			initTable();
		}
		
		
		private function initTable():void{
			
			var btn:YButton;
			for(var i:int=0; i<_tabLables.length; i++){
				btn = new YButton(new FL_skin_log_tab());
				btn.index = i;
				btn.label = _tabLables[i];
				btn.addEventListener(MouseEvent.CLICK,clickHandler);
				this.addChild(btn);
				btn.x = i * btn.width;
				_tabBtnList[i] = btn;
			}
			
			_childList[0] = new LogVideoPanel();
			_childList[1] = new LogP2pStreamPanel();
			_childList[2] = new LogP2pPeerPanel();
			
			showP2pLog(false);
		}
		
		
		
		public function open():void
		{
			updata();
			selectChildPanel(0);
			selectTabBth(0);
		}
		
		public function close():void
		{
			
		}
		
		
		public function set uiState(value:String):void{
			this._uiState = value;
		}
		
		public function get uiState():String{
			return this._uiState;
		}
		
		
		public function updata():void
		{
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x000000,0.5);
			_bg.graphics.drawRect(0,0,LiveConfig.get.defaultWidth,LiveConfig.get.defaultHeight);
			_bg.graphics.endFill();
			_btnClose.x = LiveConfig.get.defaultWidth - _btnClose.width;
		}
		
		public function screenChange(w:int,h:int):void{
			
			for(var key:String in _childList){
				_childList[key].changeScreen(w,h);
			}
			
			updata();
		}
		
		
		
		private function closeHandler(event:MouseEvent):void{
			UIManage.get.closeUI(UIKey.UI_LOG);
			if(_currPanel != null){
				_currPanel.close();
			}
		}
		
		
		private function clickHandler(event:MouseEvent):void{
			
			var btn:YButton = event.target as YButton;
			selectChildPanel(btn.index);
			selectTabBth(btn.index);
			if(btn.index ==0){
				_lastClick++;
				if(_lastClick%3==0){
					showP2pLog(true);
				}
			}
		}
		
		
		private function selectChildPanel(index:int):void{
			
			var panel:IChildUI;
			for(var i:int = 0; i<_tabLables.length; i++){
				panel = _childList[i];
				if(panel != null){
					panel.close();
					if(this.contains(panel as Sprite)){
						this.removeChild(panel as Sprite);
					}
				}
				
			}
			
			panel =  _childList[index];
			
			if(panel != null){
				panel.open();
				_currPanel = panel;
				this.addChild(panel as Sprite);
			}
			
		}
		
		
		private function selectTabBth(index:int):void{
			
			var btn:YButton;
			for(var i:int = 0; i<_tabLables.length; i++){
				btn = _tabBtnList[i];
				btn.selected = false;
			}
			
			btn =  _tabBtnList[index];
			btn.selected = true;
		}
		
		
		
		
		public function get level():int{
			return UIKey.UI_LEVEL_3;
		}
		
		
		/**
		 * 是否显示p2p 信息
		 */
		public function showP2pLog(isShow:Boolean):void{
			var btn:YButton;
			for(var i:int = 1; i<_tabLables.length; i++){
				btn = _tabBtnList[i];
				btn.visible = isShow;
			}
		}
		
		
		
		public function destroy():void
		{
		}
		
		
		
		private var _bg:Shape = new Shape();
		private var _btnClose:FL_skin_btn_close = new FL_skin_btn_close();
		private var _uiState:String = "";
		private var _tabLables:Array = ["VIDEO","p2p stream","PEER"];
		private var _tabList:Vector.<YButton> = new Vector.<YButton>();
		
		private var _childList:Dictionary = new Dictionary();
		private var _tabBtnList:Dictionary = new Dictionary();
		
		private var _textChangeMode:TextField = new TextField();
		private var _btnModel:Sprite = new Sprite();
		private var _lastClick:int = 0;
		private var _currPanel:IChildUI;
		
		
		
	}
}