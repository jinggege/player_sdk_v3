package com.laifeng.view.log
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import org.osmf.events.TimeEvent;
	
	public class GrBuffer extends Sprite
	{
		private const GRID_W:int = 10;
		private const GRID_H:int  = 20;
		private const MAX_BUFFER:int = 3;
		private const MAX_POINT:int = 50;
		
		public function GrBuffer()
		{
			super();
			addChild(_layerGrid);
			addChild(_layerLine);
			_layerLine.y = 60;
			resize(500,300);
			
			_tfTitle.text = "buffer status";
			_tfTitle.width = 110;
			_tfTitle.height = 25;
			_tfTitle.textColor = 0xAAAAAA;
			_tfTitle.y = _layerLine.y;
			addChild(_tfTitle);
		}
		
		
		public function resize(w:int,h:int):void{
			
			_layerGrid.graphics.clear();
			for(var i:int=0; i<=MAX_BUFFER; i++){
				_layerGrid.graphics.lineStyle(1,0xffffff,0.3);
				_layerGrid.graphics.moveTo(0,i*GRID_H);
				_layerGrid.graphics.lineTo(w,i*GRID_H);
				_layerGrid.graphics.endFill();
			}
			
			for(i=0; i<=MAX_POINT;i++){
				_layerGrid.graphics.lineStyle(1,0xCCCCCC,0.3);
				_layerGrid.graphics.moveTo(i*GRID_W,0);
				_layerGrid.graphics.lineTo(i*GRID_W,GRID_H*MAX_BUFFER);
				_layerGrid.graphics.endFill();
			}
			
		
		}
		
		
		
		
		public function setBuffer(bufferTime:Number,currBuffer:Number):void{
			this._bufferTime  = bufferTime;
			this._currBuffer = currBuffer;
			
			graphLine();
		}
		
		
		private function graphLine():void{
			if(_posList.length<MAX_POINT){
				_posList.push(_currBuffer);
			}else{
				_posList.splice(0,1);
				_posList.push(_currBuffer);
			}
			
			
			_layerLine.graphics.clear();
			_layerLine.graphics.lineStyle(1,0x33FF33);
			_layerLine.graphics.moveTo(0,_posList[0]*GRID_H*-1);
			for(var i:int = 1; i<_posList.length; i++){
				
				_layerLine.graphics.lineTo(i*GRID_W,_posList[i]*GRID_H*-1);
			}
			
			_layerLine.graphics.endFill();
		
		}
		
		
		
		
		public function clear():void{
			_layerLine.graphics.clear();
			while(_posList.length){
				_posList.pop();
			}
		}
		
		
		
		
		
		
		
		
		private var _bufferTime:Number = 1;
		private var _currBuffer:Number = 1;
		private var _layerGrid:Sprite = new Sprite();
		private var _layerLine:Sprite = new Sprite();
		private var _posList:Vector.<Number> = new Vector.<Number>();
		private var _tfTitle:TextField = new TextField();
		
		
		
	}
}