package com.laifeng.view.cmd
{
	import com.laifeng.config.ListenerType;
	
	/**********************************************************
	 * ParseCmd
	 * 
	 * Author         : mj
	 * Description :
	 * 			命令行解析 
	 ***********************************************************/
	public class ParseCmd
	{
		public function ParseCmd()
		{
		}
		
		
		public function getCmdInfo(cmdStr:String):Object{
			
			var index:int = cmdStr.indexOf("=");
			var cmd:String = cmdStr.substring(0,index+1);
			var paramStr:String = cmdStr.substring(index+1,cmdStr.length);
			
			switch(cmd){
				case ListenerType.CMD_DEBUG :
						return {cmdType:ListenerType.CMD_DEBUG,param:Boolean(int(paramStr))};
				case ListenerType.CMD_WH :
						var w:int = int( paramStr.substring(0,paramStr.indexOf(",")) );
						var h:int = int( paramStr.substring(paramStr.indexOf(",")+1,paramStr.length) );
						return {cmdType:ListenerType.CMD_WH,
										    param:{width:w,height:h}
					      };
					
				case ListenerType.CMD_GETSTREAMID :
						return {cmdType:ListenerType.CMD_GETSTREAMID,param:""};
				case ListenerType.CMD_BROWER :
					return {cmdType:ListenerType.CMD_BROWER,param:""};
					
			}
			
			return  {cmdType:"not found",param:""};
		}
		
		
		
		
		
		
	}
}