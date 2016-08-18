package com.laifeng.view.giftshow
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import lf.media.core.component.loader.SimpleImgLoader;
	import lf.media.core.util.Tweener;
	
	public class GiftItem extends Sprite
	{
		
		public var index:int = 0;
		public const MAX_H:int = 30;
		
		
		public function GiftItem(callback:Function)
		{
			super();
			
			_callback = callback;
			
			_tf.selectable = false;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			addChild(_tf);
			
			addChild(_tfCount);
			_tfCount.width = 60;
			_tfCount.height = MAX_H;
			_tfCount.multiline = true;
			
			_tf.width = 300;
			_tf.height = MAX_H;
		}
		
		public function setGiftInfo(info:Object):void{
			_giftInfo = info;
			_head = new CircleIcon(_giftInfo["f"]);
			addChild(_head);
			_head.x =5;
			_tf.x = _head.x+_head.WH;
			_tf.multiline = true;
			_tf.wordWrap = true;
			
			setHtml();
		}
		
		
		private function setHtml():void{
			var html:String = "<font size='14' color='#000000' face='微软雅黑,Microsoft YaHei,Arial'>";
			
			var tName:String =_giftInfo["toRoom"]? "":_giftInfo["tn"];
			html+= _giftInfo["n"] +" 送 " + tName;
			html+= "</font>";
			_tf.htmlText = html;
			_imgIloader.getImg(_giftInfo["giftInfo"]["smallicon"],loadComplete);
			
		}
		
		private function loadComplete(data:Object):void{
			_giftIcon = data["content"] as Bitmap;
			if(_giftIcon == null) return;
			addChild(_giftIcon);
			_giftIcon.width = _giftIcon.height = 26;
			_tf.width = _tf.getCharBoundaries(_tf.length - 1).x +	25;	
			var offx:int = _giftInfo["toRoom"]? 15:30;
			_giftIcon.x = _tf.width+offx;
			_giftIcon.smoothing = true;
			
			_tfCount.x =  _giftIcon.x;
			
			var count:int = _giftInfo["q"];
			
			var countHtml:String = "<font size='14' color='#000000' face='微软雅黑,Microsoft YaHei,Arial'>";
			countHtml += "x "+count;
			countHtml += "</font>";
			_tfCount.htmlText = countHtml;
			_tfCount.x = _giftIcon.x +_giftIcon.width+5;
			
			drawBg();
		}
		
		
		
		private function drawBg():void{
			graphics.beginFill(0xFFFFFF,0.7);
			graphics.drawRoundRect(0,-2,_tfCount.x+_tfCount.width,30,30,30);
			graphics.endFill();
		}
		
		
		public function move(x:int,y:int):void{
			
			this.x = x;
			this.y = y;
			Tweener.to(this,1,{x:0,y:this.y,onComplete:completeA});
		}
		
		
		private function completeA():void{
			_delayT = setTimeout(delayHandler,1000);
		}
		
		
		
		private function delayHandler():void{
			Tweener.to(this,0.5,{x:this.width * -1,y:this.y,onComplete:completeB});
			
			clearTimeout(_delayT);
		}
		
		
		private function completeB():void{
			_callback.call(null,index);
		}
		
		
		
		public function destroy():void{
			_head.destroy();
			index = 0;
			
			
			if(_giftIcon != null){
				if(_giftIcon.bitmapData != null){
					_giftIcon.bitmapData.dispose();
					_giftIcon.bitmapData = null;
				}
				
				if(contains(_giftIcon)){
					removeChild(_giftIcon);
					_giftIcon = null;
				}
			}
			
			_imgIloader = null;
			
		}
		
		
		
		private var _tf:TextField = new  TextField();
		private var _tfCount:TextField = new TextField;
		private var _head:CircleIcon;
		private var _giftInfo:Object = null;
		private var _delayT:uint;
		private var _callback:Function;
		private var _giftIcon:Bitmap;
		private var _imgIloader:SimpleImgLoader = new SimpleImgLoader();
		
		private var _headLoader:Loader = new Loader();
		
		
		
		
		
		
	}
}