package com.laifeng.view.input
{
	import flash.events.Event;
	
	public class BInputEvent extends Event
	{
		
		public static const IME_VISIBLE_CHANGED:String = "ime_visible_changed";
		public static const IME_TEXT_NONE:String = "ime_text_none";
		public static const CLCIK_IME_HANZI:String = "click_ime_hanzi";
		public static const ALERT_MESSAGE:String = "alert_message";
		public static const CLOSE_HORN:String = "close_horn";
		public static const IME_WIDTH_LONGER:String = "ime_width_longer";
		
		public var data:Object;
		
		public function BInputEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var evt:BInputEvent = new BInputEvent(this.type, this.data, this.bubbles, this.cancelable);
			return evt;
		}
	}
}