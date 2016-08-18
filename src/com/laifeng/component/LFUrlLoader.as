package com.laifeng.component
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	public class LFUrlLoader extends EventDispatcher
	{
		public function LFUrlLoader(target:IEventDispatcher = null)
		{
			super(target);
		}
		
		/**
		 * @param url:请求地址
		 * @param maxTryCount:最大请求次数
		 * @param callback:回调函数 callback = {type:xxxxx,data:xxx}
		 */
		public function request(url:String,maxTryCount:int=1,callback:Function=null):void{
			_url = url;
			_callback = callback;
			_maxTryCount = maxTryCount;
			_currTryCount = 0;
			
			clear();
			_urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpstatusHandler);
			_urlLoader.addEventListener(Event.COMPLETE,completeHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
			
			_httpCode = 0;
			
			setRequest(_url);
		}
		
		
		private function setRequest(url:String):void{
			
			var uR:URLRequest = new URLRequest(url+"&rd="+int(Math.random()*99999));
			uR.method = URLRequestMethod.GET;
			_urlLoader.load(uR);
			_oldTime = new Date().getTime();
			_currTryCount++
		}
		
		
		
		private function httpstatusHandler(event:HTTPStatusEvent):void{
			_httpCode = event.status;
		}
		
		
		private function completeHandler(event:Event):void{
			_useTime = new Date().getTime() - _oldTime;
			_callback.call(null,{type:event.type,data:(event.target as URLLoader).data});
			clear();
		}
		
		
		private function errorHandler(event:Event):void{
			_useTime = new Date().getTime() - _oldTime;
			if(_currTryCount>_maxTryCount){
				_callback.call(null,{type:event.type,data:"error"});
					return;
			}
			
			setRequest(_url);
		}
		
		
		private function clear():void{
			if(_urlLoader == null) return;
			_urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,httpstatusHandler);
			_urlLoader.removeEventListener(Event.COMPLETE,completeHandler);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
			try{
				_urlLoader.close();
			}catch(error:Error){};
			
		}
		
		
		/**
		 * 重试次数
		 */
		public function get tryCout():int{
			return _currTryCount;
		}
		
		public function get url():String{
			return _url;
		}
		
		public function get useTime():Number{
			return _useTime;
		}
		
		public function get httpCode():int{
			return _httpCode;
		}
		
		
		public function destroy():void{
			clear();
			_urlLoader = null;
		}
		
		
		
		
		private var _urlLoader:URLLoader = new URLLoader();
		private var _maxTryCount:int = 1;
		private var _currTryCount:int = 0;
		private var _callback:Function;
		private var _url:String = "";
		private var _httpCode:int = 0;
		private var _oldTime:Number = 0;
		private var _useTime:Number = 0;
		
		
		
	}
}