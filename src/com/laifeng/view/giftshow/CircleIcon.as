package com.laifeng.view.giftshow
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	import lf.media.core.component.loader.SimpleImgLoader;
	import lf.media.core.util.Console;
	
	public class CircleIcon extends Sprite
	{
		
		public const WH:int = 26;

		public function CircleIcon(url:String)
		{
			super();
			
			addChild(_iconTf);
			
			_iconTf.x = _iconTf.y = 0;
			
			_iconTf.width = WH+4;
			_iconTf.height = WH+4;
			_iconTf.wordWrap = true;
			_iconTf.multiline = true;
			_iconTf.selectable = false;
			_iconTf.mouseEnabled = false;
			
			//_iconTf.border = true;
			//_iconTf.borderColor = 0x000000;
			
			var html:String =  "";
			html += "<img id='IMG' vspace='0' hspace='0' src='";
			html +=url;
			html += "' width='"+WH+"' height='"+WH+"' />";
			
			_iconTf.htmlText = html;
			
			addMask();
		}
		
		
		
		
		
		
		private function addMask():void{
			_maskShape.graphics.beginFill(0xFFFFFF);
			var halfNum:int = WH/2;
			_maskShape.graphics.drawCircle(0,0,halfNum);
			_maskShape.x = _maskShape.y = halfNum+1;
			addChild(_maskShape);
			this.mask = _maskShape;
			
		}
		
		
		
		
		public function destroy():void{
			
			
			if(_iconTf != null){
				_iconTf.text ="";
				if(contains(_iconTf)){
					removeChild(_iconTf);
				}
			}
			
			if(_maskShape != null){
				if(contains(_maskShape)){
					removeChild(_maskShape);
				}
			}
			
			_maskShape = null;
			_iconTf = null;
		}
		
		
		private var _maskShape:Shape = new Shape();
		
		private var _iconTf:TextField = new TextField();
		
		
		
		
		
	}
}