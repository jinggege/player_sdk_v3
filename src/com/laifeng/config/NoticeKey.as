package  com.laifeng.config
{
	/**
	 * 通知 key  必须唯一
	 */
	public class NoticeKey
	{
		/**get_playlist接口数据请求完毕*/
		public static const GET_TRANSITELIST_SUCCESS:String = "GET_TRANSITELIST_SUCCESS";
		/**全屏切换*/
		public static const N_FULL_SCREEN:String = "N_FULL_SCREEN";
		/**清晰度切换*/
		public static const N_QUALITY_CHANGED:String = "N_QUALITY_CHANGED";
		/**JS 控制播放器尺寸*/
		public static const SET_WH_BY_JS:String = "SET_WH_BY_JS";
		/**ui 操作   打开 or 关闭 or  销毁*/
		public static const OPEN_UI:String  = "OPEN_UI";
		public static const CLOSE_UI:String = "CLOSE_UI";
		/**JS 控制播放 */
		public static const N_LIVE_START_BY_JS:String = "N_LIVE_START_BY_JS";
		/**JS 控制 停止*/
		public static const N_LIVE_STOP_BY_JS:String   = "N_LIVE_STOP_BY_JS";
		/**播放模式切换      0:普通模式       1：P2P模式*/
		public static const N_MODEL_CHANGE:String = "N_MODEL_CHANGE";
		/**立即执行关闭*/
		public static const N_COMMAND_STOP:String = "N_COMMAND_STOP";
		/**显示插件 */
		public static const N_SHOW_PLUGS:String = "N_SHOW_PLUGS";
		/**消息类型*/
		public static const N_P2P_ERROR:String = "N_P2P_ERROR";
		/**音量变化*/
		public static const N_CHANGE_VOLUME:String = "N_CHANGE_VOLUME";
		/**音量变化 JS控制*/
		public static const N_CHANGE_VOLUME_EX:String = "N_CHANGE_VOLUME_EX";
		/**静音与取消静音   JS控制*/
		public static const N_MUTE:String = "N_MUTE";
		/**播放 暂停控制*/
		public static const N_PLAY_PAUSE:String = "N_PLAY_PAUSE";
		/**error  信息展示*/
		public static const N_ERROR_MSG:String = "N_ERROR_MSG";
		/**弹幕状态  0：关   1：开*/
		public static const N_SET_BARRAGE_STATUS:String = "N_SET_BARRAGE_STATUS";
		/**弹幕发射信息*/
		public static const N_SEND_BARRAGE:String = "N_BARRAGE";
		/**设置弹幕*/
		public static const N_SET_BARRAGE:String = "N_SET_BARRAGE";
		/**设置弹幕的透明度*/
		public static const N_SET_BARRAGE_ALPHA:String    = "N_SET_BARRAGE_ALPHA";
		/**设置弹幕的布局*/
		public static const N_SET_BARRAGE_LAYOUT:String = "N_SET_BARRAGE_LAYOUT";
		/**设置弹幕颜色*/
		public static const N_SET_BARRAGE_COLOR:String = "N_SET_BARRAGE_COLOR";
		
		public static const N_SET_BARRAGE_OFF:String = "N_SET_BARRAGE_OFF";
		/**设置弹幕全屏时交互是否可以输入*/
		public static const N_SET_BARRAGE_FULLSCREEN_INPUT:String = "N_SET_BARRAGE_FULLSCREEN_INPUT";
		/**显示礼物信息*/
		public static const N_SEND_GIFT_INFO:String = "N_SEND_GIFT_INFO";
		/**聊天  返回*/
		public static const N_SEND_CHAT_RESPONE:String = "N_SEND_CHAT_RESPONE";
		/**金喇叭   返回*/
		public static const N_SENT_HORN_RESPONE:String = "N_SENT_HORN_RESPONE";
		/**获取词库返回*/
		public static const N_THESAURUS_RESPONE:String = "N_THESAURUS_RESPONE";
		/**control bar 状态改变*/
		public static const N_CONTROLBAR_STATUS_SWTICH:String = "N_CONTROLBAR_STATUS_SWTICH";
		/**音量变更*/
		public static const N_VOLUME_CHANGE:String = "N_VOLUME_CHANGE";
		
		
		/**
		 * 配置类型
		 */
		public static const TYPE_P2P_HOST_ERROR:String = "TYPE_P2P_HOST_ERROR";
		
		public static const TYPE_METADATA_INFO:String = "TYPE_METADATA_INFO";
		
		/**==============about report=====================*/
		
		public static const R_GET_PLAYURL_FAIL:String = "R_GET_PLAYURL_FAIL";
		
		
		/**==============about play status=====================*/
		public static const TYPE_VIDEO_STATUS_PLAYING:String = "playing";
		public static const TYPE_VIDEO_STATUS_PAUSE:String     = "pause";
		public static const TYPE_VIDEO_STATUS_CLOSE:String     = "close";
		
		
		
		
	}
	
}