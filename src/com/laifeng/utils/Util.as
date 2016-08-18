package com.laifeng.utils
{
	import flash.system.Capabilities;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Util
	{
		public function Util()
		{
		}
		
		
		public static function setFormatToTextField(tf:TextField,format:TextFormat):void{
			tf.defaultTextFormat = format;
			tf.setTextFormat(format);
		}
		
		
		public static function get getTime():Number{
			var date:Date = new Date();
			return date.getTime();
		}
		
		
		
		/**操作系统类型类型*/
		public static function get os():String{
			return flash.system.Capabilities.os.toLocaleLowerCase();
		}
		
		/**是否为mac  系统*/
		public static function get isMac():Boolean{
			return os.indexOf("mac")>=0;
		}
		
		
		/**mac平台上的 safari 浏览器*/
		public static function safariOnMac(userAgent:String):Boolean{
			if(!isMac) return false;
			
			if(userAgent.indexOf("mozilla/5.0")>=0 
				&& userAgent.indexOf("safari")>=0
				&&userAgent.indexOf("chrome")<0){
				return true;
			}
			
			return false;
		}
		
		
		
		
		
	}
}