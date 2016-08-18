package com.laifeng.view.controlbar.livehouse
{
	import com.laifeng.config.LiveConfig;
	import com.laifeng.view.controlbar.base.BaseControlBar;
	
	/**
	 * livehouse controlbar
	 */
	public class CBLivehouse extends BaseControlBar
	{
		public function CBLivehouse()
		{
			super();
		}
		
		
		override protected function layout():void{
			
			super.layout();
			
			_btnEffectStatus.x = LiveConfig.get.defaultWidth - _btnEffectStatus.width - SPACE;
			_btnBarrageStatus.x = _btnEffectStatus.x - _btnBarrageStatus.width - SPACE;
			_btnBarrageOffX = _btnBarrageStatus.visible? _btnBarrageStatus.x - _qualityTitle.width  : _btnEffectStatus.x -  _qualityTitle.width;
			_qualityTitle.x = _btnBarrageOffX-SPACE;
		}
		
		
		override public function resize(w:int,h:int):void{
			super.resize(w,h);
			_btnEffectStatus.x = LiveConfig.get.defaultWidth - _btnEffectStatus.width - SPACE;
			_btnBarrageStatus.x = _btnEffectStatus.x - _btnBarrageStatus.width - SPACE;
			_btnBarrageOffX = _btnBarrageStatus.visible? _btnBarrageStatus.x - _qualityTitle.width  : _btnEffectStatus.x -  _qualityTitle.width;
			_qualityTitle.x = _btnBarrageOffX-SPACE;
		}
		
		
		private var _btnBarrageOffX:int = 0;
		
		
	}
}