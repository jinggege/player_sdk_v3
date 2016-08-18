package com.laifeng.component
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * frame 1:mouseUp  2:mouseover   3:mouseDown  4:mouseDisable
	 * 
	 */
	public class YButton extends Sprite
	{
		public var index:int = 0;
		
		
		public function YButton(mc:MovieClip,index:int = 0)
		{
			this.index = index;
			_mc  = mc;
			_mc.gotoAndStop(1);
			this.addChild(_hotArea);
			this.addChild(_mc);
			_hotArea.graphics.beginFill(0x000000,0);
			_hotArea.graphics.drawRect(0,0,_mc.width,_mc.height);
			_hotArea.graphics.endFill();
			
			this.mouseChildren = false;
			this.buttonMode      = true;
			
			this.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
		}
		
		private function mouseUpHandler(event:MouseEvent):void{
			if(_selected)   return;
			_mc.gotoAndStop(1);
		}
		
		private function mouseDownHandler(event:MouseEvent):void{
			if(_selected)   return;
			_mc.gotoAndStop(3);
		}
		
		private function mouseOverHandler(event:MouseEvent):void{
			if(_selected)   return;
			_mc.gotoAndStop(2);
		}
		
		
		private function mouseOutHandler(event:MouseEvent):void{
			if(_selected)   return;
			_mc.gotoAndStop(1);
		}
		
		
		public function set selected(value:Boolean):void{
			_selected = value;
			if(_selected){
				_mc.gotoAndStop(3);
			}else{
				_mc.gotoAndStop(1);
			}
		}
		
		
		public  function set enabled(value:Boolean):void
		{
			if(value){
				this.mouseEnabled = true;
				_mc.gotoAndStop(1);
			}else{
				this.mouseEnabled = false;
				_mc.gotoAndStop(4);
			}
		}
		
		
		public function set label(value:String):void{
			_mc["label"].text = value;
		}
		
		public function get label():String{
			return _mc["label"].text;
		}
		
		private var _selected:Boolean = false;
		private var _hotArea:Shape = new Shape();
		private var _mc:MovieClip;
		
		
	}
}