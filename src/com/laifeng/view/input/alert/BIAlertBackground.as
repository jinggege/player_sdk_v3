package com.laifeng.view.input.alert
{
	import flash.display.Shape;
	
	public class BIAlertBackground extends Shape
	{
		public const ARROWWH:int = 5;
		
		public function BIAlertBackground()
		{
			super();
		}
		
		public function setWH(w:int, h:int):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x373737);
			this.graphics.drawRoundRect(0,0,w,h,2,2);
			this.graphics.endFill();
			
			this.graphics.beginFill(0x373737);
			this.graphics.lineStyle(1,0x373737);
			this.graphics.moveTo(w/2-ARROWWH, h);
			this.graphics.lineTo(w/2+ARROWWH, h);
			this.graphics.lineTo(w/2, h+ARROWWH);
			this.graphics.lineTo(w/2-ARROWWH, h);
			this.graphics.endFill();
		}
	}
}