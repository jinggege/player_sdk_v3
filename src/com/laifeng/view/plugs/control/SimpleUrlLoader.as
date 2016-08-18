package com.laifeng.view.plugs.control
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class SimpleUrlLoader extends URLLoader
	{
		
		private var _callback:Function;
		private var _loaderId:int = 0;
		
		/**
		 * 数据加载器 
		 * @param request:URLRequest
		 * @param id  :  加载器编号
		 */
		public function SimpleUrlLoader(request:URLRequest=null,id:int = 0)
		{
			_loaderId = id;
			super(request);
		}
		
		/**
		 * @param : callback  {type:xxx,content:*}
		 */
		public function listener(callbalck:Function):void
		{
			_callback = callbalck;
			this.addEventListener(Event.COMPLETE,completeHandler);
			this.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		}
		
		
		public function startLoad(url:String):void
		{
			load(new URLRequest(url));
		}
		
		private function completeHandler(event:Event):void
		{
			var data:Object = (event.target as URLLoader).data;
			_callback.call(null,{type:Event.COMPLETE,content:{id:_loaderId,data:data}});
			
			destroy();
		}
		
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			_callback.call(null,{type:IOErrorEvent.IO_ERROR,content:{id:_loaderId,data:event.text}});
			destroy();
		}
		
		
		private function unListener():void
		{
			this.removeEventListener(Event.COMPLETE,completeHandler);
			this.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		}
		
		
		
		private function destroy():void
		{
			unListener();
			this.close();
		}
		
		
	}
}