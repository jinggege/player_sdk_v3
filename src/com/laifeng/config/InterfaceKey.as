package com.laifeng.config
{
	public class InterfaceKey
	{
		
		/***************JS 调 PLAYER 接口**********/
		/**开播*/
		static public const IKEY_START_LIVE:String ="startLive"; 
		/** 停播*/
		static public const IKEY_STOP_LIVE:String   ="stopLive"; 
		/** 设置宽高*/
		static public const IKEY_SET_W_H:String     ="exSetPlayerWH"; 
		
		
		
		/***************PLAYER 调 JS**********/
		
		/** player call js    数据结构: 接口类型 :String :  参数:{}*/
		static public const IKEY_PLAYER_CALL_JS:String 			= "playerCallJs";
		
		
		/** 换频道*/
		static public const IKEY_SWITCH_ROOM:String     			 ="_flash_change_room"; 
		
		/***************接口类型**********/
		/**开播成功*/
		static public const ITYPE_PLAY_SUCCESS:String 			 = "ITYPE_PLAY_SUCCESS";
		/**停播接口被调用*/
		static public const ITYPE_PLAY_STOP:String 		 			 = "ITYPE_PLAY_STOP";
		/**暂停 */
		static public const ITYPE_PLAY_PAUSE:String     			 = "ITYPE_PLAY_PAUSE";
		/**暂停恢复播放 */
		static public const ITYPE_PLAY_RESUME:String  			 = "ITYPE_PLAY_RESUME";
		/**收到metada */
		static public const ITYPE_PLAY_METADA:String 			  = "ITYPE_PLAY_METADA";
		/**buffer full */
		static public const ITYPE_PLAY_BUFFER_FULL:String     = "ITYPE_PLAY_BUFFER_FULL";
		/**buffer empty */
		static public const ITYPE_PLAY_BUFFER_EMPTY:String  = "ITYPE_PLAY_BUFFER_EMPTY";
		/**error */
		static public const ITYPE_PLAY_ERROR:String  				   = "ITYPE_PLAY_ERROR";
		
		
		
		
		
		
	}
}