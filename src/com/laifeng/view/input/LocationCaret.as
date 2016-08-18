package com.laifeng.view.input
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	public class LocationCaret extends Sprite
	{
		
		private var line:Shape;
		
		private var timer:Timer;
		
		public function LocationCaret()
		{
			super();
			
			line = new Shape();
			line.graphics.lineStyle(1,0xFFFFFF);
			line.graphics.moveTo(0,0);
			line.graphics.lineTo(0,18);
			line.graphics.endFill();
			
			this.addChild(line);
			
			timer = new Timer(500);
			timer.addEventListener(TimerEvent.TIMER, onTimerRun);
		}
		
		private function onTimerRun(evt:TimerEvent):void
		{
			line.visible = !line.visible;
		}
		
		public function show():void
		{
			line.visible = true;
			timer.start();
		}
		
		public function hide():void
		{
			line.visible = false;
			timer.stop();
		}
	}
}