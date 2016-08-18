package com.laifeng.module.vo
{
	import flash.utils.getTimer;

	public class StreamLogData
	{
		public function StreamLogData()
		{
		}
		
		public  var available:Boolean = false;
		
		public var streamID:String = "";
		public var bps:String = "";
		
		public var bufferTime:Number = 0;
		public var nsTime:Number = 0;
		public var bufferLength:Number = 0;
		public var bufferFullCount:int = 0;
		public var bufferEmptyCount:int = 0;
		public var playUrl:String = "";
		public var videoWH:String = "";
		public var streamWH:String = "";
		
		public var bytesTotal:Number = 0;
		public var decodedFrames:uint = 0;
		public var currFps:int = 0;
		
		/**==============p2p info===================*/
		public var localconntionId:String = "";
		public var playStatus:String = "";
		public var peerStatus:String = "";
		/**清晰度切换  给p2p*/
		public var lastPlayId:uint = 0;
		
		
		/**buffer 被填充的最大值*/
		public var bufferMaxLength:int = 0;
		/**buffer 总共空的时间*/
		public var bufferEmptyTime:uint = 0;
		/**低帧率运行时间*/
		public var lowFrameTime:uint = 0;
		
		public var sCount:int = 0;
		
		
		
		public function clearData():void{
			lowFrameTime = 0;
			bufferEmptyTime = 0;
			bufferMaxLength = 0;
		}
		
		
		public function get systemTime():Number{
			return getTimer()/1000;
		}
		
		
		public function set useP2P(value:Boolean):void{
			_useP2P = value.toString();
		}
		
		
		public function set sdkVersion(value:String):void{
			_sdkVersion = value;
		}
		
		
		public function set videoTime(value:Number):void{
			_videoTime = value;
		}
		
		public function get videoTime():Number{
			return getTimer() - _videoTime;
		}
		
		
		public function set setDelay(value:int):void{
			_delay = value.toString();
		}
		
		/**
		 * p2p延迟时间   如果大于60秒  则设定为100秒
		 */
		public function get delayTime():int{
			var dTime:int = int(_delay)>60? 100:int(_delay);
			return dTime;
		}
		
		
		public function addBufferEmptyCount():void{
			bufferEmptyCount++;
		}
		
		public function addBufferFullCount():void{
			bufferFullCount++;
		}
		
		
		/**
		 * 1分钟内buffer empty 次数
		 */
		public function set currBfeCount(value:int):void{
			_currBufferEmptyCount = value;
		}
		
		public function get currBfeCount():int{
			return _currBufferEmptyCount;
		}
		
		
		public function set bytesLoaded(value:Number):void{
			
			_bytesLoaded = Number((value/1024).toFixed(2));
			_speedInfo.speed = _bytesLoaded - _lasterLoaded;
			_lasterLoaded = _bytesLoaded;
		}
		
		public function get bytesLoaded():Number{
			return _bytesLoaded/1024;
		}
		
		
		
		public function get p2pMsg():String{
			
			_html = "";
			_html += "<font size='12px' color='#FFFFFF'><b>[p2p version] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>"+_sdkVersion+"</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[use p2p] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>"+_useP2P+"</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[bps] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>"+bps+"</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[stream id] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>"+streamID+"</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[bufferTime] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>"+bufferTime+"</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[bufferLength] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>"+bufferLength+"</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[bufferFull] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>"+bufferFullCount+"</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[bufferEmpty] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>"+bufferEmptyCount+"</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[p2p delay] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>"+_delay+"</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[last play id] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>"+lastPlayId+"</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[bytesTotal] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>"+bytesTotal+"</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[bytesLoaded] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>"+bytesLoaded+"</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[localconnectionid] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>"+localconntionId+"</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[play status] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>"+playStatus+"</b></font>"+"\n";
			
			return _html;
		}
		
		
		public function get videoMsg():String{
			_html = "";
			_html += "<font size='12px' color='#FFFFFF'><b>[bps.............] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>【  "+bps+" 】</b></font>";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[fps..........] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>【  "+currFps+" 】</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[stream id...] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>【 "+streamID+" 】</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[nsTime......] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>【 "+nsTime+" 】</b></font>";
			
			
			_html += "<font size='12px' color='#FFFFFF'><b>[decodedFrames] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>【"+decodedFrames+"】</b></font>"+"\n";
			
			
			_html += "<font size='12px' color='#FFFFFF'><b>[videoWH....] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>【 "+videoWH+" 】</b></font>";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[streamWH] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>【 "+streamWH+" 】</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[bufferTime] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>【 "+bufferTime+" 】</b></font>";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[bufferLength] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>【 "+bufferLength+" 】</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[bufferMax..] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>【 "+bufferMaxLength+" 】</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[bufferFull..] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>【 "+bufferFullCount+" 】</b></font>";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[bufferEmpty] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>【 "+bufferEmptyCount+" 】</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[bufferEmptyTime] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>【 "+bufferEmptyTime+" 】</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[bytesLoaded] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>【 "+bytesLoaded+" 】</b></font>"+"\n";
			
			_html += "<font size='12px' color='#FFFFFF'><b>[skipCount..] : </b></font>";
			_html += "<font size='12px' color='#33FF33'><b>【 "+sCount+" 】</b></font>"+"\n";
			
			return _html;
		}
		
		
		public function get downSpeed():String{
			return _speedInfo.getSpeed();
		}
		
		public function get peerInfo():String{
			_html = "";
			_html += "<font size='12px' color='#FFFFFF'><b>"+peerStatus+"</b></font>"+"\n";
			return _html;
		}
		
		
		private var _videoTime:Number = 0;
		private var _useP2P:String       = "";
		private var _sdkVersion:String = "";
		private var _delay:String            = "";
		private var _html:String = "";
		private var _bytesLoaded:Number = 0;
		private var _downSpeed:Number = 0;
		private var _speedInfo:LoadSpeedInfo = new LoadSpeedInfo();
		private var _lasterLoaded:Number = 0;
		private var _currBufferEmptyCount:int = 0;
		
	}
	
	
}






class LoadSpeedInfo{
	
	public function set speed(value:Number):void{
		_currentSpeed = value;
		
		if(count >=300){
			count = 0;
			_speedCount = 0;
		}
		
		_speedCount += value;
		count++;
	}
		
		
	public function getSpeed():String{
		
		return (_speedCount/count).toFixed(2);
	}
	
	
	public function getCurrentSpeed():String{
		return _currentSpeed.toFixed(2);
	}
	
	
	
	private var _speedCount:Number = 0;
	private var count:int = 0;
	
	private var _currentSpeed:Number = 0;
	
		
	
}


