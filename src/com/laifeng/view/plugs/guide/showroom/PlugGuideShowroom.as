package com.laifeng.view.plugs.guide.showroom
{
	import com.adobe.json.JSON;
	import com.laifeng.config.LiveConfig;
	import com.laifeng.interfaces.IPlugin;
	import com.laifeng.view.plugs.control.SimpleUrlLoader;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 插件:正在直播的直播间推荐 只显示前三名 
	 * 
	 */
	
	public class PlugGuideShowroom extends Sprite implements IPlugin
	{
		
		public var id:int = 0;
		public const MAX_W:int = 440;
		
		private const nextIssueUrl:String = "http://v.laifeng.com/room/";
		
		
		public function PlugGuideShowroom(id:int)
		{
			this.id = id;
			
			_itemList = new Vector.<GuideItemShowroom>;
			creatItem();
			
			_tfNextMsg.width  = MAX_W
			_tfNextMsg.height = 50;
			addChild(_tfNextMsg);
			_tfNextMsg.selectable = false;
			
			_tfTitle = new TextField();
			_tfTitle.width  = 200;
			_tfTitle.height = 40;
			_tfTitle.y  = 80;
			_tfTitle.selectable = false;
			this.addChild(_tfTitle);
			
			this.addChild(_layerItem);
			_layerItem.y = _tfTitle.y+25;
		}
		
		
		/**参数*/
		public function set param(value:Object):void{
			_param = value;
		}
		
		/**启动*/
		public function start(callback:Function):void{
			
			_callback = callback;
			
			_tfTitle.text = "";
			
			var  sLoader2:SimpleUrlLoader = new SimpleUrlLoader(null,2);
			sLoader2.listener(getDataResult);
			
			var url:String = nextIssueUrl+LiveConfig.get.initOption.roomId+"/rec?rd="+int(Math.random() * 999);
			sLoader2.startLoad(url);
		}
		
		
		/**
		 * 获取数据结果
		 */
		private function getDataResult(data:Object):void
		{
			switch(data["type"]){
				case Event.COMPLETE :
					var content:Object = data["content"];	
					
					var resStr:String = String(content.data);
					var data:Object = com.adobe.json.JSON.decode(resStr);
					
					if(data["response"]["data"]==null){
						return;
					}
					
					data = null;
					
					initList(content["data"]);
					initTitle(content["data"]);
					break;
			}
			
		}
		
		
		/**结束  @param callback(结束回调)*/
		public function end():void{
		}
		
		/**
		 * 更新
		 */
		public function screenChange(w:int,h:int):void
		{
			this.x = (w - MAX_W)/2 ;
			this.y = (h-300)/2;
		}
		
		
		/**
		 * 从推荐列表中剔除当前直播间 防止在自己的直播间推荐自己
		 */
		private function removeAnchorInfoByRoomdId(arr:Array):void
		{
			var len:int = arr.length>=4?4:arr.length;
			for(var i:int=0; i<len;i++)
			{
				if(String(arr[i]["roomId"]) == LiveConfig.get.initOption.roomId)
				{
					arr.splice(i,1);
					return;
				}
			}
		}
		
		
		/**
		 * 创建ITEM
		 */
		private function creatItem():void
		{
			for(var i:int=0; i<3;i++)
			{
				_itemList.push(new GuideItemShowroom());
			}
		}
		
		
		private function initList(jsonStr:String):void
		{
			
			if(_layerItem.numChildren){
				_layerItem.removeChild(_layerItem.getChildAt(0));
			}
			var data:Object = com.adobe.json.JSON.decode(jsonStr);
			
			var list:Array = data["response"]["data"]["data"];
			
			removeAnchorInfoByRoomdId(list);
			
			var len:int = list.length>3? 3:list.length;
			if(len == 0) return;
			
			var item:GuideItemShowroom;
			for(var i:int = 0; i<len; i++)
			{
				item = _itemList[i];
				_layerItem.addChild(item);
				item.setData(list[i]);
				item.x = i * 150;
				item.addEventListener("EVENT_QUIT_FULLSCREEN",quitHandler);
			}
		}
		
		private function initTitle(jsonStr:String):void
		{
			var data:Object = com.adobe.json.JSON.decode(jsonStr);
			
			var str:String = data["response"]["data"]["next"];
			var html:String = "<p align='center'> <b><font size='20' color='#FFFFFF' face='微软雅黑,Microsoft YaHei,Arial'>";
			html+=str;
			html+="</font></b></p>";
			
			_tfNextMsg.htmlText = html;
		}
		
		/**
		 * 全屏切换
		 */
		private function quitHandler(event:Event):void
		{
			//_callback.call(null,{type:PluginConfig.CALLBACK_TYPE_EXIT_FULL_SCREEN,data:null});
		}
		
		
		/**
		 * 设置样式
		 */
		private function setTfStyle(tf:TextField,tfm:TextFormat):void
		{
			tf.defaultTextFormat = tfm;
			tf.setTextFormat(tfm);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			trace('io error');
		}
		
		
		public function destroy():void
		{
		}
		
		
		private var _tfTitle:TextField;
		private var _itemList:Vector.<GuideItemShowroom>;
		private var _layerItem:Sprite = new Sprite();
		
		private var _param:Object;
		//回调
		private var _callback:Function;
		
		private var _tfNextMsg:TextField = new TextField();
		
		
		
		
	}
}