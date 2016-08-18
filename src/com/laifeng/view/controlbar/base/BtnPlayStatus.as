package com.laifeng.view.controlbar.base
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lf.media.core.component.button.ButtonShape;
	
	public class BtnPlayStatus extends Sprite
	{
		
		public  const STATUS_PLAY:String  = "play";
		public  const STATUS_PAUSE:String = "pause";
		
		public const E_PLAY_STATUE_CHANGE:String = "E_PLAY_STATUE_CHANGE";
		
		
		public function BtnPlayStatus()
		{
			super();
			
			_btnPlay = new ButtonShape(new Skin2_btn_play());
			_btnPause = new ButtonShape(new Skin2_btn_stop());
			
			addChild(_btnPlay);
			addChild(_btnPause);
			_btnPlay.addEventListener(MouseEvent.CLICK,clickHandler);
			_btnPause.addEventListener(MouseEvent.CLICK,clickHandler);
			
		}
		
		
		private function clickHandler(event:MouseEvent):void{
			this.dispatchEvent(new Event(E_PLAY_STATUE_CHANGE));
		}
		
		
		
		
		public function set status(value:String):void{
			
			_status = value;
			switch(value){
					case STATUS_PLAY :
							if(contains(_btnPlay)){
								removeChild(_btnPlay);
							}
							
							addChild(_btnPause);
						
						break;
					case STATUS_PAUSE :
						
						if(contains(_btnPause)){
							removeChild(_btnPause);
						}
						
						addChild(_btnPlay);
						break;
			}
			
		}
		
		
		
		
		
		public function get status():String{
			return _status;
		}
		
		
		
		
		
		private var _btnPlay:ButtonShape;
		private var _btnPause:ButtonShape;
		
		private var _status:String = "";
		
		
		
	}
}