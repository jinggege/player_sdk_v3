package com.laifeng.view.background
{
	import com.laifeng.config.UIKey;
	import com.laifeng.interfaces.IUI;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * background
	 */
	
	public class BackgroundV extends Sprite implements IUI
	{
		
		private const low:int        = 10;
		private const high:int       = 20;
		private const channel:int =3;
		
			
		public function BackgroundV()
		{
			super();
			addChild(_bgImg);
		}
		
		public function open():void
		{
			clearImg();
			
			this.addEventListener(Event.ENTER_FRAME,renderHandler);
		}
		
		public function close():void
		{
			this.removeEventListener(Event.ENTER_FRAME,renderHandler);
			clearImg();
		}
		
		public function updata():void
		{
		}
		
		public function screenChange(w:int, h:int):void
		{
			clearImg();
			if(w==0 || h==0) return;
			
			try{
				_bmd = new BitmapData(w,h,false,0x000000);
				_bgImg.bitmapData = _bmd;
			}catch(error:Error){};
			
		}
		
		
		private function renderHandler(event:Event):void{
			if(_bmd==null) return;
			_bmd.unlock();
			_seed = Math.random() * 30;
			_bmd.noise(_seed,low,high,channel,true);
			_bmd.lock();
		}
		
		
		private function clearImg():void{
			if(_bmd != null){
				_bmd.dispose();
			}
			
			_bmd = null;
		}
		
		
		public function get level():int
		{
			return UIKey.UI_LEVEL_2;
		}
		
		public function set uiState(value:String):void
		{
			_uiStatus=value;
		}
		
		public function get uiState():String
		{
			return _uiStatus;
		}
		
		public function destroy():void
		{
		}
		
		
		private var _uiStatus:String = "";
		private var _bgImg:Bitmap = new Bitmap();
		private var _bmd:BitmapData;
		private var _seed:int = 0;
		
	}
}