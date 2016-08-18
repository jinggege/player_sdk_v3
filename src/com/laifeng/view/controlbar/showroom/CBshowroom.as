package com.laifeng.view.controlbar.showroom
{
	import com.laifeng.config.LiveConfig;
	import com.laifeng.view.controlbar.base.BaseControlBar;
	
	public class CBshowroom extends BaseControlBar
	{
		/**
		 * 秀场 control bar
		 * 
		 */
		public function CBshowroom()
		{
			super();
		}
		
		
		
		override protected function layout():void{
			
			super.layout();
			
			_qualityTitle.visible = false;
			_qualityTitle.mouseEnabled = false;
			_btnEffectStatus.x = _btnScreenStatus.x + _btnScreenStatus.width+SPACE;
		}
		
		
		
		
	}
}