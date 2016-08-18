package com.laifeng.view.controlbar.other
{
	import com.laifeng.config.LiveConfig;
	import com.laifeng.view.controlbar.base.BaseControlBar;
	
	public class CBother extends BaseControlBar
	{
		/**
		 * 秀场 control bar
		 * 
		 */
		public function CBother()
		{
			super();
		}
		
		
		
		override protected function layout():void{
			
			super.layout();
			
			_qualityTitle.visible = _dmLive.isShowQualitySwitch();
			_qualityTitle.mouseEnabled = false;
			_btnEffectStatus.x = _btnScreenStatus.x + _btnScreenStatus.width+SPACE;
			_btnEffectStatus.visible  = false;
		}
		
		
		
		
	}
}