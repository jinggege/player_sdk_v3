package com.laifeng.view.input
{
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class BICloseButton extends Sprite
	{
		
		private var bg1:Shape;//正常态的背景
		private var bg2:Shape;//over时的背景 
		
		
		public function BICloseButton()
		{
			super();
			
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0,0);
			bg.graphics.drawRect(0,0,11,11);
			bg.graphics.endFill();
			this.addChild(bg);
			
			bg1 = new Shape();
			bg1.graphics.clear();
			bg1.graphics.lineStyle(1,0xFFFFFF);
			bg1.graphics.moveTo(0,0);
			bg1.graphics.lineTo(11, 11);
			bg1.graphics.moveTo(0,11);
			bg1.graphics.lineTo(11, 0);
			this.addChild(bg1);
			
			bg2 = new Shape();
			bg2.graphics.lineStyle(1,0xD6417C);
			bg2.graphics.moveTo(0,0);
			bg2.graphics.lineTo(11, 11);
			bg2.graphics.moveTo(0,11);
			bg2.graphics.lineTo(11, 0);
			this.addChild(bg2);
			
			setOut();
			
			this.mouseChildren = false;
			this.buttonMode = true;
			
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
		}
		
		private function onMouseOut(evt:MouseEvent):void
		{
			setOut();
		}
		
		private function onMouseOver(evt:MouseEvent):void
		{
			setOver();
		}
		
		public function setOut():void
		{
			bg1.visible = true;
			bg2.visible = false;
		}
		
		public function setOver():void
		{
			bg1.visible = false;
			bg2.visible = true;
			
		}
		
	}
}