package com.laifeng.view.plugs.endbill
{
	import com.laifeng.interfaces.IPlugin;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.Capabilities;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * 插件[直播结束时片花]
	 */
	
	[SWF(width="672", height="378", frameRate="24", backgroundColor="#000000")]
	public class PlugEndbill extends Sprite implements IPlugin
	{
		
		public var id:int  =0;
		
		public function PlugEndbill(id:int)
		{
			this.id = id;
			
			_vc = new VideoControl();
			_vc.addEventListener(_vc.E_PLAY_END,playEndHandler);
		}
		
		/**参数*/
		public function set param(value:Object):void{
			_param        = value;
		}
		
		
		/**启动*/
		public function start(callback:Function):void{
			
			_callback = callback;
			//addChild(_skin);
			//得到播放器的大小
			_vc.play(flvUrl);
			addChild(_vc);
			screenChange(_defaultW,_defaultH);
			_timeId = setTimeout(aotuStop,MAX_TIME);
		}
		
		
		private function aotuStop():void{
			playEndHandler(null);
		}
		
		
		/**结束  @param callback(结束回调)*/
		public function end():void{	 }
			
		
		/**
		 * 更新
		 */
		public function screenChange(w:int,h:int):void
		{
			_defaultW = w;
			_defaultH  = h;
			
			_vc.x = 0;
			_vc.y = 0;
			_vc.changeVideoSize(w,h);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			trace('io error');
		}
		
		private function playEndHandler(event:Event):void
		{

			clearTimeout(_timeId);
			_vc.removeEventListener(_vc.E_PLAY_END,playEndHandler);
			destroy();
			_callback.call(null,id);
		}
		
		
		public function destroy():void
		{
			_vc.removeEventListener(_vc.E_PLAY_END,playEndHandler);
			if(contains(_vc)) removeChild(_vc);
		}
		
		
		private const flvUrl:String = "http://static.youku.com/ddshow/img/video/pianhua_2014_12_1.flv";
		
		private var _vc:VideoControl;
		
		private var _param:Object;
		private var _callback:Function;
		private const MAX_TIME:int = 8000 //8 * 1000    毫秒
		private var _timeId:uint;
		private var _defaultW:int = 520;
		private var _defaultH:int = 390;
		
		
		
	}
}