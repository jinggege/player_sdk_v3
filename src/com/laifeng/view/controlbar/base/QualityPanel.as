package com.laifeng.view.controlbar.base
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import lf.media.core.component.label.LfLabelList;
	import lf.media.core.util.Tweener;
	
	public class QualityPanel extends Sprite
	{
		
		public const E_LFLABEL_CHANGE:String = "E_LFLABEL_CHANGE";
		
		public function QualityPanel()
		{
			super();
			
			_labelList = new LfLabelList();
			addChild(_labelList);
			_labelList.addEventListener(_labelList.E_LIST_SELECT,selectQualityHandler);
		}
		
		
		public function setLabels(arr:Array):void{
			_labelList.setLabels(arr);
			_labelList.setStyle(50,20,12,"#CCCCCC","#3BAFDA",5)
			creatBg();
		}
		
		
		
		private function selectQualityHandler(event:Event):void{
			
			this.dispatchEvent(new Event(E_LFLABEL_CHANGE));
		
		}
		
		
		public function selectLabel(value:String):void{
			_labelList.selected(value);
		}
		
		public function get currentLable():String{
			return _labelList.currentLabel;
		}
		
		
		
		
		private function creatBg():void{
			
			var w:int = 50;
			var h:int = _labelList.height+10;
			
			this.graphics.clear();
			this.graphics.beginFill(0x373737);
			this.graphics.drawRoundRect(0,0,w,h,2,2);
			this.graphics.endFill();
			
			this.graphics.beginFill(0x373737);
			this.graphics.lineStyle(1,0x373737);
			this.graphics.moveTo(w/2 - _arrowWH,h);
			this.graphics.lineTo(w/2+_arrowWH,h);
			this.graphics.lineTo(w/2, h+_arrowWH);
			this.graphics.lineTo(w/2-_arrowWH,h);
			this.graphics.endFill();
			
			this.graphics.lineStyle(1,0x000000,0.2);
			for(var i:int=0; i<_labelList.list.length-1; i++){
				
				this.graphics.moveTo(5,_labelList.list[i].y+_labelList.list[i].height+10);
				this.graphics.lineTo(_labelList.x+_labelList.width-5,_labelList.list[i].y+_labelList.list[i].height+10);
			}
			
			_labelList.x = (w - _labelList.width)/2;
			_labelList.y = (h - _labelList.height)/2;
		}
		
		
		public function clear():void{
			
			_labelList.clearList();
			this.graphics.clear();
		}
		
		
		
		public function isShow():Boolean{
			if(this.parent != null){
				if(this.parent.contains(this)){
					return true;
				}
			}
			
			return false;
		}
		
		
		public function open(container:DisplayObjectContainer,x:int,y:int):void{
			container.addChild(this);
			this.x = x;
			this.y =y;
			this.alpha = 0;
			Tweener.to(this,0.3,{alpha:1});
			
			if(_autoCloseTime != 0){
				clearTimeout(_autoCloseTime);
			}
			
			_autoCloseTime = setTimeout(autoCloseHandler,3000)
			
		}
		
		
		public function close():void{
			if(isShow()){
				this.parent.removeChild(this);
				clearTimeout(_autoCloseTime);
				_autoCloseTime = 0;
			}
		}
		
		
		
		private function autoCloseHandler():void{
			close();
		}
		
		
		
		
		private var _labelList:LfLabelList;
		private var _arrowWH:int = 5;
		
		private var _autoCloseTime:uint = 0;
		
		
	}
}