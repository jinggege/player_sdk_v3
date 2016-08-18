package com.laifeng.view.plugs.endbill
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.external.ExternalInterface;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class VideoControl extends Sprite
	{
		//播放完毕
		public const E_PLAY_END:String = "E_PLAY_END";
		private var _video:Video;
		private var _nc:NetConnection;
		
		private var _ns:NetStream;
		
		public function VideoControl()
		{
			_video = new Video(672,378);
			_nc = new NetConnection();
			_nc.connect(null);
			_ns = new NetStream(_nc);
		}
		
		public function changeVideoSize(w:int,h:int):void
		{
			_video.width  = w;
			_video.height = h;
		}
		
		
		
		public function play(url:String):void
		{
			ExternalInterface.call("console.log",url);
			_ns.client = {onPlayStatus:onPlayStatus,onMetaData:onMetaData};
			_ns.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);
			_ns.play(url);
			_video.attachNetStream(_ns);
			addChild(_video);
		}
		
		
		private function netStatusHandler(event:NetStatusEvent):void
		{
			switch(event.info["code"]){
				case "NetStream.Play.Stop":
					close();
					break;
			}
		}
		
		
		private function onMetaData(data:Object):void
		{
		}
		
		
		private function onPlayStatus(data:Object):void
		{
			ExternalInterface.call("console.log",data["code"]);
			switch(data["code"]){
				case "NetStream.Play.Complete" :
					close();
					break;
			}
		}
		
		
		
		private function close():void
		{
			if(_ns != null )_ns.close();
			if(this.contains(_video)) removeChild(_video);
			this.dispatchEvent(new Event(E_PLAY_END));
		}
		
		
		
		
	}
}