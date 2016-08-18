package com.laifeng.view.barrage
{
	import com.laifeng.config.LiveConfig;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class BarrageControl extends EventDispatcher
	{
		
		public const MAX_HORN_ROW:int     = 2;
		
		public const MAX_HORN_SPACE:int   = 50; //喇叭最大间距
		public const MAX_CHAT_SPACE:int    = 50;//聊天最大间距

		public const MAX_TOP_SPACE:int       = 33;
		/**聊天弹幕的高度*/
		public const MAXZ_CHAT_HEIGHT:int = 29;
		/**0:关闭  1：开启 */
		public var CHAT_STATUS:int = 1;
		public const CHAT_STATUS_OPEN:int  = 1;
		public const CHAT_STATUS_CLOSE:int = 0;
		
		
		public function BarrageControl(layer:Sprite)
		{
				_container = layer;
				_container.addChild(_layerChat);
				_container.addChild(_layerHorn);
				_container.addChild(_layerUp);
				
				_currLayout = LiveConfig.LAYOUT_TOP;
		}
		
		
		public function start(w:int,h:int):void{
			resize(w,h);
			_container.removeEventListener(Event.ENTER_FRAME,render);
			_container.addEventListener(Event.ENTER_FRAME,render);
		}
		
		
		public function resize(w:int,h:int):void{
				_w = w;
				_h = h - 40;
				
				changeLoayout(_currLayout);
		}
		
		
		public function setAlphaHandler(value:Number):void{
			_container.alpha = value;
		}
		
		
		public function setLayoutHandler(layout:String):void{
				changeLoayout(layout);
		}
		
		
		
		public function setColorHandler(color:String):void{
			_chatColor = color;
			var rowData:Dictionary  = _chatShowData.getRootDataList();
			var list:Vector.<IBarrage>;
			
			for(var key:String in rowData){
				list = _rootData[key];
				if(list  == null ) break;
				
				for(var i:int=0; i<list.length; i++){
					list[i].setFontColor = _chatColor;
				}//end for
			}
		}
		
		
		
		public function changeLoayout(cmd:String):void{
				switch(cmd){
						case LiveConfig.LAYOUT_TOP :
							
							_startRow = 0;
							_endRow = (_h/2)/MAXZ_CHAT_HEIGHT;

							break;
						case LiveConfig.LAYOUT_BOTTOM :
							
							_startRow = (_h/2)/MAXZ_CHAT_HEIGHT;
							_endRow = _h/MAXZ_CHAT_HEIGHT;

							break;
						
						case LiveConfig.LAYOUT_FULL :
							_startRow = 0;
							_endRow   = _h/MAXZ_CHAT_HEIGHT;

							break;
						
						default:

							break;
				}
		}
		
		
		
		public function add(data:Object):void{
			
			if(LiveConfig.get.initOption.roomType !=2){
				return;
			}
			
			if(data["info"]== null) return;
			if(data["info"].hasOwnProperty("m")){
				creatBarrageByType(data);
			}
		}
		
		
		private function render(event:Event):void{
				emit();
				renderHorn();
				renderChat();
					
			  _lasterFrameTime= _lasterFrameTime==0? getTimer():_lasterFrameTime;
			  
			  if(getTimer() - _lasterFrameTime>100){
				  	setBarrageDeta();
			  }
			  
			  _lasterFrameTime = getTimer();
				
		}
		
		
		/**
		 * 发射 
		 */
		private function emit():void{
			emitHorn();
			emitChat();
		}
		
		
		
		private var _horn:IBarrage;
		private function emitHorn():void{
				if(_hornWaitList.length == 0) return;
	
				for(var i:int=0; i<MAX_HORN_ROW; i++){
					
					if((_hornShowData.getVec(i)==null)){
						_horn = _hornWaitList.shift();
						_hornShowData.add(i,_horn);
						showHorn(i,_horn);
						return;
					}
					
					if(_hornShowData.getVecLength(i) ==0){
						_horn = _hornWaitList.shift();
						_hornShowData.add(i,_horn);
						showHorn(i,_horn);
						return;
					}
					
					
					if( (_w - _hornShowData.getLastItem(i).xy.x - _hornShowData.getLastItem(i).w) > 
						MAX_HORN_SPACE){
						_horn = _hornWaitList.shift();
						_hornShowData.add(i,_horn);
						showHorn(i,_horn);
						return;
					}
					
				}
		}
		
		
		private function showHorn(index:int,item:IBarrage):void{
			_layerHorn.addChild(DisplayObject(item));
			item.setXY(_w, index * (MAXZ_CHAT_HEIGHT+5)+MAX_TOP_SPACE);
		}
		
		
		private var _cHornList:Vector.<IBarrage>;
		private function renderHorn():void{
			
			for(var i:int=0; i<MAX_HORN_ROW; i++){
				_cHornList = _hornShowData.getVec(i);
				if(_cHornList == null) break;
				for(var k:int=0; k<_cHornList.length; k++){
					if(_cHornList[k].status != BarrageConfig.B_STATUS_DEAD){
						_cHornList[k].updata();
						layerSwitch(_cHornList[k]);
					}else{
						_cHornList[k].destroy();
						_cHornList[k] = null;
						_cHornList.splice(k,1);
					}
				}
			}
		
		}
		
		
		
		
		private var _chatItem:IBarrage;
		private function emitChat():void{
			if(_chatWaitList.length ==0 ) return;
			
				for(var i:int = _startRow; i<_endRow; i++){
						if(_chatShowData.getVec(i) == null){
							_chatItem = _chatWaitList.shift();
							_chatShowData.add(i,_chatItem);
							showChat(i,_chatItem);
							return;
						}
						
						if(_chatShowData.getVec(i).length == 0){
								_chatItem = _chatWaitList.shift();
								_chatShowData.add(i,_chatItem);
								showChat(i,_chatItem);
								return;
						}
						
						
						if( (_w - _chatShowData.getLastItem(i).xy.x - _chatShowData.getLastItem(i).w) > 
							MAX_CHAT_SPACE){
							_chatItem = _chatWaitList.shift();
							_chatShowData.add(i,_chatItem);
							showChat(i,_chatItem);
							return;
						}
				}//END FOR
			
		}
		
		
		private function layerSwitch(item:IBarrage):void{
			
			if(item.status == BarrageConfig.B_STATUS_PAUSE){
					if(!item.isUp){
							item.isUp = true;
							item.pauseTime = getTimer()/1000;
							_layerUp.addChild(item as DisplayObject);
							return;
					}
			}
			
			
			if(_layerUp.numChildren >0){
				var target:IBarrage = _layerUp.getChildAt(0) as IBarrage;
				if( (getTimer()/1000 - target.pauseTime) >BarrageConfig.B_PAUSE_MAX_TIME){
					target.isUp = false;
					target.status = BarrageConfig.B_STATUS_RUNNING;
					
					if(target.BarrageType == BarrageConfig.BARRAGE_TYPE_1){
						_layerChat.addChild(target as DisplayObject);
					}else{
						_layerHorn.addChild(target as DisplayObject);
					}
					
				}
			}
			
		}
		
		
		
		private function showChat(index:int,item:IBarrage):void{
			_layerChat.addChild(DisplayObject(item));
			item.setXY(_w, index * MAXZ_CHAT_HEIGHT+MAX_TOP_SPACE);
			item.setFontColor = _chatColor;
		}
		
		
	    private var _rootData:Dictionary;
		private var _cChatList:Vector.<IBarrage>;
		private function renderChat():void{
			
			if(CHAT_STATUS == CHAT_STATUS_CLOSE){
				if(_layerChat.visible){
					_layerChat.visible =false;
					_layerUp.visible = false;
				}
			}else{
				if(!_layerChat.visible){
					_layerChat.visible =true;
					_layerUp.visible = true;
				}
			}
			
			
			_rootData = _chatShowData.getRootDataList();
			
			for(var key:String in _rootData){
					_cChatList = _rootData[key];
					if(_cChatList  == null ) break;
				
					for(var i:int=0; i<_cChatList.length; i++){
						
							if(_cChatList[i].status != BarrageConfig.B_STATUS_DEAD){
								_cChatList[i].updata();
								layerSwitch(_cChatList[i]);
							}else{
								
								_cChatList[i].destroy();
								_cChatList[i] = null;
								_cChatList.splice(i,1);
							}
					}//end for
			}
		}
		
		
		
		private function filterString(targetString:String):String{
			var str:String = targetString;
			return "";
		}
		
	
		private function creatBarrageByType(data:Object):IBarrage{
			
			var item:IBarrage;
			switch(int(data["type"])){
				
				case BarrageConfig.BARRAGE_TYPE_1 :
					if(CHAT_STATUS == CHAT_STATUS_CLOSE) return null;
					item = new BarrageItemChat();
					if(_chatWaitList.length<1000){
						_chatWaitList.push(item);
					}
					break
				
				case BarrageConfig.BARRAGE_TYPE_2 :
					item = new BarrageItemHorn();
					item["setIcon"](_hornImg.clone());
					_hornWaitList.push(item);
					break
				
			}
			
			if(item != null){
				item.setInfo(data);
			}
			
			return item;
		}
		
		
		
		public function closeChat():void{
			while(_chatWaitList.length){
				_chatWaitList[0].destroy();
				_chatWaitList[0] = null;
				_chatWaitList.splice(0,1);
			}
			
			while(_layerChat.numChildren){
				(_layerChat.getChildAt(0) as IBarrage).destroy();
			}
			
			_chatShowData.removeAll();
		}
		
		
		
		public function close():void{
			_container.removeEventListener(Event.ENTER_FRAME,render);
		}
		
		
		private function setBarrageDeta():void{
			for(var i:int=0; i<_layerChat.numChildren; i++){
				_layerChat.getChildAt(i).x = -200;
			}
			
			if(_chatWaitList != null){
				while(_chatWaitList.length){
					_chatWaitList[0].destroy();
					_chatWaitList[0] = null;
					_chatWaitList.splice(0,1);
				}
			}
			
		
		}
		
		
		private var _container    :Sprite  = new Sprite();
		private var _layerHorn   :Sprite  = new Sprite();
		private var _layerChat    :Sprite  = new Sprite();
		private var _layerUp       :Sprite  = new Sprite();
		
		private var _w:int = 0;
		private var _h:int = 0;
		private var _chatWaitList:Vector.<BarrageItemChat>  = new Vector.<BarrageItemChat>();
		private var _chatShowData:BarrageCatch = new BarrageCatch();
		
		private var _hornWaitList:Vector.<BarrageItemHorn> = new Vector.<BarrageItemHorn>();
		private var _hornShowData:BarrageCatch = new BarrageCatch();

		private var _currLayout:String = "";
		
		private var _hornImg:HornImg = new HornImg();
		
		private var _startRow:int = 0;
		private var _endRow:int  = 0;
		
		private var _chatColor:String = "#FFFFFF";
		private var _lasterFrameTime:uint = 0;
		
		
		
		
		
	}
}