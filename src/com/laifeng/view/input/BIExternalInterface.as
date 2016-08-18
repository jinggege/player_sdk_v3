package com.laifeng.view.input
{
	import com.laifeng.controls.LFExtenrnalInterface;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class BIExternalInterface
	{
		
		private static var _instance:BIExternalInterface;
		
		private var inputPanel:BInputPanel;
		
		public function BIExternalInterface()
		{
		}
		
		public static function get instace():BIExternalInterface
		{
			if (_instance == null)
			{
				_instance = new BIExternalInterface();
			}
			return _instance;
		}
		
		public function start(disObj:BInputPanel):void
		{
			ExternalInterface.addCallback("sentChatRespone", sentChatRespone);
			ExternalInterface.addCallback("sentHornRespone", sentHornRespone);
			ExternalInterface.addCallback("getThesaurusRespone", getThesaurusRespone);
			
			inputPanel = disObj;
		}
		
		/**
		 * 用户是否登录
		 * @return 
		 * 
		 */		
		public function isUserLogin():Boolean
		{
			return ExternalInterface.call("") as Boolean;
		}
		
		/**
		 * 发送聊天请求
		 * @return 
		 * 
		 */		
		public function sentChatReqest(content:String):void
		{
			ExternalInterface.call("_flash_fullscreen_chat", content);
			sentChatRespone({text:content});
		}
		
		/**
		 * 聊天返回
		 * @param obj
		 * 
		 */		
		public function sentChatRespone(obj:Object):void
		{
			inputPanel.handleNormalChat(obj);
		}
		
		/**
		 * 发送喇叭请求
		 * @return 
		 * 
		 */		
		public function sentHornReqest(content:String):void
		{
			ExternalInterface.call("_flash_fullscreen_chat", content);
			sentHornRespone({text:content});
		}
		
		/**
		 * 喇叭返回
		 * @param obj
		 * 
		 */		
		public function sentHornRespone(obj:Object):void
		{
			inputPanel.handleHornChat(obj);
		}
		
		/**
		 * 请求词库
		 * @param obj
		 * 
		 */		
		public function getThesaurusRequest(url:String):void
		{
			//ExternalInterface.call("_flash_fullscreen_ime", url);
			
			var urlLoader:URLLoader = new URLLoader();
			var urlReq:URLRequest = new URLRequest(url);
			urlLoader.load(urlReq);
			urlLoader.addEventListener(Event.COMPLETE, onLoadHanziComplete);
		}
		private function onLoadHanziComplete(evt:Event):void
		{
			var urlLoader:URLLoader = evt.target as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onLoadHanziComplete);
			getThesaurusRespone(urlLoader.data);
		}
		
		/**
		 * 词库返回
		 * @param obj
		 * 
		 */		
		public function getThesaurusRespone(obj:Object):void
		{
			inputPanel.handleHanziJson(obj as String);
		}
		
		
	}
}