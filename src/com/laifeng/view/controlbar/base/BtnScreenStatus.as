package com.laifeng.view.controlbar.base
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lf.media.core.component.button.ButtonShape;
	
	public class BtnScreenStatus extends Sprite
	{
		
		public const E_SCREEN_STATUS_CHANGE:String = "E_SCREEN_STATUS_CHANGE";
		
		public const STATUS_FULL:String = "full";
		public const STATUS_NOMAL:String = "nomal";
		
		
		public function BtnScreenStatus()
		{
			super();
			
			_btnFull      = new ButtonShape(new Skin2_btn_fullscreen());
			_btnNomal = new ButtonShape(new Skin2_btn_exitfullscreen());
			
			_btnFull.addEventListener(MouseEvent.CLICK,changeStatusHandler);
			_btnNomal.addEventListener(MouseEvent.CLICK,changeStatusHandler);
			
			addChild(_btnFull);
			addChild(_btnNomal);
		}
		
		
		private function changeStatusHandler(event:MouseEvent):void{
			this.dispatchEvent(new Event(E_SCREEN_STATUS_CHANGE));
		}
		
		
		
		
		public function set status(value:String):void{
			_status = value;
			
			switch(value){
					case STATUS_FULL :
							if(contains(_btnFull)){
								removeChild(_btnFull);
							}
							
							addChild(_btnNomal);
						break;
					
					case STATUS_NOMAL :
						if(contains(_btnNomal)){
							removeChild(_btnNomal);
						}
						
						addChild(_btnFull);
						break;
			
			}
		
		}
		
		
		public function get status():String{
			return _status;
		}
		
		
		private var _btnFull:ButtonShape;
		private var _btnNomal:ButtonShape;
		
		private var _status:String;
		
		
		
		
	}
}