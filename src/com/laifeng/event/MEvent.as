package  com.laifeng.event
{
	import flash.events.Event;
	
	public class MEvent extends Event
	{
		private var _data:Object;
		public function MEvent(type:String, data:Object=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		
		public function get data():Object{
			return _data;
		}
		
		
	}
}