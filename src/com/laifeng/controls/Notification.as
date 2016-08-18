package com.laifeng.controls
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**********************************************************
	 * Notification
	 * 
	 * Author         : mj
	 * Description :
	 * 			事件统一派发管理器
	 * 
	 * 
	 * todo:
	 * 	      将会修改为回调方式 实现事件派发
	 * 
	 ***********************************************************/

	public class Notification extends EventDispatcher
	{
		
		private static var _instance:Notification;
		
		public function Notification()
		{
			if(_instance != null){
				throw(new Event("Notification 为单例,不可构造!"));
			}
		}
		
		
		public function notify(event:Event):void{
			this.dispatchEvent(event);
		}
		
		
		
		public static function get get():Notification{
			_instance = _instance==null? new Notification():_instance;
			return _instance;
		}
		
		
		
		
	}
}