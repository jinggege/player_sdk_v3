package com.laifeng.view.loading
{
	import com.laifeng.config.LiveConfig;
	import com.laifeng.config.UIKey;
	import com.laifeng.interfaces.IUI;
	
	import flash.display.Sprite;

	/**
	 * loading view
	 */
	public class LoadingView extends Sprite implements IUI
	{
		public function LoadingView()
		{
			super();
			_skin = new FL_skin_loading();
			_skin.gotoAndStop(1);
			this.mouseChildren = false;
		}
		
		public function open():void{
			_skin.gotoAndPlay(1);
			this.addChild(_skin);
			updata();
		}
		
		public function close():void{
			_skin.gotoAndStop(1);
			if(this.contains(_skin)){
				this.removeChild(_skin);
			}
		}
		
		public function set uiState(value:String):void{
			this._uiState = value;
		}
		
		public function get uiState():String{
			return this._uiState;
		}
		
		
		
		public function updata():void{
			
			this.x = (LiveConfig.get.defaultWidth - loading_w)/2+30;
			this.y = (LiveConfig.get.defaultHeight - loading_h)/2+30;
		}
		
		
		public function screenChange(w:int,h:int):void{
			this.x = (w - loading_w)/2+30;
			this.y = (h - loading_h)/2+30;
		}
		
		public function get level():int{
			return UIKey.UI_LEVEL_3;
		}
		
		public function destroy():void{
		
		}
		
		
		private var _skin:FL_skin_loading;
		private const loading_w:int = 66;
		private const loading_h:int = 66;
		private var _uiState:String = "";
		
		
	}
}