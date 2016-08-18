var API=function(){}
var swfId = "";
var _potion = null;

API.prototype={
	

	creatVideo:function(option){
		
		_potion = option;
		
		var roomId          = _potion["roomId"];
		var roomType        = _potion["roomType"]
		var pW              = _potion["width"];
		var pH              = _potion["height"];
		var flashContentId  = _potion["flashContentId"];
		var swfUrl          = _potion["swfUrl"];
		swfId               = _potion["swfId"];
	       
		
		var swfVersionStr = "10.2.0";
        var xiSwfUrlStr = "playerProductInstall.swf";
		
		var flashvars = {};
		flashvars.room_id= roomId;  //98154982  840  9713 53473

		flashvars.autoplay="1";
		flashvars.userid="8888";
		flashvars.playerwidth= pW;  //560   800   520
		flashvars.playerheight= pH; //420  450    390
		flashvars.fullscreen="1";
		flashvars.showPlugs = 1;
		flashvars.showHorn = 1;  //0:隐藏  1:显示
		flashvars.roomType = roomType;
		flashvars.brower = "";
        flashvars.appid = "iku";
		
		var params = {};
        params.quality = "high";
        params.bgcolor = "#FFFFFF";
        params.allowscriptaccess = "always"
		params.allowfullscreen = "true";
		params.allowFullScreenInteractive="true"
		
		var attributes   = {};
        attributes.id    = swfId;
        attributes.name  = swfId;
        attributes.align = "middle";
		attributes.allowFullScreenInteractive = "true";
		
		
		 swfobject.embedSWF(
                swfUrl, flashContentId, 
                "100%", "100%", 
                swfVersionStr, xiSwfUrlStr, 
                flashvars, params, attributes
			);
		
		swfobject.createCSS('#'+flashContentId, "display:block;text-align:left;");
		
	},
	
	bingEvent:function(self){
		var _self = self;
		$(document).ready(function(self){	
			$("input[name=layout]").click(function(){
				var layout  = $("input[name='layout']:checked").val();
				//_self.getSwf()["setBarrageLayout"](layout);		
				//_self.getSwf()["exMute"](0);
				
				_self.getSwf()["exSetPlayerWH"]({width:800,height:450});
				
					
			});
						
						
			$("input[name=alpha]").click(function(){
				var alpha  = $("input[name='alpha']:checked").val();
				//_self.getSwf()["setBarrageAlpha"](alpha);			
				//_self.getSwf()["exMute"](1);	
				_self.getSwf()["exSetPlayerWH"]({width:90,height:90});
			});
						
			$("input[name=color]").click(function(){
				var color  = $("input[name='color']:checked").val();
				_self.getSwf()["setBarrageColor"](color);				
			});
			
			$("input[name=barrageStatus]").click(function(){
				var bStatus  = Number($("input[name='barrageStatus']:checked").val());
				_self.getSwf()["setBarrageChatStatus"](bStatus);				
			});
			
			
			
			
			 // start live
			$("#btnPlay").click(function(){
				_self.startLive();
					
			});
			
			
			
			
			
	
			 // stop live
			$("#btnStop").click(function(){			 
				_self.getSwf()["stopLive"]();		
			});
			
			//send chat and horn
			 $("#btnSend").click(function(){		
				var chatType = $("input[name='chat']:checked").val();	   
				var chatInfo = {};
				chatInfo["info"] = {};
				chatInfo.type = chatType;
				chatInfo["info"]["m"] = $("#lf-chat-input").val();
				chatInfo["info"]["n"] = "天下第一胖";
				_self.getSwf()["setChatInfo"](chatInfo);		
			});
			
			//send gift
			$("#btnSendGift").click(function(){			
				var ge ={}
				ge["smallicon"]="http://static.youku.com/ddshow/img/lfgift/xxxy5_24_24.png";
							
				var giftInfo = {};
				giftInfo["n"] = "爬爬爬爬爬爬爬爬爬爬爬爬爬爬";
				giftInfo["tn"] = "啵啵";
				giftInfo["f"] = "http://r1.ykimg.com/05100000555AD8400A48156AD2047BA8";
				giftInfo["giftInfo"] =ge;
				giftInfo["q"] = Math.random()*10000;
				_self.getSwf()["setGiftInfo"](giftInfo);
			});
			
			
			
			
		});//end ready
	},
	
	
	getSwf:function(){
		var idStr = "#"+swfId;
		return $(idStr)[0];
	},
	
	
	startLive:function(){
							
		this.getSwf()["init"](initOption);		
	
		this.getSwf()["startLive"](playOption);		

	},
	
	
	
	//倒计时
	_flash_videoCountDown:function (){
		return "{'sysTime':'1441164900316','endTime':'1441174900316'}";
	},
	_flash_gifter_toggle:function(isOpen){
		//console.log("effect control=",isOpen);
	},
	_flash_fullscreen_chat:function(msg){
		//console.log("send chat=",msg);
	},
	
	_flash_fullscreen_horn:function(msg){
		//console.log("send horn=",msg);
	}
	
	
	
	
	
};//end api