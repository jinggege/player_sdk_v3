package com.laifeng.view.plugs.control
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	public class SimpleLoader extends Loader
	{
		public var param:Object;
		//回调
		private var _callback:Function;
		public function SimpleLoader()
		{
			super();
		}
		
		
		public function listener(callback:Function):void
		{
			_callback = callback;
			this.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			this.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,sErrorHandler);
		}
		
		
		private function completeHandler(event:Event):void
		{
			_callback.call(null,{type:Event.COMPLETE,content:(event.target as LoaderInfo).content,param:param});
		}
		
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			
		}
		
		
		private function sErrorHandler(event:SecurityErrorEvent):void
		{
			
		}
		
		
		
		
		
	}
}