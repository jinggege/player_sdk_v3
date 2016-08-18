package  com.laifeng.config
{
    import com.laifeng.module.vo.RootRightData;
    import com.laifeng.module.vo.StreamLogData;
    
    import flash.events.Event;
    
    import lf.media.core.data.InitOption;
	
	/**********************************************************
	 * LiveConfig
	 * 
	 * Author         : mj
	 * Description :
	 * 			全局数据存储   配置
	 * 
	 * 
	 ***********************************************************/
    
    public class LiveConfig {
		public static var BUILD_TIME                    :String      = "build:160808_04";
		public static var PLAYER_VERSION           :String      = "3.3.0.0"; //主版本号为2 ， 次版本号为05
		
		/**鼠标滑入 video 的时间*/
		public static var mouseInTime                  :Number = 0;
		public static var currentVolume               :Number = 0.5;
		/**当前播放器状态*/
		public static var currVideoStatus             :String     = "";
		
		/**房间当前状态   0:未直播   1：直播结束JS通知停播 2:播放中*/
		public static var liveStatus                        :int            = 0;
		/**从请求播放地址  到第一次buffer full 的时间*/
		public static var serviceUseTime              :Number = 0
		/**最近一次切换清晰度的 时间  ms*/
		public static var lastChangeQualityTime  :Number = 0;
		
		/**直播开启方式  auto ,  js*/
		public static var START_TYPE                    :String    = "";
		/**弹幕分布方式*/
		public static const LAYOUT_TOP     	        :String = "LAYOUT_TOP";
		public static const LAYOUT_BOTTOM       :String = "LAYOUT_BOTTOM";
		public static const LAYOUT_FULL             :String ="LAYOUT_FULL";
		
		/**是否允许全屏时的交互*/
		public static var isFullScreenInteractive:Boolean = true;
		
		public  var rootRightData:RootRightData = new RootRightData();
		
		public var streamId:String = "";
		public var isP2p:Boolean = false;
		
		public var jsNameSpace:String = "XMPlayer";
		
		public var initOption:InitOption;
		
		
		public function LiveConfig() {
			if(_instance!= null){
				throw(new Event("LiveConfig 为单例  不可构造!"));
			}
		}
		
		
		
		public function get streamLogData():StreamLogData{
			return _streamLogData;
		}
		
		
		
		
		
		public static function get  get():LiveConfig{
			_instance = _instance==null? new LiveConfig():_instance;
			return _instance;
		}
		
		
		public  var defaultWidth:int  = 520;
		public  var defaultHeight:int = 390;
		
		private static var _instance:LiveConfig;
		
		private  var _streamLogData:StreamLogData = new StreamLogData();
		
		
    }
}