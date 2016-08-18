package com.laifeng.view.controlbar.base
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lf.media.core.component.button.ButtonShape;

	public class BtnSoundStatus extends Sprite
	{
		
		public const E_SOUND_STATUS_CHANGE:String = "E_SOUND_STATUS_CHANGE";
		public const STATUS_OPEN:String = "STATUS_OPEN";
		public const STATUS_CLOSE:String = "STATUS_CLOSE";
		
		public function BtnSoundStatus()
		{
			super();
			
			_btnSoundClose = new ButtonShape(new Skin2_btn_soundclose());
			_btnSoundOpen = new ButtonShape(new Skin2_btn_soundopen());
			addChild(_btnSoundClose);
			addChild(_btnSoundOpen);
			
			_btnSoundOpen.addEventListener(MouseEvent.CLICK,changeStatusHandler);
			_btnSoundClose.addEventListener(MouseEvent.CLICK,changeStatusHandler);
		}
		
		public function get status():String
		{
			return _status;
		}
		
		public function set status(value:String):void
		{
			_status = value;
			
			switch(value){
				
				case STATUS_OPEN :
						if(contains(_btnSoundOpen)){
							removeChild(_btnSoundOpen);
						}
						addChild(_btnSoundClose);
					
					break;
				
				case STATUS_CLOSE :
						if(contains(_btnSoundClose)){
							removeChild(_btnSoundClose);
						}
						addChild(_btnSoundOpen);
					
					break;
			
			}
			
		}
		
		
		
		private function changeStatusHandler(event:MouseEvent):void{
			this.dispatchEvent(new Event(E_SOUND_STATUS_CHANGE));
		}
		
		

		
		
		private var _btnSoundClose:ButtonShape;
		private var _btnSoundOpen:ButtonShape;
		private var _status:String = "";
		
		
		
	}
}