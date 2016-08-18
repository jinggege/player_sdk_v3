package com.laifeng.view.controlbar.base
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lf.media.core.component.button.ButtonShape;
	
	public class BtnBarrageStatus extends Sprite
	{
		
		public const E_BARRAGE_STATUS_CHANGE:String ="E_BARRAGE_STATUS_CHANGE";
		
		public const STATUS_OFF:String = "STATUS_OFF";
		public const STATUS_ON:String  = "STATUS_ON";
		
		
		public function BtnBarrageStatus()
		{
			super();
			
			_btnOff = new ButtonShape(new Skin2_btn_barrage_off());
			_btnOn = new ButtonShape(new Skin2_btn_barrage_on());
			
			addChild(_btnOff);
			addChild(_btnOn);
			
			_btnOn.addEventListener(MouseEvent.CLICK,statusChangeHandler);
			_btnOff.addEventListener(MouseEvent.CLICK,statusChangeHandler);
		}
		
		
		
		public function get status():String
		{
			return _status;
		}
		
		public function set status(value:String):void
		{
			_status = value;
			
			switch(value){
				case STATUS_OFF :
					if(contains(_btnOff)){
						removeChild(_btnOff);
					}
					addChild(_btnOn);
					break
				case STATUS_ON :
					if(contains(_btnOn)){
						removeChild(_btnOn);
					}
					addChild(_btnOff);
					break
				
			}
			
		}
		
		
		private function statusChangeHandler(event:MouseEvent):void{
			this.dispatchEvent(new Event(E_BARRAGE_STATUS_CHANGE));
		}
		
		
		
		
		
		private var _btnOff:ButtonShape;
		private var _btnOn:ButtonShape;
		private var _status:String ="";
		
		
		
	}
}