package com.laifeng.view.plugs.guide.showroom
{
	import com.laifeng.config.LiveConfig;
	import com.laifeng.config.UIKey;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import flashx.textLayout.accessibility.TextAccImpl;
	
	import lf.media.core.component.loader.SimpleImgLoader;

	public class GuideItemShowroom extends Sprite
	{
		
		public const MAX_W:int = 200;
		private const imgH:int = 150;
		
		public function GuideItemShowroom()
		{
			
			this.addChild(_img);
			_img.smoothing =true;
			_img.scaleX = _img.scaleY = 0.7;
			
			_img.bitmapData =new BitmapData(MAX_W,imgH)
			
			this.addChild(_aIcon);
			
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK,gotoRoomHandler);
			
			var btn:BtnPlay = new BtnPlay();
			this.addChild(btn);
			btn.x = _img.x +(_img.width-btn.width)/2;
			btn.y = _img.y + (_img.height-btn.height)/2;
			
			_tfUserInfo.width = MAX_W;
			_tfUserInfo.height = 25;
			addChild(_tfUserInfo);
			_tfUserInfo.selectable = false;
			_tfUserInfo.multiline = true;
			_tfUserInfo.wordWrap = true;
			_tfUserInfo.y = imgH - 35;
			
			_tfViewer.width = 100;
			_tfViewer.height = 25;
			_tfViewer.multiline = true;
			_tfViewer.wordWrap = true;
			_tfViewer.selectable = false;
			addChild(_tfViewer);
			
			_tfViewer.y = _tfUserInfo.y +20;
			
		}
		
		
		
		public function setData(data:Object):void
		{
			_param = data;
			
			var rand:int = Math.random() * 999;
			
			var lvUrl:String = "http://static.youku.com/ddshow/img/laifeng/icon/level/aLevel_"+data["userLevel"]+".png";
			_imgLoader = new SimpleImgLoader();
			_imgLoader.getImg(lvUrl,getIconComplete);
			var authorName:String = trimString(data["nickName"]);
			
			var html:String = "<p align='left'> <font size='12' color='#FFFFFF' face='微软雅黑,Microsoft YaHei,Arial'>";
			html+=authorName;
			html+="</font></p>";
			_tfUserInfo.htmlText = html;
			
			if(data["livehouse"]){
				_tfViewer.text = "";
			}else{
				html = "<p align='left'> <font size='12' color='#CCCCCC' face='微软雅黑,Microsoft YaHei,Arial'>";
				html+="观众:"+data["userCount"];
				html+="</font></p>";
				_tfViewer.htmlText = html;
			}
				
			
			if(_aIcon.bitmapData != null){
				_aIcon.bitmapData.dispose();
				_aIcon.bitmapData = null;
			}
			
			
			setImgToTf(data["coverW200H150"]);
			_roomUrl = data["roomUrl"];
		}
		
		
		private function getIconComplete(data:Object):void
		{
			
			if(data == null) return;
			_aIcon.bitmapData = (data["content"] as Bitmap).bitmapData;
			_aIcon.y = _tfUserInfo.y;
			
			_tfUserInfo.width = MAX_W - _aIcon.width - 2;
			_tfUserInfo.x = _aIcon.width;
		}
		
		
		
		
		private function setImgToTf(headUrl:String):void
		{
			var loader:Loader = new Loader();
			var lc:LoaderContext = new LoaderContext(true);
			loader.load(new URLRequest(headUrl),lc)
			
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioerrorHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
		}
		
		
		private function ioerrorHandler(event:IOErrorEvent):void{
			var loader:Loader = (event.target as LoaderInfo).loader;
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioerrorHandler);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadCompleteHandler);
			loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
			loader = null;
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void{
			
		}
		
		
		private function loadCompleteHandler(event:Event):void{
			var loader:Loader = LoaderInfo(event.target).loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadCompleteHandler);
			
			try{
				_img.bitmapData = (loader.content as Bitmap).bitmapData;
				_img.smoothing = true;
			}catch(e:Error){};
			
		}
		
		
		
		private function gotoRoomHandler(event:MouseEvent):void
		{
			if(LiveConfig.get.initOption.appId == -1){
				ExternalInterface.call("IKU.flashLink",_param);
				return;
			}
			
			if(this.stage != null){
				if(this.stage.displayState==StageDisplayState.FULL_SCREEN)
				{
					this.stage.displayState = StageDisplayState.NORMAL;
				}
			}
			
			navigateToURL(new URLRequest(url+_roomUrl));
		}
		
		
		/**
		 * 去掉空格
		 */
		private function trimString(str:String):String
		{
			for(var i:int=0; i<str.length; i++)
			{
				str =  str.replace(" ","");
			}
			
			return str;
		}
		
		
		
		private function setTfFormat(tf:TextField,format:TextFormat):void{
			tf.defaultTextFormat = format;
			tf.setTextFormat(format);
		}
		
		
		
		private const url:String= "http://v.laifeng.com";
		private var _roomUrl:String = "";
		private var _imgLoader:SimpleImgLoader;
		private var _param:Object = null;
		private var _aIcon:Bitmap = new Bitmap();
		
		private var _tfUserInfo:TextField = new TextField();
		private var _tfViewer:TextField = new TextField();
		private var _img:Bitmap = new Bitmap();
		
		
		
	}
}